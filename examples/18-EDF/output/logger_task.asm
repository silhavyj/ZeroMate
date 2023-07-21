
./logger_task:     file format elf32-littlearm


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
    805c:	00008f58 	andeq	r8, r0, r8, asr pc
    8060:	00008f68 	andeq	r8, r0, r8, ror #30

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
    8080:	eb000078 	bl	8268 <main>
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
    81cc:	00008f55 	andeq	r8, r0, r5, asr pc
    81d0:	00008f55 	andeq	r8, r0, r5, asr pc

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
    8224:	00008f55 	andeq	r8, r0, r5, asr pc
    8228:	00008f55 	andeq	r8, r0, r5, asr pc

0000822c <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:14
 *
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

static void fputs(uint32_t file, const char* string)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:15
    write(file, string, strlen(string));
    8240:	e51b000c 	ldr	r0, [fp, #-12]
    8244:	eb000244 	bl	8b5c <_Z6strlenPKc>
    8248:	e1a03000 	mov	r3, r0
    824c:	e1a02003 	mov	r2, r3
    8250:	e51b100c 	ldr	r1, [fp, #-12]
    8254:	e51b0008 	ldr	r0, [fp, #-8]
    8258:	eb00008b 	bl	848c <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:16
}
    825c:	e320f000 	nop	{0}
    8260:	e24bd004 	sub	sp, fp, #4
    8264:	e8bd8800 	pop	{fp, pc}

00008268 <main>:
main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:19

int main(int argc, char** argv)
{
    8268:	e92d4800 	push	{fp, lr}
    826c:	e28db004 	add	fp, sp, #4
    8270:	e24dd040 	sub	sp, sp, #64	; 0x40
    8274:	e50b0040 	str	r0, [fp, #-64]	; 0xffffffc0
    8278:	e50b1044 	str	r1, [fp, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:20
    uint32_t monitor_file = open("DEV:monitor/0", NFile_Open_Mode::Read_Write);
    827c:	e3a01002 	mov	r1, #2
    8280:	e59f00e8 	ldr	r0, [pc, #232]	; 8370 <main+0x108>
    8284:	eb00005b 	bl	83f8 <_Z4openPKc15NFile_Open_Mode>
    8288:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:22

    fputs(monitor_file, "Monitor task starting!");
    828c:	e59f10e0 	ldr	r1, [pc, #224]	; 8374 <main+0x10c>
    8290:	e51b0008 	ldr	r0, [fp, #-8]
    8294:	ebffffe4 	bl	822c <_ZL5fputsjPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:26

    char buf[16];
    char tickbuf[16];
    bzero(buf, 16);
    8298:	e24b3028 	sub	r3, fp, #40	; 0x28
    829c:	e3a01010 	mov	r1, #16
    82a0:	e1a00003 	mov	r0, r3
    82a4:	eb000241 	bl	8bb0 <_Z5bzeroPvi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:27
    bzero(tickbuf, 16);
    82a8:	e24b3038 	sub	r3, fp, #56	; 0x38
    82ac:	e3a01010 	mov	r1, #16
    82b0:	e1a00003 	mov	r0, r3
    82b4:	eb00023d 	bl	8bb0 <_Z5bzeroPvi>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:29

    uint32_t last_tick = 0;
    82b8:	e3a03000 	mov	r3, #0
    82bc:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:31

    uint32_t logpipe = pipe("log", 32);
    82c0:	e3a01020 	mov	r1, #32
    82c4:	e59f00ac 	ldr	r0, [pc, #172]	; 8378 <main+0x110>
    82c8:	eb000118 	bl	8730 <_Z4pipePKcj>
    82cc:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:35

    while (true)
    {
        wait(logpipe, 1, 10);
    82d0:	e3a0200a 	mov	r2, #10
    82d4:	e3a01001 	mov	r1, #1
    82d8:	e51b0010 	ldr	r0, [fp, #-16]
    82dc:	eb0000ae 	bl	859c <_Z4waitjjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:37

        uint32_t v = read(logpipe, buf, 15);
    82e0:	e24b3028 	sub	r3, fp, #40	; 0x28
    82e4:	e3a0200f 	mov	r2, #15
    82e8:	e1a01003 	mov	r1, r3
    82ec:	e51b0010 	ldr	r0, [fp, #-16]
    82f0:	eb000051 	bl	843c <_Z4readjPcj>
    82f4:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:38
        if (v > 0)
    82f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    82fc:	e3530000 	cmp	r3, #0
    8300:	0afffff2 	beq	82d0 <main+0x68>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:40
        {
            buf[v] = '\0';
    8304:	e24b2028 	sub	r2, fp, #40	; 0x28
    8308:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    830c:	e0823003 	add	r3, r2, r3
    8310:	e3a02000 	mov	r2, #0
    8314:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:41
            fputs(monitor_file, "\r\n[ ");
    8318:	e59f105c 	ldr	r1, [pc, #92]	; 837c <main+0x114>
    831c:	e51b0008 	ldr	r0, [fp, #-8]
    8320:	ebffffc1 	bl	822c <_ZL5fputsjPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:42
            uint32_t tick = get_tick_count();
    8324:	eb0000d4 	bl	867c <_Z14get_tick_countv>
    8328:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:43
            itoa(tick, tickbuf, 16);
    832c:	e24b3038 	sub	r3, fp, #56	; 0x38
    8330:	e3a02010 	mov	r2, #16
    8334:	e1a01003 	mov	r1, r3
    8338:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    833c:	eb000127 	bl	87e0 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:44
            fputs(monitor_file, tickbuf);
    8340:	e24b3038 	sub	r3, fp, #56	; 0x38
    8344:	e1a01003 	mov	r1, r3
    8348:	e51b0008 	ldr	r0, [fp, #-8]
    834c:	ebffffb6 	bl	822c <_ZL5fputsjPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:45
            fputs(monitor_file, "]: ");
    8350:	e59f1028 	ldr	r1, [pc, #40]	; 8380 <main+0x118>
    8354:	e51b0008 	ldr	r0, [fp, #-8]
    8358:	ebffffb3 	bl	822c <_ZL5fputsjPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:46
            fputs(monitor_file, buf);
    835c:	e24b3028 	sub	r3, fp, #40	; 0x28
    8360:	e1a01003 	mov	r1, r3
    8364:	e51b0008 	ldr	r0, [fp, #-8]
    8368:	ebffffaf 	bl	822c <_ZL5fputsjPKc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/logger_task/main.cpp:48
        }
    }
    836c:	eaffffd7 	b	82d0 <main+0x68>
    8370:	00008ed4 	ldrdeq	r8, [r0], -r4
    8374:	00008ee4 	andeq	r8, r0, r4, ror #29
    8378:	00008efc 	strdeq	r8, [r0], -ip
    837c:	00008f00 	andeq	r8, r0, r0, lsl #30
    8380:	00008f08 	andeq	r8, r0, r8, lsl #30

00008384 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8384:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8388:	e28db000 	add	fp, sp, #0
    838c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8390:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r"(pid));
    8394:	e1a03000 	mov	r3, r0
    8398:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:11

    return pid;
    839c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:12
}
    83a0:	e1a00003 	mov	r0, r3
    83a4:	e28bd000 	add	sp, fp, #0
    83a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83ac:	e12fff1e 	bx	lr

000083b0 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83b4:	e28db000 	add	fp, sp, #0
    83b8:	e24dd00c 	sub	sp, sp, #12
    83bc:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r"(exitcode));
    83c0:	e51b3008 	ldr	r3, [fp, #-8]
    83c4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    83c8:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:18
}
    83cc:	e320f000 	nop	{0}
    83d0:	e28bd000 	add	sp, fp, #0
    83d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83d8:	e12fff1e 	bx	lr

000083dc <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    83dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83e0:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    83e4:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:23
}
    83e8:	e320f000 	nop	{0}
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd014 	sub	sp, sp, #20
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r"(filename));
    840c:	e51b3010 	ldr	r3, [fp, #-16]
    8410:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r"(mode));
    8414:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8418:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    841c:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r"(file));
    8420:	e1a03000 	mov	r3, r0
    8424:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:34

    return file;
    8428:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:35
}
    842c:	e1a00003 	mov	r0, r3
    8430:	e28bd000 	add	sp, fp, #0
    8434:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8438:	e12fff1e 	bx	lr

0000843c <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    843c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8440:	e28db000 	add	fp, sp, #0
    8444:	e24dd01c 	sub	sp, sp, #28
    8448:	e50b0010 	str	r0, [fp, #-16]
    844c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8450:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r"(file));
    8454:	e51b3010 	ldr	r3, [fp, #-16]
    8458:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r"(buffer));
    845c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8460:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r"(size));
    8464:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8468:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    846c:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r"(rdnum));
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:47

    return rdnum;
    8478:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:48
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r"(file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r"(buffer));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r"(size));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    84bc:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r"(wrnum));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:60

    return wrnum;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:61
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd00c 	sub	sp, sp, #12
    84e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r"(file));
    84ec:	e51b3008 	ldr	r3, [fp, #-8]
    84f0:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    84f4:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:67
}
    84f8:	e320f000 	nop	{0}
    84fc:	e28bd000 	add	sp, fp, #0
    8500:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8504:	e12fff1e 	bx	lr

00008508 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8508:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    850c:	e28db000 	add	fp, sp, #0
    8510:	e24dd01c 	sub	sp, sp, #28
    8514:	e50b0010 	str	r0, [fp, #-16]
    8518:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    851c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    8520:	e51b3010 	ldr	r3, [fp, #-16]
    8524:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r"(operation));
    8528:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    852c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r"(param));
    8530:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8534:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8538:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r"(retcode));
    853c:	e1a03000 	mov	r3, r0
    8540:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:79

    return retcode;
    8544:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:80
}
    8548:	e1a00003 	mov	r0, r3
    854c:	e28bd000 	add	sp, fp, #0
    8550:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8554:	e12fff1e 	bx	lr

00008558 <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8558:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    855c:	e28db000 	add	fp, sp, #0
    8560:	e24dd014 	sub	sp, sp, #20
    8564:	e50b0010 	str	r0, [fp, #-16]
    8568:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r"(file));
    856c:	e51b3010 	ldr	r3, [fp, #-16]
    8570:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r"(count));
    8574:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8578:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    857c:	ef000045 	svc	0x00000045
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r"(retcnt));
    8580:	e1a03000 	mov	r3, r0
    8584:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:91

    return retcnt;
    8588:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:92
}
    858c:	e1a00003 	mov	r0, r3
    8590:	e28bd000 	add	sp, fp, #0
    8594:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8598:	e12fff1e 	bx	lr

0000859c <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    859c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a0:	e28db000 	add	fp, sp, #0
    85a4:	e24dd01c 	sub	sp, sp, #28
    85a8:	e50b0010 	str	r0, [fp, #-16]
    85ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85b0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r"(count));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r"(notified_deadline));
    85c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85c8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    85cc:	ef000046 	svc	0x00000046
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r"(retcode));
    85d0:	e1a03000 	mov	r3, r0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:104

    return retcode;
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:105
}
    85dc:	e1a00003 	mov	r0, r3
    85e0:	e28bd000 	add	sp, fp, #0
    85e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e8:	e12fff1e 	bx	lr

000085ec <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    85ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f0:	e28db000 	add	fp, sp, #0
    85f4:	e24dd014 	sub	sp, sp, #20
    85f8:	e50b0010 	str	r0, [fp, #-16]
    85fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(ticks));
    8600:	e51b3010 	ldr	r3, [fp, #-16]
    8604:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r"(notified_deadline));
    8608:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    860c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8610:	ef000003 	svc	0x00000003
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r"(retcode));
    8614:	e1a03000 	mov	r3, r0
    8618:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:116

    return retcode;
    861c:	e51b3008 	ldr	r3, [fp, #-8]
    8620:	e3530000 	cmp	r3, #0
    8624:	13a03001 	movne	r3, #1
    8628:	03a03000 	moveq	r3, #0
    862c:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:117
}
    8630:	e1a00003 	mov	r0, r3
    8634:	e28bd000 	add	sp, fp, #0
    8638:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    863c:	e12fff1e 	bx	lr

00008640 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8640:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8644:	e28db000 	add	fp, sp, #0
    8648:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    864c:	e3a03000 	mov	r3, #0
    8650:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    8654:	e3a03000 	mov	r3, #0
    8658:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r"(&retval));
    865c:	e24b300c 	sub	r3, fp, #12
    8660:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8664:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:128

    return retval;
    8668:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:129
}
    866c:	e1a00003 	mov	r0, r3
    8670:	e28bd000 	add	sp, fp, #0
    8674:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8678:	e12fff1e 	bx	lr

0000867c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    867c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8680:	e28db000 	add	fp, sp, #0
    8684:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8688:	e3a03001 	mov	r3, #1
    868c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    8690:	e3a03001 	mov	r3, #1
    8694:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r"(&retval));
    8698:	e24b300c 	sub	r3, fp, #12
    869c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    86a0:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:140

    return retval;
    86a4:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:141
}
    86a8:	e1a00003 	mov	r0, r3
    86ac:	e28bd000 	add	sp, fp, #0
    86b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b4:	e12fff1e 	bx	lr

000086b8 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    86b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86bc:	e28db000 	add	fp, sp, #0
    86c0:	e24dd014 	sub	sp, sp, #20
    86c4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    86c8:	e3a03000 	mov	r3, #0
    86cc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r"(req));
    86d0:	e3a03000 	mov	r3, #0
    86d4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r"(&tick_count_required));
    86d8:	e24b3010 	sub	r3, fp, #16
    86dc:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    86e0:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:150
}
    86e4:	e320f000 	nop	{0}
    86e8:	e28bd000 	add	sp, fp, #0
    86ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86f0:	e12fff1e 	bx	lr

000086f4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    86f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86f8:	e28db000 	add	fp, sp, #0
    86fc:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8700:	e3a03001 	mov	r3, #1
    8704:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r"(req));
    8708:	e3a03001 	mov	r3, #1
    870c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r"(&ticks));
    8710:	e24b300c 	sub	r3, fp, #12
    8714:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8718:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:161

    return ticks;
    871c:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:162
}
    8720:	e1a00003 	mov	r0, r3
    8724:	e28bd000 	add	sp, fp, #0
    8728:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    872c:	e12fff1e 	bx	lr

00008730 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8730:	e92d4800 	push	{fp, lr}
    8734:	e28db004 	add	fp, sp, #4
    8738:	e24dd050 	sub	sp, sp, #80	; 0x50
    873c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8740:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8744:	e24b3048 	sub	r3, fp, #72	; 0x48
    8748:	e3a0200a 	mov	r2, #10
    874c:	e59f1088 	ldr	r1, [pc, #136]	; 87dc <_Z4pipePKcj+0xac>
    8750:	e1a00003 	mov	r0, r3
    8754:	eb0000a5 	bl	89f0 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8758:	e24b3048 	sub	r3, fp, #72	; 0x48
    875c:	e283300a 	add	r3, r3, #10
    8760:	e3a02035 	mov	r2, #53	; 0x35
    8764:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8768:	e1a00003 	mov	r0, r3
    876c:	eb00009f 	bl	89f0 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8770:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8774:	eb0000f8 	bl	8b5c <_Z6strlenPKc>
    8778:	e1a03000 	mov	r3, r0
    877c:	e283300a 	add	r3, r3, #10
    8780:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8784:	e51b3008 	ldr	r3, [fp, #-8]
    8788:	e2832001 	add	r2, r3, #1
    878c:	e50b2008 	str	r2, [fp, #-8]
    8790:	e2433004 	sub	r3, r3, #4
    8794:	e083300b 	add	r3, r3, fp
    8798:	e3a02023 	mov	r2, #35	; 0x23
    879c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    87a0:	e24b2048 	sub	r2, fp, #72	; 0x48
    87a4:	e51b3008 	ldr	r3, [fp, #-8]
    87a8:	e0823003 	add	r3, r2, r3
    87ac:	e3a0200a 	mov	r2, #10
    87b0:	e1a01003 	mov	r1, r3
    87b4:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    87b8:	eb000008 	bl	87e0 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    87bc:	e24b3048 	sub	r3, fp, #72	; 0x48
    87c0:	e3a01002 	mov	r1, #2
    87c4:	e1a00003 	mov	r0, r3
    87c8:	ebffff0a 	bl	83f8 <_Z4openPKc15NFile_Open_Mode>
    87cc:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:179
}
    87d0:	e1a00003 	mov	r0, r3
    87d4:	e24bd004 	sub	sp, fp, #4
    87d8:	e8bd8800 	pop	{fp, pc}
    87dc:	00008f38 	andeq	r8, r0, r8, lsr pc

000087e0 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    87e0:	e92d4800 	push	{fp, lr}
    87e4:	e28db004 	add	fp, sp, #4
    87e8:	e24dd020 	sub	sp, sp, #32
    87ec:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    87f0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    87f4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:10
    int i = 0;
    87f8:	e3a03000 	mov	r3, #0
    87fc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12

    while (input > 0)
    8800:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8804:	e3530000 	cmp	r3, #0
    8808:	0a000014 	beq	8860 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    880c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8810:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8814:	e1a00003 	mov	r0, r3
    8818:	eb000199 	bl	8e84 <__aeabi_uidivmod>
    881c:	e1a03001 	mov	r3, r1
    8820:	e1a01003 	mov	r1, r3
    8824:	e51b3008 	ldr	r3, [fp, #-8]
    8828:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    882c:	e0823003 	add	r3, r2, r3
    8830:	e59f2118 	ldr	r2, [pc, #280]	; 8950 <_Z4itoajPcj+0x170>
    8834:	e7d22001 	ldrb	r2, [r2, r1]
    8838:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:15
        input /= base;
    883c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8840:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8844:	eb000113 	bl	8c98 <__udivsi3>
    8848:	e1a03000 	mov	r3, r0
    884c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:16
        i++;
    8850:	e51b3008 	ldr	r3, [fp, #-8]
    8854:	e2833001 	add	r3, r3, #1
    8858:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12
    while (input > 0)
    885c:	eaffffe7 	b	8800 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    8860:	e51b3008 	ldr	r3, [fp, #-8]
    8864:	e3530000 	cmp	r3, #0
    8868:	1a000007 	bne	888c <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    886c:	e51b3008 	ldr	r3, [fp, #-8]
    8870:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8874:	e0823003 	add	r3, r2, r3
    8878:	e3a02030 	mov	r2, #48	; 0x30
    887c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:22
        i++;
    8880:	e51b3008 	ldr	r3, [fp, #-8]
    8884:	e2833001 	add	r3, r3, #1
    8888:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    888c:	e51b3008 	ldr	r3, [fp, #-8]
    8890:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8894:	e0823003 	add	r3, r2, r3
    8898:	e3a02000 	mov	r2, #0
    889c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:26
    i--;
    88a0:	e51b3008 	ldr	r3, [fp, #-8]
    88a4:	e2433001 	sub	r3, r3, #1
    88a8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    88ac:	e3a03000 	mov	r3, #0
    88b0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 3)
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e1a02fa3 	lsr	r2, r3, #31
    88bc:	e0823003 	add	r3, r2, r3
    88c0:	e1a030c3 	asr	r3, r3, #1
    88c4:	e1a02003 	mov	r2, r3
    88c8:	e51b300c 	ldr	r3, [fp, #-12]
    88cc:	e1530002 	cmp	r3, r2
    88d0:	ca00001b 	bgt	8944 <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    88d4:	e51b2008 	ldr	r2, [fp, #-8]
    88d8:	e51b300c 	ldr	r3, [fp, #-12]
    88dc:	e0423003 	sub	r3, r2, r3
    88e0:	e1a02003 	mov	r2, r3
    88e4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88e8:	e0833002 	add	r3, r3, r2
    88ec:	e5d33000 	ldrb	r3, [r3]
    88f0:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    88f4:	e51b300c 	ldr	r3, [fp, #-12]
    88f8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88fc:	e0822003 	add	r2, r2, r3
    8900:	e51b1008 	ldr	r1, [fp, #-8]
    8904:	e51b300c 	ldr	r3, [fp, #-12]
    8908:	e0413003 	sub	r3, r1, r3
    890c:	e1a01003 	mov	r1, r3
    8910:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8914:	e0833001 	add	r3, r3, r1
    8918:	e5d22000 	ldrb	r2, [r2]
    891c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    8920:	e51b300c 	ldr	r3, [fp, #-12]
    8924:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8928:	e0823003 	add	r3, r2, r3
    892c:	e55b200d 	ldrb	r2, [fp, #-13]
    8930:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    8934:	e51b300c 	ldr	r3, [fp, #-12]
    8938:	e2833001 	add	r3, r3, #1
    893c:	e50b300c 	str	r3, [fp, #-12]
    8940:	eaffffdb 	b	88b4 <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:34
    }
}
    8944:	e320f000 	nop	{0}
    8948:	e24bd004 	sub	sp, fp, #4
    894c:	e8bd8800 	pop	{fp, pc}
    8950:	00008f44 	andeq	r8, r0, r4, asr #30

00008954 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8954:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8958:	e28db000 	add	fp, sp, #0
    895c:	e24dd014 	sub	sp, sp, #20
    8960:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:38
    int output = 0;
    8964:	e3a03000 	mov	r3, #0
    8968:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40

    while (*input != '\0')
    896c:	e51b3010 	ldr	r3, [fp, #-16]
    8970:	e5d33000 	ldrb	r3, [r3]
    8974:	e3530000 	cmp	r3, #0
    8978:	0a000017 	beq	89dc <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:42
    {
        output *= 10;
    897c:	e51b2008 	ldr	r2, [fp, #-8]
    8980:	e1a03002 	mov	r3, r2
    8984:	e1a03103 	lsl	r3, r3, #2
    8988:	e0833002 	add	r3, r3, r2
    898c:	e1a03083 	lsl	r3, r3, #1
    8990:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43
        if (*input > '9' || *input < '0')
    8994:	e51b3010 	ldr	r3, [fp, #-16]
    8998:	e5d33000 	ldrb	r3, [r3]
    899c:	e3530039 	cmp	r3, #57	; 0x39
    89a0:	8a00000d 	bhi	89dc <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43 (discriminator 1)
    89a4:	e51b3010 	ldr	r3, [fp, #-16]
    89a8:	e5d33000 	ldrb	r3, [r3]
    89ac:	e353002f 	cmp	r3, #47	; 0x2f
    89b0:	9a000009 	bls	89dc <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:46
            break;

        output += *input - '0';
    89b4:	e51b3010 	ldr	r3, [fp, #-16]
    89b8:	e5d33000 	ldrb	r3, [r3]
    89bc:	e2433030 	sub	r3, r3, #48	; 0x30
    89c0:	e51b2008 	ldr	r2, [fp, #-8]
    89c4:	e0823003 	add	r3, r2, r3
    89c8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:48

        input++;
    89cc:	e51b3010 	ldr	r3, [fp, #-16]
    89d0:	e2833001 	add	r3, r3, #1
    89d4:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40
    while (*input != '\0')
    89d8:	eaffffe3 	b	896c <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:51
    }

    return output;
    89dc:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:52
}
    89e0:	e1a00003 	mov	r0, r3
    89e4:	e28bd000 	add	sp, fp, #0
    89e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89ec:	e12fff1e 	bx	lr

000089f0 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char* src, int num)
{
    89f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89f4:	e28db000 	add	fp, sp, #0
    89f8:	e24dd01c 	sub	sp, sp, #28
    89fc:	e50b0010 	str	r0, [fp, #-16]
    8a00:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a04:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    8a08:	e3a03000 	mov	r3, #0
    8a0c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8a10:	e51b2008 	ldr	r2, [fp, #-8]
    8a14:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a18:	e1520003 	cmp	r2, r3
    8a1c:	aa000011 	bge	8a68 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8a20:	e51b3008 	ldr	r3, [fp, #-8]
    8a24:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a28:	e0823003 	add	r3, r2, r3
    8a2c:	e5d33000 	ldrb	r3, [r3]
    8a30:	e3530000 	cmp	r3, #0
    8a34:	0a00000b 	beq	8a68 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:59 (discriminator 3)
        dest[i] = src[i];
    8a38:	e51b3008 	ldr	r3, [fp, #-8]
    8a3c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a40:	e0822003 	add	r2, r2, r3
    8a44:	e51b3008 	ldr	r3, [fp, #-8]
    8a48:	e51b1010 	ldr	r1, [fp, #-16]
    8a4c:	e0813003 	add	r3, r1, r3
    8a50:	e5d22000 	ldrb	r2, [r2]
    8a54:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    8a58:	e51b3008 	ldr	r3, [fp, #-8]
    8a5c:	e2833001 	add	r3, r3, #1
    8a60:	e50b3008 	str	r3, [fp, #-8]
    8a64:	eaffffe9 	b	8a10 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 2)
    for (; i < num; i++)
    8a68:	e51b2008 	ldr	r2, [fp, #-8]
    8a6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a70:	e1520003 	cmp	r2, r3
    8a74:	aa000008 	bge	8a9c <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:61 (discriminator 1)
        dest[i] = '\0';
    8a78:	e51b3008 	ldr	r3, [fp, #-8]
    8a7c:	e51b2010 	ldr	r2, [fp, #-16]
    8a80:	e0823003 	add	r3, r2, r3
    8a84:	e3a02000 	mov	r2, #0
    8a88:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 1)
    for (; i < num; i++)
    8a8c:	e51b3008 	ldr	r3, [fp, #-8]
    8a90:	e2833001 	add	r3, r3, #1
    8a94:	e50b3008 	str	r3, [fp, #-8]
    8a98:	eafffff2 	b	8a68 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:63

    return dest;
    8a9c:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:64
}
    8aa0:	e1a00003 	mov	r0, r3
    8aa4:	e28bd000 	add	sp, fp, #0
    8aa8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8aac:	e12fff1e 	bx	lr

00008ab0 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:67

int strncmp(const char* s1, const char* s2, int num)
{
    8ab0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ab4:	e28db000 	add	fp, sp, #0
    8ab8:	e24dd01c 	sub	sp, sp, #28
    8abc:	e50b0010 	str	r0, [fp, #-16]
    8ac0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8ac4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:69
    unsigned char u1, u2;
    while (num-- > 0)
    8ac8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8acc:	e2432001 	sub	r2, r3, #1
    8ad0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8ad4:	e3530000 	cmp	r3, #0
    8ad8:	c3a03001 	movgt	r3, #1
    8adc:	d3a03000 	movle	r3, #0
    8ae0:	e6ef3073 	uxtb	r3, r3
    8ae4:	e3530000 	cmp	r3, #0
    8ae8:	0a000016 	beq	8b48 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:71
    {
        u1 = (unsigned char)*s1++;
    8aec:	e51b3010 	ldr	r3, [fp, #-16]
    8af0:	e2832001 	add	r2, r3, #1
    8af4:	e50b2010 	str	r2, [fp, #-16]
    8af8:	e5d33000 	ldrb	r3, [r3]
    8afc:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:72
        u2 = (unsigned char)*s2++;
    8b00:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b04:	e2832001 	add	r2, r3, #1
    8b08:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8b0c:	e5d33000 	ldrb	r3, [r3]
    8b10:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:73
        if (u1 != u2)
    8b14:	e55b2005 	ldrb	r2, [fp, #-5]
    8b18:	e55b3006 	ldrb	r3, [fp, #-6]
    8b1c:	e1520003 	cmp	r2, r3
    8b20:	0a000003 	beq	8b34 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:74
            return u1 - u2;
    8b24:	e55b2005 	ldrb	r2, [fp, #-5]
    8b28:	e55b3006 	ldrb	r3, [fp, #-6]
    8b2c:	e0423003 	sub	r3, r2, r3
    8b30:	ea000005 	b	8b4c <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:75
        if (u1 == '\0')
    8b34:	e55b3005 	ldrb	r3, [fp, #-5]
    8b38:	e3530000 	cmp	r3, #0
    8b3c:	1affffe1 	bne	8ac8 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:76
            return 0;
    8b40:	e3a03000 	mov	r3, #0
    8b44:	ea000000 	b	8b4c <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:79
    }

    return 0;
    8b48:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:80
}
    8b4c:	e1a00003 	mov	r0, r3
    8b50:	e28bd000 	add	sp, fp, #0
    8b54:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b58:	e12fff1e 	bx	lr

00008b5c <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b5c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b60:	e28db000 	add	fp, sp, #0
    8b64:	e24dd014 	sub	sp, sp, #20
    8b68:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:84
    int i = 0;
    8b6c:	e3a03000 	mov	r3, #0
    8b70:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86

    while (s[i] != '\0')
    8b74:	e51b3008 	ldr	r3, [fp, #-8]
    8b78:	e51b2010 	ldr	r2, [fp, #-16]
    8b7c:	e0823003 	add	r3, r2, r3
    8b80:	e5d33000 	ldrb	r3, [r3]
    8b84:	e3530000 	cmp	r3, #0
    8b88:	0a000003 	beq	8b9c <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:87
        i++;
    8b8c:	e51b3008 	ldr	r3, [fp, #-8]
    8b90:	e2833001 	add	r3, r3, #1
    8b94:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86
    while (s[i] != '\0')
    8b98:	eafffff5 	b	8b74 <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:89

    return i;
    8b9c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:90
}
    8ba0:	e1a00003 	mov	r0, r3
    8ba4:	e28bd000 	add	sp, fp, #0
    8ba8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bac:	e12fff1e 	bx	lr

00008bb0 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8bb0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bb4:	e28db000 	add	fp, sp, #0
    8bb8:	e24dd014 	sub	sp, sp, #20
    8bbc:	e50b0010 	str	r0, [fp, #-16]
    8bc0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:94
    char* mem = reinterpret_cast<char*>(memory);
    8bc4:	e51b3010 	ldr	r3, [fp, #-16]
    8bc8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96

    for (int i = 0; i < length; i++)
    8bcc:	e3a03000 	mov	r3, #0
    8bd0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8bd4:	e51b2008 	ldr	r2, [fp, #-8]
    8bd8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8bdc:	e1520003 	cmp	r2, r3
    8be0:	aa000008 	bge	8c08 <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:97 (discriminator 2)
        mem[i] = 0;
    8be4:	e51b3008 	ldr	r3, [fp, #-8]
    8be8:	e51b200c 	ldr	r2, [fp, #-12]
    8bec:	e0823003 	add	r3, r2, r3
    8bf0:	e3a02000 	mov	r2, #0
    8bf4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 2)
    for (int i = 0; i < length; i++)
    8bf8:	e51b3008 	ldr	r3, [fp, #-8]
    8bfc:	e2833001 	add	r3, r3, #1
    8c00:	e50b3008 	str	r3, [fp, #-8]
    8c04:	eafffff2 	b	8bd4 <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:98
}
    8c08:	e320f000 	nop	{0}
    8c0c:	e28bd000 	add	sp, fp, #0
    8c10:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c14:	e12fff1e 	bx	lr

00008c18 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8c18:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c1c:	e28db000 	add	fp, sp, #0
    8c20:	e24dd024 	sub	sp, sp, #36	; 0x24
    8c24:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c28:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c2c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:102
    const char* memsrc = reinterpret_cast<const char*>(src);
    8c30:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c34:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:103
    char* memdst = reinterpret_cast<char*>(dst);
    8c38:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c3c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105

    for (int i = 0; i < num; i++)
    8c40:	e3a03000 	mov	r3, #0
    8c44:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c48:	e51b2008 	ldr	r2, [fp, #-8]
    8c4c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c50:	e1520003 	cmp	r2, r3
    8c54:	aa00000b 	bge	8c88 <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:106 (discriminator 2)
        memdst[i] = memsrc[i];
    8c58:	e51b3008 	ldr	r3, [fp, #-8]
    8c5c:	e51b200c 	ldr	r2, [fp, #-12]
    8c60:	e0822003 	add	r2, r2, r3
    8c64:	e51b3008 	ldr	r3, [fp, #-8]
    8c68:	e51b1010 	ldr	r1, [fp, #-16]
    8c6c:	e0813003 	add	r3, r1, r3
    8c70:	e5d22000 	ldrb	r2, [r2]
    8c74:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 2)
    for (int i = 0; i < num; i++)
    8c78:	e51b3008 	ldr	r3, [fp, #-8]
    8c7c:	e2833001 	add	r3, r3, #1
    8c80:	e50b3008 	str	r3, [fp, #-8]
    8c84:	eaffffef 	b	8c48 <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:107
}
    8c88:	e320f000 	nop	{0}
    8c8c:	e28bd000 	add	sp, fp, #0
    8c90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c94:	e12fff1e 	bx	lr

00008c98 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8c98:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8c9c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8ca0:	3a000074 	bcc	8e78 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8ca4:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    8ca8:	9a00006b 	bls	8e5c <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8cac:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8cb0:	0a00006c 	beq	8e68 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    8cb4:	e16f3f10 	clz	r3, r0
    8cb8:	e16f2f11 	clz	r2, r1
    8cbc:	e0423003 	sub	r3, r2, r3
    8cc0:	e273301f 	rsbs	r3, r3, #31
    8cc4:	10833083 	addne	r3, r3, r3, lsl #1
    8cc8:	e3a02000 	mov	r2, #0
    8ccc:	108ff103 	addne	pc, pc, r3, lsl #2
    8cd0:	e1a00000 	nop			; (mov r0, r0)
    8cd4:	e1500f81 	cmp	r0, r1, lsl #31
    8cd8:	e0a22002 	adc	r2, r2, r2
    8cdc:	20400f81 	subcs	r0, r0, r1, lsl #31
    8ce0:	e1500f01 	cmp	r0, r1, lsl #30
    8ce4:	e0a22002 	adc	r2, r2, r2
    8ce8:	20400f01 	subcs	r0, r0, r1, lsl #30
    8cec:	e1500e81 	cmp	r0, r1, lsl #29
    8cf0:	e0a22002 	adc	r2, r2, r2
    8cf4:	20400e81 	subcs	r0, r0, r1, lsl #29
    8cf8:	e1500e01 	cmp	r0, r1, lsl #28
    8cfc:	e0a22002 	adc	r2, r2, r2
    8d00:	20400e01 	subcs	r0, r0, r1, lsl #28
    8d04:	e1500d81 	cmp	r0, r1, lsl #27
    8d08:	e0a22002 	adc	r2, r2, r2
    8d0c:	20400d81 	subcs	r0, r0, r1, lsl #27
    8d10:	e1500d01 	cmp	r0, r1, lsl #26
    8d14:	e0a22002 	adc	r2, r2, r2
    8d18:	20400d01 	subcs	r0, r0, r1, lsl #26
    8d1c:	e1500c81 	cmp	r0, r1, lsl #25
    8d20:	e0a22002 	adc	r2, r2, r2
    8d24:	20400c81 	subcs	r0, r0, r1, lsl #25
    8d28:	e1500c01 	cmp	r0, r1, lsl #24
    8d2c:	e0a22002 	adc	r2, r2, r2
    8d30:	20400c01 	subcs	r0, r0, r1, lsl #24
    8d34:	e1500b81 	cmp	r0, r1, lsl #23
    8d38:	e0a22002 	adc	r2, r2, r2
    8d3c:	20400b81 	subcs	r0, r0, r1, lsl #23
    8d40:	e1500b01 	cmp	r0, r1, lsl #22
    8d44:	e0a22002 	adc	r2, r2, r2
    8d48:	20400b01 	subcs	r0, r0, r1, lsl #22
    8d4c:	e1500a81 	cmp	r0, r1, lsl #21
    8d50:	e0a22002 	adc	r2, r2, r2
    8d54:	20400a81 	subcs	r0, r0, r1, lsl #21
    8d58:	e1500a01 	cmp	r0, r1, lsl #20
    8d5c:	e0a22002 	adc	r2, r2, r2
    8d60:	20400a01 	subcs	r0, r0, r1, lsl #20
    8d64:	e1500981 	cmp	r0, r1, lsl #19
    8d68:	e0a22002 	adc	r2, r2, r2
    8d6c:	20400981 	subcs	r0, r0, r1, lsl #19
    8d70:	e1500901 	cmp	r0, r1, lsl #18
    8d74:	e0a22002 	adc	r2, r2, r2
    8d78:	20400901 	subcs	r0, r0, r1, lsl #18
    8d7c:	e1500881 	cmp	r0, r1, lsl #17
    8d80:	e0a22002 	adc	r2, r2, r2
    8d84:	20400881 	subcs	r0, r0, r1, lsl #17
    8d88:	e1500801 	cmp	r0, r1, lsl #16
    8d8c:	e0a22002 	adc	r2, r2, r2
    8d90:	20400801 	subcs	r0, r0, r1, lsl #16
    8d94:	e1500781 	cmp	r0, r1, lsl #15
    8d98:	e0a22002 	adc	r2, r2, r2
    8d9c:	20400781 	subcs	r0, r0, r1, lsl #15
    8da0:	e1500701 	cmp	r0, r1, lsl #14
    8da4:	e0a22002 	adc	r2, r2, r2
    8da8:	20400701 	subcs	r0, r0, r1, lsl #14
    8dac:	e1500681 	cmp	r0, r1, lsl #13
    8db0:	e0a22002 	adc	r2, r2, r2
    8db4:	20400681 	subcs	r0, r0, r1, lsl #13
    8db8:	e1500601 	cmp	r0, r1, lsl #12
    8dbc:	e0a22002 	adc	r2, r2, r2
    8dc0:	20400601 	subcs	r0, r0, r1, lsl #12
    8dc4:	e1500581 	cmp	r0, r1, lsl #11
    8dc8:	e0a22002 	adc	r2, r2, r2
    8dcc:	20400581 	subcs	r0, r0, r1, lsl #11
    8dd0:	e1500501 	cmp	r0, r1, lsl #10
    8dd4:	e0a22002 	adc	r2, r2, r2
    8dd8:	20400501 	subcs	r0, r0, r1, lsl #10
    8ddc:	e1500481 	cmp	r0, r1, lsl #9
    8de0:	e0a22002 	adc	r2, r2, r2
    8de4:	20400481 	subcs	r0, r0, r1, lsl #9
    8de8:	e1500401 	cmp	r0, r1, lsl #8
    8dec:	e0a22002 	adc	r2, r2, r2
    8df0:	20400401 	subcs	r0, r0, r1, lsl #8
    8df4:	e1500381 	cmp	r0, r1, lsl #7
    8df8:	e0a22002 	adc	r2, r2, r2
    8dfc:	20400381 	subcs	r0, r0, r1, lsl #7
    8e00:	e1500301 	cmp	r0, r1, lsl #6
    8e04:	e0a22002 	adc	r2, r2, r2
    8e08:	20400301 	subcs	r0, r0, r1, lsl #6
    8e0c:	e1500281 	cmp	r0, r1, lsl #5
    8e10:	e0a22002 	adc	r2, r2, r2
    8e14:	20400281 	subcs	r0, r0, r1, lsl #5
    8e18:	e1500201 	cmp	r0, r1, lsl #4
    8e1c:	e0a22002 	adc	r2, r2, r2
    8e20:	20400201 	subcs	r0, r0, r1, lsl #4
    8e24:	e1500181 	cmp	r0, r1, lsl #3
    8e28:	e0a22002 	adc	r2, r2, r2
    8e2c:	20400181 	subcs	r0, r0, r1, lsl #3
    8e30:	e1500101 	cmp	r0, r1, lsl #2
    8e34:	e0a22002 	adc	r2, r2, r2
    8e38:	20400101 	subcs	r0, r0, r1, lsl #2
    8e3c:	e1500081 	cmp	r0, r1, lsl #1
    8e40:	e0a22002 	adc	r2, r2, r2
    8e44:	20400081 	subcs	r0, r0, r1, lsl #1
    8e48:	e1500001 	cmp	r0, r1
    8e4c:	e0a22002 	adc	r2, r2, r2
    8e50:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8e54:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8e58:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8e5c:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8e60:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8e64:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8e68:	e16f2f11 	clz	r2, r1
    8e6c:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8e70:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8e74:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8e78:	e3500000 	cmp	r0, #0
    8e7c:	13e00000 	mvnne	r0, #0
    8e80:	ea000007 	b	8ea4 <__aeabi_idiv0>

00008e84 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8e84:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8e88:	0afffffa 	beq	8e78 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8e8c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8e90:	ebffff80 	bl	8c98 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8e94:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8e98:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8e9c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8ea0:	e12fff1e 	bx	lr

00008ea4 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8ea4:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008ea8 <_ZL13Lock_Unlocked>:
    8ea8:	00000000 	andeq	r0, r0, r0

00008eac <_ZL11Lock_Locked>:
    8eac:	00000001 	andeq	r0, r0, r1

00008eb0 <_ZL21MaxFSDriverNameLength>:
    8eb0:	00000010 	andeq	r0, r0, r0, lsl r0

00008eb4 <_ZL17MaxFilenameLength>:
    8eb4:	00000010 	andeq	r0, r0, r0, lsl r0

00008eb8 <_ZL13MaxPathLength>:
    8eb8:	00000080 	andeq	r0, r0, r0, lsl #1

00008ebc <_ZL18NoFilesystemDriver>:
    8ebc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ec0 <_ZL9NotifyAll>:
    8ec0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ec4 <_ZL24Max_Process_Opened_Files>:
    8ec4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ec8 <_ZL10Indefinite>:
    8ec8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ecc <_ZL18Deadline_Unchanged>:
    8ecc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008ed0 <_ZL14Invalid_Handle>:
    8ed0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8ed4:	3a564544 	bcc	159a3ec <__bss_end+0x1591484>
    8ed8:	696e6f6d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    8edc:	2f726f74 	svccs	0x00726f74
    8ee0:	00000030 	andeq	r0, r0, r0, lsr r0
    8ee4:	696e6f4d 	stmdbvs	lr!, {r0, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
    8ee8:	20726f74 	rsbscs	r6, r2, r4, ror pc
    8eec:	6b736174 	blvs	1ce14c4 <__bss_end+0x1cd855c>
    8ef0:	61747320 	cmnvs	r4, r0, lsr #6
    8ef4:	6e697472 	mcrvs	4, 3, r7, cr9, cr2, {3}
    8ef8:	00002167 	andeq	r2, r0, r7, ror #2
    8efc:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8f00:	205b0a0d 	subscs	r0, fp, sp, lsl #20
    8f04:	00000000 	andeq	r0, r0, r0
    8f08:	00203a5d 	eoreq	r3, r0, sp, asr sl

00008f0c <_ZL13Lock_Unlocked>:
    8f0c:	00000000 	andeq	r0, r0, r0

00008f10 <_ZL11Lock_Locked>:
    8f10:	00000001 	andeq	r0, r0, r1

00008f14 <_ZL21MaxFSDriverNameLength>:
    8f14:	00000010 	andeq	r0, r0, r0, lsl r0

00008f18 <_ZL17MaxFilenameLength>:
    8f18:	00000010 	andeq	r0, r0, r0, lsl r0

00008f1c <_ZL13MaxPathLength>:
    8f1c:	00000080 	andeq	r0, r0, r0, lsl #1

00008f20 <_ZL18NoFilesystemDriver>:
    8f20:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f24 <_ZL9NotifyAll>:
    8f24:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f28 <_ZL24Max_Process_Opened_Files>:
    8f28:	00000010 	andeq	r0, r0, r0, lsl r0

00008f2c <_ZL10Indefinite>:
    8f2c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f30 <_ZL18Deadline_Unchanged>:
    8f30:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f34 <_ZL14Invalid_Handle>:
    8f34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f38 <_ZL16Pipe_File_Prefix>:
    8f38:	3a535953 	bcc	14df48c <__bss_end+0x14d6524>
    8f3c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8f40:	0000002f 	andeq	r0, r0, pc, lsr #32

00008f44 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8f44:	33323130 	teqcc	r2, #48, 2
    8f48:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8f4c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8f50:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008f58 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16848c4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x394bc>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d0d0>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7dbc>
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
  34:	5a2f7374 	bpl	bdce0c <__bss_end+0xbd3ea4>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <__bss_end+0xffff6f44>
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
 124:	fb010200 	blx	4092e <__bss_end+0x379c6>
 128:	01000d0e 	tsteq	r0, lr, lsl #26
 12c:	00010101 	andeq	r0, r1, r1, lsl #2
 130:	00010000 	andeq	r0, r1, r0
 134:	6d2f0100 	stfvss	f0, [pc, #-0]	; 13c <shift+0x13c>
 138:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 13c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 140:	4b2f7372 	blmi	bdcf10 <__bss_end+0xbd3fa8>
 144:	2f616275 	svccs	0x00616275
 148:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 14c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 150:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 154:	614d6f72 	hvcvs	55026	; 0xd6f2
 158:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbec <__bss_end+0xffff6c84>
 15c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 160:	2f73656c 	svccs	0x0073656c
 164:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 168:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb0c <__bss_end+0xffff6ba4>
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
 1cc:	4a030402 	bmi	c11dc <__bss_end+0xb8274>
 1d0:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 1d4:	05830204 	streq	r0, [r3, #516]	; 0x204
 1d8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 1dc:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 1e0:	02040200 	andeq	r0, r4, #0, 4
 1e4:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 1e8:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 1ec:	056a1005 	strbeq	r1, [sl, #-5]!
 1f0:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 1f4:	0a054a03 	beq	152a08 <__bss_end+0x149aa0>
 1f8:	02040200 	andeq	r0, r4, #0, 4
 1fc:	00110583 	andseq	r0, r1, r3, lsl #11
 200:	4a020402 	bmi	81210 <__bss_end+0x782a8>
 204:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 208:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 20c:	0105850c 	tsteq	r5, ip, lsl #10
 210:	000a022f 	andeq	r0, sl, pc, lsr #4
 214:	020f0101 	andeq	r0, pc, #1073741824	; 0x40000000
 218:	00030000 	andeq	r0, r3, r0
 21c:	000001c3 	andeq	r0, r0, r3, asr #3
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
 270:	67676f6c 	strbvs	r6, [r7, -ip, ror #30]!
 274:	745f7265 	ldrbvc	r7, [pc], #-613	; 27c <shift+0x27c>
 278:	006b7361 	rsbeq	r7, fp, r1, ror #6
 27c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 280:	552f632f 	strpl	r6, [pc, #-815]!	; ffffff59 <__bss_end+0xffff6ff1>
 284:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 288:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 28c:	6f442f61 	svcvs	0x00442f61
 290:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 294:	2f73746e 	svccs	0x0073746e
 298:	6f72655a 	svcvs	0x0072655a
 29c:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 2a0:	6178652f 	cmnvs	r8, pc, lsr #10
 2a4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 2a8:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 2ac:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 2b0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2b4:	61707372 	cmnvs	r0, r2, ror r3
 2b8:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 2bc:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 2c0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2c4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2c8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2cc:	6f72702f 	svcvs	0x0072702f
 2d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 2d4:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 2d8:	2f632f74 	svccs	0x00632f74
 2dc:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 2e0:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 2e4:	442f6162 	strtmi	r6, [pc], #-354	; 2ec <shift+0x2ec>
 2e8:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 2ec:	73746e65 	cmnvc	r4, #1616	; 0x650
 2f0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 2f4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 2f8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 2fc:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 300:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 304:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 308:	73752f66 	cmnvc	r5, #408	; 0x198
 30c:	70737265 	rsbsvc	r7, r3, r5, ror #4
 310:	2f656361 	svccs	0x00656361
 314:	6b2f2e2e 	blvs	bcbbd4 <__bss_end+0xbc2c6c>
 318:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 31c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 320:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 324:	73662f65 	cmnvc	r6, #404	; 0x194
 328:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 32c:	2f632f74 	svccs	0x00632f74
 330:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 334:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 338:	442f6162 	strtmi	r6, [pc], #-354	; 340 <shift+0x340>
 33c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 340:	73746e65 	cmnvc	r4, #1616	; 0x650
 344:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 348:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 34c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 350:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 354:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 358:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 35c:	73752f66 	cmnvc	r5, #408	; 0x198
 360:	70737265 	rsbsvc	r7, r3, r5, ror #4
 364:	2f656361 	svccs	0x00656361
 368:	6b2f2e2e 	blvs	bcbc28 <__bss_end+0xbc2cc0>
 36c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 370:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 374:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 378:	6f622f65 	svcvs	0x00622f65
 37c:	2f647261 	svccs	0x00647261
 380:	30697072 	rsbcc	r7, r9, r2, ror r0
 384:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 388:	616d0000 	cmnvs	sp, r0
 38c:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 390:	01007070 	tsteq	r0, r0, ror r0
 394:	70730000 	rsbsvc	r0, r3, r0
 398:	6f6c6e69 	svcvs	0x006c6e69
 39c:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3a0:	00000200 	andeq	r0, r0, r0, lsl #4
 3a4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3a8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3ac:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3b0:	00000300 	andeq	r0, r0, r0, lsl #6
 3b4:	636f7270 	cmnvs	pc, #112, 4
 3b8:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3bc:	00020068 	andeq	r0, r2, r8, rrx
 3c0:	6f727000 	svcvs	0x00727000
 3c4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3c8:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3cc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3d0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3d4:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 3d8:	66656474 			; <UNDEFINED> instruction: 0x66656474
 3dc:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 3e0:	05000000 	streq	r0, [r0, #-0]
 3e4:	02050001 	andeq	r0, r5, #1
 3e8:	0000822c 	andeq	r8, r0, ip, lsr #4
 3ec:	05010d03 	streq	r0, [r1, #-3331]	; 0xfffff2fd
 3f0:	0a059f1f 	beq	168074 <__bss_end+0x15f10c>
 3f4:	83010566 	movwhi	r0, #5478	; 0x1566
 3f8:	9f210569 	svcls	0x00210569
 3fc:	6a840a05 	bvs	fe102c18 <__bss_end+0xfe0f9cb0>
 400:	840e0583 	strhi	r0, [lr], #-1411	; 0xfffffa7d
 404:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
 408:	1a05860d 	bne	161c44 <__bss_end+0x158cdc>
 40c:	bb090584 	bllt	241a24 <__bss_end+0x238abc>
 410:	05681405 	strbeq	r1, [r8, #-1029]!	; 0xfffffbfb
 414:	2b059f12 	blcs	168064 <__bss_end+0x15f0fc>
 418:	4b110567 	blmi	4419bc <__bss_end+0x438a54>
 41c:	839f1205 	orrshi	r1, pc, #1342177280	; 0x50000000
 420:	84050567 	strhi	r0, [r5], #-1383	; 0xfffffa99
 424:	01000c02 	tsteq	r0, r2, lsl #24
 428:	00028801 	andeq	r8, r2, r1, lsl #16
 42c:	9d000300 	stcls	3, cr0, [r0, #-0]
 430:	02000001 	andeq	r0, r0, #1
 434:	0d0efb01 	vstreq	d15, [lr, #-4]
 438:	01010100 	mrseq	r0, (UNDEF: 17)
 43c:	00000001 	andeq	r0, r0, r1
 440:	01000001 	tsteq	r0, r1
 444:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 448:	552f632f 	strpl	r6, [pc, #-815]!	; 121 <shift+0x121>
 44c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 450:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 454:	6f442f61 	svcvs	0x00442f61
 458:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 45c:	2f73746e 	svccs	0x0073746e
 460:	6f72655a 	svcvs	0x0072655a
 464:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 468:	6178652f 	cmnvs	r8, pc, lsr #10
 46c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 470:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 474:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 478:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 47c:	2f62696c 	svccs	0x0062696c
 480:	00637273 	rsbeq	r7, r3, r3, ror r2
 484:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 488:	552f632f 	strpl	r6, [pc, #-815]!	; 161 <shift+0x161>
 48c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 490:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 494:	6f442f61 	svcvs	0x00442f61
 498:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 49c:	2f73746e 	svccs	0x0073746e
 4a0:	6f72655a 	svcvs	0x0072655a
 4a4:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 4a8:	6178652f 	cmnvs	r8, pc, lsr #10
 4ac:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 4b0:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 4b4:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 4b8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 4bc:	2f6c656e 	svccs	0x006c656e
 4c0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 4c4:	2f656475 	svccs	0x00656475
 4c8:	636f7270 	cmnvs	pc, #112, 4
 4cc:	00737365 	rsbseq	r7, r3, r5, ror #6
 4d0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 4d4:	552f632f 	strpl	r6, [pc, #-815]!	; 1ad <shift+0x1ad>
 4d8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 4dc:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 4e0:	6f442f61 	svcvs	0x00442f61
 4e4:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 4e8:	2f73746e 	svccs	0x0073746e
 4ec:	6f72655a 	svcvs	0x0072655a
 4f0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 4f4:	6178652f 	cmnvs	r8, pc, lsr #10
 4f8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 4fc:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 500:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 504:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 508:	2f6c656e 	svccs	0x006c656e
 50c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 510:	2f656475 	svccs	0x00656475
 514:	2f007366 	svccs	0x00007366
 518:	2f746e6d 	svccs	0x00746e6d
 51c:	73552f63 	cmpvc	r5, #396	; 0x18c
 520:	2f737265 	svccs	0x00737265
 524:	6162754b 	cmnvs	r2, fp, asr #10
 528:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 52c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 530:	5a2f7374 	bpl	bdd308 <__bss_end+0xbd43a0>
 534:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 3a8 <shift+0x3a8>
 538:	2f657461 	svccs	0x00657461
 53c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 540:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 544:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 548:	2f666465 	svccs	0x00666465
 54c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 550:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 554:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 558:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 55c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 560:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 564:	61682f30 	cmnvs	r8, r0, lsr pc
 568:	7300006c 	movwvc	r0, #108	; 0x6c
 56c:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 570:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 574:	01007070 	tsteq	r0, r0, ror r0
 578:	77730000 	ldrbvc	r0, [r3, -r0]!
 57c:	00682e69 	rsbeq	r2, r8, r9, ror #28
 580:	73000002 	movwvc	r0, #2
 584:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 588:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 58c:	00020068 	andeq	r0, r2, r8, rrx
 590:	6c696600 	stclvs	6, cr6, [r9], #-0
 594:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 598:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 59c:	00030068 	andeq	r0, r3, r8, rrx
 5a0:	6f727000 	svcvs	0x00727000
 5a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 5a8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5ac:	72700000 	rsbsvc	r0, r0, #0
 5b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 5b4:	616d5f73 	smcvs	54771	; 0xd5f3
 5b8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 5bc:	00682e72 	rsbeq	r2, r8, r2, ror lr
 5c0:	69000002 	stmdbvs	r0, {r1}
 5c4:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 5c8:	00682e66 	rsbeq	r2, r8, r6, ror #28
 5cc:	00000004 	andeq	r0, r0, r4
 5d0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 5d4:	00838402 	addeq	r8, r3, r2, lsl #8
 5d8:	05051600 	streq	r1, [r5, #-1536]	; 0xfffffa00
 5dc:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
 5e0:	2f01054c 	svccs	0x0001054c
 5e4:	83050585 	movwhi	r0, #21893	; 0x5585
 5e8:	2f01054b 	svccs	0x0001054b
 5ec:	4b050585 	blmi	141c08 <__bss_end+0x138ca0>
 5f0:	852f0105 	strhi	r0, [pc, #-261]!	; 4f3 <shift+0x4f3>
 5f4:	4ba10505 	blmi	fe841a10 <__bss_end+0xfe838aa8>
 5f8:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 5fc:	2f01054c 	svccs	0x0001054c
 600:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 604:	2f4b4b4b 	svccs	0x004b4b4b
 608:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 60c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 610:	4b4bbd05 	blmi	12efa2c <__bss_end+0x12e6ac4>
 614:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 618:	2f01054c 	svccs	0x0001054c
 61c:	83050585 	movwhi	r0, #21893	; 0x5585
 620:	2f01054b 	svccs	0x0001054b
 624:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 628:	2f4b4b4b 	svccs	0x004b4b4b
 62c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 630:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 634:	4b4ba105 	blmi	12e8a50 <__bss_end+0x12dfae8>
 638:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 63c:	852f0105 	strhi	r0, [pc, #-261]!	; 53f <shift+0x53f>
 640:	4bbd0505 	blmi	fef41a5c <__bss_end+0xfef38af4>
 644:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffb01 <__bss_end+0xffff6b99>
 648:	01054c0c 	tsteq	r5, ip, lsl #24
 64c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 650:	2f4b4ba1 	svccs	0x004b4ba1
 654:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 658:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 65c:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
 660:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
 664:	0105300c 	tsteq	r5, ip
 668:	2005852f 	andcs	r8, r5, pc, lsr #10
 66c:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
 670:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
 674:	2f010530 	svccs	0x00010530
 678:	83200585 			; <UNDEFINED> instruction: 0x83200585
 67c:	4b4c0505 	blmi	1301a98 <__bss_end+0x12f8b30>
 680:	2f01054b 	svccs	0x0001054b
 684:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 688:	4b4d0505 	blmi	1341aa4 <__bss_end+0x1338b3c>
 68c:	300c054b 	andcc	r0, ip, fp, asr #10
 690:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 694:	9fa00c05 	svcls	0x00a00c05
 698:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 69c:	36056629 	strcc	r6, [r5], -r9, lsr #12
 6a0:	300f052e 	andcc	r0, pc, lr, lsr #10
 6a4:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 6a8:	10058409 	andne	r8, r5, r9, lsl #8
 6ac:	9f0105d8 	svcls	0x000105d8
 6b0:	01000802 	tsteq	r0, r2, lsl #16
 6b4:	00028701 	andeq	r8, r2, r1, lsl #14
 6b8:	64000300 	strvs	r0, [r0], #-768	; 0xfffffd00
 6bc:	02000000 	andeq	r0, r0, #0
 6c0:	0d0efb01 	vstreq	d15, [lr, #-4]
 6c4:	01010100 	mrseq	r0, (UNDEF: 17)
 6c8:	00000001 	andeq	r0, r0, r1
 6cc:	01000001 	tsteq	r0, r1
 6d0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 6d4:	552f632f 	strpl	r6, [pc, #-815]!	; 3ad <shift+0x3ad>
 6d8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 6dc:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
 6e0:	6f442f61 	svcvs	0x00442f61
 6e4:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
 6e8:	2f73746e 	svccs	0x0073746e
 6ec:	6f72655a 	svcvs	0x0072655a
 6f0:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
 6f4:	6178652f 	cmnvs	r8, pc, lsr #10
 6f8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
 6fc:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
 700:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
 704:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 708:	2f62696c 	svccs	0x0062696c
 70c:	00637273 	rsbeq	r7, r3, r3, ror r2
 710:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 714:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 718:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 71c:	01007070 	tsteq	r0, r0, ror r0
 720:	05000000 	streq	r0, [r0, #-0]
 724:	02050001 	andeq	r0, r5, #1
 728:	000087e0 	andeq	r8, r0, r0, ror #15
 72c:	bb09051a 	bllt	241b9c <__bss_end+0x238c34>
 730:	054c1205 	strbeq	r1, [ip, #-517]	; 0xfffffdfb
 734:	10056827 	andne	r6, r5, r7, lsr #16
 738:	2e1105ba 	cfcmp64cs	r0, mvdx1, mvdx10
 73c:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
 740:	0f054a13 	svceq	0x00054a13
 744:	9f0a052f 	svcls	0x000a052f
 748:	35620505 	strbcc	r0, [r2, #-1285]!	; 0xfffffafb
 74c:	05681005 	strbeq	r1, [r8, #-5]!
 750:	22052e11 	andcs	r2, r5, #272	; 0x110
 754:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 758:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffd5b <__bss_end+0xffff6df3>
 75c:	0d05690c 	vstreq.16	s12, [r5, #-24]	; 0xffffffe8	; <UNPREDICTABLE>
 760:	4a0f052e 	bmi	3c1c20 <__bss_end+0x3b8cb8>
 764:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
 768:	1c05680e 	stcne	8, cr6, [r5], {14}
 76c:	03040200 	movweq	r0, #16896	; 0x4200
 770:	0017054a 	andseq	r0, r7, sl, asr #10
 774:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 778:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 77c:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 780:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 784:	0e058202 	cdpeq	2, 0, cr8, cr5, cr2, {0}
 788:	02040200 	andeq	r0, r4, #0, 4
 78c:	0020054a 	eoreq	r0, r0, sl, asr #10
 790:	4b020402 	blmi	817a0 <__bss_end+0x78838>
 794:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
 798:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 79c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 7a0:	15054a02 	strne	r4, [r5, #-2562]	; 0xfffff5fe
 7a4:	02040200 	andeq	r0, r4, #0, 4
 7a8:	00210582 	eoreq	r0, r1, r2, lsl #11
 7ac:	4a020402 	bmi	817bc <__bss_end+0x78854>
 7b0:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 7b4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7b8:	04020010 	streq	r0, [r2], #-16
 7bc:	11052f02 	tstne	r5, r2, lsl #30
 7c0:	02040200 	andeq	r0, r4, #0, 4
 7c4:	0013052e 	andseq	r0, r3, lr, lsr #10
 7c8:	4a020402 	bmi	817d8 <__bss_end+0x78870>
 7cc:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 7d0:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 7d4:	05858801 	streq	r8, [r5, #2049]	; 0x801
 7d8:	0c058309 	stceq	3, cr8, [r5], {9}
 7dc:	4a13054c 	bmi	4c1d14 <__bss_end+0x4b8dac>
 7e0:	054c1005 	strbeq	r1, [ip, #-5]
 7e4:	0905bb0d 	stmdbeq	r5, {r0, r2, r3, r8, r9, fp, ip, sp, pc}
 7e8:	001d054a 	andseq	r0, sp, sl, asr #10
 7ec:	4a010402 	bmi	417fc <__bss_end+0x38894>
 7f0:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 7f4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 7f8:	1a054d13 	bne	153c4c <__bss_end+0x14ace4>
 7fc:	2e10054a 	cfmac32cs	mvfx0, mvfx0, mvfx10
 800:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
 804:	66780305 	ldrbtvs	r0, [r8], -r5, lsl #6
 808:	0b030c05 	bleq	c3824 <__bss_end+0xba8bc>
 80c:	2f01052e 	svccs	0x0001052e
 810:	bd0c0585 	cfstr32lt	mvfx0, [ip, #-532]	; 0xfffffdec
 814:	02001905 	andeq	r1, r0, #81920	; 0x14000
 818:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 81c:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 820:	21058202 	tstcs	r5, r2, lsl #4
 824:	02040200 	andeq	r0, r4, #0, 4
 828:	0019052e 	andseq	r0, r9, lr, lsr #10
 82c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 830:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 834:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 838:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 83c:	0e052e03 	cdpeq	14, 0, cr2, cr5, cr3, {0}
 840:	03040200 	movweq	r0, #16896	; 0x4200
 844:	000f054a 	andeq	r0, pc, sl, asr #10
 848:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 84c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 850:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 854:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 858:	05052e03 	streq	r2, [r5, #-3587]	; 0xfffff1fd
 85c:	03040200 	movweq	r0, #16896	; 0x4200
 860:	000e052d 	andeq	r0, lr, sp, lsr #10
 864:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 868:	01040200 	mrseq	r0, R12_usr
 86c:	000f0583 	andeq	r0, pc, r3, lsl #11
 870:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
 874:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 878:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 87c:	04020005 	streq	r0, [r2], #-5
 880:	0c054901 			; <UNDEFINED> instruction: 0x0c054901
 884:	2f010585 	svccs	0x00010585
 888:	bc0f0585 	cfstr32lt	mvfx0, [pc], {133}	; 0x85
 88c:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
 890:	0c05bc20 	stceq	12, cr11, [r5], {32}
 894:	4b200566 	blmi	801e34 <__bss_end+0x7f8ecc>
 898:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
 89c:	14054b09 	strne	r4, [r5], #-2825	; 0xfffff4f7
 8a0:	2e190583 	cdpcs	5, 1, cr0, cr9, cr3, {4}
 8a4:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
 8a8:	0c056714 	stceq	7, cr6, [r5], {20}
 8ac:	2f01054d 	svccs	0x0001054d
 8b0:	83090585 	movwhi	r0, #38277	; 0x9585
 8b4:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 8b8:	11052e0f 	tstne	r5, pc, lsl #28
 8bc:	4b0a0566 	blmi	281e5c <__bss_end+0x278ef4>
 8c0:	05650505 	strbeq	r0, [r5, #-1285]!	; 0xfffffafb
 8c4:	0105310c 	tsteq	r5, ip, lsl #2
 8c8:	0b05852f 	bleq	161d8c <__bss_end+0x158e24>
 8cc:	4c0e059f 	cfstr32mi	mvfx0, [lr], {159}	; 0x9f
 8d0:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 8d4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 8d8:	0402000d 	streq	r0, [r2], #-13
 8dc:	0e058302 	cdpeq	3, 0, cr8, cr5, cr2, {0}
 8e0:	02040200 	andeq	r0, r4, #0, 4
 8e4:	0010052e 	andseq	r0, r0, lr, lsr #10
 8e8:	4a020402 	bmi	818f8 <__bss_end+0x78990>
 8ec:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 8f0:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
 8f4:	05858401 	streq	r8, [r5, #1025]	; 0x401
 8f8:	0b05bb11 	bleq	16f544 <__bss_end+0x1665dc>
 8fc:	4c0e054b 	cfstr32mi	mvfx0, [lr], {75}	; 0x4b
 900:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 904:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 908:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 90c:	1d058302 	stcne	3, cr8, [r5, #-8]
 910:	02040200 	andeq	r0, r4, #0, 4
 914:	0010052e 	andseq	r0, r0, lr, lsr #10
 918:	4a020402 	bmi	81928 <__bss_end+0x789c0>
 91c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 920:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 924:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 928:	13054a02 	movwne	r4, #23042	; 0x5a02
 92c:	02040200 	andeq	r0, r4, #0, 4
 930:	0005052e 	andeq	r0, r5, lr, lsr #10
 934:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 938:	02840105 	addeq	r0, r4, #1073741825	; 0x40000001
 93c:	01010008 	tsteq	r1, r8
 940:	00000079 	andeq	r0, r0, r9, ror r0
 944:	00460003 	subeq	r0, r6, r3
 948:	01020000 	mrseq	r0, (UNDEF: 2)
 94c:	000d0efb 	strdeq	r0, [sp], -fp
 950:	01010101 	tsteq	r1, r1, lsl #2
 954:	01000000 	mrseq	r0, (UNDEF: 0)
 958:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 95c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 960:	2f2e2e2f 	svccs	0x002e2e2f
 964:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 968:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 96c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 970:	2f636367 	svccs	0x00636367
 974:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 978:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 97c:	00006d72 	andeq	r6, r0, r2, ror sp
 980:	3162696c 	cmncc	r2, ip, ror #18
 984:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 988:	00532e73 	subseq	r2, r3, r3, ror lr
 98c:	00000001 	andeq	r0, r0, r1
 990:	98020500 	stmdals	r2, {r8, sl}
 994:	0300008c 	movweq	r0, #140	; 0x8c
 998:	300108cf 	andcc	r0, r1, pc, asr #17
 99c:	2f2f2f2f 	svccs	0x002f2f2f
 9a0:	d002302f 	andle	r3, r2, pc, lsr #32
 9a4:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
 9a8:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
 9ac:	1f03322f 	svcne	0x0003322f
 9b0:	2f2f2f66 	svccs	0x002f2f66
 9b4:	2f2f2f2f 	svccs	0x002f2f2f
 9b8:	01000202 	tsteq	r0, r2, lsl #4
 9bc:	00005c01 	andeq	r5, r0, r1, lsl #24
 9c0:	46000300 	strmi	r0, [r0], -r0, lsl #6
 9c4:	02000000 	andeq	r0, r0, #0
 9c8:	0d0efb01 	vstreq	d15, [lr, #-4]
 9cc:	01010100 	mrseq	r0, (UNDEF: 17)
 9d0:	00000001 	andeq	r0, r0, r1
 9d4:	01000001 	tsteq	r0, r1
 9d8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9dc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9e0:	2f2e2e2f 	svccs	0x002e2e2f
 9e4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9e8:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 9ec:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 9f0:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 9f4:	2f676966 	svccs	0x00676966
 9f8:	006d7261 	rsbeq	r7, sp, r1, ror #4
 9fc:	62696c00 	rsbvs	r6, r9, #0, 24
 a00:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 a04:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 a08:	00000100 	andeq	r0, r0, r0, lsl #2
 a0c:	02050000 	andeq	r0, r5, #0
 a10:	00008ea4 	andeq	r8, r0, r4, lsr #29
 a14:	010bb903 	tsteq	fp, r3, lsl #18
 a18:	01000202 	tsteq	r0, r2, lsl #4
 a1c:	0000a401 	andeq	sl, r0, r1, lsl #8
 a20:	9e000300 	cdpls	3, 0, cr0, cr0, cr0, {0}
 a24:	02000000 	andeq	r0, r0, #0
 a28:	0d0efb01 	vstreq	d15, [lr, #-4]
 a2c:	01010100 	mrseq	r0, (UNDEF: 17)
 a30:	00000001 	andeq	r0, r0, r1
 a34:	01000001 	tsteq	r0, r1
 a38:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a3c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a40:	2f2e2e2f 	svccs	0x002e2e2f
 a44:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a48:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 a4c:	2f2e2e00 	svccs	0x002e2e00
 a50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a58:	2f2e2e2f 	svccs	0x002e2e2f
 a5c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 9ac <shift+0x9ac>
 a60:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a64:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 a68:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 a6c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 a70:	2f676966 	svccs	0x00676966
 a74:	006d7261 	rsbeq	r7, sp, r1, ror #4
 a78:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a7c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a80:	2f2e2e2f 	svccs	0x002e2e2f
 a84:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a88:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a8c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a90:	72610000 	rsbvc	r0, r1, #0
 a94:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
 a98:	00682e61 	rsbeq	r2, r8, r1, ror #28
 a9c:	61000001 	tstvs	r0, r1
 aa0:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
 aa4:	00000200 	andeq	r0, r0, r0, lsl #4
 aa8:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 aac:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 ab0:	00682e73 	rsbeq	r2, r8, r3, ror lr
 ab4:	6c000003 	stcvs	0, cr0, [r0], {3}
 ab8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 abc:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 ac0:	00000300 	andeq	r0, r0, r0, lsl #6
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
      34:	3a0c0000 	bcc	30003c <__bss_end+0x2f70d4>
      38:	46000001 	strmi	r0, [r0], -r1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	76000000 	strvc	r0, [r0], -r0
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a1 	andeq	r0, r0, r1, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	14210704 	strtne	r0, [r1], #-1796	; 0xfffff8fc
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x37150>
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
     11c:	14210704 	strtne	r0, [r1], #-1796	; 0xfffff8fc
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
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7618>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ee 	andeq	r0, r0, lr, ror #3
     184:	d20f4901 	andle	r4, pc, #16384	; 0x4000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x14470>
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
     254:	cb140a01 	blgt	502a60 <__bss_end+0x4f9af8>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x374f8>
     2c0:	00019e31 	andeq	r9, r1, r1, lsr lr
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	02640000 	rsbeq	r0, r4, #0
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02d40104 	sbcseq	r0, r4, #4, 2
     2d8:	c8040000 	stmdagt	r4, {}	; <UNPREDICTABLE>
     2dc:	46000003 	strmi	r0, [r0], -r3
     2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
     2e4:	58000082 	stmdapl	r0, {r1, r7}
     2e8:	16000001 	strne	r0, [r0], -r1
     2ec:	02000002 	andeq	r0, r0, #2
     2f0:	047b0801 	ldrbteq	r0, [fp], #-2049	; 0xfffff7ff
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	05230502 	streq	r0, [r3, #-1282]!	; 0xfffffafe
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000472 	andeq	r0, r0, r2, ror r4
     310:	93070202 	movwls	r0, #29186	; 0x7202
     314:	05000004 	streq	r0, [r0, #-4]
     318:	00000532 	andeq	r0, r0, r2, lsr r5
     31c:	5e070906 	vmlapl.f16	s0, s14, s12	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	21070402 	tstcs	r7, r2, lsl #8
     32c:	06000014 			; <UNDEFINED> instruction: 0x06000014
     330:	00000510 	andeq	r0, r0, r0, lsl r5
     334:	59140502 	ldmdbpl	r4, {r1, r8, sl}
     338:	05000000 	streq	r0, [r0, #-0]
     33c:	008ea803 	addeq	sl, lr, r3, lsl #16
     340:	041c0600 	ldreq	r0, [ip], #-1536	; 0xfffffa00
     344:	06020000 	streq	r0, [r2], -r0
     348:	00005914 	andeq	r5, r0, r4, lsl r9
     34c:	ac030500 	cfstr32ge	mvfx0, [r3], {-0}
     350:	0600008e 	streq	r0, [r0], -lr, lsl #1
     354:	000003ad 	andeq	r0, r0, sp, lsr #7
     358:	591a0703 	ldmdbpl	sl, {r0, r1, r8, r9, sl}
     35c:	05000000 	streq	r0, [r0, #-0]
     360:	008eb003 	addeq	fp, lr, r3
     364:	04520600 	ldrbeq	r0, [r2], #-1536	; 0xfffffa00
     368:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     36c:	0000591a 	andeq	r5, r0, sl, lsl r9
     370:	b4030500 	strlt	r0, [r3], #-1280	; 0xfffffb00
     374:	0600008e 	streq	r0, [r0], -lr, lsl #1
     378:	00000464 	andeq	r0, r0, r4, ror #8
     37c:	591a0b03 	ldmdbpl	sl, {r0, r1, r8, r9, fp}
     380:	05000000 	streq	r0, [r0, #-0]
     384:	008eb803 	addeq	fp, lr, r3, lsl #16
     388:	04350600 	ldrteq	r0, [r5], #-1536	; 0xfffffa00
     38c:	0d030000 	stceq	0, cr0, [r3, #-0]
     390:	0000591a 	andeq	r5, r0, sl, lsl r9
     394:	bc030500 	cfstr32lt	mvfx0, [r3], {-0}
     398:	0600008e 	streq	r0, [r0], -lr, lsl #1
     39c:	000004a6 	andeq	r0, r0, r6, lsr #9
     3a0:	591a0f03 	ldmdbpl	sl, {r0, r1, r8, r9, sl, fp}
     3a4:	05000000 	streq	r0, [r0, #-0]
     3a8:	008ec003 	addeq	ip, lr, r3
     3ac:	0f020700 	svceq	0x00020700
     3b0:	04050000 	streq	r0, [r5], #-0
     3b4:	00000038 	andeq	r0, r0, r8, lsr r0
     3b8:	080c1b03 	stmdaeq	ip, {r0, r1, r8, r9, fp, ip}
     3bc:	08000001 	stmdaeq	r0, {r0}
     3c0:	00000506 	andeq	r0, r0, r6, lsl #10
     3c4:	04b00800 	ldrteq	r0, [r0], #2048	; 0x800
     3c8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
     3cc:	000004d4 	ldrdeq	r0, [r0], -r4
     3d0:	25090002 	strcs	r0, [r9, #-2]
     3d4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     3d8:	0a000001 	beq	3e4 <shift+0x3e4>
     3dc:	0000005e 	andeq	r0, r0, lr, asr r0
     3e0:	0102000f 	tsteq	r2, pc
     3e4:	0003c302 	andeq	ip, r3, r2, lsl #6
     3e8:	2c040b00 			; <UNDEFINED> instruction: 0x2c040b00
     3ec:	06000000 	streq	r0, [r0], -r0
     3f0:	000004bb 			; <UNDEFINED> instruction: 0x000004bb
     3f4:	59140404 	ldmdbpl	r4, {r2, sl}
     3f8:	05000000 	streq	r0, [r0, #-0]
     3fc:	008ec403 	addeq	ip, lr, r3, lsl #8
     400:	04ee0600 	strbteq	r0, [lr], #1536	; 0x600
     404:	07040000 	streq	r0, [r4, -r0]
     408:	00005914 	andeq	r5, r0, r4, lsl r9
     40c:	c8030500 	stmdagt	r3, {r8, sl}
     410:	0600008e 	streq	r0, [r0], -lr, lsl #1
     414:	00000480 	andeq	r0, r0, r0, lsl #9
     418:	59140a04 	ldmdbpl	r4, {r2, r9, fp}
     41c:	05000000 	streq	r0, [r0, #-0]
     420:	008ecc03 	addeq	ip, lr, r3, lsl #24
     424:	07040200 	streq	r0, [r4, -r0, lsl #4]
     428:	0000141c 	andeq	r1, r0, ip, lsl r4
     42c:	0004df06 	andeq	sp, r4, r6, lsl #30
     430:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     434:	00000059 	andeq	r0, r0, r9, asr r0
     438:	8ed00305 	cdphi	3, 13, cr0, cr0, cr5, {0}
     43c:	b50c0000 	strlt	r0, [ip, #-0]
     440:	01000013 	tsteq	r0, r3, lsl r0
     444:	00380512 	eorseq	r0, r8, r2, lsl r5
     448:	82680000 	rsbhi	r0, r8, #0
     44c:	011c0000 	tsteq	ip, r0
     450:	9c010000 	stcls	0, cr0, [r1], {-0}
     454:	0000022a 	andeq	r0, r0, sl, lsr #4
     458:	00051e0d 	andeq	r1, r5, sp, lsl #28
     45c:	0e120100 	mufeqs	f0, f2, f0
     460:	00000038 	andeq	r0, r0, r8, lsr r0
     464:	7fbc9103 	svcvc	0x00bc9103
     468:	00052d0d 	andeq	r2, r5, sp, lsl #26
     46c:	1b120100 	blne	480874 <__bss_end+0x47790c>
     470:	0000022a 	andeq	r0, r0, sl, lsr #4
     474:	7fb89103 	svcvc	0x00b89103
     478:	0004f90e 	andeq	pc, r4, lr, lsl #18
     47c:	0e140100 	mufeqs	f0, f4, f0
     480:	0000004d 	andeq	r0, r0, sp, asr #32
     484:	0f749102 	svceq	0x00749102
     488:	00667562 	rsbeq	r7, r6, r2, ror #10
     48c:	080a1801 	stmdaeq	sl, {r0, fp, ip}
     490:	02000001 	andeq	r0, r0, #1
     494:	430e5491 	movwmi	r5, #58513	; 0xe491
     498:	01000005 	tsteq	r0, r5
     49c:	01080a19 	tsteq	r8, r9, lsl sl
     4a0:	91020000 	mrsls	r0, (UNDEF: 2)
     4a4:	04480e44 	strbeq	r0, [r8], #-3652	; 0xfffff1bc
     4a8:	1d010000 	stcne	0, cr0, [r1, #-0]
     4ac:	00004d0e 	andeq	r4, r0, lr, lsl #26
     4b0:	70910200 	addsvc	r0, r1, r0, lsl #4
     4b4:	00053b0e 	andeq	r3, r5, lr, lsl #22
     4b8:	0e1f0100 	mufeqe	f0, f7, f0
     4bc:	0000004d 	andeq	r0, r0, sp, asr #32
     4c0:	106c9102 	rsbne	r9, ip, r2, lsl #2
     4c4:	000082d0 	ldrdeq	r8, [r0], -r0
     4c8:	0000009c 	muleq	r0, ip, r0
     4cc:	0100760f 	tsteq	r0, pc, lsl #12
     4d0:	004d1225 	subeq	r1, sp, r5, lsr #4
     4d4:	91020000 	mrsls	r0, (UNDEF: 2)
     4d8:	83041068 	movwhi	r1, #16488	; 0x4068
     4dc:	00680000 	rsbeq	r0, r8, r0
     4e0:	4d0e0000 	stcmi	0, cr0, [lr, #-0]
     4e4:	01000004 	tsteq	r0, r4
     4e8:	004d162a 	subeq	r1, sp, sl, lsr #12
     4ec:	91020000 	mrsls	r0, (UNDEF: 2)
     4f0:	00000064 	andeq	r0, r0, r4, rrx
     4f4:	0230040b 	eorseq	r0, r0, #184549376	; 0xb000000
     4f8:	040b0000 	streq	r0, [fp], #-0
     4fc:	00000025 	andeq	r0, r0, r5, lsr #32
     500:	00042811 	andeq	r2, r4, r1, lsl r8
     504:	0d0d0100 	stfeqs	f0, [sp, #-0]
     508:	0000822c 	andeq	r8, r0, ip, lsr #4
     50c:	0000003c 	andeq	r0, r0, ip, lsr r0
     510:	010d9c01 	tsteq	sp, r1, lsl #24
     514:	01000005 	tsteq	r0, r5
     518:	004d1c0d 	subeq	r1, sp, sp, lsl #24
     51c:	91020000 	mrsls	r0, (UNDEF: 2)
     520:	042e0d74 	strteq	r0, [lr], #-3444	; 0xfffff28c
     524:	0d010000 	stceq	0, cr0, [r1, #-0]
     528:	00011f2e 	andeq	r1, r1, lr, lsr #30
     52c:	70910200 	addsvc	r0, r1, r0, lsl #4
     530:	0b1f0000 	bleq	7c0538 <__bss_end+0x7b75d0>
     534:	00040000 	andeq	r0, r4, r0
     538:	000002c2 	andeq	r0, r0, r2, asr #5
     53c:	09f40104 	ldmibeq	r4!, {r2, r8}^
     540:	69040000 	stmdbvs	r4, {}	; <UNPREDICTABLE>
     544:	53000007 	movwpl	r0, #7
     548:	8400000b 	strhi	r0, [r0], #-11
     54c:	5c000083 	stcpl	0, cr0, [r0], {131}	; 0x83
     550:	29000004 	stmdbcs	r0, {r2}
     554:	02000004 	andeq	r0, r0, #4
     558:	047b0801 	ldrbteq	r0, [fp], #-2049	; 0xfffff7ff
     55c:	25030000 	strcs	r0, [r3, #-0]
     560:	02000000 	andeq	r0, r0, #0
     564:	05230502 	streq	r0, [r3, #-1282]!	; 0xfffffafe
     568:	04040000 	streq	r0, [r4], #-0
     56c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     570:	08010200 	stmdaeq	r1, {r9}
     574:	00000472 	andeq	r0, r0, r2, ror r4
     578:	93070202 	movwls	r0, #29186	; 0x7202
     57c:	05000004 	streq	r0, [r0, #-4]
     580:	00000532 	andeq	r0, r0, r2, lsr r5
     584:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
     588:	03000000 	movweq	r0, #0
     58c:	0000004d 	andeq	r0, r0, sp, asr #32
     590:	21070402 	tstcs	r7, r2, lsl #8
     594:	06000014 			; <UNDEFINED> instruction: 0x06000014
     598:	00000750 	andeq	r0, r0, r0, asr r7
     59c:	08060208 	stmdaeq	r6, {r3, r9}
     5a0:	0000008b 	andeq	r0, r0, fp, lsl #1
     5a4:	00307207 	eorseq	r7, r0, r7, lsl #4
     5a8:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     5ac:	00000000 	andeq	r0, r0, r0
     5b0:	00317207 	eorseq	r7, r1, r7, lsl #4
     5b4:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     5b8:	04000000 	streq	r0, [r0], #-0
     5bc:	0c840800 	stceq	8, cr0, [r4], {0}
     5c0:	04050000 	streq	r0, [r5], #-0
     5c4:	00000038 	andeq	r0, r0, r8, lsr r0
     5c8:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     5cc:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     5d0:	00004b4f 	andeq	r4, r0, pc, asr #22
     5d4:	0007b50a 	andeq	fp, r7, sl, lsl #10
     5d8:	08000100 	stmdaeq	r0, {r8}
     5dc:	00000631 	andeq	r0, r0, r1, lsr r6
     5e0:	00380405 	eorseq	r0, r8, r5, lsl #8
     5e4:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     5e8:	0000e00c 	andeq	lr, r0, ip
     5ec:	08070a00 	stmdaeq	r7, {r9, fp}
     5f0:	0a000000 	beq	5f8 <shift+0x5f8>
     5f4:	00000f32 	andeq	r0, r0, r2, lsr pc
     5f8:	0f120a01 	svceq	0x00120a01
     5fc:	0a020000 	beq	80604 <__bss_end+0x7769c>
     600:	0000097f 	andeq	r0, r0, pc, ror r9
     604:	0b8e0a03 	bleq	fe382e18 <__bss_end+0xfe379eb0>
     608:	0a040000 	beq	100610 <__bss_end+0xf76a8>
     60c:	000007c7 	andeq	r0, r0, r7, asr #15
     610:	8c080005 	stchi	0, cr0, [r8], {5}
     614:	0500000e 	streq	r0, [r0, #-14]
     618:	00003804 	andeq	r3, r0, r4, lsl #16
     61c:	0c400200 	sfmeq	f0, 2, [r0], {-0}
     620:	0000011d 	andeq	r0, r0, sp, lsl r1
     624:	0005560a 	andeq	r5, r5, sl, lsl #12
     628:	460a0000 	strmi	r0, [sl], -r0
     62c:	01000006 	tsteq	r0, r6
     630:	0004d90a 	andeq	sp, r4, sl, lsl #18
     634:	e90a0200 	stmdb	sl, {r9}
     638:	0300000e 	movweq	r0, #14
     63c:	000f3c0a 	andeq	r3, pc, sl, lsl #24
     640:	140a0400 	strne	r0, [sl], #-1024	; 0xfffffc00
     644:	0500000b 	streq	r0, [r0, #-11]
     648:	0009460a 	andeq	r4, r9, sl, lsl #12
     64c:	08000600 	stmdaeq	r0, {r9, sl}
     650:	00000e46 	andeq	r0, r0, r6, asr #28
     654:	00380405 	eorseq	r0, r8, r5, lsl #8
     658:	67020000 	strvs	r0, [r2, -r0]
     65c:	0001480c 	andeq	r4, r1, ip, lsl #16
     660:	0c030a00 			; <UNDEFINED> instruction: 0x0c030a00
     664:	0a000000 	beq	66c <shift+0x66c>
     668:	00000901 	andeq	r0, r0, r1, lsl #18
     66c:	0c4d0a01 	mcrreq	10, 0, r0, sp, cr1
     670:	0a020000 	beq	80678 <__bss_end+0x77710>
     674:	0000094b 	andeq	r0, r0, fp, asr #18
     678:	100b0003 	andne	r0, fp, r3
     67c:	03000005 	movweq	r0, #5
     680:	00591405 	subseq	r1, r9, r5, lsl #8
     684:	03050000 	movweq	r0, #20480	; 0x5000
     688:	00008f0c 	andeq	r8, r0, ip, lsl #30
     68c:	00041c0b 	andeq	r1, r4, fp, lsl #24
     690:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     694:	00000059 	andeq	r0, r0, r9, asr r0
     698:	8f100305 	svchi	0x00100305
     69c:	ad0b0000 	stcge	0, cr0, [fp, #-0]
     6a0:	04000003 	streq	r0, [r0], #-3
     6a4:	00591a07 	subseq	r1, r9, r7, lsl #20
     6a8:	03050000 	movweq	r0, #20480	; 0x5000
     6ac:	00008f14 	andeq	r8, r0, r4, lsl pc
     6b0:	0004520b 	andeq	r5, r4, fp, lsl #4
     6b4:	1a090400 	bne	2416bc <__bss_end+0x238754>
     6b8:	00000059 	andeq	r0, r0, r9, asr r0
     6bc:	8f180305 	svchi	0x00180305
     6c0:	640b0000 	strvs	r0, [fp], #-0
     6c4:	04000004 	streq	r0, [r0], #-4
     6c8:	00591a0b 	subseq	r1, r9, fp, lsl #20
     6cc:	03050000 	movweq	r0, #20480	; 0x5000
     6d0:	00008f1c 	andeq	r8, r0, ip, lsl pc
     6d4:	0004350b 	andeq	r3, r4, fp, lsl #10
     6d8:	1a0d0400 	bne	3416e0 <__bss_end+0x338778>
     6dc:	00000059 	andeq	r0, r0, r9, asr r0
     6e0:	8f200305 	svchi	0x00200305
     6e4:	a60b0000 	strge	r0, [fp], -r0
     6e8:	04000004 	streq	r0, [r0], #-4
     6ec:	00591a0f 	subseq	r1, r9, pc, lsl #20
     6f0:	03050000 	movweq	r0, #20480	; 0x5000
     6f4:	00008f24 	andeq	r8, r0, r4, lsr #30
     6f8:	000f0208 	andeq	r0, pc, r8, lsl #4
     6fc:	38040500 	stmdacc	r4, {r8, sl}
     700:	04000000 	streq	r0, [r0], #-0
     704:	01eb0c1b 	mvneq	r0, fp, lsl ip
     708:	060a0000 	streq	r0, [sl], -r0
     70c:	00000005 	andeq	r0, r0, r5
     710:	0004b00a 	andeq	fp, r4, sl
     714:	d40a0100 	strle	r0, [sl], #-256	; 0xffffff00
     718:	02000004 	andeq	r0, r0, #4
     71c:	0bfd0c00 	bleq	fff43724 <__bss_end+0xfff3a7bc>
     720:	01020000 	mrseq	r0, (UNDEF: 2)
     724:	0003c302 	andeq	ip, r3, r2, lsl #6
     728:	2c040d00 	stccs	13, cr0, [r4], {-0}
     72c:	0d000000 	stceq	0, cr0, [r0, #-0]
     730:	0001eb04 	andeq	lr, r1, r4, lsl #22
     734:	04bb0b00 	ldrteq	r0, [fp], #2816	; 0xb00
     738:	04050000 	streq	r0, [r5], #-0
     73c:	00005914 	andeq	r5, r0, r4, lsl r9
     740:	28030500 	stmdacs	r3, {r8, sl}
     744:	0b00008f 	bleq	988 <shift+0x988>
     748:	000004ee 	andeq	r0, r0, lr, ror #9
     74c:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
     750:	05000000 	streq	r0, [r0, #-0]
     754:	008f2c03 	addeq	r2, pc, r3, lsl #24
     758:	04800b00 	streq	r0, [r0], #2816	; 0xb00
     75c:	0a050000 	beq	140764 <__bss_end+0x1377fc>
     760:	00005914 	andeq	r5, r0, r4, lsl r9
     764:	30030500 	andcc	r0, r3, r0, lsl #10
     768:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     76c:	000009da 	ldrdeq	r0, [r0], -sl
     770:	00380405 	eorseq	r0, r8, r5, lsl #8
     774:	0d050000 	stceq	0, cr0, [r5, #-0]
     778:	0002700c 	andeq	r7, r2, ip
     77c:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
     780:	0a000077 	beq	964 <shift+0x964>
     784:	000009d1 	ldrdeq	r0, [r0], -r1
     788:	0c950a01 	vldmiaeq	r5, {s0}
     78c:	0a020000 	beq	80794 <__bss_end+0x7782c>
     790:	000009a3 	andeq	r0, r0, r3, lsr #19
     794:	09710a03 	ldmdbeq	r1!, {r0, r1, r9, fp}^
     798:	0a040000 	beq	1007a0 <__bss_end+0xf7838>
     79c:	000008a3 	andeq	r0, r0, r3, lsr #17
     7a0:	ba060005 	blt	1807bc <__bss_end+0x177854>
     7a4:	10000007 	andne	r0, r0, r7
     7a8:	af081d05 	svcge	0x00081d05
     7ac:	07000002 	streq	r0, [r0, -r2]
     7b0:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     7b4:	02af131f 	adceq	r1, pc, #2080374784	; 0x7c000000
     7b8:	07000000 	streq	r0, [r0, -r0]
     7bc:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     7c0:	02af1320 	adceq	r1, pc, #32, 6	; 0x80000000
     7c4:	07040000 	streq	r0, [r4, -r0]
     7c8:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     7cc:	02af1321 	adceq	r1, pc, #-2080374784	; 0x84000000
     7d0:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     7d4:	000007d9 	ldrdeq	r0, [r0], -r9
     7d8:	af132205 	svcge	0x00132205
     7dc:	0c000002 	stceq	0, cr0, [r0], {2}
     7e0:	07040200 	streq	r0, [r4, -r0, lsl #4]
     7e4:	0000141c 	andeq	r1, r0, ip, lsl r4
     7e8:	00087606 	andeq	r7, r8, r6, lsl #12
     7ec:	2a057000 	bcs	15c7f4 <__bss_end+0x15388c>
     7f0:	00034608 	andeq	r4, r3, r8, lsl #12
     7f4:	0d020e00 	stceq	14, cr0, [r2, #-0]
     7f8:	2c050000 	stccs	0, cr0, [r5], {-0}
     7fc:	00027012 	andeq	r7, r2, r2, lsl r0
     800:	70070000 	andvc	r0, r7, r0
     804:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     808:	005e122d 	subseq	r1, lr, sp, lsr #4
     80c:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     810:	0000068b 	andeq	r0, r0, fp, lsl #13
     814:	39112e05 	ldmdbcc	r1, {r0, r2, r9, sl, fp, sp}
     818:	14000002 	strne	r0, [r0], #-2
     81c:	0009e60e 	andeq	lr, r9, lr, lsl #12
     820:	122f0500 	eorne	r0, pc, #0, 10
     824:	0000005e 	andeq	r0, r0, lr, asr r0
     828:	0ab50e18 	beq	fed44090 <__bss_end+0xfed3b128>
     82c:	31050000 	mrscc	r0, (UNDEF: 5)
     830:	00005e12 	andeq	r5, r0, r2, lsl lr
     834:	5c0e1c00 	stcpl	12, cr1, [lr], {-0}
     838:	05000007 	streq	r0, [r0, #-7]
     83c:	03460c32 	movteq	r0, #27698	; 0x6c32
     840:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     844:	00000aab 	andeq	r0, r0, fp, lsr #21
     848:	38053405 	stmdacc	r5, {r0, r2, sl, ip, sp}
     84c:	60000000 	andvs	r0, r0, r0
     850:	000d150e 	andeq	r1, sp, lr, lsl #10
     854:	0e350500 	cfabs32eq	mvfx0, mvfx5
     858:	0000004d 	andeq	r0, r0, sp, asr #32
     85c:	08180e64 	ldmdaeq	r8, {r2, r5, r6, r9, sl, fp}
     860:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     864:	00004d0e 	andeq	r4, r0, lr, lsl #26
     868:	0f0e6800 	svceq	0x000e6800
     86c:	05000008 	streq	r0, [r0, #-8]
     870:	004d0e39 	subeq	r0, sp, r9, lsr lr
     874:	006c0000 	rsbeq	r0, ip, r0
     878:	0001fd0f 	andeq	pc, r1, pc, lsl #26
     87c:	00035600 	andeq	r5, r3, r0, lsl #12
     880:	005e1000 	subseq	r1, lr, r0
     884:	000f0000 	andeq	r0, pc, r0
     888:	0004df0b 	andeq	sp, r4, fp, lsl #30
     88c:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
     890:	00000059 	andeq	r0, r0, r9, asr r0
     894:	8f340305 	svchi	0x00340305
     898:	ab080000 	blge	2008a0 <__bss_end+0x1f7938>
     89c:	05000009 	streq	r0, [r0, #-9]
     8a0:	00003804 	andeq	r3, r0, r4, lsl #16
     8a4:	0c0d0600 	stceq	6, cr0, [sp], {-0}
     8a8:	00000387 	andeq	r0, r0, r7, lsl #7
     8ac:	00064b0a 	andeq	r4, r6, sl, lsl #22
     8b0:	4b0a0000 	blmi	2808b8 <__bss_end+0x277950>
     8b4:	01000005 	tsteq	r0, r5
     8b8:	03680300 	cmneq	r8, #0, 6
     8bc:	f0080000 			; <UNDEFINED> instruction: 0xf0080000
     8c0:	0500000a 	streq	r0, [r0, #-10]
     8c4:	00003804 	andeq	r3, r0, r4, lsl #16
     8c8:	0c140600 	ldceq	6, cr0, [r4], {-0}
     8cc:	000003ab 	andeq	r0, r0, fp, lsr #7
     8d0:	0005950a 	andeq	r9, r5, sl, lsl #10
     8d4:	3f0a0000 	svccc	0x000a0000
     8d8:	0100000c 	tsteq	r0, ip
     8dc:	038c0300 	orreq	r0, ip, #0, 6
     8e0:	d5060000 	strle	r0, [r6, #-0]
     8e4:	0c00000d 	stceq	0, cr0, [r0], {13}
     8e8:	e5081b06 	str	r1, [r8, #-2822]	; 0xfffff4fa
     8ec:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     8f0:	00000590 	muleq	r0, r0, r5
     8f4:	e5191d06 	ldr	r1, [r9, #-3334]	; 0xfffff2fa
     8f8:	00000003 	andeq	r0, r0, r3
     8fc:	0006080e 	andeq	r0, r6, lr, lsl #16
     900:	191e0600 	ldmdbne	lr, {r9, sl}
     904:	000003e5 	andeq	r0, r0, r5, ror #7
     908:	0d890e04 	stceq	14, cr0, [r9, #16]
     90c:	1f060000 	svcne	0x00060000
     910:	0003eb13 	andeq	lr, r3, r3, lsl fp
     914:	0d000800 	stceq	8, cr0, [r0, #-0]
     918:	0003b004 	andeq	fp, r3, r4
     91c:	b6040d00 	strlt	r0, [r4], -r0, lsl #26
     920:	11000002 	tstne	r0, r2
     924:	000006b0 			; <UNDEFINED> instruction: 0x000006b0
     928:	07220614 			; <UNDEFINED> instruction: 0x07220614
     92c:	00000673 	andeq	r0, r0, r3, ror r6
     930:	0009990e 	andeq	r9, r9, lr, lsl #18
     934:	0e260600 	cfmadda32eq	mvax0, mvax0, mvfx6, mvfx0
     938:	0000004d 	andeq	r0, r0, sp, asr #32
     93c:	05c10e00 	strbeq	r0, [r1, #3584]	; 0xe00
     940:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
     944:	0003e519 	andeq	lr, r3, r9, lsl r5
     948:	d90e0400 	stmdble	lr, {sl}
     94c:	0600000c 	streq	r0, [r0], -ip
     950:	03e5192c 	mvneq	r1, #44, 18	; 0xb0000
     954:	12080000 	andne	r0, r8, #0
     958:	00000e82 	andeq	r0, r0, r2, lsl #29
     95c:	b20a2f06 	andlt	r2, sl, #6, 30
     960:	3900000d 	stmdbcc	r0, {r0, r2, r3}
     964:	44000004 	strmi	r0, [r0], #-4
     968:	13000004 	movwne	r0, #4
     96c:	00000678 	andeq	r0, r0, r8, ror r6
     970:	0003e514 	andeq	lr, r3, r4, lsl r5
     974:	9a150000 	bls	54097c <__bss_end+0x537a14>
     978:	0600000d 	streq	r0, [r0], -sp
     97c:	084d0a31 	stmdaeq	sp, {r0, r4, r5, r9, fp}^
     980:	01f00000 	mvnseq	r0, r0
     984:	045c0000 	ldrbeq	r0, [ip], #-0
     988:	04670000 	strbteq	r0, [r7], #-0
     98c:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     990:	14000006 	strne	r0, [r0], #-6
     994:	000003eb 	andeq	r0, r0, fp, ror #7
     998:	0de81600 	stcleq	6, cr1, [r8]
     99c:	35060000 	strcc	r0, [r6, #-0]
     9a0:	000d6419 	andeq	r6, sp, r9, lsl r4
     9a4:	0003e500 	andeq	lr, r3, r0, lsl #10
     9a8:	04800200 	streq	r0, [r0], #512	; 0x200
     9ac:	04860000 	streq	r0, [r6], #0
     9b0:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     9b4:	00000006 	andeq	r0, r0, r6
     9b8:	00093916 	andeq	r3, r9, r6, lsl r9
     9bc:	19370600 	ldmdbne	r7!, {r9, sl}
     9c0:	00000c0e 	andeq	r0, r0, lr, lsl #24
     9c4:	000003e5 	andeq	r0, r0, r5, ror #7
     9c8:	00049f02 	andeq	r9, r4, r2, lsl #30
     9cc:	0004a500 	andeq	sl, r4, r0, lsl #10
     9d0:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     9d4:	17000000 	strne	r0, [r0, -r0]
     9d8:	00000ad1 	ldrdeq	r0, [r0], -r1
     9dc:	912d3906 			; <UNDEFINED> instruction: 0x912d3906
     9e0:	0c000006 	stceq	0, cr0, [r0], {6}
     9e4:	06b01602 	ldrteq	r1, [r0], r2, lsl #12
     9e8:	3c060000 	stccc	0, cr0, [r6], {-0}
     9ec:	000f1805 	andeq	r1, pc, r5, lsl #16
     9f0:	00067800 	andeq	r7, r6, r0, lsl #16
     9f4:	04cc0100 	strbeq	r0, [ip], #256	; 0x100
     9f8:	04d20000 	ldrbeq	r0, [r2], #0
     9fc:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     a00:	00000006 	andeq	r0, r0, r6
     a04:	00066016 	andeq	r6, r6, r6, lsl r0
     a08:	0e3f0600 	cfmsuba32eq	mvax0, mvax0, mvfx15, mvfx0
     a0c:	00000e57 	andeq	r0, r0, r7, asr lr
     a10:	0000004d 	andeq	r0, r0, sp, asr #32
     a14:	0004eb01 	andeq	lr, r4, r1, lsl #22
     a18:	00050000 	andeq	r0, r5, r0
     a1c:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     a20:	9a140000 	bls	500a28 <__bss_end+0x4f7ac0>
     a24:	14000006 	strne	r0, [r0], #-6
     a28:	0000005e 	andeq	r0, r0, lr, asr r0
     a2c:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
     a30:	a9180000 	ldmdbge	r8, {}	; <UNPREDICTABLE>
     a34:	0600000d 	streq	r0, [r0], -sp
     a38:	0baf0a43 	bleq	febc334c <__bss_end+0xfebba3e4>
     a3c:	15010000 	strne	r0, [r1, #-0]
     a40:	1b000005 	blne	a5c <shift+0xa5c>
     a44:	13000005 	movwne	r0, #5
     a48:	00000678 	andeq	r0, r0, r8, ror r6
     a4c:	08c81600 	stmiaeq	r8, {r9, sl, ip}^
     a50:	46060000 	strmi	r0, [r6], -r0
     a54:	0005d413 	andeq	sp, r5, r3, lsl r4
     a58:	0003eb00 	andeq	lr, r3, r0, lsl #22
     a5c:	05340100 	ldreq	r0, [r4, #-256]!	; 0xffffff00
     a60:	053a0000 	ldreq	r0, [sl, #-0]!
     a64:	a0130000 	andsge	r0, r3, r0
     a68:	00000006 	andeq	r0, r0, r6
     a6c:	00060d16 	andeq	r0, r6, r6, lsl sp
     a70:	13490600 	movtne	r0, #38400	; 0x9600
     a74:	00000d21 	andeq	r0, r0, r1, lsr #26
     a78:	000003eb 	andeq	r0, r0, fp, ror #7
     a7c:	00055301 	andeq	r5, r5, r1, lsl #6
     a80:	00055e00 	andeq	r5, r5, r0, lsl #28
     a84:	06a01300 	strteq	r1, [r0], r0, lsl #6
     a88:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     a8c:	00000000 	andeq	r0, r0, r0
     a90:	000ece18 	andeq	ip, lr, r8, lsl lr
     a94:	0a4c0600 	beq	130229c <__bss_end+0x12f9334>
     a98:	0000055b 	andeq	r0, r0, fp, asr r5
     a9c:	00057301 	andeq	r7, r5, r1, lsl #6
     aa0:	00057900 	andeq	r7, r5, r0, lsl #18
     aa4:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     aa8:	16000000 	strne	r0, [r0], -r0
     aac:	00000d9a 	muleq	r0, sl, sp
     ab0:	df0a4e06 	svcle	0x000a4e06
     ab4:	f0000007 			; <UNDEFINED> instruction: 0xf0000007
     ab8:	01000001 	tsteq	r0, r1
     abc:	00000592 	muleq	r0, r2, r5
     ac0:	0000059d 	muleq	r0, sp, r5
     ac4:	00067813 	andeq	r7, r6, r3, lsl r8
     ac8:	004d1400 	subeq	r1, sp, r0, lsl #8
     acc:	16000000 	strne	r0, [r0], -r0
     ad0:	000008ed 	andeq	r0, r0, sp, ror #17
     ad4:	d00e5106 	andle	r5, lr, r6, lsl #2
     ad8:	4d00000b 	stcmi	0, cr0, [r0, #-44]	; 0xffffffd4
     adc:	01000000 	mrseq	r0, (UNDEF: 0)
     ae0:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
     ae4:	000005c1 	andeq	r0, r0, r1, asr #11
     ae8:	00067813 	andeq	r7, r6, r3, lsl r8
     aec:	01fd1400 	mvnseq	r1, r0, lsl #8
     af0:	16000000 	strne	r0, [r0], -r0
     af4:	000005a2 	andeq	r0, r0, r2, lsr #11
     af8:	210a5406 	tstcs	sl, r6, lsl #8
     afc:	f0000008 			; <UNDEFINED> instruction: 0xf0000008
     b00:	01000001 	tsteq	r0, r1
     b04:	000005da 	ldrdeq	r0, [r0], -sl
     b08:	000005e5 	andeq	r0, r0, r5, ror #11
     b0c:	00067813 	andeq	r7, r6, r3, lsl r8
     b10:	004d1400 	subeq	r1, sp, r0, lsl #8
     b14:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     b18:	00000920 	andeq	r0, r0, r0, lsr #18
     b1c:	f40a5706 	vst1.8	{d5}, [sl], r6
     b20:	0100000d 	tsteq	r0, sp
     b24:	000005fa 	strdeq	r0, [r0], -sl
     b28:	00000619 	andeq	r0, r0, r9, lsl r6
     b2c:	00067813 	andeq	r7, r6, r3, lsl r8
     b30:	00a91400 	adceq	r1, r9, r0, lsl #8
     b34:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     b38:	14000000 	strne	r0, [r0], #-0
     b3c:	0000004d 	andeq	r0, r0, sp, asr #32
     b40:	00004d14 	andeq	r4, r0, r4, lsl sp
     b44:	06a61400 	strteq	r1, [r6], r0, lsl #8
     b48:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     b4c:	00000d4e 	andeq	r0, r0, lr, asr #26
     b50:	04055a06 	streq	r5, [r5], #-2566	; 0xfffff5fa
     b54:	01000007 	tsteq	r0, r7
     b58:	0000062e 	andeq	r0, r0, lr, lsr #12
     b5c:	0000064d 	andeq	r0, r0, sp, asr #12
     b60:	00067813 	andeq	r7, r6, r3, lsl r8
     b64:	00e01400 	rsceq	r1, r0, r0, lsl #8
     b68:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     b6c:	14000000 	strne	r0, [r0], #-0
     b70:	0000004d 	andeq	r0, r0, sp, asr #32
     b74:	00004d14 	andeq	r4, r0, r4, lsl sp
     b78:	06a61400 	strteq	r1, [r6], r0, lsl #8
     b7c:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     b80:	0000069d 	muleq	r0, sp, r6
     b84:	c10a5d06 	tstgt	sl, r6, lsl #26
     b88:	f0000006 			; <UNDEFINED> instruction: 0xf0000006
     b8c:	01000001 	tsteq	r0, r1
     b90:	00000662 	andeq	r0, r0, r2, ror #12
     b94:	00067813 	andeq	r7, r6, r3, lsl r8
     b98:	03681400 	cmneq	r8, #0, 8
     b9c:	ac140000 	ldcge	0, cr0, [r4], {-0}
     ba0:	00000006 	andeq	r0, r0, r6
     ba4:	03f10300 	mvnseq	r0, #0, 6
     ba8:	040d0000 	streq	r0, [sp], #-0
     bac:	000003f1 	strdeq	r0, [r0], -r1
     bb0:	0003e51a 	andeq	lr, r3, sl, lsl r5
     bb4:	00068b00 	andeq	r8, r6, r0, lsl #22
     bb8:	00069100 	andeq	r9, r6, r0, lsl #2
     bbc:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     bc0:	1b000000 	blne	bc8 <shift+0xbc8>
     bc4:	000003f1 	strdeq	r0, [r0], -r1
     bc8:	0000067e 	andeq	r0, r0, lr, ror r6
     bcc:	003f040d 	eorseq	r0, pc, sp, lsl #8
     bd0:	040d0000 	streq	r0, [sp], #-0
     bd4:	00000673 	andeq	r0, r0, r3, ror r6
     bd8:	0065041c 	rsbeq	r0, r5, ip, lsl r4
     bdc:	041d0000 	ldreq	r0, [sp], #-0
     be0:	00002c0f 	andeq	r2, r0, pc, lsl #24
     be4:	0006be00 	andeq	fp, r6, r0, lsl #28
     be8:	005e1000 	subseq	r1, lr, r0
     bec:	00090000 	andeq	r0, r9, r0
     bf0:	0006ae03 	andeq	sl, r6, r3, lsl #28
     bf4:	08dc1e00 	ldmeq	ip, {r9, sl, fp, ip}^
     bf8:	a4010000 	strge	r0, [r1], #-0
     bfc:	0006be0c 	andeq	fp, r6, ip, lsl #28
     c00:	38030500 	stmdacc	r3, {r8, sl}
     c04:	1f00008f 	svcne	0x0000008f
     c08:	0000053e 	andeq	r0, r0, lr, lsr r5
     c0c:	e40aa601 	str	sl, [sl], #-1537	; 0xfffff9ff
     c10:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
     c14:	30000000 	andcc	r0, r0, r0
     c18:	b0000087 	andlt	r0, r0, r7, lsl #1
     c1c:	01000000 	mrseq	r0, (UNDEF: 0)
     c20:	0007339c 	muleq	r7, ip, r3
     c24:	0ec92000 	cdpeq	0, 12, cr2, cr9, cr0, {0}
     c28:	a6010000 	strge	r0, [r1], -r0
     c2c:	0001f71b 	andeq	pc, r1, fp, lsl r7	; <UNPREDICTABLE>
     c30:	ac910300 	ldcge	3, cr0, [r1], {0}
     c34:	0b4a207f 	bleq	1288e38 <__bss_end+0x127fed0>
     c38:	a6010000 	strge	r0, [r1], -r0
     c3c:	00004d2a 	andeq	r4, r0, sl, lsr #26
     c40:	a8910300 	ldmge	r1, {r8, r9}
     c44:	09cb1e7f 	stmibeq	fp, {r0, r1, r2, r3, r4, r5, r6, r9, sl, fp, ip}^
     c48:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
     c4c:	0007330a 	andeq	r3, r7, sl, lsl #6
     c50:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
     c54:	05bc1e7f 	ldreq	r1, [ip, #3711]!	; 0xe7f
     c58:	ac010000 	stcge	0, cr0, [r1], {-0}
     c5c:	00003809 	andeq	r3, r0, r9, lsl #16
     c60:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c64:	00250f00 	eoreq	r0, r5, r0, lsl #30
     c68:	07430000 	strbeq	r0, [r3, -r0]
     c6c:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
     c70:	3f000000 	svccc	0x00000000
     c74:	0b2f2100 	bleq	bc907c <__bss_end+0xbc0114>
     c78:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
     c7c:	000c640a 	andeq	r6, ip, sl, lsl #8
     c80:	00004d00 	andeq	r4, r0, r0, lsl #26
     c84:	0086f400 	addeq	pc, r6, r0, lsl #8
     c88:	00003c00 	andeq	r3, r0, r0, lsl #24
     c8c:	809c0100 	addshi	r0, ip, r0, lsl #2
     c90:	22000007 	andcs	r0, r0, #7
     c94:	00716572 	rsbseq	r6, r1, r2, ror r5
     c98:	ab209a01 	blge	8274a4 <__bss_end+0x81e53c>
     c9c:	02000003 	andeq	r0, r0, #3
     ca0:	cb1e7491 	blgt	79deec <__bss_end+0x794f84>
     ca4:	0100000a 	tsteq	r0, sl
     ca8:	004d0e9b 	umaaleq	r0, sp, fp, lr
     cac:	91020000 	mrsls	r0, (UNDEF: 2)
     cb0:	9d230070 	stcls	0, cr0, [r3, #-448]!	; 0xfffffe40
     cb4:	0100000b 	tsteq	r0, fp
     cb8:	066f068f 	strbteq	r0, [pc], -pc, lsl #13
     cbc:	86b80000 	ldrthi	r0, [r8], r0
     cc0:	003c0000 	eorseq	r0, ip, r0
     cc4:	9c010000 	stcls	0, cr0, [r1], {-0}
     cc8:	000007b9 			; <UNDEFINED> instruction: 0x000007b9
     ccc:	00088f20 	andeq	r8, r8, r0, lsr #30
     cd0:	218f0100 	orrcs	r0, pc, r0, lsl #2
     cd4:	0000004d 	andeq	r0, r0, sp, asr #32
     cd8:	226c9102 	rsbcs	r9, ip, #-2147483648	; 0x80000000
     cdc:	00716572 	rsbseq	r6, r1, r2, ror r5
     ce0:	ab209101 	blge	8250ec <__bss_end+0x81c184>
     ce4:	02000003 	andeq	r0, r0, #3
     ce8:	21007491 			; <UNDEFINED> instruction: 0x21007491
     cec:	00000b05 	andeq	r0, r0, r5, lsl #22
     cf0:	0c0a8301 	stceq	3, cr8, [sl], {1}
     cf4:	4d000009 	stcmi	0, cr0, [r0, #-36]	; 0xffffffdc
     cf8:	7c000000 	stcvc	0, cr0, [r0], {-0}
     cfc:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
     d00:	01000000 	mrseq	r0, (UNDEF: 0)
     d04:	0007f69c 	muleq	r7, ip, r6
     d08:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
     d0c:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
     d10:	00038720 	andeq	r8, r3, r0, lsr #14
     d14:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     d18:	0005b51e 	andeq	fp, r5, lr, lsl r5
     d1c:	0e860100 	rmfeqs	f0, f6, f0
     d20:	0000004d 	andeq	r0, r0, sp, asr #32
     d24:	00709102 	rsbseq	r9, r0, r2, lsl #2
     d28:	000eac21 	andeq	sl, lr, r1, lsr #24
     d2c:	0a770100 	beq	1dc1134 <__bss_end+0x1db81cc>
     d30:	000008aa 	andeq	r0, r0, sl, lsr #17
     d34:	0000004d 	andeq	r0, r0, sp, asr #32
     d38:	00008640 	andeq	r8, r0, r0, asr #12
     d3c:	0000003c 	andeq	r0, r0, ip, lsr r0
     d40:	08339c01 	ldmdaeq	r3!, {r0, sl, fp, ip, pc}
     d44:	72220000 	eorvc	r0, r2, #0
     d48:	01007165 	tsteq	r0, r5, ror #2
     d4c:	03872079 	orreq	r2, r7, #121	; 0x79
     d50:	91020000 	mrsls	r0, (UNDEF: 2)
     d54:	05b51e74 	ldreq	r1, [r5, #3700]!	; 0xe74
     d58:	7a010000 	bvc	40d60 <__bss_end+0x37df8>
     d5c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     d60:	70910200 	addsvc	r0, r1, r0, lsl #4
     d64:	09332100 	ldmdbeq	r3!, {r8, sp}
     d68:	6b010000 	blvs	40d70 <__bss_end+0x37e08>
     d6c:	000c3406 	andeq	r3, ip, r6, lsl #8
     d70:	0001f000 	andeq	pc, r1, r0
     d74:	0085ec00 	addeq	lr, r5, r0, lsl #24
     d78:	00005400 	andeq	r5, r0, r0, lsl #8
     d7c:	7f9c0100 	svcvc	0x009c0100
     d80:	20000008 	andcs	r0, r0, r8
     d84:	00000acb 	andeq	r0, r0, fp, asr #21
     d88:	4d156b01 	vldrmi	d6, [r5, #-4]
     d8c:	02000000 	andeq	r0, r0, #0
     d90:	0f206c91 	svceq	0x00206c91
     d94:	01000008 	tsteq	r0, r8
     d98:	004d256b 	subeq	r2, sp, fp, ror #10
     d9c:	91020000 	mrsls	r0, (UNDEF: 2)
     da0:	0ea41e68 	cdpeq	14, 10, cr1, cr4, cr8, {3}
     da4:	6d010000 	stcvs	0, cr0, [r1, #-0]
     da8:	00004d0e 	andeq	r4, r0, lr, lsl #26
     dac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     db0:	06862100 	streq	r2, [r6], r0, lsl #2
     db4:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
     db8:	000ca312 	andeq	sl, ip, r2, lsl r3
     dbc:	00008b00 	andeq	r8, r0, r0, lsl #22
     dc0:	00859c00 	addeq	r9, r5, r0, lsl #24
     dc4:	00005000 	andeq	r5, r0, r0
     dc8:	da9c0100 	ble	fe7011d0 <__bss_end+0xfe6f8268>
     dcc:	20000008 	andcs	r0, r0, r8
     dd0:	00000501 	andeq	r0, r0, r1, lsl #10
     dd4:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
     dd8:	02000000 	andeq	r0, r0, #0
     ddc:	0e206c91 	mcreq	12, 1, r6, cr0, cr1, {4}
     de0:	0100000b 	tsteq	r0, fp
     de4:	004d2f5e 	subeq	r2, sp, lr, asr pc
     de8:	91020000 	mrsls	r0, (UNDEF: 2)
     dec:	080f2068 	stmdaeq	pc, {r3, r5, r6, sp}	; <UNPREDICTABLE>
     df0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
     df4:	00004d3f 	andeq	r4, r0, pc, lsr sp
     df8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     dfc:	000ea41e 	andeq	sl, lr, lr, lsl r4
     e00:	16600100 	strbtne	r0, [r0], -r0, lsl #2
     e04:	0000008b 	andeq	r0, r0, fp, lsl #1
     e08:	00749102 	rsbseq	r9, r4, r2, lsl #2
     e0c:	000cec21 	andeq	lr, ip, r1, lsr #24
     e10:	0a520100 	beq	1481218 <__bss_end+0x14782b0>
     e14:	00000691 	muleq	r0, r1, r6
     e18:	0000004d 	andeq	r0, r0, sp, asr #32
     e1c:	00008558 	andeq	r8, r0, r8, asr r5
     e20:	00000044 	andeq	r0, r0, r4, asr #32
     e24:	09269c01 	stmdbeq	r6!, {r0, sl, fp, ip, pc}
     e28:	01200000 			; <UNDEFINED> instruction: 0x01200000
     e2c:	01000005 	tsteq	r0, r5
     e30:	004d1a52 	subeq	r1, sp, r2, asr sl
     e34:	91020000 	mrsls	r0, (UNDEF: 2)
     e38:	0b0e206c 	bleq	388ff0 <__bss_end+0x380088>
     e3c:	52010000 	andpl	r0, r1, #0
     e40:	00004d29 	andeq	r4, r0, r9, lsr #26
     e44:	68910200 	ldmvs	r1, {r9}
     e48:	000cd21e 	andeq	sp, ip, lr, lsl r2
     e4c:	0e540100 	rdfeqs	f0, f4, f0
     e50:	0000004d 	andeq	r0, r0, sp, asr #32
     e54:	00749102 	rsbseq	r9, r4, r2, lsl #2
     e58:	000ccc21 	andeq	ip, ip, r1, lsr #24
     e5c:	0a450100 	beq	1141264 <__bss_end+0x11382fc>
     e60:	00000cae 	andeq	r0, r0, lr, lsr #25
     e64:	0000004d 	andeq	r0, r0, sp, asr #32
     e68:	00008508 	andeq	r8, r0, r8, lsl #10
     e6c:	00000050 	andeq	r0, r0, r0, asr r0
     e70:	09819c01 	stmibeq	r1, {r0, sl, fp, ip, pc}
     e74:	01200000 			; <UNDEFINED> instruction: 0x01200000
     e78:	01000005 	tsteq	r0, r5
     e7c:	004d1945 	subeq	r1, sp, r5, asr #18
     e80:	91020000 	mrsls	r0, (UNDEF: 2)
     e84:	0985206c 	stmibeq	r5, {r2, r3, r5, r6, sp}
     e88:	45010000 	strmi	r0, [r1, #-0]
     e8c:	00011d30 	andeq	r1, r1, r0, lsr sp
     e90:	68910200 	ldmvs	r1, {r9}
     e94:	000b1b20 	andeq	r1, fp, r0, lsr #22
     e98:	41450100 	mrsmi	r0, (UNDEF: 85)
     e9c:	000006ac 	andeq	r0, r0, ip, lsr #13
     ea0:	1e649102 	lgnnes	f1, f2
     ea4:	00000ea4 	andeq	r0, r0, r4, lsr #29
     ea8:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
     eac:	02000000 	andeq	r0, r0, #0
     eb0:	23007491 	movwcs	r7, #1169	; 0x491
     eb4:	0000058a 	andeq	r0, r0, sl, lsl #11
     eb8:	8f063f01 	svchi	0x00063f01
     ebc:	dc000009 	stcle	0, cr0, [r0], {9}
     ec0:	2c000084 	stccs	0, cr0, [r0], {132}	; 0x84
     ec4:	01000000 	mrseq	r0, (UNDEF: 0)
     ec8:	0009ab9c 	muleq	r9, ip, fp
     ecc:	05012000 	streq	r2, [r1, #-0]
     ed0:	3f010000 	svccc	0x00010000
     ed4:	00004d15 	andeq	r4, r0, r5, lsl sp
     ed8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     edc:	0aa52100 	beq	fe9492e4 <__bss_end+0xfe94037c>
     ee0:	32010000 	andcc	r0, r1, #0
     ee4:	000b210a 	andeq	r2, fp, sl, lsl #2
     ee8:	00004d00 	andeq	r4, r0, r0, lsl #26
     eec:	00848c00 	addeq	r8, r4, r0, lsl #24
     ef0:	00005000 	andeq	r5, r0, r0
     ef4:	069c0100 	ldreq	r0, [ip], r0, lsl #2
     ef8:	2000000a 	andcs	r0, r0, sl
     efc:	00000501 	andeq	r0, r0, r1, lsl #10
     f00:	4d193201 	lfmmi	f3, 4, [r9, #-4]
     f04:	02000000 	andeq	r0, r0, #0
     f08:	0e206c91 	mcreq	12, 1, r6, cr0, cr1, {4}
     f0c:	0100000d 	tsteq	r0, sp
     f10:	01f72b32 	mvnseq	r2, r2, lsr fp
     f14:	91020000 	mrsls	r0, (UNDEF: 2)
     f18:	0b4e2068 	bleq	13890c0 <__bss_end+0x1380158>
     f1c:	32010000 	andcc	r0, r1, #0
     f20:	00004d3c 	andeq	r4, r0, ip, lsr sp
     f24:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     f28:	000c9d1e 	andeq	r9, ip, lr, lsl sp
     f2c:	0e340100 	rsfeqs	f0, f4, f0
     f30:	0000004d 	andeq	r0, r0, sp, asr #32
     f34:	00749102 	rsbseq	r9, r4, r2, lsl #2
     f38:	000ee421 	andeq	lr, lr, r1, lsr #8
     f3c:	0a250100 	beq	941344 <__bss_end+0x9383dc>
     f40:	00000d8e 	andeq	r0, r0, lr, lsl #27
     f44:	0000004d 	andeq	r0, r0, sp, asr #32
     f48:	0000843c 	andeq	r8, r0, ip, lsr r4
     f4c:	00000050 	andeq	r0, r0, r0, asr r0
     f50:	0a619c01 	beq	1867f5c <__bss_end+0x185eff4>
     f54:	01200000 			; <UNDEFINED> instruction: 0x01200000
     f58:	01000005 	tsteq	r0, r5
     f5c:	004d1825 	subeq	r1, sp, r5, lsr #16
     f60:	91020000 	mrsls	r0, (UNDEF: 2)
     f64:	0d0e206c 	stceq	0, cr2, [lr, #-432]	; 0xfffffe50
     f68:	25010000 	strcs	r0, [r1, #-0]
     f6c:	000a672a 	andeq	r6, sl, sl, lsr #14
     f70:	68910200 	ldmvs	r1, {r9}
     f74:	000b4e20 	andeq	r4, fp, r0, lsr #28
     f78:	3b250100 	blcc	941380 <__bss_end+0x938418>
     f7c:	0000004d 	andeq	r0, r0, sp, asr #32
     f80:	1e649102 	lgnnes	f1, f2
     f84:	00000602 	andeq	r0, r0, r2, lsl #12
     f88:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
     f8c:	02000000 	andeq	r0, r0, #0
     f90:	0d007491 	cfstrseq	mvf7, [r0, #-580]	; 0xfffffdbc
     f94:	00002504 	andeq	r2, r0, r4, lsl #10
     f98:	0a610300 	beq	1841ba0 <__bss_end+0x1838c38>
     f9c:	df210000 	svcle	0x00210000
     fa0:	0100000a 	tsteq	r0, sl
     fa4:	0ef60a19 			; <UNDEFINED> instruction: 0x0ef60a19
     fa8:	004d0000 	subeq	r0, sp, r0
     fac:	83f80000 	mvnshi	r0, #0
     fb0:	00440000 	subeq	r0, r4, r0
     fb4:	9c010000 	stcls	0, cr0, [r1], {-0}
     fb8:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
     fbc:	000ec520 	andeq	ip, lr, r0, lsr #10
     fc0:	1b190100 	blne	6413c8 <__bss_end+0x638460>
     fc4:	000001f7 	strdeq	r0, [r0], -r7
     fc8:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     fcc:	00000cfd 	strdeq	r0, [r0], -sp
     fd0:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
     fd4:	02000001 	andeq	r0, r0, #1
     fd8:	011e6891 			; <UNDEFINED> instruction: 0x011e6891
     fdc:	01000005 	tsteq	r0, r5
     fe0:	004d0e1b 	subeq	r0, sp, fp, lsl lr
     fe4:	91020000 	mrsls	r0, (UNDEF: 2)
     fe8:	83240074 			; <UNDEFINED> instruction: 0x83240074
     fec:	01000008 	tsteq	r0, r8
     ff0:	06200614 			; <UNDEFINED> instruction: 0x06200614
     ff4:	83dc0000 	bicshi	r0, ip, #0
     ff8:	001c0000 	andseq	r0, ip, r0
     ffc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1000:	000cf323 	andeq	pc, ip, r3, lsr #6
    1004:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1008:	00000963 	andeq	r0, r0, r3, ror #18
    100c:	000083b0 			; <UNDEFINED> instruction: 0x000083b0
    1010:	0000002c 	andeq	r0, r0, ip, lsr #32
    1014:	0af89c01 	beq	ffe28020 <__bss_end+0xffe1f0b8>
    1018:	d0200000 	eorle	r0, r0, r0
    101c:	01000007 	tsteq	r0, r7
    1020:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1024:	91020000 	mrsls	r0, (UNDEF: 2)
    1028:	ef250074 	svc	0x00250074
    102c:	0100000e 	tsteq	r0, lr
    1030:	09c00a04 	stmibeq	r0, {r2, r9, fp}^
    1034:	004d0000 	subeq	r0, sp, r0
    1038:	83840000 	orrhi	r0, r4, #0
    103c:	002c0000 	eoreq	r0, ip, r0
    1040:	9c010000 	stcls	0, cr0, [r1], {-0}
    1044:	64697022 	strbtvs	r7, [r9], #-34	; 0xffffffde
    1048:	0e060100 	adfeqs	f0, f6, f0
    104c:	0000004d 	andeq	r0, r0, sp, asr #32
    1050:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1054:	00032e00 	andeq	r2, r3, r0, lsl #28
    1058:	2b000400 	blcs	2060 <shift+0x2060>
    105c:	04000005 	streq	r0, [r0], #-5
    1060:	0009f401 	andeq	pc, r9, r1, lsl #8
    1064:	10010400 	andne	r0, r1, r0, lsl #8
    1068:	0b530000 	bleq	14c1070 <__bss_end+0x14b8108>
    106c:	87e00000 	strbhi	r0, [r0, r0]!
    1070:	04b80000 	ldrteq	r0, [r8], #0
    1074:	06b50000 	ldrteq	r0, [r5], r0
    1078:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    107c:	03000000 	movweq	r0, #0
    1080:	00000f79 	andeq	r0, r0, r9, ror pc
    1084:	61100501 	tstvs	r0, r1, lsl #10
    1088:	11000000 	mrsne	r0, (UNDEF: 0)
    108c:	33323130 	teqcc	r2, #48, 2
    1090:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1094:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1098:	46454443 	strbmi	r4, [r5], -r3, asr #8
    109c:	01040000 	mrseq	r0, (UNDEF: 4)
    10a0:	00250103 	eoreq	r0, r5, r3, lsl #2
    10a4:	74050000 	strvc	r0, [r5], #-0
    10a8:	61000000 	mrsvs	r0, (UNDEF: 0)
    10ac:	06000000 	streq	r0, [r0], -r0
    10b0:	00000066 	andeq	r0, r0, r6, rrx
    10b4:	51070010 	tstpl	r7, r0, lsl r0
    10b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    10bc:	14210704 	strtne	r0, [r1], #-1796	; 0xfffff8fc
    10c0:	01080000 	mrseq	r0, (UNDEF: 8)
    10c4:	00047b08 	andeq	r7, r4, r8, lsl #22
    10c8:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    10cc:	2a090000 	bcs	2410d4 <__bss_end+0x23816c>
    10d0:	0a000000 	beq	10d8 <shift+0x10d8>
    10d4:	00000fa3 	andeq	r0, r0, r3, lsr #31
    10d8:	93066401 	movwls	r6, #25601	; 0x6401
    10dc:	1800000f 	stmdane	r0, {r0, r1, r2, r3}
    10e0:	8000008c 	andhi	r0, r0, ip, lsl #1
    10e4:	01000000 	mrseq	r0, (UNDEF: 0)
    10e8:	0000fb9c 	muleq	r0, ip, fp
    10ec:	72730b00 	rsbsvc	r0, r3, #0, 22
    10f0:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    10f4:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    10f8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    10fc:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    1100:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    1104:	00000102 	andeq	r0, r0, r2, lsl #2
    1108:	0b609102 	bleq	1825518 <__bss_end+0x181c5b0>
    110c:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1110:	042d6401 	strteq	r6, [sp], #-1025	; 0xfffffbff
    1114:	02000001 	andeq	r0, r0, #1
    1118:	f50c5c91 			; <UNDEFINED> instruction: 0xf50c5c91
    111c:	0100000f 	tsteq	r0, pc
    1120:	010b1166 	tsteq	fp, r6, ror #2
    1124:	91020000 	mrsls	r0, (UNDEF: 2)
    1128:	0f850c70 	svceq	0x00850c70
    112c:	67010000 	strvs	r0, [r1, -r0]
    1130:	0001110b 	andeq	r1, r1, fp, lsl #2
    1134:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1138:	008c400d 	addeq	r4, ip, sp
    113c:	00004800 	andeq	r4, r0, r0, lsl #16
    1140:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1144:	040e6901 	streq	r6, [lr], #-2305	; 0xfffff6ff
    1148:	02000001 	andeq	r0, r0, #1
    114c:	00007491 	muleq	r0, r1, r4
    1150:	0101040f 	tsteq	r1, pc, lsl #8
    1154:	11100000 	tstne	r0, r0
    1158:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    115c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1160:	0074040f 	rsbseq	r0, r4, pc, lsl #8
    1164:	040f0000 	streq	r0, [pc], #-0	; 116c <shift+0x116c>
    1168:	0000006d 	andeq	r0, r0, sp, rrx
    116c:	000f4d0a 	andeq	r4, pc, sl, lsl #26
    1170:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1174:	00000f5a 	andeq	r0, r0, sl, asr pc
    1178:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
    117c:	00000068 	andeq	r0, r0, r8, rrx
    1180:	01769c01 	cmneq	r6, r1, lsl #24
    1184:	ee130000 	cdp	0, 1, cr0, cr3, cr0, {0}
    1188:	0100000f 	tsteq	r0, pc
    118c:	0102125c 	tsteq	r2, ip, asr r2
    1190:	91020000 	mrsls	r0, (UNDEF: 2)
    1194:	0f53136c 	svceq	0x0053136c
    1198:	5c010000 	stcpl	0, cr0, [r1], {-0}
    119c:	0001041e 	andeq	r0, r1, lr, lsl r4
    11a0:	68910200 	ldmvs	r1, {r9}
    11a4:	6d656d0e 	stclvs	13, cr6, [r5, #-56]!	; 0xffffffc8
    11a8:	0b5e0100 	bleq	17815b0 <__bss_end+0x1778648>
    11ac:	00000111 	andeq	r0, r0, r1, lsl r1
    11b0:	0d709102 	ldfeqp	f1, [r0, #-8]!
    11b4:	00008bcc 	andeq	r8, r0, ip, asr #23
    11b8:	0000003c 	andeq	r0, r0, ip, lsr r0
    11bc:	0100690e 	tsteq	r0, lr, lsl #18
    11c0:	01040e60 	tsteq	r4, r0, ror #28
    11c4:	91020000 	mrsls	r0, (UNDEF: 2)
    11c8:	14000074 	strne	r0, [r0], #-116	; 0xffffff8c
    11cc:	00000faa 	andeq	r0, r0, sl, lsr #31
    11d0:	c3055201 	movwgt	r5, #20993	; 0x5201
    11d4:	0400000f 	streq	r0, [r0], #-15
    11d8:	5c000001 	stcpl	0, cr0, [r0], {1}
    11dc:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
    11e0:	01000000 	mrseq	r0, (UNDEF: 0)
    11e4:	0001af9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    11e8:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    11ec:	0b185201 	bleq	6159f8 <__bss_end+0x60ca90>
    11f0:	02000001 	andeq	r0, r0, #1
    11f4:	690e6c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, sp, lr}
    11f8:	09540100 	ldmdbeq	r4, {r8}^
    11fc:	00000104 	andeq	r0, r0, r4, lsl #2
    1200:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1204:	000fe614 	andeq	lr, pc, r4, lsl r6	; <UNPREDICTABLE>
    1208:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    120c:	00000fb1 			; <UNDEFINED> instruction: 0x00000fb1
    1210:	00000104 	andeq	r0, r0, r4, lsl #2
    1214:	00008ab0 			; <UNDEFINED> instruction: 0x00008ab0
    1218:	000000ac 	andeq	r0, r0, ip, lsr #1
    121c:	02159c01 	andseq	r9, r5, #256	; 0x100
    1220:	730b0000 	movwvc	r0, #45056	; 0xb000
    1224:	42010031 	andmi	r0, r1, #49	; 0x31
    1228:	00010b19 	andeq	r0, r1, r9, lsl fp
    122c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1230:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1234:	0b294201 	bleq	a51a40 <__bss_end+0xa48ad8>
    1238:	02000001 	andeq	r0, r0, #1
    123c:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1240:	01006d75 	tsteq	r0, r5, ror sp
    1244:	01043142 	tsteq	r4, r2, asr #2
    1248:	91020000 	mrsls	r0, (UNDEF: 2)
    124c:	31750e64 	cmncc	r5, r4, ror #28
    1250:	13440100 	movtne	r0, #16640	; 0x4100
    1254:	00000215 	andeq	r0, r0, r5, lsl r2
    1258:	0e779102 	expeqs	f1, f2
    125c:	01003275 	tsteq	r0, r5, ror r2
    1260:	02151744 	andseq	r1, r5, #68, 14	; 0x1100000
    1264:	91020000 	mrsls	r0, (UNDEF: 2)
    1268:	01080076 	tsteq	r8, r6, ror r0
    126c:	00047208 	andeq	r7, r4, r8, lsl #4
    1270:	0f661400 	svceq	0x00661400
    1274:	36010000 	strcc	r0, [r1], -r0
    1278:	000fd507 	andeq	sp, pc, r7, lsl #10
    127c:	00011100 	andeq	r1, r1, r0, lsl #2
    1280:	0089f000 	addeq	pc, r9, r0
    1284:	0000c000 	andeq	ip, r0, r0
    1288:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    128c:	13000002 	movwne	r0, #2
    1290:	00000f48 	andeq	r0, r0, r8, asr #30
    1294:	11153601 	tstne	r5, r1, lsl #12
    1298:	02000001 	andeq	r0, r0, #1
    129c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    12a0:	01006372 	tsteq	r0, r2, ror r3
    12a4:	010b2736 	tsteq	fp, r6, lsr r7
    12a8:	91020000 	mrsls	r0, (UNDEF: 2)
    12ac:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    12b0:	3601006d 	strcc	r0, [r1], -sp, rrx
    12b4:	00010430 	andeq	r0, r1, r0, lsr r4
    12b8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    12bc:	0100690e 	tsteq	r0, lr, lsl #18
    12c0:	01040938 	tsteq	r4, r8, lsr r9
    12c4:	91020000 	mrsls	r0, (UNDEF: 2)
    12c8:	d0140074 	andsle	r0, r4, r4, ror r0
    12cc:	0100000f 	tsteq	r0, pc
    12d0:	0f6e0524 	svceq	0x006e0524
    12d4:	01040000 	mrseq	r0, (UNDEF: 4)
    12d8:	89540000 	ldmdbhi	r4, {}^	; <UNPREDICTABLE>
    12dc:	009c0000 	addseq	r0, ip, r0
    12e0:	9c010000 	stcls	0, cr0, [r1], {-0}
    12e4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    12e8:	000f4213 	andeq	r4, pc, r3, lsl r2	; <UNPREDICTABLE>
    12ec:	16240100 	strtne	r0, [r4], -r0, lsl #2
    12f0:	0000010b 	andeq	r0, r0, fp, lsl #2
    12f4:	0c6c9102 	stfeqp	f1, [ip], #-8
    12f8:	00000f8c 	andeq	r0, r0, ip, lsl #31
    12fc:	04092601 	streq	r2, [r9], #-1537	; 0xfffff9ff
    1300:	02000001 	andeq	r0, r0, #1
    1304:	15007491 	strne	r7, [r0, #-1169]	; 0xfffffb6f
    1308:	00000ffc 	strdeq	r0, [r0], -ip
    130c:	4f060801 	svcmi	0x00060801
    1310:	e0000010 	and	r0, r0, r0, lsl r0
    1314:	74000087 	strvc	r0, [r0], #-135	; 0xffffff79
    1318:	01000001 	tsteq	r0, r1
    131c:	0f42139c 	svceq	0x0042139c
    1320:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1324:	00006618 	andeq	r6, r0, r8, lsl r6
    1328:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    132c:	000f8c13 	andeq	r8, pc, r3, lsl ip	; <UNPREDICTABLE>
    1330:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    1334:	00000111 	andeq	r0, r0, r1, lsl r1
    1338:	13609102 	cmnne	r0, #-2147483648	; 0x80000000
    133c:	0000111b 	andeq	r1, r0, fp, lsl r1
    1340:	663a0801 	ldrtvs	r0, [sl], -r1, lsl #16
    1344:	02000000 	andeq	r0, r0, #0
    1348:	690e5c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, ip, lr}
    134c:	090a0100 	stmdbeq	sl, {r8}
    1350:	00000104 	andeq	r0, r0, r4, lsl #2
    1354:	0d749102 	ldfeqp	f1, [r4, #-8]!
    1358:	000088ac 	andeq	r8, r0, ip, lsr #17
    135c:	00000098 	muleq	r0, r8, r0
    1360:	01006a0e 	tsteq	r0, lr, lsl #20
    1364:	01040e1c 	tsteq	r4, ip, lsl lr
    1368:	91020000 	mrsls	r0, (UNDEF: 2)
    136c:	88d40d70 	ldmhi	r4, {r4, r5, r6, r8, sl, fp}^
    1370:	00600000 	rsbeq	r0, r0, r0
    1374:	630e0000 	movwvs	r0, #57344	; 0xe000
    1378:	0e1e0100 	mufeqe	f0, f6, f0
    137c:	0000006d 	andeq	r0, r0, sp, rrx
    1380:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    1384:	22000000 	andcs	r0, r0, #0
    1388:	02000000 	andeq	r0, r0, #0
    138c:	00065200 	andeq	r5, r6, r0, lsl #4
    1390:	40010400 	andmi	r0, r1, r0, lsl #8
    1394:	98000009 	stmdals	r0, {r0, r3}
    1398:	a400008c 	strge	r0, [r0], #-140	; 0xffffff74
    139c:	5b00008e 	blpl	15dc <shift+0x15dc>
    13a0:	8b000010 	blhi	13e8 <shift+0x13e8>
    13a4:	f3000010 	vqadd.u8	d0, d0, d0
    13a8:	01000010 	tsteq	r0, r0, lsl r0
    13ac:	00002280 	andeq	r2, r0, r0, lsl #5
    13b0:	66000200 	strvs	r0, [r0], -r0, lsl #4
    13b4:	04000006 	streq	r0, [r0], #-6
    13b8:	0009bd01 	andeq	fp, r9, r1, lsl #26
    13bc:	008ea400 	addeq	sl, lr, r0, lsl #8
    13c0:	008ea800 	addeq	sl, lr, r0, lsl #16
    13c4:	00105b00 	andseq	r5, r0, r0, lsl #22
    13c8:	00108b00 	andseq	r8, r0, r0, lsl #22
    13cc:	0010f300 	andseq	pc, r0, r0, lsl #6
    13d0:	2a800100 	bcs	fe0017d8 <__bss_end+0xfdff8870>
    13d4:	04000003 	streq	r0, [r0], #-3
    13d8:	00067a00 	andeq	r7, r6, r0, lsl #20
    13dc:	1f010400 	svcne	0x00010400
    13e0:	0c000012 	stceq	0, cr0, [r0], {18}
    13e4:	000013d8 	ldrdeq	r1, [r0], -r8
    13e8:	0000108b 	andeq	r1, r0, fp, lsl #1
    13ec:	00000a1d 	andeq	r0, r0, sp, lsl sl
    13f0:	69050402 	stmdbvs	r5, {r1, sl}
    13f4:	0300746e 	movweq	r7, #1134	; 0x46e
    13f8:	14210704 	strtne	r0, [r1], #-1796	; 0xfffff8fc
    13fc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1400:	0002b905 	andeq	fp, r2, r5, lsl #18
    1404:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    1408:	000013cc 	andeq	r1, r0, ip, asr #7
    140c:	72080103 	andvc	r0, r8, #-1073741824	; 0xc0000000
    1410:	03000004 	movweq	r0, #4
    1414:	04740601 	ldrbteq	r0, [r4], #-1537	; 0xfffff9ff
    1418:	a4040000 	strge	r0, [r4], #-0
    141c:	07000015 	smladeq	r0, r5, r0, r0
    1420:	00003901 	andeq	r3, r0, r1, lsl #18
    1424:	06170100 	ldreq	r0, [r7], -r0, lsl #2
    1428:	000001d4 	ldrdeq	r0, [r0], -r4
    142c:	00112e05 	andseq	r2, r1, r5, lsl #28
    1430:	53050000 	movwpl	r0, #20480	; 0x5000
    1434:	01000016 	tsteq	r0, r6, lsl r0
    1438:	00130105 	andseq	r0, r3, r5, lsl #2
    143c:	bf050200 	svclt	0x00050200
    1440:	03000013 	movweq	r0, #19
    1444:	0015bd05 	andseq	fp, r5, r5, lsl #26
    1448:	63050400 	movwvs	r0, #21504	; 0x5400
    144c:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    1450:	0015d305 	andseq	sp, r5, r5, lsl #6
    1454:	08050600 	stmdaeq	r5, {r9, sl}
    1458:	07000014 	smladeq	r0, r4, r0, r0
    145c:	00154e05 	andseq	r4, r5, r5, lsl #28
    1460:	5c050800 	stcpl	8, cr0, [r5], {-0}
    1464:	09000015 	stmdbeq	r0, {r0, r2, r4}
    1468:	00156a05 	andseq	r6, r5, r5, lsl #20
    146c:	71050a00 	tstvc	r5, r0, lsl #20
    1470:	0b000014 	bleq	14c8 <shift+0x14c8>
    1474:	00146105 	andseq	r6, r4, r5, lsl #2
    1478:	4a050c00 	bmi	144480 <__bss_end+0x13b518>
    147c:	0d000011 	stceq	0, cr0, [r0, #-68]	; 0xffffffbc
    1480:	00116305 	andseq	r6, r1, r5, lsl #6
    1484:	52050e00 	andpl	r0, r5, #0, 28
    1488:	0f000014 	svceq	0x00000014
    148c:	00161605 	andseq	r1, r6, r5, lsl #12
    1490:	93051000 	movwls	r1, #20480	; 0x5000
    1494:	11000015 	tstne	r0, r5, lsl r0
    1498:	00160705 	andseq	r0, r6, r5, lsl #14
    149c:	10051200 	andne	r1, r5, r0, lsl #4
    14a0:	13000012 	movwne	r0, #18
    14a4:	00118d05 	andseq	r8, r1, r5, lsl #26
    14a8:	57051400 	strpl	r1, [r5, -r0, lsl #8]
    14ac:	15000011 	strne	r0, [r0, #-17]	; 0xffffffef
    14b0:	0014f005 	andseq	pc, r4, r5
    14b4:	c4051600 	strgt	r1, [r5], #-1536	; 0xfffffa00
    14b8:	17000011 	smladne	r0, r1, r0, r0
    14bc:	0010ff05 	andseq	pc, r0, r5, lsl #30
    14c0:	f9051800 			; <UNDEFINED> instruction: 0xf9051800
    14c4:	19000015 	stmdbne	r0, {r0, r2, r4}
    14c8:	00142e05 	andseq	r2, r4, r5, lsl #28
    14cc:	08051a00 	stmdaeq	r5, {r9, fp, ip}
    14d0:	1b000015 	blne	152c <shift+0x152c>
    14d4:	00119805 	andseq	r9, r1, r5, lsl #16
    14d8:	a4051c00 	strge	r1, [r5], #-3072	; 0xfffff400
    14dc:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
    14e0:	0012f305 	andseq	pc, r2, r5, lsl #6
    14e4:	85051e00 	strhi	r1, [r5, #-3584]	; 0xfffff200
    14e8:	1f000015 	svcne	0x00000015
    14ec:	0015e105 	andseq	lr, r5, r5, lsl #2
    14f0:	22052000 	andcs	r2, r5, #0
    14f4:	21000016 	tstcs	r0, r6, lsl r0
    14f8:	00163005 	andseq	r3, r6, r5
    14fc:	45052200 	strmi	r2, [r5, #-512]	; 0xfffffe00
    1500:	23000014 	movwcs	r0, #20
    1504:	00136805 	andseq	r6, r3, r5, lsl #16
    1508:	a7052400 	strge	r2, [r5, -r0, lsl #8]
    150c:	25000011 	strcs	r0, [r0, #-17]	; 0xffffffef
    1510:	0013fb05 	andseq	pc, r3, r5, lsl #22
    1514:	0d052600 	stceq	6, cr2, [r5, #-0]
    1518:	27000013 	smladcs	r0, r3, r0, r0
    151c:	0015b005 	andseq	fp, r5, r5
    1520:	1d052800 	stcne	8, cr2, [r5, #-0]
    1524:	29000013 	stmdbcs	r0, {r0, r1, r4}
    1528:	00132c05 	andseq	r2, r3, r5, lsl #24
    152c:	3b052a00 	blcc	14bd34 <__bss_end+0x142dcc>
    1530:	2b000013 	blcs	1584 <shift+0x1584>
    1534:	00134a05 	andseq	r4, r3, r5, lsl #20
    1538:	d8052c00 	stmdale	r5, {sl, fp, sp}
    153c:	2d000012 	stccs	0, cr0, [r0, #-72]	; 0xffffffb8
    1540:	00135905 	andseq	r5, r3, r5, lsl #18
    1544:	3f052e00 	svccc	0x00052e00
    1548:	2f000015 	svccs	0x00000015
    154c:	00137705 	andseq	r7, r3, r5, lsl #14
    1550:	86053000 	strhi	r3, [r5], -r0
    1554:	31000013 	tstcc	r0, r3, lsl r0
    1558:	00113805 	andseq	r3, r1, r5, lsl #16
    155c:	90053200 	andls	r3, r5, r0, lsl #4
    1560:	33000014 	movwcc	r0, #20
    1564:	0014a005 	andseq	sl, r4, r5
    1568:	b0053400 	andlt	r3, r5, r0, lsl #8
    156c:	35000014 	strcc	r0, [r0, #-20]	; 0xffffffec
    1570:	0012c605 	andseq	ip, r2, r5, lsl #12
    1574:	c0053600 	andgt	r3, r5, r0, lsl #12
    1578:	37000014 	smladcc	r0, r4, r0, r0
    157c:	0014d005 	andseq	sp, r4, r5
    1580:	e0053800 	and	r3, r5, r0, lsl #16
    1584:	39000014 	stmdbcc	r0, {r2, r4}
    1588:	0011b705 	andseq	fp, r1, r5, lsl #14
    158c:	70053a00 	andvc	r3, r5, r0, lsl #20
    1590:	3b000011 	blcc	15dc <shift+0x15dc>
    1594:	00139505 	andseq	r9, r3, r5, lsl #10
    1598:	0f053c00 	svceq	0x00053c00
    159c:	3d000011 	stccc	0, cr0, [r0, #-68]	; 0xffffffbc
    15a0:	0014fb05 	andseq	pc, r4, r5, lsl #22
    15a4:	06003e00 	streq	r3, [r0], -r0, lsl #28
    15a8:	000011f7 	strdeq	r1, [r0], -r7
    15ac:	026b0102 	rsbeq	r0, fp, #-2147483648	; 0x80000000
    15b0:	0001ff08 	andeq	pc, r1, r8, lsl #30
    15b4:	13ba0700 			; <UNDEFINED> instruction: 0x13ba0700
    15b8:	70010000 	andvc	r0, r1, r0
    15bc:	00471402 	subeq	r1, r7, r2, lsl #8
    15c0:	07000000 	streq	r0, [r0, -r0]
    15c4:	000012d3 	ldrdeq	r1, [r0], -r3
    15c8:	14027101 	strne	r7, [r2], #-257	; 0xfffffeff
    15cc:	00000047 	andeq	r0, r0, r7, asr #32
    15d0:	d4080001 	strle	r0, [r8], #-1
    15d4:	09000001 	stmdbeq	r0, {r0}
    15d8:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    15dc:	00000214 	andeq	r0, r0, r4, lsl r2
    15e0:	0000240a 	andeq	r2, r0, sl, lsl #8
    15e4:	08001100 	stmdaeq	r0, {r8, ip}
    15e8:	00000204 	andeq	r0, r0, r4, lsl #4
    15ec:	00147e0b 	andseq	r7, r4, fp, lsl #28
    15f0:	02740100 	rsbseq	r0, r4, #0, 2
    15f4:	00021426 	andeq	r1, r2, r6, lsr #8
    15f8:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    15fc:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 15dc <shift+0x15dc>
    1600:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    1604:	3d053d02 	stccc	13, cr3, [r5, #-8]
    1608:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    160c:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    1610:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    1614:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    1618:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    161c:	02030000 	andeq	r0, r3, #0
    1620:	00049307 	andeq	r9, r4, r7, lsl #6
    1624:	08010300 	stmdaeq	r1, {r8, r9}
    1628:	0000047b 	andeq	r0, r0, fp, ror r4
    162c:	59040d0c 	stmdbpl	r4, {r2, r3, r8, sl, fp}
    1630:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1634:	0000163e 	andeq	r1, r0, lr, lsr r6
    1638:	00390107 	eorseq	r0, r9, r7, lsl #2
    163c:	f7020000 			; <UNDEFINED> instruction: 0xf7020000
    1640:	029e0604 	addseq	r0, lr, #4, 12	; 0x400000
    1644:	d1050000 	mrsle	r0, (UNDEF: 5)
    1648:	00000011 	andeq	r0, r0, r1, lsl r0
    164c:	0011dc05 	andseq	sp, r1, r5, lsl #24
    1650:	ee050100 	adfs	f0, f5, f0
    1654:	02000011 	andeq	r0, r0, #17
    1658:	00120805 	andseq	r0, r2, r5, lsl #16
    165c:	78050300 	stmdavc	r5, {r8, r9}
    1660:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    1664:	0012e705 	andseq	lr, r2, r5, lsl #14
    1668:	31050500 	tstcc	r5, r0, lsl #10
    166c:	06000015 			; <UNDEFINED> instruction: 0x06000015
    1670:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    1674:	00000523 	andeq	r0, r0, r3, lsr #10
    1678:	17070803 	strne	r0, [r7, -r3, lsl #16]
    167c:	03000014 	movweq	r0, #20
    1680:	11280404 			; <UNDEFINED> instruction: 0x11280404
    1684:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1688:	00112003 	andseq	r2, r1, r3
    168c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    1690:	000013d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1694:	22031003 	andcs	r1, r3, #3
    1698:	0f000015 	svceq	0x00000015
    169c:	00001519 	andeq	r1, r0, r9, lsl r5
    16a0:	5a102a03 	bpl	40beb4 <__bss_end+0x402f4c>
    16a4:	09000002 	stmdbeq	r0, {r1}
    16a8:	000002c8 	andeq	r0, r0, r8, asr #5
    16ac:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    16b0:	82110010 	andshi	r0, r1, #16
    16b4:	03000003 	movweq	r0, #3
    16b8:	02d4112f 	sbcseq	r1, r4, #-1073741813	; 0xc000000b
    16bc:	76110000 	ldrvc	r0, [r1], -r0
    16c0:	03000002 	movweq	r0, #2
    16c4:	02d41130 	sbcseq	r1, r4, #48, 2
    16c8:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    16cc:	07000002 	streq	r0, [r0, -r2]
    16d0:	0a000003 	beq	16e4 <shift+0x16e4>
    16d4:	00000024 	andeq	r0, r0, r4, lsr #32
    16d8:	df120001 	svcle	0x00120001
    16dc:	04000002 	streq	r0, [r0], #-2
    16e0:	f70a0933 			; <UNDEFINED> instruction: 0xf70a0933
    16e4:	05000002 	streq	r0, [r0, #-2]
    16e8:	008f5503 	addeq	r5, pc, r3, lsl #10
    16ec:	02eb1200 	rsceq	r1, fp, #0, 4
    16f0:	34040000 	strcc	r0, [r4], #-0
    16f4:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    16f8:	03050000 	movweq	r0, #20480	; 0x5000
    16fc:	00008f55 	andeq	r8, r0, r5, asr pc
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377cac>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9db4>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9dd4>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9dec>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x128>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a92c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39e10>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377d54>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79db0>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c59c8>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a9b0>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39e94>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9ea8>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x1f8>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a9e8>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39ecc>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9edc>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377e64>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5a54>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5a68>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377e98>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79ea8>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b731c>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377e98>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00340600 	eorseq	r0, r4, r0, lsl #12
 208:	0b3a0e03 	bleq	e83a1c <__bss_end+0xe7aab4>
 20c:	0b390b3b 	bleq	e42f00 <__bss_end+0xe39f98>
 210:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 214:	00001802 	andeq	r1, r0, r2, lsl #16
 218:	03010407 	movweq	r0, #5127	; 0x1407
 21c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 220:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 224:	3b0b3a13 	blcc	2cea78 <__bss_end+0x2c5b10>
 228:	010b390b 	tsteq	fp, fp, lsl #18
 22c:	08000013 	stmdaeq	r0, {r0, r1, r4}
 230:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 234:	00000b1c 	andeq	r0, r0, ip, lsl fp
 238:	49010109 	stmdbmi	r1, {r0, r3, r8}
 23c:	00130113 	andseq	r0, r3, r3, lsl r1
 240:	00210a00 	eoreq	r0, r1, r0, lsl #20
 244:	0b2f1349 	bleq	bc4f70 <__bss_end+0xbbc008>
 248:	0f0b0000 	svceq	0x000b0000
 24c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 250:	0c000013 	stceq	0, cr0, [r0], {19}
 254:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 258:	0b3a0e03 	bleq	e83a6c <__bss_end+0xe7ab04>
 25c:	0b390b3b 	bleq	e42f50 <__bss_end+0xe39fe8>
 260:	01111349 	tsteq	r1, r9, asr #6
 264:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 268:	01194296 			; <UNDEFINED> instruction: 0x01194296
 26c:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 270:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 274:	0b3b0b3a 	bleq	ec2f64 <__bss_end+0xeb9ffc>
 278:	13490b39 	movtne	r0, #39737	; 0x9b39
 27c:	00001802 	andeq	r1, r0, r2, lsl #16
 280:	0300340e 	movweq	r3, #1038	; 0x40e
 284:	3b0b3a0e 	blcc	2ceac4 <__bss_end+0x2c5b5c>
 288:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 28c:	00180213 	andseq	r0, r8, r3, lsl r2
 290:	00340f00 	eorseq	r0, r4, r0, lsl #30
 294:	0b3a0803 	bleq	e822a8 <__bss_end+0xe79340>
 298:	0b390b3b 	bleq	e42f8c <__bss_end+0xe3a024>
 29c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 2a0:	0b100000 	bleq	4002a8 <__bss_end+0x3f7340>
 2a4:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 2a8:	11000006 	tstne	r0, r6
 2ac:	0e03012e 	adfeqsp	f0, f3, #0.5
 2b0:	0b3b0b3a 	bleq	ec2fa0 <__bss_end+0xeba038>
 2b4:	01110b39 	tsteq	r1, r9, lsr fp
 2b8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 2bc:	00194296 	mulseq	r9, r6, r2
 2c0:	11010000 	mrsne	r0, (UNDEF: 1)
 2c4:	130e2501 	movwne	r2, #58625	; 0xe501
 2c8:	1b0e030b 	blne	380efc <__bss_end+0x377f94>
 2cc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 2d0:	00171006 	andseq	r1, r7, r6
 2d4:	00240200 	eoreq	r0, r4, r0, lsl #4
 2d8:	0b3e0b0b 	bleq	f82f0c <__bss_end+0xf79fa4>
 2dc:	00000e03 	andeq	r0, r0, r3, lsl #28
 2e0:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 2e4:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 2e8:	0b0b0024 	bleq	2c0380 <__bss_end+0x2b7418>
 2ec:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 2f0:	16050000 	strne	r0, [r5], -r0
 2f4:	3a0e0300 	bcc	380efc <__bss_end+0x377f94>
 2f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2fc:	0013490b 	andseq	r4, r3, fp, lsl #18
 300:	01130600 	tsteq	r3, r0, lsl #12
 304:	0b0b0e03 	bleq	2c3b18 <__bss_end+0x2babb0>
 308:	0b3b0b3a 	bleq	ec2ff8 <__bss_end+0xeba090>
 30c:	13010b39 	movwne	r0, #6969	; 0x1b39
 310:	0d070000 	stceq	0, cr0, [r7, #-0]
 314:	3a080300 	bcc	200f1c <__bss_end+0x1f7fb4>
 318:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 31c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 320:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 324:	0e030104 	adfeqs	f0, f3, f4
 328:	0b3e196d 	bleq	f868e4 <__bss_end+0xf7d97c>
 32c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 330:	0b3b0b3a 	bleq	ec3020 <__bss_end+0xeba0b8>
 334:	13010b39 	movwne	r0, #6969	; 0x1b39
 338:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 33c:	1c080300 	stcne	3, cr0, [r8], {-0}
 340:	0a00000b 	beq	374 <shift+0x374>
 344:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 348:	00000b1c 	andeq	r0, r0, ip, lsl fp
 34c:	0300340b 	movweq	r3, #1035	; 0x40b
 350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c5c28>
 354:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 358:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 35c:	0c000018 	stceq	0, cr0, [r0], {24}
 360:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 364:	0000193c 	andeq	r1, r0, ip, lsr r9
 368:	0b000f0d 	bleq	3fa4 <shift+0x3fa4>
 36c:	0013490b 	andseq	r4, r3, fp, lsl #18
 370:	000d0e00 	andeq	r0, sp, r0, lsl #28
 374:	0b3a0e03 	bleq	e83b88 <__bss_end+0xe7ac20>
 378:	0b390b3b 	bleq	e4306c <__bss_end+0xe3a104>
 37c:	0b381349 	bleq	e050a8 <__bss_end+0xdfc140>
 380:	010f0000 	mrseq	r0, CPSR
 384:	01134901 	tsteq	r3, r1, lsl #18
 388:	10000013 	andne	r0, r0, r3, lsl r0
 38c:	13490021 	movtne	r0, #36897	; 0x9021
 390:	00000b2f 	andeq	r0, r0, pc, lsr #22
 394:	03010211 	movweq	r0, #4625	; 0x1211
 398:	3a0b0b0e 	bcc	2c2fd8 <__bss_end+0x2ba070>
 39c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3a0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3a4:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 3a8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3ac:	0b3b0b3a 	bleq	ec309c <__bss_end+0xeba134>
 3b0:	0e6e0b39 	vmoveq.8	d14[5], r0
 3b4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 3b8:	00001301 	andeq	r1, r0, r1, lsl #6
 3bc:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 3c0:	00193413 	andseq	r3, r9, r3, lsl r4
 3c4:	00051400 	andeq	r1, r5, r0, lsl #8
 3c8:	00001349 	andeq	r1, r0, r9, asr #6
 3cc:	3f012e15 	svccc	0x00012e15
 3d0:	3a0e0319 	bcc	38103c <__bss_end+0x3780d4>
 3d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3d8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 3dc:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 3e0:	00130113 	andseq	r0, r3, r3, lsl r1
 3e4:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 3e8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3ec:	0b3b0b3a 	bleq	ec30dc <__bss_end+0xeba174>
 3f0:	0e6e0b39 	vmoveq.8	d14[5], r0
 3f4:	0b321349 	bleq	c85120 <__bss_end+0xc7c1b8>
 3f8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 3fc:	00001301 	andeq	r1, r0, r1, lsl #6
 400:	03000d17 	movweq	r0, #3351	; 0xd17
 404:	3b0b3a0e 	blcc	2cec44 <__bss_end+0x2c5cdc>
 408:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 40c:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 410:	1800000b 	stmdane	r0, {r0, r1, r3}
 414:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 418:	0b3a0e03 	bleq	e83c2c <__bss_end+0xe7acc4>
 41c:	0b390b3b 	bleq	e43110 <__bss_end+0xe3a1a8>
 420:	0b320e6e 	bleq	c83de0 <__bss_end+0xc7ae78>
 424:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 428:	00001301 	andeq	r1, r0, r1, lsl #6
 42c:	3f012e19 	svccc	0x00012e19
 430:	3a0e0319 	bcc	38109c <__bss_end+0x378134>
 434:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 438:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 43c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 440:	00136419 	andseq	r6, r3, r9, lsl r4
 444:	01151a00 	tsteq	r5, r0, lsl #20
 448:	13641349 	cmnne	r4, #603979777	; 0x24000001
 44c:	00001301 	andeq	r1, r0, r1, lsl #6
 450:	1d001f1b 	stcne	15, cr1, [r0, #-108]	; 0xffffff94
 454:	00134913 	andseq	r4, r3, r3, lsl r9
 458:	00101c00 	andseq	r1, r0, r0, lsl #24
 45c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 460:	0f1d0000 	svceq	0x001d0000
 464:	000b0b00 	andeq	r0, fp, r0, lsl #22
 468:	00341e00 	eorseq	r1, r4, r0, lsl #28
 46c:	0b3a0e03 	bleq	e83c80 <__bss_end+0xe7ad18>
 470:	0b390b3b 	bleq	e43164 <__bss_end+0xe3a1fc>
 474:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 478:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
 47c:	03193f01 	tsteq	r9, #1, 30
 480:	3b0b3a0e 	blcc	2cecc0 <__bss_end+0x2c5d58>
 484:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 488:	1113490e 	tstne	r3, lr, lsl #18
 48c:	40061201 	andmi	r1, r6, r1, lsl #4
 490:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 494:	00001301 	andeq	r1, r0, r1, lsl #6
 498:	03000520 	movweq	r0, #1312	; 0x520
 49c:	3b0b3a0e 	blcc	2cecdc <__bss_end+0x2c5d74>
 4a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4a4:	00180213 	andseq	r0, r8, r3, lsl r2
 4a8:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
 4ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 4b0:	0b3b0b3a 	bleq	ec31a0 <__bss_end+0xeba238>
 4b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 4b8:	01111349 	tsteq	r1, r9, asr #6
 4bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4c0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 4c4:	22000013 	andcs	r0, r0, #19
 4c8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 4cc:	0b3b0b3a 	bleq	ec31bc <__bss_end+0xeba254>
 4d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 4d4:	00001802 	andeq	r1, r0, r2, lsl #16
 4d8:	3f012e23 	svccc	0x00012e23
 4dc:	3a0e0319 	bcc	381148 <__bss_end+0x3781e0>
 4e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e4:	110e6e0b 	tstne	lr, fp, lsl #28
 4e8:	40061201 	andmi	r1, r6, r1, lsl #4
 4ec:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 4f0:	00001301 	andeq	r1, r0, r1, lsl #6
 4f4:	3f002e24 	svccc	0x00002e24
 4f8:	3a0e0319 	bcc	381164 <__bss_end+0x3781fc>
 4fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 500:	110e6e0b 	tstne	lr, fp, lsl #28
 504:	40061201 	andmi	r1, r6, r1, lsl #4
 508:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 50c:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 510:	03193f01 	tsteq	r9, #1, 30
 514:	3b0b3a0e 	blcc	2ced54 <__bss_end+0x2c5dec>
 518:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 51c:	1113490e 	tstne	r3, lr, lsl #18
 520:	40061201 	andmi	r1, r6, r1, lsl #4
 524:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 528:	01000000 	mrseq	r0, (UNDEF: 0)
 52c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 530:	0e030b13 	vmoveq.32	d3[0], r0
 534:	01110e1b 	tsteq	r1, fp, lsl lr
 538:	17100612 			; <UNDEFINED> instruction: 0x17100612
 53c:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 540:	00130101 	andseq	r0, r3, r1, lsl #2
 544:	00340300 	eorseq	r0, r4, r0, lsl #6
 548:	0b3a0e03 	bleq	e83d5c <__bss_end+0xe7adf4>
 54c:	0b390b3b 	bleq	e43240 <__bss_end+0xe3a2d8>
 550:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 554:	00000a1c 	andeq	r0, r0, ip, lsl sl
 558:	3a003a04 	bcc	ed70 <__bss_end+0x5e08>
 55c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 560:	0013180b 	andseq	r1, r3, fp, lsl #16
 564:	01010500 	tsteq	r1, r0, lsl #10
 568:	13011349 	movwne	r1, #4937	; 0x1349
 56c:	21060000 	mrscs	r0, (UNDEF: 6)
 570:	2f134900 	svccs	0x00134900
 574:	0700000b 	streq	r0, [r0, -fp]
 578:	13490026 	movtne	r0, #36902	; 0x9026
 57c:	24080000 	strcs	r0, [r8], #-0
 580:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 584:	000e030b 	andeq	r0, lr, fp, lsl #6
 588:	00340900 	eorseq	r0, r4, r0, lsl #18
 58c:	00001347 	andeq	r1, r0, r7, asr #6
 590:	3f012e0a 	svccc	0x00012e0a
 594:	3a0e0319 	bcc	381200 <__bss_end+0x378298>
 598:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 59c:	110e6e0b 	tstne	lr, fp, lsl #28
 5a0:	40061201 	andmi	r1, r6, r1, lsl #4
 5a4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 5a8:	00001301 	andeq	r1, r0, r1, lsl #6
 5ac:	0300050b 	movweq	r0, #1291	; 0x50b
 5b0:	3b0b3a08 	blcc	2cedd8 <__bss_end+0x2c5e70>
 5b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5b8:	00180213 	andseq	r0, r8, r3, lsl r2
 5bc:	00340c00 	eorseq	r0, r4, r0, lsl #24
 5c0:	0b3a0e03 	bleq	e83dd4 <__bss_end+0xe7ae6c>
 5c4:	0b390b3b 	bleq	e432b8 <__bss_end+0xe3a350>
 5c8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5cc:	0b0d0000 	bleq	3405d4 <__bss_end+0x33766c>
 5d0:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 5d4:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 5d8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 5dc:	0b3b0b3a 	bleq	ec32cc <__bss_end+0xeba364>
 5e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 5e4:	00001802 	andeq	r1, r0, r2, lsl #16
 5e8:	0b000f0f 	bleq	422c <shift+0x422c>
 5ec:	0013490b 	andseq	r4, r3, fp, lsl #18
 5f0:	00261000 	eoreq	r1, r6, r0
 5f4:	0f110000 	svceq	0x00110000
 5f8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 5fc:	00241200 	eoreq	r1, r4, r0, lsl #4
 600:	0b3e0b0b 	bleq	f83234 <__bss_end+0xf7a2cc>
 604:	00000803 	andeq	r0, r0, r3, lsl #16
 608:	03000513 	movweq	r0, #1299	; 0x513
 60c:	3b0b3a0e 	blcc	2cee4c <__bss_end+0x2c5ee4>
 610:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 614:	00180213 	andseq	r0, r8, r3, lsl r2
 618:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 61c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 620:	0b3b0b3a 	bleq	ec3310 <__bss_end+0xeba3a8>
 624:	0e6e0b39 	vmoveq.8	d14[5], r0
 628:	01111349 	tsteq	r1, r9, asr #6
 62c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 630:	01194297 			; <UNDEFINED> instruction: 0x01194297
 634:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 638:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 63c:	0b3a0e03 	bleq	e83e50 <__bss_end+0xe7aee8>
 640:	0b390b3b 	bleq	e43334 <__bss_end+0xe3a3cc>
 644:	01110e6e 	tsteq	r1, lr, ror #28
 648:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 64c:	00194296 	mulseq	r9, r6, r2
 650:	11010000 	mrsne	r0, (UNDEF: 1)
 654:	11061000 	mrsne	r1, (UNDEF: 6)
 658:	03011201 	movweq	r1, #4609	; 0x1201
 65c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 660:	0005130e 	andeq	r1, r5, lr, lsl #6
 664:	11010000 	mrsne	r0, (UNDEF: 1)
 668:	11061000 	mrsne	r1, (UNDEF: 6)
 66c:	03011201 	movweq	r1, #4609	; 0x1201
 670:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 674:	0005130e 	andeq	r1, r5, lr, lsl #6
 678:	11010000 	mrsne	r0, (UNDEF: 1)
 67c:	130e2501 	movwne	r2, #58625	; 0xe501
 680:	1b0e030b 	blne	3812b4 <__bss_end+0x37834c>
 684:	0017100e 	andseq	r1, r7, lr
 688:	00240200 	eoreq	r0, r4, r0, lsl #4
 68c:	0b3e0b0b 	bleq	f832c0 <__bss_end+0xf7a358>
 690:	00000803 	andeq	r0, r0, r3, lsl #16
 694:	0b002403 	bleq	96a8 <__bss_end+0x740>
 698:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 69c:	0400000e 	streq	r0, [r0], #-14
 6a0:	0e030104 	adfeqs	f0, f3, f4
 6a4:	0b0b0b3e 	bleq	2c33a4 <__bss_end+0x2ba43c>
 6a8:	0b3a1349 	bleq	e853d4 <__bss_end+0xe7c46c>
 6ac:	0b390b3b 	bleq	e433a0 <__bss_end+0xe3a438>
 6b0:	00001301 	andeq	r1, r0, r1, lsl #6
 6b4:	03002805 	movweq	r2, #2053	; 0x805
 6b8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 6bc:	01130600 	tsteq	r3, r0, lsl #12
 6c0:	0b0b0e03 	bleq	2c3ed4 <__bss_end+0x2baf6c>
 6c4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 6c8:	13010b39 	movwne	r0, #6969	; 0x1b39
 6cc:	0d070000 	stceq	0, cr0, [r7, #-0]
 6d0:	3a0e0300 	bcc	3812d8 <__bss_end+0x378370>
 6d4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 6d8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 6dc:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 6e0:	13490026 	movtne	r0, #36902	; 0x9026
 6e4:	01090000 	mrseq	r0, (UNDEF: 9)
 6e8:	01134901 	tsteq	r3, r1, lsl #18
 6ec:	0a000013 	beq	740 <shift+0x740>
 6f0:	13490021 	movtne	r0, #36897	; 0x9021
 6f4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 6f8:	0300340b 	movweq	r3, #1035	; 0x40b
 6fc:	3b0b3a0e 	blcc	2cef3c <__bss_end+0x2c5fd4>
 700:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 704:	000a1c13 	andeq	r1, sl, r3, lsl ip
 708:	00150c00 	andseq	r0, r5, r0, lsl #24
 70c:	00001927 	andeq	r1, r0, r7, lsr #18
 710:	0b000f0d 	bleq	434c <shift+0x434c>
 714:	0013490b 	andseq	r4, r3, fp, lsl #18
 718:	01040e00 	tsteq	r4, r0, lsl #28
 71c:	0b3e0e03 	bleq	f83f30 <__bss_end+0xf7afc8>
 720:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 724:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 728:	13010b39 	movwne	r0, #6969	; 0x1b39
 72c:	160f0000 	strne	r0, [pc], -r0
 730:	3a0e0300 	bcc	381338 <__bss_end+0x3783d0>
 734:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 738:	0013490b 	andseq	r4, r3, fp, lsl #18
 73c:	00211000 	eoreq	r1, r1, r0
 740:	34110000 	ldrcc	r0, [r1], #-0
 744:	3a0e0300 	bcc	38134c <__bss_end+0x3783e4>
 748:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 74c:	3f13490b 	svccc	0x0013490b
 750:	00193c19 	andseq	r3, r9, r9, lsl ip
 754:	00341200 	eorseq	r1, r4, r0, lsl #4
 758:	0b3a1347 	bleq	e8547c <__bss_end+0xe7c514>
 75c:	0b39053b 	bleq	e41c50 <__bss_end+0xe38ce8>
 760:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 764:	Address 0x0000000000000764 is out of bounds.


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
  74:	00000158 	andeq	r0, r0, r8, asr r1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	05320002 	ldreq	r0, [r2, #-2]!
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008384 	andeq	r8, r0, r4, lsl #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	10550002 	subsne	r0, r5, r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000087e0 	andeq	r8, r0, r0, ror #15
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	13870002 	orrne	r0, r7, #2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c98 	muleq	r0, r8, ip
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	13ad0002 			; <UNDEFINED> instruction: 0x13ad0002
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008ea4 	andeq	r8, r0, r4, lsr #29
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	13d30002 	bicsne	r0, r3, #2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff6d75>
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
      44:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe80 <__bss_end+0xffff6f18>
      48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      50:	4b2f7372 	blmi	bdce20 <__bss_end+0xbd3eb8>
      54:	2f616275 	svccs	0x00616275
      58:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      5c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      60:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      64:	614d6f72 	hvcvs	55026	; 0xd6f2
      68:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffafc <__bss_end+0xffff6b94>
      6c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      70:	2f73656c 	svccs	0x0073656c
      74:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
      78:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffa1c <__bss_end+0xffff6ab4>
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
     114:	2b6b7a36 	blcs	1ade9f4 <__bss_end+0x1ad5a8c>
     118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     11c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     120:	304f2d20 	subcc	r2, pc, r0, lsr #26
     124:	304f2d20 	subcc	r2, pc, r0, lsr #26
     128:	625f5f00 	subsvs	r5, pc, #0, 30
     12c:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffdc1 <__bss_end+0xffff6e59>
     130:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     134:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     138:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff70 <__bss_end+0xffff7008>
     13c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     140:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     144:	4b2f7372 	blmi	bdcf14 <__bss_end+0xbd3fac>
     148:	2f616275 	svccs	0x00616275
     14c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     150:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     154:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <__bss_end+0xffff6c88>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     16c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb10 <__bss_end+0xffff6ba8>
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
     21c:	4b2f7372 	blmi	bdcfec <__bss_end+0xbd4084>
     220:	2f616275 	svccs	0x00616275
     224:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     228:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     22c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     230:	614d6f72 	hvcvs	55026	; 0xd6f2
     234:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffcc8 <__bss_end+0xffff6d60>
     238:	706d6178 	rsbvc	r6, sp, r8, ror r1
     23c:	2f73656c 	svccs	0x0073656c
     240:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     244:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffbe8 <__bss_end+0xffff6c80>
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
     3ac:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     3b0:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     3b4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     3b8:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     3bc:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     3c0:	62006874 	andvs	r6, r0, #116, 16	; 0x740000
     3c4:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     3c8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     3cc:	552f632f 	strpl	r6, [pc, #-815]!	; a5 <shift+0xa5>
     3d0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     3d4:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     3d8:	6f442f61 	svcvs	0x00442f61
     3dc:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     3e0:	2f73746e 	svccs	0x0073746e
     3e4:	6f72655a 	svcvs	0x0072655a
     3e8:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     3ec:	6178652f 	cmnvs	r8, pc, lsr #10
     3f0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     3f4:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     3f8:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     3fc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     400:	61707372 	cmnvs	r0, r2, ror r3
     404:	6c2f6563 	cfstr32vs	mvfx6, [pc], #-396	; 280 <shift+0x280>
     408:	6567676f 	strbvs	r6, [r7, #-1903]!	; 0xfffff891
     40c:	61745f72 	cmnvs	r4, r2, ror pc
     410:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     414:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     418:	00707063 	rsbseq	r7, r0, r3, rrx
     41c:	6b636f4c 	blvs	18dc154 <__bss_end+0x18d31ec>
     420:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     424:	0064656b 	rsbeq	r6, r4, fp, ror #10
     428:	74757066 	ldrbtvc	r7, [r5], #-102	; 0xffffff9a
     42c:	74730073 	ldrbtvc	r0, [r3], #-115	; 0xffffff8d
     430:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     434:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     438:	73656c69 	cmnvc	r5, #26880	; 0x6900
     43c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     440:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     444:	00726576 	rsbseq	r6, r2, r6, ror r5
     448:	7473616c 	ldrbtvc	r6, [r3], #-364	; 0xfffffe94
     44c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     450:	614d006b 	cmpvs	sp, fp, rrx
     454:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     458:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     45c:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     460:	00687467 	rsbeq	r7, r8, r7, ror #8
     464:	5078614d 	rsbspl	r6, r8, sp, asr #2
     468:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     46c:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     470:	6e750068 	cdpvs	0, 7, cr0, cr5, cr8, {3}
     474:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     478:	63206465 			; <UNDEFINED> instruction: 0x63206465
     47c:	00726168 	rsbseq	r6, r2, r8, ror #2
     480:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     484:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     488:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     48c:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     490:	73006465 	movwvc	r6, #1125	; 0x465
     494:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     498:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     49c:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     4a0:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     4a4:	6f4e0074 	svcvs	0x004e0074
     4a8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     4ac:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     4b0:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     4b4:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     4b8:	4d00796c 	vstrmi.16	s14, [r0, #-216]	; 0xffffff28	; <UNPREDICTABLE>
     4bc:	505f7861 	subspl	r7, pc, r1, ror #16
     4c0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4c4:	4f5f7373 	svcmi	0x005f7373
     4c8:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     4cc:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     4d0:	0073656c 	rsbseq	r6, r3, ip, ror #10
     4d4:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     4d8:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     4dc:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     4e0:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     4e4:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     4e8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4ec:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     4f0:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     4f4:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     4f8:	6e6f6d00 	cdpvs	13, 6, cr6, cr15, cr0, {0}
     4fc:	726f7469 	rsbvc	r7, pc, #1761607680	; 0x69000000
     500:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     504:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     508:	4f5f6461 	svcmi	0x005f6461
     50c:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     510:	6b636f4c 	blvs	18dc248 <__bss_end+0x18d32e0>
     514:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     518:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     51c:	72610064 	rsbvc	r0, r1, #100	; 0x64
     520:	73006367 	movwvc	r6, #871	; 0x367
     524:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     528:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     52c:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     530:	69750076 	ldmdbvs	r5!, {r1, r2, r4, r5, r6}^
     534:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     538:	6c00745f 	cfstrsvs	mvf7, [r0], {95}	; 0x5f
     53c:	6970676f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     540:	74006570 	strvc	r6, [r0], #-1392	; 0xfffffa90
     544:	626b6369 	rsbvs	r6, fp, #-1543503871	; 0xa4000001
     548:	54006675 	strpl	r6, [r0], #-1653	; 0xfffff98b
     54c:	5f6b6369 	svcpl	0x006b6369
     550:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     554:	704f0074 	subvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     558:	5f006e65 	svcpl	0x00006e65
     55c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     560:	6f725043 	svcvs	0x00725043
     564:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     568:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     56c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     570:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     574:	5f6b636f 	svcpl	0x006b636f
     578:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     57c:	5f746e65 	svcpl	0x00746e65
     580:	636f7250 	cmnvs	pc, #80, 4
     584:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     588:	6c630076 	stclvs	0, cr0, [r3], #-472	; 0xfffffe28
     58c:	0065736f 	rsbeq	r7, r5, pc, ror #6
     590:	76657270 			; <UNDEFINED> instruction: 0x76657270
     594:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     598:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     59c:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     5a0:	6e550065 	cdpvs	0, 5, cr0, cr5, cr5, {3}
     5a4:	5f70616d 	svcpl	0x0070616d
     5a8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     5ac:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     5b0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     5b4:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     5b8:	006c6176 	rsbeq	r6, ip, r6, ror r1
     5bc:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     5c0:	72506d00 	subsvc	r6, r0, #0, 26
     5c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c8:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5cc:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     5d0:	00646165 	rsbeq	r6, r4, r5, ror #2
     5d4:	4b4e5a5f 	blmi	1396f58 <__bss_end+0x138dff0>
     5d8:	50433631 	subpl	r3, r3, r1, lsr r6
     5dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5e0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 41c <shift+0x41c>
     5e4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5e8:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     5ec:	5f746547 	svcpl	0x00746547
     5f0:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     5f4:	5f746e65 	svcpl	0x00746e65
     5f8:	636f7250 	cmnvs	pc, #80, 4
     5fc:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     600:	64720076 	ldrbtvs	r0, [r2], #-118	; 0xffffff8a
     604:	006d756e 	rsbeq	r7, sp, lr, ror #10
     608:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     60c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     610:	6f72505f 	svcvs	0x0072505f
     614:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     618:	5f79425f 	svcpl	0x0079425f
     61c:	00444950 	subeq	r4, r4, r0, asr r9
     620:	31315a5f 	teqcc	r1, pc, asr sl
     624:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     628:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     62c:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     630:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     634:	72505f49 	subsvc	r5, r0, #292	; 0x124
     638:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     63c:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     640:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     644:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     648:	41006461 	tstmi	r0, r1, ror #8
     64c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     650:	72505f65 	subsvc	r5, r0, #404	; 0x194
     654:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     658:	6f435f73 	svcvs	0x00435f73
     65c:	00746e75 	rsbseq	r6, r4, r5, ror lr
     660:	61657243 	cmnvs	r5, r3, asr #4
     664:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     668:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     66c:	5f007373 	svcpl	0x00007373
     670:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
     674:	745f7465 	ldrbvc	r7, [pc], #-1125	; 67c <shift+0x67c>
     678:	5f6b7361 	svcpl	0x006b7361
     67c:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     680:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     684:	6177006a 	cmnvs	r7, sl, rrx
     688:	73007469 	movwvc	r7, #1129	; 0x469
     68c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     690:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     694:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     698:	6a6a7966 	bvs	1a9ec38 <__bss_end+0x1a95cd0>
     69c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     6a0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6a4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     6a8:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     6ac:	006f666e 	rsbeq	r6, pc, lr, ror #12
     6b0:	6f725043 	svcvs	0x00725043
     6b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6b8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6bc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6c4:	50433631 	subpl	r3, r3, r1, lsr r6
     6c8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6cc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 508 <shift+0x508>
     6d0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6d4:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     6d8:	5f746547 	svcpl	0x00746547
     6dc:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     6e0:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     6e4:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     6e8:	32456f66 	subcc	r6, r5, #408	; 0x198
     6ec:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     6f0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     6f4:	5f646568 	svcpl	0x00646568
     6f8:	6f666e49 	svcvs	0x00666e49
     6fc:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     700:	00765065 	rsbseq	r5, r6, r5, rrx
     704:	314e5a5f 	cmpcc	lr, pc, asr sl
     708:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     70c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     710:	614d5f73 	hvcvs	54771	; 0xd5f3
     714:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     718:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     71c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     720:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     724:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     728:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     72c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     730:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     734:	5f495753 	svcpl	0x00495753
     738:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     73c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     740:	535f6d65 	cmppl	pc, #6464	; 0x1940
     744:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     748:	6a6a6563 	bvs	1a99cdc <__bss_end+0x1a90d74>
     74c:	3131526a 	teqcc	r1, sl, ror #4
     750:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     754:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     758:	00746c75 	rsbseq	r6, r4, r5, ror ip
     75c:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     760:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     764:	73656c69 	cmnvc	r5, #26880	; 0x6900
     768:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     76c:	2f632f74 	svccs	0x00632f74
     770:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     774:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     778:	442f6162 	strtmi	r6, [pc], #-354	; 780 <shift+0x780>
     77c:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     780:	73746e65 	cmnvc	r4, #1616	; 0x650
     784:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     788:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     78c:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     790:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     794:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     798:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
     79c:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
     7a0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     7a4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     7a8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     7ac:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     7b0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     7b4:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     7b8:	4354006c 	cmpmi	r4, #108	; 0x6c
     7bc:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     7c0:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     7c4:	44007478 	strmi	r7, [r0], #-1144	; 0xfffffb88
     7c8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     7cc:	00656e69 	rsbeq	r6, r5, r9, ror #28
     7d0:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     7d4:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     7d8:	62747400 	rsbsvs	r7, r4, #0, 8
     7dc:	5f003072 	svcpl	0x00003072
     7e0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7e4:	6f725043 	svcvs	0x00725043
     7e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7ec:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7f4:	6f4e3431 	svcvs	0x004e3431
     7f8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     7fc:	6f72505f 	svcvs	0x0072505f
     800:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     804:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     808:	505f7465 	subspl	r7, pc, r5, ror #8
     80c:	6e004449 	cdpvs	4, 0, cr4, cr0, cr9, {2}
     810:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     814:	5f646569 	svcpl	0x00646569
     818:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     81c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     820:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     824:	50433631 	subpl	r3, r3, r1, lsr r6
     828:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     82c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 668 <shift+0x668>
     830:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     834:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     838:	616d6e55 	cmnvs	sp, r5, asr lr
     83c:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     840:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     844:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     848:	6a45746e 	bvs	115da08 <__bss_end+0x1154aa0>
     84c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     850:	50433631 	subpl	r3, r3, r1, lsr r6
     854:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     858:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 694 <shift+0x694>
     85c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     860:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     864:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     868:	505f7966 	subspl	r7, pc, r6, ror #18
     86c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     870:	50457373 	subpl	r7, r5, r3, ror r3
     874:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     878:	5f6b7361 	svcpl	0x006b7361
     87c:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     880:	73007463 	movwvc	r7, #1123	; 0x463
     884:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     888:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     88c:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     890:	5f6b6369 	svcpl	0x006b6369
     894:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     898:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     89c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     8a0:	5a006465 	bpl	19a3c <__bss_end+0x10ad4>
     8a4:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     8a8:	5a5f0065 	bpl	17c0a44 <__bss_end+0x17b7adc>
     8ac:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
     8b0:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     8b4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     8b8:	6f72705f 	svcvs	0x0072705f
     8bc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8c0:	756f635f 	strbvc	r6, [pc, #-863]!	; 569 <shift+0x569>
     8c4:	0076746e 	rsbseq	r7, r6, lr, ror #8
     8c8:	5f746547 	svcpl	0x00746547
     8cc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     8d0:	5f746e65 	svcpl	0x00746e65
     8d4:	636f7250 	cmnvs	pc, #80, 4
     8d8:	00737365 	rsbseq	r7, r3, r5, ror #6
     8dc:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
     8e0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     8e4:	72505f65 	subsvc	r5, r0, #404	; 0x194
     8e8:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
     8ec:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     8f0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     8f4:	6f545f65 	svcvs	0x00545f65
     8f8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     8fc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     900:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     904:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     908:	00736d61 	rsbseq	r6, r3, r1, ror #26
     90c:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     910:	5f746567 	svcpl	0x00746567
     914:	6b636974 	blvs	18daeec <__bss_end+0x18d1f84>
     918:	756f635f 	strbvc	r6, [pc, #-863]!	; 5c1 <shift+0x5c1>
     91c:	0076746e 	rsbseq	r7, r6, lr, ror #8
     920:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     924:	505f656c 	subspl	r6, pc, ip, ror #10
     928:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     92c:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     930:	73004957 	movwvc	r4, #2391	; 0x957
     934:	7065656c 	rsbvc	r6, r5, ip, ror #10
     938:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     93c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     940:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     944:	61570046 	cmpvs	r7, r6, asr #32
     948:	44007469 	strmi	r7, [r0], #-1129	; 0xfffffb97
     94c:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     950:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 3ec <shift+0x3ec>
     954:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     958:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     95c:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     960:	5f006e6f 	svcpl	0x00006e6f
     964:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
     968:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     96c:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     970:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     974:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     978:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     97c:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     980:	7065656c 	rsbvc	r6, r5, ip, ror #10
     984:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     988:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     98c:	5f006e6f 	svcpl	0x00006e6f
     990:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     994:	6a65736f 	bvs	195d758 <__bss_end+0x19547f0>
     998:	614c6d00 	cmpvs	ip, r0, lsl #26
     99c:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     9a0:	42004449 	andmi	r4, r0, #1224736768	; 0x49000000
     9a4:	6b636f6c 	blvs	18dc75c <__bss_end+0x18d37f4>
     9a8:	4e006465 	cdpmi	4, 0, cr6, cr0, cr5, {3}
     9ac:	5f746547 	svcpl	0x00746547
     9b0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     9b4:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     9b8:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 9c0 <shift+0x9c0>
     9bc:	00657079 	rsbeq	r7, r5, r9, ror r0
     9c0:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     9c4:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     9c8:	66007664 	strvs	r7, [r0], -r4, ror #12
     9cc:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     9d0:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     9d4:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     9d8:	544e0065 	strbpl	r0, [lr], #-101	; 0xffffff9b
     9dc:	5f6b7361 	svcpl	0x006b7361
     9e0:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     9e4:	63730065 	cmnvs	r3, #101	; 0x65
     9e8:	5f646568 	svcpl	0x00646568
     9ec:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     9f0:	00726574 	rsbseq	r6, r2, r4, ror r5
     9f4:	20554e47 	subscs	r4, r5, r7, asr #28
     9f8:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
     9fc:	30312034 	eorscc	r2, r1, r4, lsr r0
     a00:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
     a04:	32303220 	eorscc	r3, r0, #32, 4
     a08:	32363031 	eorscc	r3, r6, #49	; 0x31
     a0c:	72282031 	eorvc	r2, r8, #49	; 0x31
     a10:	61656c65 	cmnvs	r5, r5, ror #24
     a14:	20296573 	eorcs	r6, r9, r3, ror r5
     a18:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     a1c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     a20:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     a24:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     a28:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     a2c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     a30:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     a34:	6f6c666d 	svcvs	0x006c666d
     a38:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     a3c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     a40:	20647261 	rsbcs	r7, r4, r1, ror #4
     a44:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     a48:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     a4c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     a50:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     a54:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     a58:	36373131 			; <UNDEFINED> instruction: 0x36373131
     a5c:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     a60:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     a64:	206d7261 	rsbcs	r7, sp, r1, ror #4
     a68:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     a6c:	613d6863 	teqvs	sp, r3, ror #16
     a70:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     a74:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     a78:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     a7c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     a80:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     a84:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     a88:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     a8c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 8fc <shift+0x8fc>
     a90:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     a94:	6f697470 	svcvs	0x00697470
     a98:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     a9c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 90c <shift+0x90c>
     aa0:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     aa4:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     aa8:	65006574 	strvs	r6, [r0, #-1396]	; 0xfffffa8c
     aac:	5f746978 	svcpl	0x00746978
     ab0:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     ab4:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     ab8:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     abc:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     ac0:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     ac4:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     ac8:	74007974 	strvc	r7, [r0], #-2420	; 0xfffff68c
     acc:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     ad0:	63536d00 	cmpvs	r3, #0, 26
     ad4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     ad8:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     adc:	6f00636e 	svcvs	0x0000636e
     ae0:	006e6570 	rsbeq	r6, lr, r0, ror r5
     ae4:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     ae8:	50657069 	rsbpl	r7, r5, r9, rrx
     aec:	006a634b 	rsbeq	r6, sl, fp, asr #6
     af0:	6165444e 	cmnvs	r5, lr, asr #8
     af4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     af8:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     afc:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     b00:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     b04:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     b08:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     b0c:	6f635f6b 	svcvs	0x00635f6b
     b10:	00746e75 	rsbseq	r6, r4, r5, ror lr
     b14:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     b18:	70007966 	andvc	r7, r0, r6, ror #18
     b1c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     b20:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     b24:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     b28:	4b506a65 	blmi	141b4c4 <__bss_end+0x141255c>
     b2c:	67006a63 	strvs	r6, [r0, -r3, ror #20]
     b30:	745f7465 	ldrbvc	r7, [pc], #-1125	; b38 <shift+0xb38>
     b34:	5f6b7361 	svcpl	0x006b7361
     b38:	6b636974 	blvs	18db110 <__bss_end+0x18d21a8>
     b3c:	6f745f73 	svcvs	0x00745f73
     b40:	6165645f 	cmnvs	r5, pc, asr r4
     b44:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     b48:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     b4c:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     b50:	2f00657a 	svccs	0x0000657a
     b54:	2f746e6d 	svccs	0x00746e6d
     b58:	73552f63 	cmpvc	r5, #396	; 0x18c
     b5c:	2f737265 	svccs	0x00737265
     b60:	6162754b 	cmnvs	r2, fp, asr #10
     b64:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     b68:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     b6c:	5a2f7374 	bpl	bdd944 <__bss_end+0xbd49dc>
     b70:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 9e4 <shift+0x9e4>
     b74:	2f657461 	svccs	0x00657461
     b78:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     b7c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     b80:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     b84:	2f666465 	svccs	0x00666465
     b88:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     b8c:	65470064 	strbvs	r0, [r7, #-100]	; 0xffffff9c
     b90:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b94:	5f646568 	svcpl	0x00646568
     b98:	6f666e49 	svcvs	0x00666e49
     b9c:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     ba0:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     ba4:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     ba8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     bac:	5f00656e 	svcpl	0x0000656e
     bb0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     bb4:	6f725043 	svcvs	0x00725043
     bb8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bbc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     bc0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     bc4:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     bc8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     bcc:	00764565 	rsbseq	r4, r6, r5, ror #10
     bd0:	314e5a5f 	cmpcc	lr, pc, asr sl
     bd4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bd8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bdc:	614d5f73 	hvcvs	54771	; 0xd5f3
     be0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     be4:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     be8:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     bec:	5f656c69 	svcpl	0x00656c69
     bf0:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     bf4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     bf8:	5045746e 	subpl	r7, r5, lr, ror #8
     bfc:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     c00:	4700656c 	strmi	r6, [r0, -ip, ror #10]
     c04:	505f7465 	subspl	r7, pc, r5, ror #8
     c08:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     c0c:	5a5f0073 	bpl	17c0de0 <__bss_end+0x17b7e78>
     c10:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c14:	636f7250 	cmnvs	pc, #80, 4
     c18:	5f737365 	svcpl	0x00737365
     c1c:	616e614d 	cmnvs	lr, sp, asr #2
     c20:	31726567 	cmncc	r2, r7, ror #10
     c24:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     c28:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     c2c:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     c30:	00764546 	rsbseq	r4, r6, r6, asr #10
     c34:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     c38:	7065656c 	rsbvc	r6, r5, ip, ror #10
     c3c:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
     c40:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     c44:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     c48:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     c4c:	616e4500 	cmnvs	lr, r0, lsl #10
     c50:	5f656c62 	svcpl	0x00656c62
     c54:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     c58:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     c5c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     c60:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c64:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
     c68:	5f746567 	svcpl	0x00746567
     c6c:	6b736174 	blvs	1cd9244 <__bss_end+0x1cd02dc>
     c70:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     c74:	745f736b 	ldrbvc	r7, [pc], #-875	; c7c <shift+0xc7c>
     c78:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
     c7c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     c80:	0076656e 	rsbseq	r6, r6, lr, ror #10
     c84:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     c88:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     c8c:	5f746c75 	svcpl	0x00746c75
     c90:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
     c94:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     c98:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     c9c:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
     ca0:	5f006d75 	svcpl	0x00006d75
     ca4:	6177345a 	cmnvs	r7, sl, asr r4
     ca8:	6a6a7469 	bvs	1a9de54 <__bss_end+0x1a94eec>
     cac:	5a5f006a 	bpl	17c0e5c <__bss_end+0x17b7ef4>
     cb0:	636f6935 	cmnvs	pc, #868352	; 0xd4000
     cb4:	316a6c74 	smccc	42692	; 0xa6c4
     cb8:	4f494e36 	svcmi	0x00494e36
     cbc:	5f6c7443 	svcpl	0x006c7443
     cc0:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
     cc4:	6f697461 	svcvs	0x00697461
     cc8:	0076506e 	rsbseq	r5, r6, lr, rrx
     ccc:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     cd0:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
     cd4:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
     cd8:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     cdc:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     ce0:	61545f74 	cmpvs	r4, r4, ror pc
     ce4:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     ce8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     cec:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     cf0:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
     cf4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     cf8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     cfc:	646f6d00 	strbtvs	r6, [pc], #-3328	; d04 <shift+0xd04>
     d00:	70630065 	rsbvc	r0, r3, r5, rrx
     d04:	6f635f75 	svcvs	0x00635f75
     d08:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     d0c:	75620074 	strbvc	r0, [r2, #-116]!	; 0xffffff8c
     d10:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     d14:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     d18:	745f7065 	ldrbvc	r7, [pc], #-101	; d20 <shift+0xd20>
     d1c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     d20:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d24:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     d28:	636f7250 	cmnvs	pc, #80, 4
     d2c:	5f737365 	svcpl	0x00737365
     d30:	616e614d 	cmnvs	lr, sp, asr #2
     d34:	31726567 	cmncc	r2, r7, ror #10
     d38:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     d3c:	6f72505f 	svcvs	0x0072505f
     d40:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d44:	5f79425f 	svcpl	0x0079425f
     d48:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     d4c:	6148006a 	cmpvs	r8, sl, rrx
     d50:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     d54:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     d58:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     d5c:	5f6d6574 	svcpl	0x006d6574
     d60:	00495753 	subeq	r5, r9, r3, asr r7
     d64:	314e5a5f 	cmpcc	lr, pc, asr sl
     d68:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d6c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d70:	614d5f73 	hvcvs	54771	; 0xd5f3
     d74:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d78:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     d7c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d80:	5f656c75 	svcpl	0x00656c75
     d84:	76455252 			; <UNDEFINED> instruction: 0x76455252
     d88:	73617400 	cmnvc	r1, #0, 8
     d8c:	5a5f006b 	bpl	17c0f40 <__bss_end+0x17b7fd8>
     d90:	61657234 	cmnvs	r5, r4, lsr r2
     d94:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
     d98:	6f4e006a 	svcvs	0x004e006a
     d9c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     da0:	6f72505f 	svcvs	0x0072505f
     da4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     da8:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     dac:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     db0:	5a5f0065 	bpl	17c0f4c <__bss_end+0x17b7fe4>
     db4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     db8:	636f7250 	cmnvs	pc, #80, 4
     dbc:	5f737365 	svcpl	0x00737365
     dc0:	616e614d 	cmnvs	lr, sp, asr #2
     dc4:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     dc8:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     dcc:	545f6863 	ldrbpl	r6, [pc], #-2147	; dd4 <shift+0xdd4>
     dd0:	3150456f 	cmpcc	r0, pc, ror #10
     dd4:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     dd8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ddc:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     de0:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     de4:	0065646f 	rsbeq	r6, r5, pc, ror #8
     de8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     dec:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     df0:	0052525f 	subseq	r5, r2, pc, asr r2
     df4:	314e5a5f 	cmpcc	lr, pc, asr sl
     df8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     dfc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e00:	614d5f73 	hvcvs	54771	; 0xd5f3
     e04:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e08:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
     e0c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e10:	72505f65 	subsvc	r5, r0, #404	; 0x194
     e14:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e18:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     e1c:	30324549 	eorscc	r4, r2, r9, asr #10
     e20:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     e24:	6f72505f 	svcvs	0x0072505f
     e28:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e2c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     e30:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     e34:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     e38:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     e3c:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     e40:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     e44:	494e0074 	stmdbmi	lr, {r2, r4, r5, r6}^
     e48:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     e4c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     e50:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     e54:	5f006e6f 	svcpl	0x00006e6f
     e58:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     e5c:	6f725043 	svcvs	0x00725043
     e60:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e64:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     e68:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     e6c:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     e70:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     e74:	6f72505f 	svcvs	0x0072505f
     e78:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e7c:	6a685045 	bvs	1a14f98 <__bss_end+0x1a0c030>
     e80:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     e84:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     e88:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     e8c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     e90:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     e94:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e98:	5f6d6574 	svcpl	0x006d6574
     e9c:	76726553 			; <UNDEFINED> instruction: 0x76726553
     ea0:	00656369 	rsbeq	r6, r5, r9, ror #6
     ea4:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     ea8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     eac:	5f746567 	svcpl	0x00746567
     eb0:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     eb4:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     eb8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ebc:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     ec0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     ec4:	6c696600 	stclvs	6, cr6, [r9], #-0
     ec8:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     ecc:	6c420065 	mcrrvs	0, 6, r0, r2, cr5
     ed0:	5f6b636f 	svcpl	0x006b636f
     ed4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     ed8:	5f746e65 	svcpl	0x00746e65
     edc:	636f7250 	cmnvs	pc, #80, 4
     ee0:	00737365 	rsbseq	r7, r3, r5, ror #6
     ee4:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     ee8:	6f6c4300 	svcvs	0x006c4300
     eec:	67006573 	smlsdxvs	r0, r3, r5, r6
     ef0:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     ef4:	5a5f0064 	bpl	17c108c <__bss_end+0x17b8124>
     ef8:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
     efc:	634b506e 	movtvs	r5, #45166	; 0xb06e
     f00:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     f04:	5f656c69 	svcpl	0x00656c69
     f08:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     f0c:	646f4d5f 	strbtvs	r4, [pc], #-3423	; f14 <shift+0xf14>
     f10:	69590065 	ldmdbvs	r9, {r0, r2, r5, r6}^
     f14:	00646c65 	rsbeq	r6, r4, r5, ror #24
     f18:	314e5a5f 	cmpcc	lr, pc, asr sl
     f1c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     f20:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f24:	614d5f73 	hvcvs	54771	; 0xd5f3
     f28:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     f2c:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     f30:	65540076 	ldrbvs	r0, [r4, #-118]	; 0xffffff8a
     f34:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     f38:	00657461 	rsbeq	r7, r5, r1, ror #8
     f3c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     f40:	6e69006c 	cdpvs	0, 6, cr0, cr9, cr12, {3}
     f44:	00747570 	rsbseq	r7, r4, r0, ror r5
     f48:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
     f4c:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
     f50:	6c006f72 	stcvs	15, cr6, [r0], {114}	; 0x72
     f54:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     f58:	5a5f0068 	bpl	17c1100 <__bss_end+0x17b8198>
     f5c:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
     f60:	76506f72 	usub16vc	r6, r0, r2
     f64:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
     f68:	70636e72 	rsbvc	r6, r3, r2, ror lr
     f6c:	5a5f0079 	bpl	17c1158 <__bss_end+0x17b81f0>
     f70:	6f746134 	svcvs	0x00746134
     f74:	634b5069 	movtvs	r5, #45161	; 0xb069
     f78:	61684300 	cmnvs	r8, r0, lsl #6
     f7c:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
     f80:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
     f84:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     f88:	00747364 	rsbseq	r7, r4, r4, ror #6
     f8c:	7074756f 	rsbsvc	r7, r4, pc, ror #10
     f90:	5f007475 	svcpl	0x00007475
     f94:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
     f98:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
     f9c:	50764b50 	rsbspl	r4, r6, r0, asr fp
     fa0:	6d006976 	vstrvs.16	s12, [r0, #-236]	; 0xffffff14	; <UNPREDICTABLE>
     fa4:	70636d65 	rsbvc	r6, r3, r5, ror #26
     fa8:	74730079 	ldrbtvc	r0, [r3], #-121	; 0xffffff87
     fac:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
     fb0:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
     fb4:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
     fb8:	50706d63 	rsbspl	r6, r0, r3, ror #26
     fbc:	3053634b 	subscc	r6, r3, fp, asr #6
     fc0:	5f00695f 	svcpl	0x0000695f
     fc4:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
     fc8:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
     fcc:	00634b50 	rsbeq	r4, r3, r0, asr fp
     fd0:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     fd4:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
     fd8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
     fdc:	50797063 	rsbspl	r7, r9, r3, rrx
     fe0:	634b5063 	movtvs	r5, #45155	; 0xb063
     fe4:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
     fe8:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
     fec:	656d0070 	strbvs	r0, [sp, #-112]!	; 0xffffff90
     ff0:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     ff4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     ff8:	00637273 	rsbeq	r7, r3, r3, ror r2
     ffc:	616f7469 	cmnvs	pc, r9, ror #8
    1000:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    1004:	2f632f74 	svccs	0x00632f74
    1008:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    100c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
    1010:	442f6162 	strtmi	r6, [pc], #-354	; 1018 <shift+0x1018>
    1014:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
    1018:	73746e65 	cmnvc	r4, #1616	; 0x650
    101c:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
    1020:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
    1024:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1028:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
    102c:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
    1030:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
    1034:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
    1038:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    103c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1040:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1044:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1048:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    104c:	5f007070 	svcpl	0x00007070
    1050:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1054:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1058:	2e006a63 	vmlscs.f32	s12, s0, s7
    105c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1060:	2f2e2e2f 	svccs	0x002e2e2f
    1064:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1068:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    106c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1070:	2f636367 	svccs	0x00636367
    1074:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1078:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    107c:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; ebc <shift+0xebc>
    1080:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1084:	73636e75 	cmnvc	r3, #1872	; 0x750
    1088:	2f00532e 	svccs	0x0000532e
    108c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1090:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1094:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1098:	6f6e2d6d 	svcvs	0x006e2d6d
    109c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    10a0:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    10a4:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    10a8:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    10ac:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    10b0:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    10b4:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    10b8:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    10bc:	2e30312d 	rsfcssp	f3, f0, #5.0
    10c0:	30322d33 	eorscc	r2, r2, r3, lsr sp
    10c4:	302e3132 	eorcc	r3, lr, r2, lsr r1
    10c8:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    10cc:	2f646c69 	svccs	0x00646c69
    10d0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    10d4:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    10d8:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    10dc:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    10e0:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    10e4:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    10e8:	2f647261 	svccs	0x00647261
    10ec:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    10f0:	47006363 	strmi	r6, [r0, -r3, ror #6]
    10f4:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    10f8:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    10fc:	69003733 	stmdbvs	r0, {r0, r1, r4, r5, r8, r9, sl, ip, sp}
    1100:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1104:	705f7469 	subsvc	r7, pc, r9, ror #8
    1108:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    110c:	69007365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    1110:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1114:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1118:	625f7066 	subsvs	r7, pc, #102	; 0x66
    111c:	00657361 	rsbeq	r7, r5, r1, ror #6
    1120:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1124:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1128:	616f6c66 	cmnvs	pc, r6, ror #24
    112c:	73690074 	cmnvc	r9, #116	; 0x74
    1130:	6f6e5f61 	svcvs	0x006e5f61
    1134:	00746962 	rsbseq	r6, r4, r2, ror #18
    1138:	5f617369 	svcpl	0x00617369
    113c:	5f746962 	svcpl	0x00746962
    1140:	5f65766d 	svcpl	0x0065766d
    1144:	616f6c66 	cmnvs	pc, r6, ror #24
    1148:	73690074 	cmnvc	r9, #116	; 0x74
    114c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1150:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1154:	69003631 	stmdbvs	r0, {r0, r4, r5, r9, sl, ip, sp}
    1158:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    115c:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1160:	69006365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, sp, lr}
    1164:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1168:	615f7469 	cmpvs	pc, r9, ror #8
    116c:	00766964 	rsbseq	r6, r6, r4, ror #18
    1170:	5f617369 	svcpl	0x00617369
    1174:	5f746962 	svcpl	0x00746962
    1178:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    117c:	6f6e5f6b 	svcvs	0x006e5f6b
    1180:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 100c <shift+0x100c>
    1184:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1188:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    118c:	61736900 	cmnvs	r3, r0, lsl #18
    1190:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1194:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    1198:	5f617369 	svcpl	0x00617369
    119c:	5f746962 	svcpl	0x00746962
    11a0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    11a4:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    11a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    11ac:	615f7469 	cmpvs	pc, r9, ror #8
    11b0:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    11b4:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    11b8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    11bc:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    11c0:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    11c4:	5f617369 	svcpl	0x00617369
    11c8:	5f746962 	svcpl	0x00746962
    11cc:	36316662 	ldrtcc	r6, [r1], -r2, ror #12
    11d0:	53504600 	cmppl	r0, #0, 12
    11d4:	455f5243 	ldrbmi	r5, [pc, #-579]	; f99 <shift+0xf99>
    11d8:	004d554e 	subeq	r5, sp, lr, asr #10
    11dc:	43535046 	cmpmi	r3, #70	; 0x46
    11e0:	7a6e5f52 	bvc	1b98f30 <__bss_end+0x1b8ffc8>
    11e4:	63717663 	cmnvs	r1, #103809024	; 0x6300000
    11e8:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    11ec:	5056004d 	subspl	r0, r6, sp, asr #32
    11f0:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    11f4:	66004d55 			; <UNDEFINED> instruction: 0x66004d55
    11f8:	5f746962 	svcpl	0x00746962
    11fc:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    1200:	74616369 	strbtvc	r6, [r1], #-873	; 0xfffffc97
    1204:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1208:	455f3050 	ldrbmi	r3, [pc, #-80]	; 11c0 <shift+0x11c0>
    120c:	004d554e 	subeq	r5, sp, lr, asr #10
    1210:	5f617369 	svcpl	0x00617369
    1214:	5f746962 	svcpl	0x00746962
    1218:	70797263 	rsbsvc	r7, r9, r3, ror #4
    121c:	47006f74 	smlsdxmi	r0, r4, pc, r6	; <UNPREDICTABLE>
    1220:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1224:	31203731 			; <UNDEFINED> instruction: 0x31203731
    1228:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    122c:	30322031 	eorscc	r2, r2, r1, lsr r0
    1230:	36303132 			; <UNDEFINED> instruction: 0x36303132
    1234:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    1238:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    123c:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    1240:	616d2d20 	cmnvs	sp, r0, lsr #26
    1244:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1248:	6f6c666d 	svcvs	0x006c666d
    124c:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1250:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1254:	20647261 	rsbcs	r7, r4, r1, ror #4
    1258:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    125c:	613d6863 	teqvs	sp, r3, ror #16
    1260:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1264:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1268:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    126c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1270:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1274:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1278:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    127c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1280:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    1284:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    1288:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    128c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1290:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1294:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    1298:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    129c:	746f7270 	strbtvc	r7, [pc], #-624	; 12a4 <shift+0x12a4>
    12a0:	6f746365 	svcvs	0x00746365
    12a4:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    12a8:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    12ac:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    12b0:	662d2065 	strtvs	r2, [sp], -r5, rrx
    12b4:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    12b8:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    12bc:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    12c0:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    12c4:	7369006e 	cmnvc	r9, #110	; 0x6e
    12c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12cc:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    12d0:	63007669 	movwvs	r7, #1641	; 0x669
    12d4:	00736e6f 	rsbseq	r6, r3, pc, ror #28
    12d8:	5f617369 	svcpl	0x00617369
    12dc:	5f746962 	svcpl	0x00746962
    12e0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    12e4:	46007478 			; <UNDEFINED> instruction: 0x46007478
    12e8:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
    12ec:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    12f0:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    12f4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12f8:	615f7469 	cmpvs	pc, r9, ror #8
    12fc:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1300:	61736900 	cmnvs	r3, r0, lsl #18
    1304:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1308:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    130c:	61736900 	cmnvs	r3, r0, lsl #18
    1310:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1314:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1318:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    131c:	61736900 	cmnvs	r3, r0, lsl #18
    1320:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1324:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1328:	00307063 	eorseq	r7, r0, r3, rrx
    132c:	5f617369 	svcpl	0x00617369
    1330:	5f746962 	svcpl	0x00746962
    1334:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1338:	69003170 	stmdbvs	r0, {r4, r5, r6, r8, ip, sp}
    133c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1340:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1344:	70636564 	rsbvc	r6, r3, r4, ror #10
    1348:	73690032 	cmnvc	r9, #50	; 0x32
    134c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1350:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1354:	33706365 	cmncc	r0, #-1811939327	; 0x94000001
    1358:	61736900 	cmnvs	r3, r0, lsl #18
    135c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1360:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1364:	00347063 	eorseq	r7, r4, r3, rrx
    1368:	5f617369 	svcpl	0x00617369
    136c:	5f746962 	svcpl	0x00746962
    1370:	645f7066 	ldrbvs	r7, [pc], #-102	; 1378 <shift+0x1378>
    1374:	69006c62 	stmdbvs	r0, {r1, r5, r6, sl, fp, sp, lr}
    1378:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    137c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1380:	70636564 	rsbvc	r6, r3, r4, ror #10
    1384:	73690036 	cmnvc	r9, #54	; 0x36
    1388:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    138c:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1390:	37706365 	ldrbcc	r6, [r0, -r5, ror #6]!
    1394:	61736900 	cmnvs	r3, r0, lsl #18
    1398:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    139c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    13a0:	006b3676 	rsbeq	r3, fp, r6, ror r6
    13a4:	5f617369 	svcpl	0x00617369
    13a8:	5f746962 	svcpl	0x00746962
    13ac:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13b0:	6d315f38 	ldcvs	15, cr5, [r1, #-224]!	; 0xffffff20
    13b4:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
    13b8:	6e61006e 	cdpvs	0, 6, cr0, cr1, cr14, {3}
    13bc:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    13c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13c4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    13c8:	0065736d 	rsbeq	r7, r5, sp, ror #6
    13cc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    13d0:	756f6420 	strbvc	r6, [pc, #-1056]!	; fb8 <shift+0xfb8>
    13d4:	00656c62 	rsbeq	r6, r5, r2, ror #24
    13d8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    13dc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    13e0:	2f2e2e2f 	svccs	0x002e2e2f
    13e4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    13e8:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    13ec:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    13f0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    13f4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    13f8:	6900632e 	stmdbvs	r0, {r1, r2, r3, r5, r8, r9, sp, lr}
    13fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1400:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1404:	00357670 	eorseq	r7, r5, r0, ror r6
    1408:	5f617369 	svcpl	0x00617369
    140c:	5f746962 	svcpl	0x00746962
    1410:	61637378 	smcvs	14136	; 0x3738
    1414:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
    1418:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    141c:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1420:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1424:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1428:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    142c:	73690074 	cmnvc	r9, #116	; 0x74
    1430:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1434:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1438:	5f6b7269 	svcpl	0x006b7269
    143c:	5f336d63 	svcpl	0x00336d63
    1440:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    1444:	61736900 	cmnvs	r3, r0, lsl #18
    1448:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    144c:	6d38695f 			; <UNDEFINED> instruction: 0x6d38695f
    1450:	7369006d 	cmnvc	r9, #109	; 0x6d
    1454:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1458:	70665f74 	rsbvc	r5, r6, r4, ror pc
    145c:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    1460:	61736900 	cmnvs	r3, r0, lsl #18
    1464:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1468:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    146c:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1470:	61736900 	cmnvs	r3, r0, lsl #18
    1474:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1478:	61706c5f 	cmnvs	r0, pc, asr ip
    147c:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1480:	6d695f6c 	stclvs	15, cr5, [r9, #-432]!	; 0xfffffe50
    1484:	65696c70 	strbvs	r6, [r9, #-3184]!	; 0xfffff390
    1488:	62665f64 	rsbvs	r5, r6, #100, 30	; 0x190
    148c:	00737469 	rsbseq	r7, r3, r9, ror #8
    1490:	5f617369 	svcpl	0x00617369
    1494:	5f746962 	svcpl	0x00746962
    1498:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    149c:	00315f38 	eorseq	r5, r1, r8, lsr pc
    14a0:	5f617369 	svcpl	0x00617369
    14a4:	5f746962 	svcpl	0x00746962
    14a8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14ac:	00325f38 	eorseq	r5, r2, r8, lsr pc
    14b0:	5f617369 	svcpl	0x00617369
    14b4:	5f746962 	svcpl	0x00746962
    14b8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14bc:	00335f38 	eorseq	r5, r3, r8, lsr pc
    14c0:	5f617369 	svcpl	0x00617369
    14c4:	5f746962 	svcpl	0x00746962
    14c8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14cc:	00345f38 	eorseq	r5, r4, r8, lsr pc
    14d0:	5f617369 	svcpl	0x00617369
    14d4:	5f746962 	svcpl	0x00746962
    14d8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14dc:	00355f38 	eorseq	r5, r5, r8, lsr pc
    14e0:	5f617369 	svcpl	0x00617369
    14e4:	5f746962 	svcpl	0x00746962
    14e8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14ec:	00365f38 	eorseq	r5, r6, r8, lsr pc
    14f0:	5f617369 	svcpl	0x00617369
    14f4:	5f746962 	svcpl	0x00746962
    14f8:	69006273 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sp, lr}
    14fc:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1500:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    1504:	00737469 	rsbseq	r7, r3, r9, ror #8
    1508:	5f617369 	svcpl	0x00617369
    150c:	5f746962 	svcpl	0x00746962
    1510:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1514:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1518:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    151c:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    1520:	6f630072 	svcvs	0x00630072
    1524:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1528:	6f642078 	svcvs	0x00642078
    152c:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1530:	5f424e00 	svcpl	0x00424e00
    1534:	535f5046 	cmppl	pc, #70	; 0x46
    1538:	45525359 	ldrbmi	r5, [r2, #-857]	; 0xfffffca7
    153c:	69005347 	stmdbvs	r0, {r0, r1, r2, r6, r8, r9, ip, lr}
    1540:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1544:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1548:	70636564 	rsbvc	r6, r3, r4, ror #10
    154c:	73690035 	cmnvc	r9, #53	; 0x35
    1550:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1554:	66765f74 	uhsub16vs	r5, r6, r4
    1558:	00327670 	eorseq	r7, r2, r0, ror r6
    155c:	5f617369 	svcpl	0x00617369
    1560:	5f746962 	svcpl	0x00746962
    1564:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1568:	73690033 	cmnvc	r9, #51	; 0x33
    156c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1570:	66765f74 	uhsub16vs	r5, r6, r4
    1574:	00347670 	eorseq	r7, r4, r0, ror r6
    1578:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    157c:	5f534e54 	svcpl	0x00534e54
    1580:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1584:	61736900 	cmnvs	r3, r0, lsl #18
    1588:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    158c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1590:	6900626d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r9, sp, lr}
    1594:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1598:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    159c:	63363170 	teqvs	r6, #112, 2
    15a0:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    15a4:	5f617369 	svcpl	0x00617369
    15a8:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    15ac:	00657275 	rsbeq	r7, r5, r5, ror r2
    15b0:	5f617369 	svcpl	0x00617369
    15b4:	5f746962 	svcpl	0x00746962
    15b8:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    15bc:	61736900 	cmnvs	r3, r0, lsl #18
    15c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15c4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    15c8:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    15cc:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    15d0:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    15d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15d8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    15dc:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    15e0:	61736900 	cmnvs	r3, r0, lsl #18
    15e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15e8:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    15ec:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    15f0:	73615f6f 	cmnvc	r1, #444	; 0x1bc
    15f4:	7570636d 	ldrbvc	r6, [r0, #-877]!	; 0xfffffc93
    15f8:	61736900 	cmnvs	r3, r0, lsl #18
    15fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1600:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1604:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    1608:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    160c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1614 <shift+0x1614>
    1610:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1614:	73690032 	cmnvc	r9, #50	; 0x32
    1618:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    161c:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1620:	73690038 	cmnvc	r9, #56	; 0x38
    1624:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1628:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    162c:	0037766d 	eorseq	r7, r7, sp, ror #12
    1630:	5f617369 	svcpl	0x00617369
    1634:	5f746962 	svcpl	0x00746962
    1638:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    163c:	66760038 			; <UNDEFINED> instruction: 0x66760038
    1640:	79735f70 	ldmdbvc	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1644:	67657273 			; <UNDEFINED> instruction: 0x67657273
    1648:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    164c:	69646f63 	stmdbvs	r4!, {r0, r1, r5, r6, r8, r9, sl, fp, sp, lr}^
    1650:	6900676e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
    1654:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1658:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    165c:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1660:	69006c6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, sl, fp, sp, lr}
    1664:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1668:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1670 <shift+0x1670>
    166c:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1670:	Address 0x0000000000001670 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa9c8>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3478c8>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa9e8>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9d18>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfaa18>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347918>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaa38>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347938>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfaa58>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347958>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaa78>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347978>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaa98>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347998>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfaab8>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3479b8>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaad8>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3479d8>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faaf0>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fab10>
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
 194:	0000003c 	andeq	r0, r0, ip, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fab40>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008268 	andeq	r8, r0, r8, ror #4
 1b4:	0000011c 	andeq	r0, r0, ip, lsl r1
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1fab60>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	00008384 	andeq	r8, r0, r4, lsl #7
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfab8c>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347a8c>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	000083b0 			; <UNDEFINED> instruction: 0x000083b0
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfabac>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347aac>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	000083dc 	ldrdeq	r8, [r0], -ip
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfabcc>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347acc>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfabec>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347aec>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	0000843c 	andeq	r8, r0, ip, lsr r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfac0c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347b0c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	0000848c 	andeq	r8, r0, ip, lsl #9
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfac2c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347b2c>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	000084dc 	ldrdeq	r8, [r0], -ip
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfac4c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347b4c>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	00008508 	andeq	r8, r0, r8, lsl #10
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfac6c>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347b6c>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	00008558 	andeq	r8, r0, r8, asr r5
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfac8c>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347b8c>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	0000859c 	muleq	r0, ip, r5
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfacac>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347bac>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	000085ec 	andeq	r8, r0, ip, ror #11
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfaccc>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347bcc>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	00008640 	andeq	r8, r0, r0, asr #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfacec>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347bec>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	0000867c 	andeq	r8, r0, ip, ror r6
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfad0c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347c0c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	000086b8 			; <UNDEFINED> instruction: 0x000086b8
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfad2c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347c2c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	000086f4 	strdeq	r8, [r0], -r4
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfad4c>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347c4c>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	00008730 	andeq	r8, r0, r0, lsr r7
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fad6c>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	000087e0 	andeq	r8, r0, r0, ror #15
 3f0:	00000174 	andeq	r0, r0, r4, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fad9c>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	00008954 	andeq	r8, r0, r4, asr r9
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfadbc>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347cbc>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	000089f0 	strdeq	r8, [r0], -r0
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfaddc>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347cdc>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008ab0 			; <UNDEFINED> instruction: 0x00008ab0
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfadfc>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347cfc>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008b5c 	andeq	r8, r0, ip, asr fp
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfae1c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347d1c>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008bb0 			; <UNDEFINED> instruction: 0x00008bb0
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfae3c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347d3c>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008c18 	andeq	r8, r0, r8, lsl ip
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfae5c>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347d5c>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000000c 	andeq	r0, r0, ip
 4c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4cc:	7c010001 	stcvc	0, cr0, [r1], {1}
 4d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4d4:	0000000c 	andeq	r0, r0, ip
 4d8:	000004c4 	andeq	r0, r0, r4, asr #9
 4dc:	00008c98 	muleq	r0, r8, ip
 4e0:	000001ec 	andeq	r0, r0, ip, ror #3
