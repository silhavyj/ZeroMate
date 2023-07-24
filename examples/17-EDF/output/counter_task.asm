
./counter_task:     file format elf32-littlearm


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
    805c:	00008fbc 			; <UNDEFINED> instruction: 0x00008fbc
    8060:	00008fcc 	andeq	r8, r0, ip, asr #31

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
    8080:	eb000069 	bl	822c <main>
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
    81cc:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    81d0:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9

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
    8224:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    8228:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:17
 *  - vzestupne pokud je prepinac 1 v poloze "zapnuto", jinak sestupne
 *  - rychle pokud je prepinac 2 v poloze "zapnuto", jinak pomalu
 **/

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:18
    uint32_t display_file = open("DEV:segd", NFile_Open_Mode::Write_Only);
    8240:	e3a01001 	mov	r1, #1
    8244:	e59f0170 	ldr	r0, [pc, #368]	; 83bc <main+0x190>
    8248:	eb00007c 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    824c:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:19
    uint32_t switch1_file = open("DEV:gpio/4", NFile_Open_Mode::Read_Only);
    8250:	e3a01000 	mov	r1, #0
    8254:	e59f0164 	ldr	r0, [pc, #356]	; 83c0 <main+0x194>
    8258:	eb000078 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    825c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:20
    uint32_t switch2_file = open("DEV:gpio/17", NFile_Open_Mode::Read_Only);
    8260:	e3a01000 	mov	r1, #0
    8264:	e59f0158 	ldr	r0, [pc, #344]	; 83c4 <main+0x198>
    8268:	eb000074 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    826c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:22

    unsigned int counter = 0;
    8270:	e3a03000 	mov	r3, #0
    8274:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:23
    bool fast = false;
    8278:	e3a03000 	mov	r3, #0
    827c:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:24
    bool ascending = true;
    8280:	e3a03001 	mov	r3, #1
    8284:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:26

    set_task_deadline(fast ? 10 : 28);
    8288:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    828c:	e3530000 	cmp	r3, #0
    8290:	0a000001 	beq	829c <main+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:26 (discriminator 1)
    8294:	e3a0300a 	mov	r3, #10
    8298:	ea000000 	b	82a0 <main+0x74>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:26 (discriminator 2)
    829c:	e3a0301c 	mov	r3, #28
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:26 (discriminator 4)
    82a0:	e1a00003 	mov	r0, r3
    82a4:	eb000115 	bl	8700 <_Z17set_task_deadlinej>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:30

    while (true)
    {
        char tmp = '0';
    82a8:	e3a03030 	mov	r3, #48	; 0x30
    82ac:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:32

        read(switch1_file, &tmp, 1);
    82b0:	e24b3017 	sub	r3, fp, #23
    82b4:	e3a02001 	mov	r2, #1
    82b8:	e1a01003 	mov	r1, r3
    82bc:	e51b0010 	ldr	r0, [fp, #-16]
    82c0:	eb00006f 	bl	8484 <_Z4readjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:33
        ascending = (tmp == '1');
    82c4:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82c8:	e3530031 	cmp	r3, #49	; 0x31
    82cc:	03a03001 	moveq	r3, #1
    82d0:	13a03000 	movne	r3, #0
    82d4:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:35

        read(switch2_file, &tmp, 1);
    82d8:	e24b3017 	sub	r3, fp, #23
    82dc:	e3a02001 	mov	r2, #1
    82e0:	e1a01003 	mov	r1, r3
    82e4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    82e8:	eb000065 	bl	8484 <_Z4readjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:36
        fast = (tmp == '1');
    82ec:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82f0:	e3530031 	cmp	r3, #49	; 0x31
    82f4:	03a03001 	moveq	r3, #1
    82f8:	13a03000 	movne	r3, #0
    82fc:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:38

        if (ascending)
    8300:	e55b3016 	ldrb	r3, [fp, #-22]	; 0xffffffea
    8304:	e3530000 	cmp	r3, #0
    8308:	0a000003 	beq	831c <main+0xf0>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:39
            counter++;
    830c:	e51b3008 	ldr	r3, [fp, #-8]
    8310:	e2833001 	add	r3, r3, #1
    8314:	e50b3008 	str	r3, [fp, #-8]
    8318:	ea000002 	b	8328 <main+0xfc>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:41
        else
            counter--;
    831c:	e51b3008 	ldr	r3, [fp, #-8]
    8320:	e2433001 	sub	r3, r3, #1
    8324:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:43

        tmp = '0' + (counter % 10);
    8328:	e51b1008 	ldr	r1, [fp, #-8]
    832c:	e59f3094 	ldr	r3, [pc, #148]	; 83c8 <main+0x19c>
    8330:	e0832193 	umull	r2, r3, r3, r1
    8334:	e1a021a3 	lsr	r2, r3, #3
    8338:	e1a03002 	mov	r3, r2
    833c:	e1a03103 	lsl	r3, r3, #2
    8340:	e0833002 	add	r3, r3, r2
    8344:	e1a03083 	lsl	r3, r3, #1
    8348:	e0412003 	sub	r2, r1, r3
    834c:	e6ef3072 	uxtb	r3, r2
    8350:	e2833030 	add	r3, r3, #48	; 0x30
    8354:	e6ef3073 	uxtb	r3, r3
    8358:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:44
        write(display_file, &tmp, 1);
    835c:	e24b3017 	sub	r3, fp, #23
    8360:	e3a02001 	mov	r2, #1
    8364:	e1a01003 	mov	r1, r3
    8368:	e51b000c 	ldr	r0, [fp, #-12]
    836c:	eb000058 	bl	84d4 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:46

        sleep(3);
    8370:	e3e01001 	mvn	r1, #1
    8374:	e3a00003 	mov	r0, #3
    8378:	eb0000ad 	bl	8634 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47
        sleep(fast ? 4 : 20, fast ? 10 : 28);
    837c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8380:	e3530000 	cmp	r3, #0
    8384:	0a000001 	beq	8390 <main+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47 (discriminator 1)
    8388:	e3a02004 	mov	r2, #4
    838c:	ea000000 	b	8394 <main+0x168>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47 (discriminator 2)
    8390:	e3a02014 	mov	r2, #20
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47 (discriminator 4)
    8394:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8398:	e3530000 	cmp	r3, #0
    839c:	0a000001 	beq	83a8 <main+0x17c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47 (discriminator 5)
    83a0:	e3a0300a 	mov	r3, #10
    83a4:	ea000000 	b	83ac <main+0x180>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47 (discriminator 6)
    83a8:	e3a0301c 	mov	r3, #28
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:47 (discriminator 8)
    83ac:	e1a01003 	mov	r1, r3
    83b0:	e1a00002 	mov	r0, r2
    83b4:	eb00009e 	bl	8634 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/counter_task/main.cpp:48 (discriminator 8)
    }
    83b8:	eaffffba 	b	82a8 <main+0x7c>
    83bc:	00008f4c 	andeq	r8, r0, ip, asr #30
    83c0:	00008f58 	andeq	r8, r0, r8, asr pc
    83c4:	00008f64 	andeq	r8, r0, r4, ror #30
    83c8:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000083cc <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83d8:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r"(pid));
    83dc:	e1a03000 	mov	r3, r0
    83e0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:11

    return pid;
    83e4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:12
}
    83e8:	e1a00003 	mov	r0, r3
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd00c 	sub	sp, sp, #12
    8404:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r"(exitcode));
    8408:	e51b3008 	ldr	r3, [fp, #-8]
    840c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8410:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:18
}
    8414:	e320f000 	nop	{0}
    8418:	e28bd000 	add	sp, fp, #0
    841c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8420:	e12fff1e 	bx	lr

00008424 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8424:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8428:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    842c:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:23
}
    8430:	e320f000 	nop	{0}
    8434:	e28bd000 	add	sp, fp, #0
    8438:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    843c:	e12fff1e 	bx	lr

00008440 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8440:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8444:	e28db000 	add	fp, sp, #0
    8448:	e24dd014 	sub	sp, sp, #20
    844c:	e50b0010 	str	r0, [fp, #-16]
    8450:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r"(filename));
    8454:	e51b3010 	ldr	r3, [fp, #-16]
    8458:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r"(mode));
    845c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8460:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8464:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r"(file));
    8468:	e1a03000 	mov	r3, r0
    846c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:34

    return file;
    8470:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:35
}
    8474:	e1a00003 	mov	r0, r3
    8478:	e28bd000 	add	sp, fp, #0
    847c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8480:	e12fff1e 	bx	lr

00008484 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8484:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8488:	e28db000 	add	fp, sp, #0
    848c:	e24dd01c 	sub	sp, sp, #28
    8490:	e50b0010 	str	r0, [fp, #-16]
    8494:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8498:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r"(file));
    849c:	e51b3010 	ldr	r3, [fp, #-16]
    84a0:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r"(buffer));
    84a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84a8:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r"(size));
    84ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b0:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    84b4:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r"(rdnum));
    84b8:	e1a03000 	mov	r3, r0
    84bc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:47

    return rdnum;
    84c0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:48
}
    84c4:	e1a00003 	mov	r0, r3
    84c8:	e28bd000 	add	sp, fp, #0
    84cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d0:	e12fff1e 	bx	lr

000084d4 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d8:	e28db000 	add	fp, sp, #0
    84dc:	e24dd01c 	sub	sp, sp, #28
    84e0:	e50b0010 	str	r0, [fp, #-16]
    84e4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r"(file));
    84ec:	e51b3010 	ldr	r3, [fp, #-16]
    84f0:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r"(buffer));
    84f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f8:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r"(size));
    84fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8500:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8504:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r"(wrnum));
    8508:	e1a03000 	mov	r3, r0
    850c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:60

    return wrnum;
    8510:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:61
}
    8514:	e1a00003 	mov	r0, r3
    8518:	e28bd000 	add	sp, fp, #0
    851c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8520:	e12fff1e 	bx	lr

00008524 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8524:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8528:	e28db000 	add	fp, sp, #0
    852c:	e24dd00c 	sub	sp, sp, #12
    8530:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r"(file));
    8534:	e51b3008 	ldr	r3, [fp, #-8]
    8538:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    853c:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:67
}
    8540:	e320f000 	nop	{0}
    8544:	e28bd000 	add	sp, fp, #0
    8548:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    854c:	e12fff1e 	bx	lr

00008550 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8550:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8554:	e28db000 	add	fp, sp, #0
    8558:	e24dd01c 	sub	sp, sp, #28
    855c:	e50b0010 	str	r0, [fp, #-16]
    8560:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8564:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    8568:	e51b3010 	ldr	r3, [fp, #-16]
    856c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r"(operation));
    8570:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8574:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r"(param));
    8578:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    857c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8580:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r"(retcode));
    8584:	e1a03000 	mov	r3, r0
    8588:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:79

    return retcode;
    858c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:80
}
    8590:	e1a00003 	mov	r0, r3
    8594:	e28bd000 	add	sp, fp, #0
    8598:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    859c:	e12fff1e 	bx	lr

000085a0 <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    85a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a4:	e28db000 	add	fp, sp, #0
    85a8:	e24dd014 	sub	sp, sp, #20
    85ac:	e50b0010 	str	r0, [fp, #-16]
    85b0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r"(file));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r"(count));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    85c4:	ef000045 	svc	0x00000045
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r"(retcnt));
    85c8:	e1a03000 	mov	r3, r0
    85cc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:91

    return retcnt;
    85d0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:92
}
    85d4:	e1a00003 	mov	r0, r3
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd01c 	sub	sp, sp, #28
    85f0:	e50b0010 	str	r0, [fp, #-16]
    85f4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85f8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    85fc:	e51b3010 	ldr	r3, [fp, #-16]
    8600:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r"(count));
    8604:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8608:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r"(notified_deadline));
    860c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8610:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8614:	ef000046 	svc	0x00000046
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r"(retcode));
    8618:	e1a03000 	mov	r3, r0
    861c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:104

    return retcode;
    8620:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:105
}
    8624:	e1a00003 	mov	r0, r3
    8628:	e28bd000 	add	sp, fp, #0
    862c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8630:	e12fff1e 	bx	lr

00008634 <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8634:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8638:	e28db000 	add	fp, sp, #0
    863c:	e24dd014 	sub	sp, sp, #20
    8640:	e50b0010 	str	r0, [fp, #-16]
    8644:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(ticks));
    8648:	e51b3010 	ldr	r3, [fp, #-16]
    864c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r"(notified_deadline));
    8650:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8654:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8658:	ef000003 	svc	0x00000003
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r"(retcode));
    865c:	e1a03000 	mov	r3, r0
    8660:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:116

    return retcode;
    8664:	e51b3008 	ldr	r3, [fp, #-8]
    8668:	e3530000 	cmp	r3, #0
    866c:	13a03001 	movne	r3, #1
    8670:	03a03000 	moveq	r3, #0
    8674:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:117
}
    8678:	e1a00003 	mov	r0, r3
    867c:	e28bd000 	add	sp, fp, #0
    8680:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8684:	e12fff1e 	bx	lr

00008688 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8688:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    868c:	e28db000 	add	fp, sp, #0
    8690:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8694:	e3a03000 	mov	r3, #0
    8698:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    869c:	e3a03000 	mov	r3, #0
    86a0:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r"(&retval));
    86a4:	e24b300c 	sub	r3, fp, #12
    86a8:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    86ac:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:128

    return retval;
    86b0:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:129
}
    86b4:	e1a00003 	mov	r0, r3
    86b8:	e28bd000 	add	sp, fp, #0
    86bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86c0:	e12fff1e 	bx	lr

000086c4 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    86c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86c8:	e28db000 	add	fp, sp, #0
    86cc:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86d0:	e3a03001 	mov	r3, #1
    86d4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    86d8:	e3a03001 	mov	r3, #1
    86dc:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r"(&retval));
    86e0:	e24b300c 	sub	r3, fp, #12
    86e4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    86e8:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:140

    return retval;
    86ec:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:141
}
    86f0:	e1a00003 	mov	r0, r3
    86f4:	e28bd000 	add	sp, fp, #0
    86f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86fc:	e12fff1e 	bx	lr

00008700 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8700:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8704:	e28db000 	add	fp, sp, #0
    8708:	e24dd014 	sub	sp, sp, #20
    870c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8710:	e3a03000 	mov	r3, #0
    8714:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r"(req));
    8718:	e3a03000 	mov	r3, #0
    871c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r"(&tick_count_required));
    8720:	e24b3010 	sub	r3, fp, #16
    8724:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8728:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:150
}
    872c:	e320f000 	nop	{0}
    8730:	e28bd000 	add	sp, fp, #0
    8734:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8738:	e12fff1e 	bx	lr

0000873c <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    873c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8740:	e28db000 	add	fp, sp, #0
    8744:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8748:	e3a03001 	mov	r3, #1
    874c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r"(req));
    8750:	e3a03001 	mov	r3, #1
    8754:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r"(&ticks));
    8758:	e24b300c 	sub	r3, fp, #12
    875c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8760:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:161

    return ticks;
    8764:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:162
}
    8768:	e1a00003 	mov	r0, r3
    876c:	e28bd000 	add	sp, fp, #0
    8770:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8774:	e12fff1e 	bx	lr

00008778 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8778:	e92d4800 	push	{fp, lr}
    877c:	e28db004 	add	fp, sp, #4
    8780:	e24dd050 	sub	sp, sp, #80	; 0x50
    8784:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8788:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    878c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8790:	e3a0200a 	mov	r2, #10
    8794:	e59f1088 	ldr	r1, [pc, #136]	; 8824 <_Z4pipePKcj+0xac>
    8798:	e1a00003 	mov	r0, r3
    879c:	eb0000a5 	bl	8a38 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87a0:	e24b3048 	sub	r3, fp, #72	; 0x48
    87a4:	e283300a 	add	r3, r3, #10
    87a8:	e3a02035 	mov	r2, #53	; 0x35
    87ac:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87b0:	e1a00003 	mov	r0, r3
    87b4:	eb00009f 	bl	8a38 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    87b8:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    87bc:	eb0000f8 	bl	8ba4 <_Z6strlenPKc>
    87c0:	e1a03000 	mov	r3, r0
    87c4:	e283300a 	add	r3, r3, #10
    87c8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    87cc:	e51b3008 	ldr	r3, [fp, #-8]
    87d0:	e2832001 	add	r2, r3, #1
    87d4:	e50b2008 	str	r2, [fp, #-8]
    87d8:	e2433004 	sub	r3, r3, #4
    87dc:	e083300b 	add	r3, r3, fp
    87e0:	e3a02023 	mov	r2, #35	; 0x23
    87e4:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    87e8:	e24b2048 	sub	r2, fp, #72	; 0x48
    87ec:	e51b3008 	ldr	r3, [fp, #-8]
    87f0:	e0823003 	add	r3, r2, r3
    87f4:	e3a0200a 	mov	r2, #10
    87f8:	e1a01003 	mov	r1, r3
    87fc:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8800:	eb000008 	bl	8828 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8804:	e24b3048 	sub	r3, fp, #72	; 0x48
    8808:	e3a01002 	mov	r1, #2
    880c:	e1a00003 	mov	r0, r3
    8810:	ebffff0a 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    8814:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:179
}
    8818:	e1a00003 	mov	r0, r3
    881c:	e24bd004 	sub	sp, fp, #4
    8820:	e8bd8800 	pop	{fp, pc}
    8824:	00008f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>

00008828 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8828:	e92d4800 	push	{fp, lr}
    882c:	e28db004 	add	fp, sp, #4
    8830:	e24dd020 	sub	sp, sp, #32
    8834:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8838:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    883c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:10
    int i = 0;
    8840:	e3a03000 	mov	r3, #0
    8844:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12

    while (input > 0)
    8848:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    884c:	e3530000 	cmp	r3, #0
    8850:	0a000014 	beq	88a8 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    8854:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8858:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    885c:	e1a00003 	mov	r0, r3
    8860:	eb000199 	bl	8ecc <__aeabi_uidivmod>
    8864:	e1a03001 	mov	r3, r1
    8868:	e1a01003 	mov	r1, r3
    886c:	e51b3008 	ldr	r3, [fp, #-8]
    8870:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8874:	e0823003 	add	r3, r2, r3
    8878:	e59f2118 	ldr	r2, [pc, #280]	; 8998 <_Z4itoajPcj+0x170>
    887c:	e7d22001 	ldrb	r2, [r2, r1]
    8880:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:15
        input /= base;
    8884:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8888:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    888c:	eb000113 	bl	8ce0 <__udivsi3>
    8890:	e1a03000 	mov	r3, r0
    8894:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:16
        i++;
    8898:	e51b3008 	ldr	r3, [fp, #-8]
    889c:	e2833001 	add	r3, r3, #1
    88a0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12
    while (input > 0)
    88a4:	eaffffe7 	b	8848 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    88a8:	e51b3008 	ldr	r3, [fp, #-8]
    88ac:	e3530000 	cmp	r3, #0
    88b0:	1a000007 	bne	88d4 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88bc:	e0823003 	add	r3, r2, r3
    88c0:	e3a02030 	mov	r2, #48	; 0x30
    88c4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:22
        i++;
    88c8:	e51b3008 	ldr	r3, [fp, #-8]
    88cc:	e2833001 	add	r3, r3, #1
    88d0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    88d4:	e51b3008 	ldr	r3, [fp, #-8]
    88d8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88dc:	e0823003 	add	r3, r2, r3
    88e0:	e3a02000 	mov	r2, #0
    88e4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:26
    i--;
    88e8:	e51b3008 	ldr	r3, [fp, #-8]
    88ec:	e2433001 	sub	r3, r3, #1
    88f0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    88f4:	e3a03000 	mov	r3, #0
    88f8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 3)
    88fc:	e51b3008 	ldr	r3, [fp, #-8]
    8900:	e1a02fa3 	lsr	r2, r3, #31
    8904:	e0823003 	add	r3, r2, r3
    8908:	e1a030c3 	asr	r3, r3, #1
    890c:	e1a02003 	mov	r2, r3
    8910:	e51b300c 	ldr	r3, [fp, #-12]
    8914:	e1530002 	cmp	r3, r2
    8918:	ca00001b 	bgt	898c <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    891c:	e51b2008 	ldr	r2, [fp, #-8]
    8920:	e51b300c 	ldr	r3, [fp, #-12]
    8924:	e0423003 	sub	r3, r2, r3
    8928:	e1a02003 	mov	r2, r3
    892c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8930:	e0833002 	add	r3, r3, r2
    8934:	e5d33000 	ldrb	r3, [r3]
    8938:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    893c:	e51b300c 	ldr	r3, [fp, #-12]
    8940:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8944:	e0822003 	add	r2, r2, r3
    8948:	e51b1008 	ldr	r1, [fp, #-8]
    894c:	e51b300c 	ldr	r3, [fp, #-12]
    8950:	e0413003 	sub	r3, r1, r3
    8954:	e1a01003 	mov	r1, r3
    8958:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    895c:	e0833001 	add	r3, r3, r1
    8960:	e5d22000 	ldrb	r2, [r2]
    8964:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    8968:	e51b300c 	ldr	r3, [fp, #-12]
    896c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8970:	e0823003 	add	r3, r2, r3
    8974:	e55b200d 	ldrb	r2, [fp, #-13]
    8978:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    897c:	e51b300c 	ldr	r3, [fp, #-12]
    8980:	e2833001 	add	r3, r3, #1
    8984:	e50b300c 	str	r3, [fp, #-12]
    8988:	eaffffdb 	b	88fc <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:34
    }
}
    898c:	e320f000 	nop	{0}
    8990:	e24bd004 	sub	sp, fp, #4
    8994:	e8bd8800 	pop	{fp, pc}
    8998:	00008fa8 	andeq	r8, r0, r8, lsr #31

0000899c <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    899c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89a0:	e28db000 	add	fp, sp, #0
    89a4:	e24dd014 	sub	sp, sp, #20
    89a8:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:38
    int output = 0;
    89ac:	e3a03000 	mov	r3, #0
    89b0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40

    while (*input != '\0')
    89b4:	e51b3010 	ldr	r3, [fp, #-16]
    89b8:	e5d33000 	ldrb	r3, [r3]
    89bc:	e3530000 	cmp	r3, #0
    89c0:	0a000017 	beq	8a24 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:42
    {
        output *= 10;
    89c4:	e51b2008 	ldr	r2, [fp, #-8]
    89c8:	e1a03002 	mov	r3, r2
    89cc:	e1a03103 	lsl	r3, r3, #2
    89d0:	e0833002 	add	r3, r3, r2
    89d4:	e1a03083 	lsl	r3, r3, #1
    89d8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43
        if (*input > '9' || *input < '0')
    89dc:	e51b3010 	ldr	r3, [fp, #-16]
    89e0:	e5d33000 	ldrb	r3, [r3]
    89e4:	e3530039 	cmp	r3, #57	; 0x39
    89e8:	8a00000d 	bhi	8a24 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43 (discriminator 1)
    89ec:	e51b3010 	ldr	r3, [fp, #-16]
    89f0:	e5d33000 	ldrb	r3, [r3]
    89f4:	e353002f 	cmp	r3, #47	; 0x2f
    89f8:	9a000009 	bls	8a24 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:46
            break;

        output += *input - '0';
    89fc:	e51b3010 	ldr	r3, [fp, #-16]
    8a00:	e5d33000 	ldrb	r3, [r3]
    8a04:	e2433030 	sub	r3, r3, #48	; 0x30
    8a08:	e51b2008 	ldr	r2, [fp, #-8]
    8a0c:	e0823003 	add	r3, r2, r3
    8a10:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:48

        input++;
    8a14:	e51b3010 	ldr	r3, [fp, #-16]
    8a18:	e2833001 	add	r3, r3, #1
    8a1c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40
    while (*input != '\0')
    8a20:	eaffffe3 	b	89b4 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:51
    }

    return output;
    8a24:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:52
}
    8a28:	e1a00003 	mov	r0, r3
    8a2c:	e28bd000 	add	sp, fp, #0
    8a30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a34:	e12fff1e 	bx	lr

00008a38 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char* src, int num)
{
    8a38:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a3c:	e28db000 	add	fp, sp, #0
    8a40:	e24dd01c 	sub	sp, sp, #28
    8a44:	e50b0010 	str	r0, [fp, #-16]
    8a48:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a4c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    8a50:	e3a03000 	mov	r3, #0
    8a54:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8a58:	e51b2008 	ldr	r2, [fp, #-8]
    8a5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a60:	e1520003 	cmp	r2, r3
    8a64:	aa000011 	bge	8ab0 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8a68:	e51b3008 	ldr	r3, [fp, #-8]
    8a6c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a70:	e0823003 	add	r3, r2, r3
    8a74:	e5d33000 	ldrb	r3, [r3]
    8a78:	e3530000 	cmp	r3, #0
    8a7c:	0a00000b 	beq	8ab0 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:59 (discriminator 3)
        dest[i] = src[i];
    8a80:	e51b3008 	ldr	r3, [fp, #-8]
    8a84:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a88:	e0822003 	add	r2, r2, r3
    8a8c:	e51b3008 	ldr	r3, [fp, #-8]
    8a90:	e51b1010 	ldr	r1, [fp, #-16]
    8a94:	e0813003 	add	r3, r1, r3
    8a98:	e5d22000 	ldrb	r2, [r2]
    8a9c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    8aa0:	e51b3008 	ldr	r3, [fp, #-8]
    8aa4:	e2833001 	add	r3, r3, #1
    8aa8:	e50b3008 	str	r3, [fp, #-8]
    8aac:	eaffffe9 	b	8a58 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 2)
    for (; i < num; i++)
    8ab0:	e51b2008 	ldr	r2, [fp, #-8]
    8ab4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ab8:	e1520003 	cmp	r2, r3
    8abc:	aa000008 	bge	8ae4 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:61 (discriminator 1)
        dest[i] = '\0';
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e51b2010 	ldr	r2, [fp, #-16]
    8ac8:	e0823003 	add	r3, r2, r3
    8acc:	e3a02000 	mov	r2, #0
    8ad0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 1)
    for (; i < num; i++)
    8ad4:	e51b3008 	ldr	r3, [fp, #-8]
    8ad8:	e2833001 	add	r3, r3, #1
    8adc:	e50b3008 	str	r3, [fp, #-8]
    8ae0:	eafffff2 	b	8ab0 <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:63

    return dest;
    8ae4:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:64
}
    8ae8:	e1a00003 	mov	r0, r3
    8aec:	e28bd000 	add	sp, fp, #0
    8af0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8af4:	e12fff1e 	bx	lr

00008af8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:67

int strncmp(const char* s1, const char* s2, int num)
{
    8af8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8afc:	e28db000 	add	fp, sp, #0
    8b00:	e24dd01c 	sub	sp, sp, #28
    8b04:	e50b0010 	str	r0, [fp, #-16]
    8b08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b0c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:69
    unsigned char u1, u2;
    while (num-- > 0)
    8b10:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b14:	e2432001 	sub	r2, r3, #1
    8b18:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b1c:	e3530000 	cmp	r3, #0
    8b20:	c3a03001 	movgt	r3, #1
    8b24:	d3a03000 	movle	r3, #0
    8b28:	e6ef3073 	uxtb	r3, r3
    8b2c:	e3530000 	cmp	r3, #0
    8b30:	0a000016 	beq	8b90 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:71
    {
        u1 = (unsigned char)*s1++;
    8b34:	e51b3010 	ldr	r3, [fp, #-16]
    8b38:	e2832001 	add	r2, r3, #1
    8b3c:	e50b2010 	str	r2, [fp, #-16]
    8b40:	e5d33000 	ldrb	r3, [r3]
    8b44:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:72
        u2 = (unsigned char)*s2++;
    8b48:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b4c:	e2832001 	add	r2, r3, #1
    8b50:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8b54:	e5d33000 	ldrb	r3, [r3]
    8b58:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:73
        if (u1 != u2)
    8b5c:	e55b2005 	ldrb	r2, [fp, #-5]
    8b60:	e55b3006 	ldrb	r3, [fp, #-6]
    8b64:	e1520003 	cmp	r2, r3
    8b68:	0a000003 	beq	8b7c <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:74
            return u1 - u2;
    8b6c:	e55b2005 	ldrb	r2, [fp, #-5]
    8b70:	e55b3006 	ldrb	r3, [fp, #-6]
    8b74:	e0423003 	sub	r3, r2, r3
    8b78:	ea000005 	b	8b94 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:75
        if (u1 == '\0')
    8b7c:	e55b3005 	ldrb	r3, [fp, #-5]
    8b80:	e3530000 	cmp	r3, #0
    8b84:	1affffe1 	bne	8b10 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:76
            return 0;
    8b88:	e3a03000 	mov	r3, #0
    8b8c:	ea000000 	b	8b94 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:79
    }

    return 0;
    8b90:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:80
}
    8b94:	e1a00003 	mov	r0, r3
    8b98:	e28bd000 	add	sp, fp, #0
    8b9c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ba0:	e12fff1e 	bx	lr

00008ba4 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8ba4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ba8:	e28db000 	add	fp, sp, #0
    8bac:	e24dd014 	sub	sp, sp, #20
    8bb0:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:84
    int i = 0;
    8bb4:	e3a03000 	mov	r3, #0
    8bb8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86

    while (s[i] != '\0')
    8bbc:	e51b3008 	ldr	r3, [fp, #-8]
    8bc0:	e51b2010 	ldr	r2, [fp, #-16]
    8bc4:	e0823003 	add	r3, r2, r3
    8bc8:	e5d33000 	ldrb	r3, [r3]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	0a000003 	beq	8be4 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:87
        i++;
    8bd4:	e51b3008 	ldr	r3, [fp, #-8]
    8bd8:	e2833001 	add	r3, r3, #1
    8bdc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86
    while (s[i] != '\0')
    8be0:	eafffff5 	b	8bbc <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:89

    return i;
    8be4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:90
}
    8be8:	e1a00003 	mov	r0, r3
    8bec:	e28bd000 	add	sp, fp, #0
    8bf0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf4:	e12fff1e 	bx	lr

00008bf8 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8bf8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bfc:	e28db000 	add	fp, sp, #0
    8c00:	e24dd014 	sub	sp, sp, #20
    8c04:	e50b0010 	str	r0, [fp, #-16]
    8c08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:94
    char* mem = reinterpret_cast<char*>(memory);
    8c0c:	e51b3010 	ldr	r3, [fp, #-16]
    8c10:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96

    for (int i = 0; i < length; i++)
    8c14:	e3a03000 	mov	r3, #0
    8c18:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c1c:	e51b2008 	ldr	r2, [fp, #-8]
    8c20:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c24:	e1520003 	cmp	r2, r3
    8c28:	aa000008 	bge	8c50 <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:97 (discriminator 2)
        mem[i] = 0;
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e51b200c 	ldr	r2, [fp, #-12]
    8c34:	e0823003 	add	r3, r2, r3
    8c38:	e3a02000 	mov	r2, #0
    8c3c:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 2)
    for (int i = 0; i < length; i++)
    8c40:	e51b3008 	ldr	r3, [fp, #-8]
    8c44:	e2833001 	add	r3, r3, #1
    8c48:	e50b3008 	str	r3, [fp, #-8]
    8c4c:	eafffff2 	b	8c1c <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:98
}
    8c50:	e320f000 	nop	{0}
    8c54:	e28bd000 	add	sp, fp, #0
    8c58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c5c:	e12fff1e 	bx	lr

00008c60 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8c60:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c64:	e28db000 	add	fp, sp, #0
    8c68:	e24dd024 	sub	sp, sp, #36	; 0x24
    8c6c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c70:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c74:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:102
    const char* memsrc = reinterpret_cast<const char*>(src);
    8c78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c7c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:103
    char* memdst = reinterpret_cast<char*>(dst);
    8c80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c84:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105

    for (int i = 0; i < num; i++)
    8c88:	e3a03000 	mov	r3, #0
    8c8c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c90:	e51b2008 	ldr	r2, [fp, #-8]
    8c94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c98:	e1520003 	cmp	r2, r3
    8c9c:	aa00000b 	bge	8cd0 <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:106 (discriminator 2)
        memdst[i] = memsrc[i];
    8ca0:	e51b3008 	ldr	r3, [fp, #-8]
    8ca4:	e51b200c 	ldr	r2, [fp, #-12]
    8ca8:	e0822003 	add	r2, r2, r3
    8cac:	e51b3008 	ldr	r3, [fp, #-8]
    8cb0:	e51b1010 	ldr	r1, [fp, #-16]
    8cb4:	e0813003 	add	r3, r1, r3
    8cb8:	e5d22000 	ldrb	r2, [r2]
    8cbc:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 2)
    for (int i = 0; i < num; i++)
    8cc0:	e51b3008 	ldr	r3, [fp, #-8]
    8cc4:	e2833001 	add	r3, r3, #1
    8cc8:	e50b3008 	str	r3, [fp, #-8]
    8ccc:	eaffffef 	b	8c90 <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:107
}
    8cd0:	e320f000 	nop	{0}
    8cd4:	e28bd000 	add	sp, fp, #0
    8cd8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cdc:	e12fff1e 	bx	lr

00008ce0 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8ce0:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8ce4:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8ce8:	3a000074 	bcc	8ec0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8cec:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    8cf0:	9a00006b 	bls	8ea4 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8cf4:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8cf8:	0a00006c 	beq	8eb0 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    8cfc:	e16f3f10 	clz	r3, r0
    8d00:	e16f2f11 	clz	r2, r1
    8d04:	e0423003 	sub	r3, r2, r3
    8d08:	e273301f 	rsbs	r3, r3, #31
    8d0c:	10833083 	addne	r3, r3, r3, lsl #1
    8d10:	e3a02000 	mov	r2, #0
    8d14:	108ff103 	addne	pc, pc, r3, lsl #2
    8d18:	e1a00000 	nop			; (mov r0, r0)
    8d1c:	e1500f81 	cmp	r0, r1, lsl #31
    8d20:	e0a22002 	adc	r2, r2, r2
    8d24:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d28:	e1500f01 	cmp	r0, r1, lsl #30
    8d2c:	e0a22002 	adc	r2, r2, r2
    8d30:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d34:	e1500e81 	cmp	r0, r1, lsl #29
    8d38:	e0a22002 	adc	r2, r2, r2
    8d3c:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d40:	e1500e01 	cmp	r0, r1, lsl #28
    8d44:	e0a22002 	adc	r2, r2, r2
    8d48:	20400e01 	subcs	r0, r0, r1, lsl #28
    8d4c:	e1500d81 	cmp	r0, r1, lsl #27
    8d50:	e0a22002 	adc	r2, r2, r2
    8d54:	20400d81 	subcs	r0, r0, r1, lsl #27
    8d58:	e1500d01 	cmp	r0, r1, lsl #26
    8d5c:	e0a22002 	adc	r2, r2, r2
    8d60:	20400d01 	subcs	r0, r0, r1, lsl #26
    8d64:	e1500c81 	cmp	r0, r1, lsl #25
    8d68:	e0a22002 	adc	r2, r2, r2
    8d6c:	20400c81 	subcs	r0, r0, r1, lsl #25
    8d70:	e1500c01 	cmp	r0, r1, lsl #24
    8d74:	e0a22002 	adc	r2, r2, r2
    8d78:	20400c01 	subcs	r0, r0, r1, lsl #24
    8d7c:	e1500b81 	cmp	r0, r1, lsl #23
    8d80:	e0a22002 	adc	r2, r2, r2
    8d84:	20400b81 	subcs	r0, r0, r1, lsl #23
    8d88:	e1500b01 	cmp	r0, r1, lsl #22
    8d8c:	e0a22002 	adc	r2, r2, r2
    8d90:	20400b01 	subcs	r0, r0, r1, lsl #22
    8d94:	e1500a81 	cmp	r0, r1, lsl #21
    8d98:	e0a22002 	adc	r2, r2, r2
    8d9c:	20400a81 	subcs	r0, r0, r1, lsl #21
    8da0:	e1500a01 	cmp	r0, r1, lsl #20
    8da4:	e0a22002 	adc	r2, r2, r2
    8da8:	20400a01 	subcs	r0, r0, r1, lsl #20
    8dac:	e1500981 	cmp	r0, r1, lsl #19
    8db0:	e0a22002 	adc	r2, r2, r2
    8db4:	20400981 	subcs	r0, r0, r1, lsl #19
    8db8:	e1500901 	cmp	r0, r1, lsl #18
    8dbc:	e0a22002 	adc	r2, r2, r2
    8dc0:	20400901 	subcs	r0, r0, r1, lsl #18
    8dc4:	e1500881 	cmp	r0, r1, lsl #17
    8dc8:	e0a22002 	adc	r2, r2, r2
    8dcc:	20400881 	subcs	r0, r0, r1, lsl #17
    8dd0:	e1500801 	cmp	r0, r1, lsl #16
    8dd4:	e0a22002 	adc	r2, r2, r2
    8dd8:	20400801 	subcs	r0, r0, r1, lsl #16
    8ddc:	e1500781 	cmp	r0, r1, lsl #15
    8de0:	e0a22002 	adc	r2, r2, r2
    8de4:	20400781 	subcs	r0, r0, r1, lsl #15
    8de8:	e1500701 	cmp	r0, r1, lsl #14
    8dec:	e0a22002 	adc	r2, r2, r2
    8df0:	20400701 	subcs	r0, r0, r1, lsl #14
    8df4:	e1500681 	cmp	r0, r1, lsl #13
    8df8:	e0a22002 	adc	r2, r2, r2
    8dfc:	20400681 	subcs	r0, r0, r1, lsl #13
    8e00:	e1500601 	cmp	r0, r1, lsl #12
    8e04:	e0a22002 	adc	r2, r2, r2
    8e08:	20400601 	subcs	r0, r0, r1, lsl #12
    8e0c:	e1500581 	cmp	r0, r1, lsl #11
    8e10:	e0a22002 	adc	r2, r2, r2
    8e14:	20400581 	subcs	r0, r0, r1, lsl #11
    8e18:	e1500501 	cmp	r0, r1, lsl #10
    8e1c:	e0a22002 	adc	r2, r2, r2
    8e20:	20400501 	subcs	r0, r0, r1, lsl #10
    8e24:	e1500481 	cmp	r0, r1, lsl #9
    8e28:	e0a22002 	adc	r2, r2, r2
    8e2c:	20400481 	subcs	r0, r0, r1, lsl #9
    8e30:	e1500401 	cmp	r0, r1, lsl #8
    8e34:	e0a22002 	adc	r2, r2, r2
    8e38:	20400401 	subcs	r0, r0, r1, lsl #8
    8e3c:	e1500381 	cmp	r0, r1, lsl #7
    8e40:	e0a22002 	adc	r2, r2, r2
    8e44:	20400381 	subcs	r0, r0, r1, lsl #7
    8e48:	e1500301 	cmp	r0, r1, lsl #6
    8e4c:	e0a22002 	adc	r2, r2, r2
    8e50:	20400301 	subcs	r0, r0, r1, lsl #6
    8e54:	e1500281 	cmp	r0, r1, lsl #5
    8e58:	e0a22002 	adc	r2, r2, r2
    8e5c:	20400281 	subcs	r0, r0, r1, lsl #5
    8e60:	e1500201 	cmp	r0, r1, lsl #4
    8e64:	e0a22002 	adc	r2, r2, r2
    8e68:	20400201 	subcs	r0, r0, r1, lsl #4
    8e6c:	e1500181 	cmp	r0, r1, lsl #3
    8e70:	e0a22002 	adc	r2, r2, r2
    8e74:	20400181 	subcs	r0, r0, r1, lsl #3
    8e78:	e1500101 	cmp	r0, r1, lsl #2
    8e7c:	e0a22002 	adc	r2, r2, r2
    8e80:	20400101 	subcs	r0, r0, r1, lsl #2
    8e84:	e1500081 	cmp	r0, r1, lsl #1
    8e88:	e0a22002 	adc	r2, r2, r2
    8e8c:	20400081 	subcs	r0, r0, r1, lsl #1
    8e90:	e1500001 	cmp	r0, r1
    8e94:	e0a22002 	adc	r2, r2, r2
    8e98:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8e9c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8ea0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8ea4:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8ea8:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8eac:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8eb0:	e16f2f11 	clz	r2, r1
    8eb4:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8eb8:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8ebc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8ec0:	e3500000 	cmp	r0, #0
    8ec4:	13e00000 	mvnne	r0, #0
    8ec8:	ea000007 	b	8eec <__aeabi_idiv0>

00008ecc <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8ecc:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8ed0:	0afffffa 	beq	8ec0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8ed4:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8ed8:	ebffff80 	bl	8ce0 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8edc:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8ee0:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8ee4:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8ee8:	e12fff1e 	bx	lr

00008eec <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8eec:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008ef0 <_ZL13Lock_Unlocked>:
    8ef0:	00000000 	andeq	r0, r0, r0

00008ef4 <_ZL11Lock_Locked>:
    8ef4:	00000001 	andeq	r0, r0, r1

00008ef8 <_ZL21MaxFSDriverNameLength>:
    8ef8:	00000010 	andeq	r0, r0, r0, lsl r0

00008efc <_ZL17MaxFilenameLength>:
    8efc:	00000010 	andeq	r0, r0, r0, lsl r0

00008f00 <_ZL13MaxPathLength>:
    8f00:	00000080 	andeq	r0, r0, r0, lsl #1

00008f04 <_ZL18NoFilesystemDriver>:
    8f04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f08 <_ZL9NotifyAll>:
    8f08:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f0c <_ZL24Max_Process_Opened_Files>:
    8f0c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f10 <_ZL10Indefinite>:
    8f10:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f14 <_ZL18Deadline_Unchanged>:
    8f14:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f18 <_ZL14Invalid_Handle>:
    8f18:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f1c <_ZN3halL18Default_Clock_RateE>:
    8f1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008f20 <_ZN3halL15Peripheral_BaseE>:
    8f20:	20000000 	andcs	r0, r0, r0

00008f24 <_ZN3halL9GPIO_BaseE>:
    8f24:	20200000 	eorcs	r0, r0, r0

00008f28 <_ZN3halL14GPIO_Pin_CountE>:
    8f28:	00000036 	andeq	r0, r0, r6, lsr r0

00008f2c <_ZN3halL8AUX_BaseE>:
    8f2c:	20215000 	eorcs	r5, r1, r0

00008f30 <_ZN3halL25Interrupt_Controller_BaseE>:
    8f30:	2000b200 	andcs	fp, r0, r0, lsl #4

00008f34 <_ZN3halL10Timer_BaseE>:
    8f34:	2000b400 	andcs	fp, r0, r0, lsl #8

00008f38 <_ZN3halL9TRNG_BaseE>:
    8f38:	20104000 	andscs	r4, r0, r0

00008f3c <_ZN3halL9BSC0_BaseE>:
    8f3c:	20205000 	eorcs	r5, r0, r0

00008f40 <_ZN3halL9BSC1_BaseE>:
    8f40:	20804000 	addcs	r4, r0, r0

00008f44 <_ZN3halL9BSC2_BaseE>:
    8f44:	20805000 	addcs	r5, r0, r0

00008f48 <_ZL11Invalid_Pin>:
    8f48:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8f4c:	3a564544 	bcc	159a464 <__bss_end+0x1591498>
    8f50:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    8f54:	00000000 	andeq	r0, r0, r0
    8f58:	3a564544 	bcc	159a470 <__bss_end+0x15914a4>
    8f5c:	6f697067 	svcvs	0x00697067
    8f60:	0000342f 	andeq	r3, r0, pc, lsr #8
    8f64:	3a564544 	bcc	159a47c <__bss_end+0x15914b0>
    8f68:	6f697067 	svcvs	0x00697067
    8f6c:	0037312f 	eorseq	r3, r7, pc, lsr #2

00008f70 <_ZL13Lock_Unlocked>:
    8f70:	00000000 	andeq	r0, r0, r0

00008f74 <_ZL11Lock_Locked>:
    8f74:	00000001 	andeq	r0, r0, r1

00008f78 <_ZL21MaxFSDriverNameLength>:
    8f78:	00000010 	andeq	r0, r0, r0, lsl r0

00008f7c <_ZL17MaxFilenameLength>:
    8f7c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f80 <_ZL13MaxPathLength>:
    8f80:	00000080 	andeq	r0, r0, r0, lsl #1

00008f84 <_ZL18NoFilesystemDriver>:
    8f84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f88 <_ZL9NotifyAll>:
    8f88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f8c <_ZL24Max_Process_Opened_Files>:
    8f8c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f90 <_ZL10Indefinite>:
    8f90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f94 <_ZL18Deadline_Unchanged>:
    8f94:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f98 <_ZL14Invalid_Handle>:
    8f98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f9c <_ZL16Pipe_File_Prefix>:
    8f9c:	3a535953 	bcc	14df4f0 <__bss_end+0x14d6524>
    8fa0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8fa4:	0000002f 	andeq	r0, r0, pc, lsr #32

00008fa8 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8fa8:	33323130 	teqcc	r2, #48, 2
    8fac:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8fb0:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8fb4:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008fbc <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684860>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39458>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d06c>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7d58>
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
  34:	5a2f7374 	bpl	bdce0c <__bss_end+0xbd3e40>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <__bss_end+0xffff6ee0>
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
 124:	fb010200 	blx	4092e <__bss_end+0x37962>
 128:	01000d0e 	tsteq	r0, lr, lsl #26
 12c:	00010101 	andeq	r0, r1, r1, lsl #2
 130:	00010000 	andeq	r0, r1, r0
 134:	6d2f0100 	stfvss	f0, [pc, #-0]	; 13c <shift+0x13c>
 138:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 13c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 140:	4b2f7372 	blmi	bdcf10 <__bss_end+0xbd3f44>
 144:	2f616275 	svccs	0x00616275
 148:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 14c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 150:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 154:	614d6f72 	hvcvs	55026	; 0xd6f2
 158:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbec <__bss_end+0xffff6c20>
 15c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 160:	2f73656c 	svccs	0x0073656c
 164:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 168:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb0c <__bss_end+0xffff6b40>
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
 1cc:	4a030402 	bmi	c11dc <__bss_end+0xb8210>
 1d0:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 1d4:	05830204 	streq	r0, [r3, #516]	; 0x204
 1d8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 1dc:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 1e0:	02040200 	andeq	r0, r4, #0, 4
 1e4:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 1e8:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 1ec:	056a1005 	strbeq	r1, [sl, #-5]!
 1f0:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 1f4:	0a054a03 	beq	152a08 <__bss_end+0x149a3c>
 1f8:	02040200 	andeq	r0, r4, #0, 4
 1fc:	00110583 	andseq	r0, r1, r3, lsl #11
 200:	4a020402 	bmi	81210 <__bss_end+0x78244>
 204:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 208:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 20c:	0105850c 	tsteq	r5, ip, lsl #10
 210:	000a022f 	andeq	r0, sl, pc, lsr #4
 214:	02ca0101 	sbceq	r0, sl, #1073741824	; 0x40000000
 218:	00030000 	andeq	r0, r3, r0
 21c:	00000241 	andeq	r0, r0, r1, asr #4
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
 270:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
 274:	5f726574 	svcpl	0x00726574
 278:	6b736174 	blvs	1cd8850 <__bss_end+0x1ccf884>
 27c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 280:	2f632f74 	svccs	0x00632f74
 284:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 288:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 28c:	442f6162 	strtmi	r6, [pc], #-354	; 294 <shift+0x294>
 290:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 294:	73746e65 	cmnvc	r4, #1616	; 0x650
 298:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 29c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 2a0:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 2a4:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 2a8:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 2ac:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 2b0:	73752f66 	cmnvc	r5, #408	; 0x198
 2b4:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2b8:	2f656361 	svccs	0x00656361
 2bc:	6b2f2e2e 	blvs	bcbb7c <__bss_end+0xbc2bb0>
 2c0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2c4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 2c8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2cc:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 2d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 2d4:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 110 <shift+0x110>
 2d8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 2dc:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 2e0:	4b2f7372 	blmi	bdd0b0 <__bss_end+0xbd40e4>
 2e4:	2f616275 	svccs	0x00616275
 2e8:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 2ec:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 2f0:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 2f4:	614d6f72 	hvcvs	55026	; 0xd6f2
 2f8:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd8c <__bss_end+0xffff6dc0>
 2fc:	706d6178 	rsbvc	r6, sp, r8, ror r1
 300:	2f73656c 	svccs	0x0073656c
 304:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 308:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffcac <__bss_end+0xffff6ce0>
 30c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 310:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 314:	2f2e2e2f 	svccs	0x002e2e2f
 318:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 31c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 320:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 324:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 328:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 164 <shift+0x164>
 32c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 330:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 334:	4b2f7372 	blmi	bdd104 <__bss_end+0xbd4138>
 338:	2f616275 	svccs	0x00616275
 33c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 340:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 344:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 348:	614d6f72 	hvcvs	55026	; 0xd6f2
 34c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffde0 <__bss_end+0xffff6e14>
 350:	706d6178 	rsbvc	r6, sp, r8, ror r1
 354:	2f73656c 	svccs	0x0073656c
 358:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 35c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffd00 <__bss_end+0xffff6d34>
 360:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 364:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 368:	2f2e2e2f 	svccs	0x002e2e2f
 36c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 370:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 374:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 378:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 37c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 380:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 384:	61682f30 	cmnvs	r8, r0, lsr pc
 388:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; 1e0 <shift+0x1e0>
 38c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 390:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 394:	4b2f7372 	blmi	bdd164 <__bss_end+0xbd4198>
 398:	2f616275 	svccs	0x00616275
 39c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 3a0:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 3a4:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 3a8:	614d6f72 	hvcvs	55026	; 0xd6f2
 3ac:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffe40 <__bss_end+0xffff6e74>
 3b0:	706d6178 	rsbvc	r6, sp, r8, ror r1
 3b4:	2f73656c 	svccs	0x0073656c
 3b8:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 3bc:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffd60 <__bss_end+0xffff6d94>
 3c0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 3c4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 3c8:	2f2e2e2f 	svccs	0x002e2e2f
 3cc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 3d0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 3d4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 3d8:	642f6564 	strtvs	r6, [pc], #-1380	; 3e0 <shift+0x3e0>
 3dc:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 3e0:	00007372 	andeq	r7, r0, r2, ror r3
 3e4:	6e69616d 	powvsez	f6, f1, #5.0
 3e8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 3ec:	00000100 	andeq	r0, r0, r0, lsl #2
 3f0:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 3f4:	00020068 	andeq	r0, r2, r8, rrx
 3f8:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 3fc:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 400:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 404:	66000002 	strvs	r0, [r0], -r2
 408:	73656c69 	cmnvc	r5, #26880	; 0x6900
 40c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 410:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 414:	70000003 	andvc	r0, r0, r3
 418:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 41c:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 420:	00000200 	andeq	r0, r0, r0, lsl #4
 424:	636f7270 	cmnvs	pc, #112, 4
 428:	5f737365 	svcpl	0x00737365
 42c:	616e616d 	cmnvs	lr, sp, ror #2
 430:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 434:	00020068 	andeq	r0, r2, r8, rrx
 438:	72657000 	rsbvc	r7, r5, #0
 43c:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 440:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 444:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 448:	70670000 	rsbvc	r0, r7, r0
 44c:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 450:	00000500 	andeq	r0, r0, r0, lsl #10
 454:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 458:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 45c:	00000400 	andeq	r0, r0, r0, lsl #8
 460:	00010500 	andeq	r0, r1, r0, lsl #10
 464:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 468:	10030000 	andne	r0, r3, r0
 46c:	9f210501 	svcls	0x00210501
 470:	12058383 	andne	r8, r5, #201326594	; 0xc000002
 474:	4b0a0584 	blmi	281a8c <__bss_end+0x278ac0>
 478:	4c16054b 	cfldr32mi	mvfx0, [r6], {75}	; 0x4b
 47c:	01040200 	mrseq	r0, R12_usr
 480:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 484:	004a0204 	subeq	r0, sl, r4, lsl #4
 488:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 48c:	4e060e05 	cdpmi	14, 0, cr0, cr6, cr5, {0}
 490:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
 494:	13059f1a 	movwne	r9, #24346	; 0x5f1a
 498:	840d052e 	strhi	r0, [sp], #-1326	; 0xfffffad2
 49c:	059f1505 	ldreq	r1, [pc, #1285]	; 9a9 <shift+0x9a9>
 4a0:	09052e0e 	stmdbeq	r5, {r1, r2, r3, r9, sl, fp, sp}
 4a4:	67140584 	ldrvs	r0, [r4, -r4, lsl #11]
 4a8:	681e0584 	ldmdavs	lr, {r2, r7, r8, sl}
 4ac:	20081305 	andcs	r1, r8, r5, lsl #6
 4b0:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 4b4:	67a02f0e 	strvs	r2, [r0, lr, lsl #30]!
 4b8:	01040200 	mrseq	r0, R12_usr
 4bc:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 4c0:	004a0204 	subeq	r0, sl, r4, lsl #4
 4c4:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 4c8:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 4cc:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 4d0:	02004a06 	andeq	r4, r0, #24576	; 0x6000
 4d4:	052e0804 	streq	r0, [lr, #-2052]!	; 0xfffff7fc
 4d8:	04020005 	streq	r0, [r2], #-5
 4dc:	02670608 	rsbeq	r0, r7, #8, 12	; 0x800000
 4e0:	0101000a 	tsteq	r1, sl
 4e4:	00000288 	andeq	r0, r0, r8, lsl #5
 4e8:	019d0003 	orrseq	r0, sp, r3
 4ec:	01020000 	mrseq	r0, (UNDEF: 2)
 4f0:	000d0efb 	strdeq	r0, [sp], -fp
 4f4:	01010101 	tsteq	r1, r1, lsl #2
 4f8:	01000000 	mrseq	r0, (UNDEF: 0)
 4fc:	2f010000 	svccs	0x00010000
 500:	2f746e6d 	svccs	0x00746e6d
 504:	73552f63 	cmpvc	r5, #396	; 0x18c
 508:	2f737265 	svccs	0x00737265
 50c:	6162754b 	cmnvs	r2, fp, asr #10
 510:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 514:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 518:	5a2f7374 	bpl	bdd2f0 <__bss_end+0xbd4324>
 51c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 390 <shift+0x390>
 520:	2f657461 	svccs	0x00657461
 524:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 528:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 52c:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 530:	2f666465 	svccs	0x00666465
 534:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 538:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 53c:	2f006372 	svccs	0x00006372
 540:	2f746e6d 	svccs	0x00746e6d
 544:	73552f63 	cmpvc	r5, #396	; 0x18c
 548:	2f737265 	svccs	0x00737265
 54c:	6162754b 	cmnvs	r2, fp, asr #10
 550:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 554:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 558:	5a2f7374 	bpl	bdd330 <__bss_end+0xbd4364>
 55c:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 3d0 <shift+0x3d0>
 560:	2f657461 	svccs	0x00657461
 564:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 568:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 56c:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 570:	2f666465 	svccs	0x00666465
 574:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 578:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 57c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 580:	702f6564 	eorvc	r6, pc, r4, ror #10
 584:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 588:	2f007373 	svccs	0x00007373
 58c:	2f746e6d 	svccs	0x00746e6d
 590:	73552f63 	cmpvc	r5, #396	; 0x18c
 594:	2f737265 	svccs	0x00737265
 598:	6162754b 	cmnvs	r2, fp, asr #10
 59c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 5a0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 5a4:	5a2f7374 	bpl	bdd37c <__bss_end+0xbd43b0>
 5a8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 41c <shift+0x41c>
 5ac:	2f657461 	svccs	0x00657461
 5b0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 5b4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 5b8:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 5bc:	2f666465 	svccs	0x00666465
 5c0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5c4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 5c8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 5cc:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 5d0:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 40c <shift+0x40c>
 5d4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 5d8:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 5dc:	4b2f7372 	blmi	bdd3ac <__bss_end+0xbd43e0>
 5e0:	2f616275 	svccs	0x00616275
 5e4:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 5e8:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 5ec:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 5f0:	614d6f72 	hvcvs	55026	; 0xd6f2
 5f4:	652f6574 	strvs	r6, [pc, #-1396]!	; 88 <shift+0x88>
 5f8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 5fc:	2f73656c 	svccs	0x0073656c
 600:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 604:	6b2f6664 	blvs	bd9f9c <__bss_end+0xbd0fd0>
 608:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 60c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 610:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 614:	6f622f65 	svcvs	0x00622f65
 618:	2f647261 	svccs	0x00647261
 61c:	30697072 	rsbcc	r7, r9, r2, ror r0
 620:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 624:	74730000 	ldrbtvc	r0, [r3], #-0
 628:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 62c:	70632e65 	rsbvc	r2, r3, r5, ror #28
 630:	00010070 	andeq	r0, r1, r0, ror r0
 634:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 638:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 63c:	70730000 	rsbsvc	r0, r3, r0
 640:	6f6c6e69 	svcvs	0x006c6e69
 644:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 648:	00000200 	andeq	r0, r0, r0, lsl #4
 64c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 650:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 654:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 658:	00000300 	andeq	r0, r0, r0, lsl #6
 65c:	636f7270 	cmnvs	pc, #112, 4
 660:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 664:	00020068 	andeq	r0, r2, r8, rrx
 668:	6f727000 	svcvs	0x00727000
 66c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 670:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 674:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 678:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 67c:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 680:	66656474 			; <UNDEFINED> instruction: 0x66656474
 684:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 688:	05000000 	streq	r0, [r0, #-0]
 68c:	02050001 	andeq	r0, r5, #1
 690:	000083cc 	andeq	r8, r0, ip, asr #7
 694:	69050516 	stmdbvs	r5, {r1, r2, r4, r8, sl}
 698:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 69c:	852f0105 	strhi	r0, [pc, #-261]!	; 59f <shift+0x59f>
 6a0:	4b830505 	blmi	fe0c1abc <__bss_end+0xfe0b8af0>
 6a4:	852f0105 	strhi	r0, [pc, #-261]!	; 5a7 <shift+0x5a7>
 6a8:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
 6ac:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6b0:	4b4ba105 	blmi	12e8acc <__bss_end+0x12dfb00>
 6b4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6b8:	852f0105 	strhi	r0, [pc, #-261]!	; 5bb <shift+0x5bb>
 6bc:	4bbd0505 	blmi	fef41ad8 <__bss_end+0xfef38b0c>
 6c0:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffb7d <__bss_end+0xffff6bb1>
 6c4:	01054c0c 	tsteq	r5, ip, lsl #24
 6c8:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 6cc:	4b4b4bbd 	blmi	12d35c8 <__bss_end+0x12ca5fc>
 6d0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6d4:	852f0105 	strhi	r0, [pc, #-261]!	; 5d7 <shift+0x5d7>
 6d8:	4b830505 	blmi	fe0c1af4 <__bss_end+0xfe0b8b28>
 6dc:	852f0105 	strhi	r0, [pc, #-261]!	; 5df <shift+0x5df>
 6e0:	4bbd0505 	blmi	fef41afc <__bss_end+0xfef38b30>
 6e4:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffba1 <__bss_end+0xffff6bd5>
 6e8:	01054c0c 	tsteq	r5, ip, lsl #24
 6ec:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 6f0:	2f4b4ba1 	svccs	0x004b4ba1
 6f4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6f8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6fc:	4b4bbd05 	blmi	12efb18 <__bss_end+0x12e6b4c>
 700:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 704:	2f01054c 	svccs	0x0001054c
 708:	a1050585 	smlabbge	r5, r5, r5, r0
 70c:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffbc9 <__bss_end+0xffff6bfd>
 710:	01054c0c 	tsteq	r5, ip, lsl #24
 714:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
 718:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
 71c:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
 720:	2f010530 	svccs	0x00010530
 724:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 728:	4b4d0505 	blmi	1341b44 <__bss_end+0x1338b78>
 72c:	300c054b 	andcc	r0, ip, fp, asr #10
 730:	852f0105 	strhi	r0, [pc, #-261]!	; 633 <shift+0x633>
 734:	05832005 	streq	r2, [r3, #5]
 738:	4b4b4c05 	blmi	12d3754 <__bss_end+0x12ca788>
 73c:	852f0105 	strhi	r0, [pc, #-261]!	; 63f <shift+0x63f>
 740:	05672005 	strbeq	r2, [r7, #-5]!
 744:	4b4b4d05 	blmi	12d3b60 <__bss_end+0x12cab94>
 748:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 74c:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
 750:	059fa00c 	ldreq	sl, [pc, #12]	; 764 <shift+0x764>
 754:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
 758:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
 75c:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
 760:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
 764:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
 768:	029f0105 	addseq	r0, pc, #1073741825	; 0x40000001
 76c:	01010008 	tsteq	r1, r8
 770:	00000287 	andeq	r0, r0, r7, lsl #5
 774:	00640003 	rsbeq	r0, r4, r3
 778:	01020000 	mrseq	r0, (UNDEF: 2)
 77c:	000d0efb 	strdeq	r0, [sp], -fp
 780:	01010101 	tsteq	r1, r1, lsl #2
 784:	01000000 	mrseq	r0, (UNDEF: 0)
 788:	2f010000 	svccs	0x00010000
 78c:	2f746e6d 	svccs	0x00746e6d
 790:	73552f63 	cmpvc	r5, #396	; 0x18c
 794:	2f737265 	svccs	0x00737265
 798:	6162754b 	cmnvs	r2, fp, asr #10
 79c:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 7a0:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 7a4:	5a2f7374 	bpl	bdd57c <__bss_end+0xbd45b0>
 7a8:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 61c <shift+0x61c>
 7ac:	2f657461 	svccs	0x00657461
 7b0:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 7b4:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 7b8:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 7bc:	2f666465 	svccs	0x00666465
 7c0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 7c4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 7c8:	00006372 	andeq	r6, r0, r2, ror r3
 7cc:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 7d0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 7d4:	70632e67 	rsbvc	r2, r3, r7, ror #28
 7d8:	00010070 	andeq	r0, r1, r0, ror r0
 7dc:	01050000 	mrseq	r0, (UNDEF: 5)
 7e0:	28020500 	stmdacs	r2, {r8, sl}
 7e4:	1a000088 	bne	a0c <shift+0xa0c>
 7e8:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
 7ec:	27054c12 	smladcs	r5, r2, ip, r4
 7f0:	ba100568 	blt	401d98 <__bss_end+0x3f8dcc>
 7f4:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 7f8:	13054a2d 	movwne	r4, #23085	; 0x5a2d
 7fc:	2f0f054a 	svccs	0x000f054a
 800:	059f0a05 	ldreq	r0, [pc, #2565]	; 120d <shift+0x120d>
 804:	05356205 	ldreq	r6, [r5, #-517]!	; 0xfffffdfb
 808:	11056810 	tstne	r5, r0, lsl r8
 80c:	4a22052e 	bmi	881ccc <__bss_end+0x878d00>
 810:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 814:	0c052f0a 	stceq	15, cr2, [r5], {10}
 818:	2e0d0569 	cfsh32cs	mvfx0, mvfx13, #57
 81c:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
 820:	0e054b06 	vmlaeq.f64	d4, d5, d6
 824:	001c0568 	andseq	r0, ip, r8, ror #10
 828:	4a030402 	bmi	c1838 <__bss_end+0xb886c>
 82c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 830:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 834:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 838:	1e056802 	cdpne	8, 0, cr6, cr5, cr2, {0}
 83c:	02040200 	andeq	r0, r4, #0, 4
 840:	000e0582 	andeq	r0, lr, r2, lsl #11
 844:	4a020402 	bmi	81854 <__bss_end+0x78888>
 848:	02002005 	andeq	r2, r0, #5
 84c:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 850:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 854:	12052e02 	andne	r2, r5, #2, 28
 858:	02040200 	andeq	r0, r4, #0, 4
 85c:	0015054a 	andseq	r0, r5, sl, asr #10
 860:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 864:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
 868:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 86c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 870:	10052e02 	andne	r2, r5, r2, lsl #28
 874:	02040200 	andeq	r0, r4, #0, 4
 878:	0011052f 	andseq	r0, r1, pc, lsr #10
 87c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 880:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 884:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 888:	04020005 	streq	r0, [r2], #-5
 88c:	01054602 	tsteq	r5, r2, lsl #12
 890:	09058588 	stmdbeq	r5, {r3, r7, r8, sl, pc}
 894:	4c0c0583 	cfstr32mi	mvfx0, [ip], {131}	; 0x83
 898:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
 89c:	0d054c10 	stceq	12, cr4, [r5, #-64]	; 0xffffffc0
 8a0:	4a0905bb 	bmi	241f94 <__bss_end+0x238fc8>
 8a4:	02001d05 	andeq	r1, r0, #320	; 0x140
 8a8:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 8ac:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 8b0:	13054a01 	movwne	r4, #23041	; 0x5a01
 8b4:	4a1a054d 	bmi	681df0 <__bss_end+0x678e24>
 8b8:	052e1005 	streq	r1, [lr, #-5]!
 8bc:	0505680e 	streq	r6, [r5, #-2062]	; 0xfffff7f2
 8c0:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 8c4:	2e0b030c 	cdpcs	3, 0, cr0, cr11, cr12, {0}
 8c8:	852f0105 	strhi	r0, [pc, #-261]!	; 7cb <shift+0x7cb>
 8cc:	05bd0c05 	ldreq	r0, [sp, #3077]!	; 0xc05
 8d0:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 8d4:	20054a04 	andcs	r4, r5, r4, lsl #20
 8d8:	02040200 	andeq	r0, r4, #0, 4
 8dc:	00210582 	eoreq	r0, r1, r2, lsl #11
 8e0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8e4:	02001905 	andeq	r1, r0, #81920	; 0x14000
 8e8:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 8ec:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8f0:	18054b03 	stmdane	r5, {r0, r1, r8, r9, fp, lr}
 8f4:	03040200 	movweq	r0, #16896	; 0x4200
 8f8:	000e052e 	andeq	r0, lr, lr, lsr #10
 8fc:	4a030402 	bmi	c190c <__bss_end+0xb8940>
 900:	02000f05 	andeq	r0, r0, #5, 30
 904:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 908:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 90c:	11054a03 	tstne	r5, r3, lsl #20
 910:	03040200 	movweq	r0, #16896	; 0x4200
 914:	0005052e 	andeq	r0, r5, lr, lsr #10
 918:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 91c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 920:	00840204 	addeq	r0, r4, r4, lsl #4
 924:	83010402 	movwhi	r0, #5122	; 0x1402
 928:	02000f05 	andeq	r0, r0, #5, 30
 92c:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
 930:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 934:	05054a01 	streq	r4, [r5, #-2561]	; 0xfffff5ff
 938:	01040200 	mrseq	r0, R12_usr
 93c:	850c0549 	strhi	r0, [ip, #-1353]	; 0xfffffab7
 940:	852f0105 	strhi	r0, [pc, #-261]!	; 843 <shift+0x843>
 944:	05bc0f05 	ldreq	r0, [ip, #3845]!	; 0xf05
 948:	20056612 	andcs	r6, r5, r2, lsl r6
 94c:	660c05bc 			; <UNDEFINED> instruction: 0x660c05bc
 950:	054b2005 	strbeq	r2, [fp, #-5]
 954:	0905660c 	stmdbeq	r5, {r2, r3, r9, sl, sp, lr}
 958:	8314054b 	tsthi	r4, #314572800	; 0x12c00000
 95c:	052e1905 	streq	r1, [lr, #-2309]!	; 0xfffff6fb
 960:	14056709 	strne	r6, [r5], #-1801	; 0xfffff8f7
 964:	4d0c0567 	cfstr32mi	mvfx0, [ip, #-412]	; 0xfffffe64
 968:	852f0105 	strhi	r0, [pc, #-261]!	; 86b <shift+0x86b>
 96c:	05830905 	streq	r0, [r3, #2309]	; 0x905
 970:	0f054c0e 	svceq	0x00054c0e
 974:	6611052e 	ldrvs	r0, [r1], -lr, lsr #10
 978:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
 97c:	0c056505 	cfstr32eq	mvfx6, [r5], {5}
 980:	2f010531 	svccs	0x00010531
 984:	9f0b0585 	svcls	0x000b0585
 988:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 98c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 990:	0d054a03 	vstreq	s8, [r5, #-12]
 994:	02040200 	andeq	r0, r4, #0, 4
 998:	000e0583 	andeq	r0, lr, r3, lsl #11
 99c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9a0:	02001005 	andeq	r1, r0, #5
 9a4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 9a8:	04020005 	streq	r0, [r2], #-5
 9ac:	01054902 	tsteq	r5, r2, lsl #18
 9b0:	11058584 	smlabbne	r5, r4, r5, r8
 9b4:	4b0b05bb 	blmi	2c20a8 <__bss_end+0x2b90dc>
 9b8:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
 9bc:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 9c0:	1c054a03 			; <UNDEFINED> instruction: 0x1c054a03
 9c4:	02040200 	andeq	r0, r4, #0, 4
 9c8:	001d0583 	andseq	r0, sp, r3, lsl #11
 9cc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9d0:	02001005 	andeq	r1, r0, #5
 9d4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 9d8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 9dc:	1d052e02 	stcne	14, cr2, [r5, #-8]
 9e0:	02040200 	andeq	r0, r4, #0, 4
 9e4:	0013054a 	andseq	r0, r3, sl, asr #10
 9e8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9ec:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 9f0:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 9f4:	08028401 	stmdaeq	r2, {r0, sl, pc}
 9f8:	79010100 	stmdbvc	r1, {r8}
 9fc:	03000000 	movweq	r0, #0
 a00:	00004600 	andeq	r4, r0, r0, lsl #12
 a04:	fb010200 	blx	4120e <__bss_end+0x38242>
 a08:	01000d0e 	tsteq	r0, lr, lsl #26
 a0c:	00010101 	andeq	r0, r1, r1, lsl #2
 a10:	00010000 	andeq	r0, r1, r0
 a14:	2e2e0100 	sufcse	f0, f6, f0
 a18:	2f2e2e2f 	svccs	0x002e2e2f
 a1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a24:	2f2e2e2f 	svccs	0x002e2e2f
 a28:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a2c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 a30:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 a34:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 a38:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 a3c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 a40:	73636e75 	cmnvc	r3, #1872	; 0x750
 a44:	0100532e 	tsteq	r0, lr, lsr #6
 a48:	00000000 	andeq	r0, r0, r0
 a4c:	8ce00205 	sfmhi	f0, 2, [r0], #20
 a50:	cf030000 	svcgt	0x00030000
 a54:	2f300108 	svccs	0x00300108
 a58:	2f2f2f2f 	svccs	0x002f2f2f
 a5c:	01d00230 	bicseq	r0, r0, r0, lsr r2
 a60:	2f312f14 	svccs	0x00312f14
 a64:	2f4c302f 	svccs	0x004c302f
 a68:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
 a6c:	2f2f2f2f 	svccs	0x002f2f2f
 a70:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
 a74:	01010002 	tsteq	r1, r2
 a78:	0000005c 	andeq	r0, r0, ip, asr r0
 a7c:	00460003 	subeq	r0, r6, r3
 a80:	01020000 	mrseq	r0, (UNDEF: 2)
 a84:	000d0efb 	strdeq	r0, [sp], -fp
 a88:	01010101 	tsteq	r1, r1, lsl #2
 a8c:	01000000 	mrseq	r0, (UNDEF: 0)
 a90:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 a94:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a98:	2f2e2e2f 	svccs	0x002e2e2f
 a9c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aa0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 aa4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 aa8:	2f636367 	svccs	0x00636367
 aac:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 ab0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 ab4:	00006d72 	andeq	r6, r0, r2, ror sp
 ab8:	3162696c 	cmncc	r2, ip, ror #18
 abc:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 ac0:	00532e73 	subseq	r2, r3, r3, ror lr
 ac4:	00000001 	andeq	r0, r0, r1
 ac8:	ec020500 	cfstr32	mvfx0, [r2], {-0}
 acc:	0300008e 	movweq	r0, #142	; 0x8e
 ad0:	02010bb9 	andeq	r0, r1, #189440	; 0x2e400
 ad4:	01010002 	tsteq	r1, r2
 ad8:	000000a4 	andeq	r0, r0, r4, lsr #1
 adc:	009e0003 	addseq	r0, lr, r3
 ae0:	01020000 	mrseq	r0, (UNDEF: 2)
 ae4:	000d0efb 	strdeq	r0, [sp], -fp
 ae8:	01010101 	tsteq	r1, r1, lsl #2
 aec:	01000000 	mrseq	r0, (UNDEF: 0)
 af0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 af4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 af8:	2f2e2e2f 	svccs	0x002e2e2f
 afc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b00:	2f2e2f2e 	svccs	0x002e2f2e
 b04:	00636367 	rsbeq	r6, r3, r7, ror #6
 b08:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b0c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b10:	2f2e2e2f 	svccs	0x002e2e2f
 b14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b18:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 b1c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b20:	2f2e2e2f 	svccs	0x002e2e2f
 b24:	2f636367 	svccs	0x00636367
 b28:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 b2c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 b30:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 b34:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b38:	2f2e2e2f 	svccs	0x002e2e2f
 b3c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b40:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b44:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 b48:	00636367 	rsbeq	r6, r3, r7, ror #6
 b4c:	6d726100 	ldfvse	f6, [r2, #-0]
 b50:	6173692d 	cmnvs	r3, sp, lsr #18
 b54:	0100682e 	tsteq	r0, lr, lsr #16
 b58:	72610000 	rsbvc	r0, r1, #0
 b5c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 b60:	67000002 	strvs	r0, [r0, -r2]
 b64:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 b68:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 b6c:	0300682e 	movweq	r6, #2094	; 0x82e
 b70:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 b74:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b78:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 b7c:	00000003 	andeq	r0, r0, r3

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
      34:	3a0c0000 	bcc	30003c <__bss_end+0x2f7070>
      38:	46000001 	strmi	r0, [r0], -r1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	76000000 	strvc	r0, [r0], -r0
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a1 	andeq	r0, r0, r1, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	14c70704 	strbne	r0, [r7], #1796	; 0x704
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x370ec>
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
     11c:	14c70704 	strbne	r0, [r7], #1796	; 0x704
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
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f75b4>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ee 	andeq	r0, r0, lr, ror #3
     184:	d20f4901 	andle	r4, pc, #16384	; 0x4000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x1440c>
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
     254:	cb140a01 	blgt	502a60 <__bss_end+0x4f9a94>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37494>
     2c0:	00019e31 	andeq	r9, r1, r1, lsr lr
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	07f30000 	ldrbeq	r0, [r3, r0]!
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02d40104 	sbcseq	r0, r4, #4, 2
     2d8:	27040000 	strcs	r0, [r4, -r0]
     2dc:	46000009 	strmi	r0, [r0], -r9
     2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
     2e4:	a0000082 	andge	r0, r0, r2, lsl #1
     2e8:	16000001 	strne	r0, [r0], -r1
     2ec:	02000002 	andeq	r0, r0, #2
     2f0:	08e30801 	stmiaeq	r3!, {r0, fp}^
     2f4:	02020000 	andeq	r0, r2, #0
     2f8:	00091d05 	andeq	r1, r9, r5, lsl #26
     2fc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     300:	00746e69 	rsbseq	r6, r4, r9, ror #28
     304:	da080102 	ble	200714 <__bss_end+0x1f7748>
     308:	02000008 	andeq	r0, r0, #8
     30c:	07400702 	strbeq	r0, [r0, -r2, lsl #14]
     310:	a0040000 	andge	r0, r4, r0
     314:	09000009 	stmdbeq	r0, {r0, r3}
     318:	00590709 	subseq	r0, r9, r9, lsl #14
     31c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     320:	02000000 	andeq	r0, r0, #0
     324:	14c70704 	strbne	r0, [r7], #1796	; 0x704
     328:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     32c:	06000000 	streq	r0, [r0], -r0
     330:	000005dd 	ldrdeq	r0, [r0], -sp
     334:	08060208 	stmdaeq	r6, {r3, r9}
     338:	0000008b 	andeq	r0, r0, fp, lsl #1
     33c:	00307207 	eorseq	r7, r0, r7, lsl #4
     340:	480e0802 	stmdami	lr, {r1, fp}
     344:	00000000 	andeq	r0, r0, r0
     348:	00317207 	eorseq	r7, r1, r7, lsl #4
     34c:	480e0902 	stmdami	lr, {r1, r8, fp}
     350:	04000000 	streq	r0, [r0], #-0
     354:	04b80800 	ldrteq	r0, [r8], #2048	; 0x800
     358:	04050000 	streq	r0, [r5], #-0
     35c:	00000033 	andeq	r0, r0, r3, lsr r0
     360:	c20c1e02 	andgt	r1, ip, #2, 28
     364:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     368:	00000644 	andeq	r0, r0, r4, asr #12
     36c:	0bb10900 	bleq	fec42774 <__bss_end+0xfec397a8>
     370:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     374:	00000b91 	muleq	r0, r1, fp
     378:	07730902 	ldrbeq	r0, [r3, -r2, lsl #18]!
     37c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     380:	00000869 	andeq	r0, r0, r9, ror #16
     384:	060d0904 	streq	r0, [sp], -r4, lsl #18
     388:	00050000 	andeq	r0, r5, r0
     38c:	000b3108 	andeq	r3, fp, r8, lsl #2
     390:	33040500 	movwcc	r0, #17664	; 0x4500
     394:	02000000 	andeq	r0, r0, #0
     398:	00ff0c40 	rscseq	r0, pc, r0, asr #24
     39c:	c3090000 	movwgt	r0, #36864	; 0x9000
     3a0:	00000003 	andeq	r0, r0, r3
     3a4:	0004cd09 	andeq	ip, r4, r9, lsl #26
     3a8:	5c090100 	stfpls	f0, [r9], {-0}
     3ac:	02000008 	andeq	r0, r0, #8
     3b0:	000b6e09 	andeq	r6, fp, r9, lsl #28
     3b4:	bb090300 	bllt	240fbc <__bss_end+0x237ff0>
     3b8:	0400000b 	streq	r0, [r0], #-11
     3bc:	00082309 	andeq	r2, r8, r9, lsl #6
     3c0:	60090500 	andvs	r0, r9, r0, lsl #10
     3c4:	06000007 	streq	r0, [r0], -r7
     3c8:	083d0a00 	ldmdaeq	sp!, {r9, fp}
     3cc:	05030000 	streq	r0, [r3, #-0]
     3d0:	00005414 	andeq	r5, r0, r4, lsl r4
     3d4:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
     3d8:	0a00008e 	beq	618 <shift+0x618>
     3dc:	0000084b 	andeq	r0, r0, fp, asr #16
     3e0:	54140603 	ldrpl	r0, [r4], #-1539	; 0xfffff9fd
     3e4:	05000000 	streq	r0, [r0, #-0]
     3e8:	008ef403 	addeq	pc, lr, r3, lsl #8
     3ec:	080d0a00 	stmdaeq	sp, {r9, fp}
     3f0:	07040000 	streq	r0, [r4, -r0]
     3f4:	0000541a 	andeq	r5, r0, sl, lsl r4
     3f8:	f8030500 			; <UNDEFINED> instruction: 0xf8030500
     3fc:	0a00008e 	beq	63c <shift+0x63c>
     400:	000004fc 	strdeq	r0, [r0], -ip
     404:	541a0904 	ldrpl	r0, [sl], #-2308	; 0xfffff6fc
     408:	05000000 	streq	r0, [r0, #-0]
     40c:	008efc03 	addeq	pc, lr, r3, lsl #24
     410:	08cc0a00 	stmiaeq	ip, {r9, fp}^
     414:	0b040000 	bleq	10041c <__bss_end+0xf7450>
     418:	0000541a 	andeq	r5, r0, sl, lsl r4
     41c:	00030500 	andeq	r0, r3, r0, lsl #10
     420:	0a00008f 	beq	664 <shift+0x664>
     424:	0000071a 	andeq	r0, r0, sl, lsl r7
     428:	541a0d04 	ldrpl	r0, [sl], #-3332	; 0xfffff2fc
     42c:	05000000 	streq	r0, [r0, #-0]
     430:	008f0403 	addeq	r0, pc, r3, lsl #8
     434:	05f60a00 	ldrbeq	r0, [r6, #2560]!	; 0xa00
     438:	0f040000 	svceq	0x00040000
     43c:	0000541a 	andeq	r5, r0, sl, lsl r4
     440:	08030500 	stmdaeq	r3, {r8, sl}
     444:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     448:	00000fd8 	ldrdeq	r0, [r0], -r8
     44c:	00330405 	eorseq	r0, r3, r5, lsl #8
     450:	1b040000 	blne	100458 <__bss_end+0xf748c>
     454:	0001a20c 	andeq	sl, r1, ip, lsl #4
     458:	09c80900 	stmibeq	r8, {r8, fp}^
     45c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     460:	00000b86 	andeq	r0, r0, r6, lsl #23
     464:	08570901 	ldmdaeq	r7, {r0, r8, fp}^
     468:	00020000 	andeq	r0, r2, r0
     46c:	0008c60b 	andeq	ip, r8, fp, lsl #12
     470:	02010200 	andeq	r0, r1, #0, 4
     474:	00000786 	andeq	r0, r0, r6, lsl #15
     478:	01a2040c 			; <UNDEFINED> instruction: 0x01a2040c
     47c:	8c0a0000 	stchi	0, cr0, [sl], {-0}
     480:	05000006 	streq	r0, [r0, #-6]
     484:	00541404 	subseq	r1, r4, r4, lsl #8
     488:	03050000 	movweq	r0, #20480	; 0x5000
     48c:	00008f0c 	andeq	r8, r0, ip, lsl #30
     490:	0003b80a 	andeq	fp, r3, sl, lsl #16
     494:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     498:	00000054 	andeq	r0, r0, r4, asr r0
     49c:	8f100305 	svchi	0x00100305
     4a0:	2a0a0000 	bcs	2804a8 <__bss_end+0x2774dc>
     4a4:	05000005 	streq	r0, [r0, #-5]
     4a8:	0054140a 	subseq	r1, r4, sl, lsl #8
     4ac:	03050000 	movweq	r0, #20480	; 0x5000
     4b0:	00008f14 	andeq	r8, r0, r4, lsl pc
     4b4:	0007bb08 	andeq	fp, r7, r8, lsl #22
     4b8:	33040500 	movwcc	r0, #17664	; 0x4500
     4bc:	05000000 	streq	r0, [r0, #-0]
     4c0:	02210c0d 	eoreq	r0, r1, #3328	; 0xd00
     4c4:	4e0d0000 	cdpmi	0, 0, cr0, cr13, cr0, {0}
     4c8:	00007765 	andeq	r7, r0, r5, ror #14
     4cc:	0007b209 	andeq	fp, r7, r9, lsl #4
     4d0:	98090100 	stmdals	r9, {r8}
     4d4:	02000009 	andeq	r0, r0, #9
     4d8:	00079509 	andeq	r9, r7, r9, lsl #10
     4dc:	65090300 	strvs	r0, [r9, #-768]	; 0xfffffd00
     4e0:	04000007 	streq	r0, [r0], #-7
     4e4:	00086209 	andeq	r6, r8, r9, lsl #4
     4e8:	06000500 	streq	r0, [r0], -r0, lsl #10
     4ec:	00000600 	andeq	r0, r0, r0, lsl #12
     4f0:	081d0510 	ldmdaeq	sp, {r4, r8, sl}
     4f4:	00000260 	andeq	r0, r0, r0, ror #4
     4f8:	00726c07 	rsbseq	r6, r2, r7, lsl #24
     4fc:	60131f05 	andsvs	r1, r3, r5, lsl #30
     500:	00000002 	andeq	r0, r0, r2
     504:	00707307 	rsbseq	r7, r0, r7, lsl #6
     508:	60132005 	andsvs	r2, r3, r5
     50c:	04000002 	streq	r0, [r0], #-2
     510:	00637007 	rsbeq	r7, r3, r7
     514:	60132105 	andsvs	r2, r3, r5, lsl #2
     518:	08000002 	stmdaeq	r0, {r1}
     51c:	0006160e 	andeq	r1, r6, lr, lsl #12
     520:	13220500 			; <UNDEFINED> instruction: 0x13220500
     524:	00000260 	andeq	r0, r0, r0, ror #4
     528:	0402000c 	streq	r0, [r2], #-12
     52c:	0014c207 	andseq	ip, r4, r7, lsl #4
     530:	02600500 	rsbeq	r0, r0, #0, 10
     534:	25060000 	strcs	r0, [r6, #-0]
     538:	70000004 	andvc	r0, r0, r4
     53c:	fc082a05 	stc2	10, cr2, [r8], {5}	; <UNPREDICTABLE>
     540:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     544:	000009bc 			; <UNDEFINED> instruction: 0x000009bc
     548:	21122c05 	tstcs	r2, r5, lsl #24
     54c:	00000002 	andeq	r0, r0, r2
     550:	64697007 	strbtvs	r7, [r9], #-7
     554:	122d0500 	eorne	r0, sp, #0, 10
     558:	00000059 	andeq	r0, r0, r9, asr r0
     55c:	04f60e10 	ldrbteq	r0, [r6], #3600	; 0xe10
     560:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     564:	0001ea11 	andeq	lr, r1, r1, lsl sl
     568:	c70e1400 	strgt	r1, [lr, -r0, lsl #8]
     56c:	05000007 	streq	r0, [r0, #-7]
     570:	0059122f 	subseq	r1, r9, pc, lsr #4
     574:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     578:	000007d5 	ldrdeq	r0, [r0], -r5
     57c:	59123105 	ldmdbpl	r2, {r0, r2, r8, ip, sp}
     580:	1c000000 	stcne	0, cr0, [r0], {-0}
     584:	0005e90e 	andeq	lr, r5, lr, lsl #18
     588:	0c320500 	cfldr32eq	mvfx0, [r2], #-0
     58c:	000002fc 	strdeq	r0, [r0], -ip
     590:	07eb0e20 	strbeq	r0, [fp, r0, lsr #28]!
     594:	34050000 	strcc	r0, [r5], #-0
     598:	00003305 	andeq	r3, r0, r5, lsl #6
     59c:	d20e6000 	andle	r6, lr, #0
     5a0:	05000009 	streq	r0, [r0, #-9]
     5a4:	00480e35 	subeq	r0, r8, r5, lsr lr
     5a8:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     5ac:	0000065f 	andeq	r0, r0, pc, asr r6
     5b0:	480e3805 	stmdami	lr, {r0, r2, fp, ip, sp}
     5b4:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     5b8:	0006560e 	andeq	r5, r6, lr, lsl #12
     5bc:	0e390500 	cfabs32eq	mvfx0, mvfx9
     5c0:	00000048 	andeq	r0, r0, r8, asr #32
     5c4:	ae0f006c 	cdpge	0, 0, cr0, cr15, cr12, {3}
     5c8:	0c000001 	stceq	0, cr0, [r0], {1}
     5cc:	10000003 	andne	r0, r0, r3
     5d0:	00000059 	andeq	r0, r0, r9, asr r0
     5d4:	490a000f 	stmdbmi	sl, {r0, r1, r2, r3}
     5d8:	0600000b 	streq	r0, [r0], -fp
     5dc:	0054140a 	subseq	r1, r4, sl, lsl #8
     5e0:	03050000 	movweq	r0, #20480	; 0x5000
     5e4:	00008f18 	andeq	r8, r0, r8, lsl pc
     5e8:	00079d08 	andeq	r9, r7, r8, lsl #26
     5ec:	33040500 	movwcc	r0, #17664	; 0x4500
     5f0:	06000000 	streq	r0, [r0], -r0
     5f4:	033d0c0d 	teqeq	sp, #3328	; 0xd00
     5f8:	d2090000 	andle	r0, r9, #0
     5fc:	00000004 	andeq	r0, r0, r4
     600:	0003ad09 	andeq	sl, r3, r9, lsl #26
     604:	06000100 	streq	r0, [r0], -r0, lsl #2
     608:	00000a86 	andeq	r0, r0, r6, lsl #21
     60c:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     610:	00000372 	andeq	r0, r0, r2, ror r3
     614:	0003f70e 	andeq	pc, r3, lr, lsl #14
     618:	191d0600 	ldmdbne	sp, {r9, sl}
     61c:	00000372 	andeq	r0, r0, r2, ror r3
     620:	04950e00 	ldreq	r0, [r5], #3584	; 0xe00
     624:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     628:	00037219 	andeq	r7, r3, r9, lsl r2
     62c:	460e0400 	strmi	r0, [lr], -r0, lsl #8
     630:	0600000a 	streq	r0, [r0], -sl
     634:	0378131f 	cmneq	r8, #2080374784	; 0x7c000000
     638:	00080000 	andeq	r0, r8, r0
     63c:	033d040c 	teqeq	sp, #12, 8	; 0xc000000
     640:	040c0000 	streq	r0, [ip], #-0
     644:	0000026c 	andeq	r0, r0, ip, ror #4
     648:	00053d11 	andeq	r3, r5, r1, lsl sp
     64c:	22061400 	andcs	r1, r6, #0, 8
     650:	00060007 	andeq	r0, r6, r7
     654:	078b0e00 	streq	r0, [fp, r0, lsl #28]
     658:	26060000 	strcs	r0, [r6], -r0
     65c:	0000480e 	andeq	r4, r0, lr, lsl #16
     660:	540e0000 	strpl	r0, [lr], #-0
     664:	06000004 	streq	r0, [r0], -r4
     668:	03721929 	cmneq	r2, #671744	; 0xa4000
     66c:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     670:	000009a9 	andeq	r0, r0, r9, lsr #19
     674:	72192c06 	andsvc	r2, r9, #1536	; 0x600
     678:	08000003 	stmdaeq	r0, {r0, r1}
     67c:	000b2712 	andeq	r2, fp, r2, lsl r7
     680:	0a2f0600 	beq	bc1e88 <__bss_end+0xbb8ebc>
     684:	00000a63 	andeq	r0, r0, r3, ror #20
     688:	000003c6 	andeq	r0, r0, r6, asr #7
     68c:	000003d1 	ldrdeq	r0, [r0], -r1
     690:	00060513 	andeq	r0, r6, r3, lsl r5
     694:	03721400 	cmneq	r2, #0, 8
     698:	15000000 	strne	r0, [r0, #-0]
     69c:	00000a4b 	andeq	r0, r0, fp, asr #20
     6a0:	fc0a3106 	stc2	1, cr3, [sl], {6}
     6a4:	a7000003 	strge	r0, [r0, -r3]
     6a8:	e9000001 	stmdb	r0, {r0}
     6ac:	f4000003 	vst4.8	{d0-d3}, [r0], r3
     6b0:	13000003 	movwne	r0, #3
     6b4:	00000605 	andeq	r0, r0, r5, lsl #12
     6b8:	00037814 	andeq	r7, r3, r4, lsl r8
     6bc:	99160000 	ldmdbls	r6, {}	; <UNPREDICTABLE>
     6c0:	0600000a 	streq	r0, [r0], -sl
     6c4:	0a211935 	beq	846ba0 <__bss_end+0x83dbd4>
     6c8:	03720000 	cmneq	r2, #0
     6cc:	0d020000 	stceq	0, cr0, [r2, #-0]
     6d0:	13000004 	movwne	r0, #4
     6d4:	13000004 	movwne	r0, #4
     6d8:	00000605 	andeq	r0, r0, r5, lsl #12
     6dc:	07531600 	ldrbeq	r1, [r3, -r0, lsl #12]
     6e0:	37060000 	strcc	r0, [r6, -r0]
     6e4:	0008e819 	andeq	lr, r8, r9, lsl r8
     6e8:	00037200 	andeq	r7, r3, r0, lsl #4
     6ec:	042c0200 	strteq	r0, [ip], #-512	; 0xfffffe00
     6f0:	04320000 	ldrteq	r0, [r2], #-0
     6f4:	05130000 	ldreq	r0, [r3, #-0]
     6f8:	00000006 	andeq	r0, r0, r6
     6fc:	0007f517 	andeq	pc, r7, r7, lsl r5	; <UNPREDICTABLE>
     700:	2d390600 	ldccs	6, cr0, [r9, #-0]
     704:	0000061e 	andeq	r0, r0, lr, lsl r6
     708:	3d16020c 	lfmcc	f0, 4, [r6, #-48]	; 0xffffffd0
     70c:	06000005 	streq	r0, [r0], -r5
     710:	0b97053c 	bleq	fe5c1c08 <__bss_end+0xfe5b8c3c>
     714:	06050000 	streq	r0, [r5], -r0
     718:	59010000 	stmdbpl	r1, {}	; <UNPREDICTABLE>
     71c:	5f000004 	svcpl	0x00000004
     720:	13000004 	movwne	r0, #4
     724:	00000605 	andeq	r0, r0, r5, lsl #12
     728:	04e71600 	strbteq	r1, [r7], #1536	; 0x600
     72c:	3f060000 	svccc	0x00060000
     730:	000afc0e 	andeq	pc, sl, lr, lsl #24
     734:	00004800 	andeq	r4, r0, r0, lsl #16
     738:	04780100 	ldrbteq	r0, [r8], #-256	; 0xffffff00
     73c:	048d0000 	streq	r0, [sp], #0
     740:	05130000 	ldreq	r0, [r3, #-0]
     744:	14000006 	strne	r0, [r0], #-6
     748:	00000627 	andeq	r0, r0, r7, lsr #12
     74c:	00005914 	andeq	r5, r0, r4, lsl r9
     750:	01a71400 			; <UNDEFINED> instruction: 0x01a71400
     754:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     758:	00000a5a 	andeq	r0, r0, sl, asr sl
     75c:	780a4306 	stmdavc	sl, {r1, r2, r8, r9, lr}
     760:	01000008 	tsteq	r0, r8
     764:	000004a2 	andeq	r0, r0, r2, lsr #9
     768:	000004a8 	andeq	r0, r0, r8, lsr #9
     76c:	00060513 	andeq	r0, r6, r3, lsl r5
     770:	e5160000 	ldr	r0, [r6, #-0]
     774:	06000006 	streq	r0, [r0], -r6
     778:	04671346 	strbteq	r1, [r7], #-838	; 0xfffffcba
     77c:	03780000 	cmneq	r8, #0
     780:	c1010000 	mrsgt	r0, (UNDEF: 1)
     784:	c7000004 	strgt	r0, [r0, -r4]
     788:	13000004 	movwne	r0, #4
     78c:	0000062d 	andeq	r0, r0, sp, lsr #12
     790:	049a1600 	ldreq	r1, [sl], #1536	; 0x600
     794:	49060000 	stmdbmi	r6, {}	; <UNPREDICTABLE>
     798:	0009de13 	andeq	sp, r9, r3, lsl lr
     79c:	00037800 	andeq	r7, r3, r0, lsl #16
     7a0:	04e00100 	strbteq	r0, [r0], #256	; 0x100
     7a4:	04eb0000 	strbteq	r0, [fp], #0
     7a8:	2d130000 	ldccs	0, cr0, [r3, #-0]
     7ac:	14000006 	strne	r0, [r0], #-6
     7b0:	00000048 	andeq	r0, r0, r8, asr #32
     7b4:	0b581800 	bleq	16067bc <__bss_end+0x15fd7f0>
     7b8:	4c060000 	stcmi	0, cr0, [r6], {-0}
     7bc:	0003c80a 	andeq	ip, r3, sl, lsl #16
     7c0:	05000100 	streq	r0, [r0, #-256]	; 0xffffff00
     7c4:	05060000 	streq	r0, [r6, #-0]
     7c8:	05130000 	ldreq	r0, [r3, #-0]
     7cc:	00000006 	andeq	r0, r0, r6
     7d0:	000a4b16 	andeq	r4, sl, r6, lsl fp
     7d4:	0a4e0600 	beq	1381fdc <__bss_end+0x1379010>
     7d8:	0000061c 	andeq	r0, r0, ip, lsl r6
     7dc:	000001a7 	andeq	r0, r0, r7, lsr #3
     7e0:	00051f01 	andeq	r1, r5, r1, lsl #30
     7e4:	00052a00 	andeq	r2, r5, r0, lsl #20
     7e8:	06051300 	streq	r1, [r5], -r0, lsl #6
     7ec:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     7f0:	00000000 	andeq	r0, r0, r0
     7f4:	0006f916 	andeq	pc, r6, r6, lsl r9	; <UNPREDICTABLE>
     7f8:	0e510600 	cdpeq	6, 5, cr0, cr1, cr0, {0}
     7fc:	00000899 	muleq	r0, r9, r8
     800:	00000048 	andeq	r0, r0, r8, asr #32
     804:	00054301 	andeq	r4, r5, r1, lsl #6
     808:	00054e00 	andeq	r4, r5, r0, lsl #28
     80c:	06051300 	streq	r1, [r5], -r0, lsl #6
     810:	ae140000 	cdpge	0, 1, cr0, cr4, cr0, {0}
     814:	00000001 	andeq	r0, r0, r1
     818:	00043716 	andeq	r3, r4, r6, lsl r7
     81c:	0a540600 	beq	1502024 <__bss_end+0x14f9058>
     820:	000006a5 	andeq	r0, r0, r5, lsr #13
     824:	000001a7 	andeq	r0, r0, r7, lsr #3
     828:	00056701 	andeq	r6, r5, r1, lsl #14
     82c:	00057200 	andeq	r7, r5, r0, lsl #4
     830:	06051300 	streq	r1, [r5], -r0, lsl #6
     834:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     838:	00000000 	andeq	r0, r0, r0
     83c:	00072d18 	andeq	r2, r7, r8, lsl sp
     840:	0a570600 	beq	15c2048 <__bss_end+0x15b907c>
     844:	00000aa5 	andeq	r0, r0, r5, lsr #21
     848:	00058701 	andeq	r8, r5, r1, lsl #14
     84c:	0005a600 	andeq	sl, r5, r0, lsl #12
     850:	06051300 	streq	r1, [r5], -r0, lsl #6
     854:	8b140000 	blhi	50085c <__bss_end+0x4f7890>
     858:	14000000 	strne	r0, [r0], #-0
     85c:	00000048 	andeq	r0, r0, r8, asr #32
     860:	00004814 	andeq	r4, r0, r4, lsl r8
     864:	00481400 	subeq	r1, r8, r0, lsl #8
     868:	33140000 	tstcc	r4, #0
     86c:	00000006 	andeq	r0, r0, r6
     870:	000a0b18 	andeq	r0, sl, r8, lsl fp
     874:	055a0600 	ldrbeq	r0, [sl, #-1536]	; 0xfffffa00
     878:	00000591 	muleq	r0, r1, r5
     87c:	0005bb01 	andeq	fp, r5, r1, lsl #22
     880:	0005da00 	andeq	sp, r5, r0, lsl #20
     884:	06051300 	streq	r1, [r5], -r0, lsl #6
     888:	c2140000 	andsgt	r0, r4, #0
     88c:	14000000 	strne	r0, [r0], #-0
     890:	00000048 	andeq	r0, r0, r8, asr #32
     894:	00004814 	andeq	r4, r0, r4, lsl r8
     898:	00481400 	subeq	r1, r8, r0, lsl #8
     89c:	33140000 	tstcc	r4, #0
     8a0:	00000006 	andeq	r0, r0, r6
     8a4:	00051719 	andeq	r1, r5, r9, lsl r7
     8a8:	0a5d0600 	beq	17420b0 <__bss_end+0x17390e4>
     8ac:	0000054e 	andeq	r0, r0, lr, asr #10
     8b0:	000001a7 	andeq	r0, r0, r7, lsr #3
     8b4:	0005ef01 	andeq	lr, r5, r1, lsl #30
     8b8:	06051300 	streq	r1, [r5], -r0, lsl #6
     8bc:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
     8c0:	14000003 	strne	r0, [r0], #-3
     8c4:	00000639 	andeq	r0, r0, r9, lsr r6
     8c8:	7e050000 	cdpvc	0, 0, cr0, cr5, cr0, {0}
     8cc:	0c000003 	stceq	0, cr0, [r0], {3}
     8d0:	00037e04 	andeq	r7, r3, r4, lsl #28
     8d4:	03721a00 	cmneq	r2, #0, 20
     8d8:	06180000 	ldreq	r0, [r8], -r0
     8dc:	061e0000 	ldreq	r0, [lr], -r0
     8e0:	05130000 	ldreq	r0, [r3, #-0]
     8e4:	00000006 	andeq	r0, r0, r6
     8e8:	00037e1b 	andeq	r7, r3, fp, lsl lr
     8ec:	00060b00 	andeq	r0, r6, r0, lsl #22
     8f0:	3a040c00 	bcc	1038f8 <__bss_end+0xfa92c>
     8f4:	0c000000 	stceq	0, cr0, [r0], {-0}
     8f8:	00060004 	andeq	r0, r6, r4
     8fc:	65041c00 	strvs	r1, [r4, #-3072]	; 0xfffff400
     900:	1d000000 	stcne	0, cr0, [r0, #-0]
     904:	61681e04 	cmnvs	r8, r4, lsl #28
     908:	0507006c 	streq	r0, [r7, #-108]	; 0xffffff94
     90c:	0006f50b 	andeq	pc, r6, fp, lsl #10
     910:	082a1f00 	stmdaeq	sl!, {r8, r9, sl, fp, ip}
     914:	07070000 	streq	r0, [r7, -r0]
     918:	0000601c 	andeq	r6, r0, ip, lsl r0
     91c:	e6b28000 	ldrt	r8, [r2], r0
     920:	09881f0e 	stmibeq	r8, {r1, r2, r3, r8, r9, sl, fp, ip}
     924:	0a070000 	beq	1c092c <__bss_end+0x1b7960>
     928:	0002671d 	andeq	r6, r2, sp, lsl r7
     92c:	00000000 	andeq	r0, r0, r0
     930:	08031f20 	stmdaeq	r3, {r5, r8, r9, sl, fp, ip}
     934:	0d070000 	stceq	0, cr0, [r7, #-0]
     938:	0002671d 	andeq	r6, r2, sp, lsl r7
     93c:	20000000 	andcs	r0, r0, r0
     940:	090e2020 	stmdbeq	lr, {r5, sp}
     944:	10070000 	andne	r0, r7, r0
     948:	00005418 	andeq	r5, r0, r8, lsl r4
     94c:	0e1f3600 	cfmsub32eq	mvax0, mvfx3, mvfx15, mvfx0
     950:	07000005 	streq	r0, [r0, -r5]
     954:	02671d42 	rsbeq	r1, r7, #4224	; 0x1080
     958:	50000000 	andpl	r0, r0, r0
     95c:	681f2021 	ldmdavs	pc, {r0, r5, sp}	; <UNPREDICTABLE>
     960:	07000006 	streq	r0, [r0, -r6]
     964:	02671d71 	rsbeq	r1, r7, #7232	; 0x1c40
     968:	b2000000 	andlt	r0, r0, #0
     96c:	ad1f2000 	ldcge	0, cr2, [pc, #-0]	; 974 <shift+0x974>
     970:	07000004 	streq	r0, [r0, -r4]
     974:	02671da4 	rsbeq	r1, r7, #164, 26	; 0x2900
     978:	b4000000 	strlt	r0, [r0], #-0
     97c:	d11f2000 	tstle	pc, r0
     980:	07000006 	streq	r0, [r0, -r6]
     984:	02671db3 	rsbeq	r1, r7, #11456	; 0x2cc0
     988:	40000000 	andmi	r0, r0, r0
     98c:	4c1f2010 	ldcmi	0, cr2, [pc], {16}
     990:	07000006 	streq	r0, [r0, -r6]
     994:	02671dbe 	rsbeq	r1, r7, #12160	; 0x2f80
     998:	50000000 	andpl	r0, r0, r0
     99c:	821f2020 	andshi	r2, pc, #32
     9a0:	07000006 	streq	r0, [r0, -r6]
     9a4:	02671dbf 	rsbeq	r1, r7, #12224	; 0x2fc0
     9a8:	40000000 	andmi	r0, r0, r0
     9ac:	4a1f2080 	bmi	7c8bb4 <__bss_end+0x7bfbe8>
     9b0:	07000004 	streq	r0, [r0, -r4]
     9b4:	02671dc0 	rsbeq	r1, r7, #192, 26	; 0x3000
     9b8:	50000000 	andpl	r0, r0, r0
     9bc:	21002080 	smlabbcs	r0, r0, r0, r2
     9c0:	00000647 	andeq	r0, r0, r7, asr #12
     9c4:	00065721 	andeq	r5, r6, r1, lsr #14
     9c8:	06672100 	strbteq	r2, [r7], -r0, lsl #2
     9cc:	77210000 	strvc	r0, [r1, -r0]!
     9d0:	21000006 	tstcs	r0, r6
     9d4:	00000684 	andeq	r0, r0, r4, lsl #13
     9d8:	00069421 	andeq	r9, r6, r1, lsr #8
     9dc:	06a42100 	strteq	r2, [r4], r0, lsl #2
     9e0:	b4210000 	strtlt	r0, [r1], #-0
     9e4:	21000006 	tstcs	r0, r6
     9e8:	000006c4 	andeq	r0, r0, r4, asr #13
     9ec:	0006d421 	andeq	sp, r6, r1, lsr #8
     9f0:	06e42100 	strbteq	r2, [r4], r0, lsl #2
     9f4:	7c0a0000 	stcvc	0, cr0, [sl], {-0}
     9f8:	08000009 	stmdaeq	r0, {r0, r3}
     9fc:	00541408 	subseq	r1, r4, r8, lsl #8
     a00:	03050000 	movweq	r0, #20480	; 0x5000
     a04:	00008f48 	andeq	r8, r0, r8, asr #30
     a08:	00145b22 	andseq	r5, r4, r2, lsr #22
     a0c:	05100100 	ldreq	r0, [r0, #-256]	; 0xffffff00
     a10:	00000033 	andeq	r0, r0, r3, lsr r0
     a14:	0000822c 	andeq	r8, r0, ip, lsr #4
     a18:	000001a0 	andeq	r0, r0, r0, lsr #3
     a1c:	07ea9c01 	strbeq	r9, [sl, r1, lsl #24]!
     a20:	74230000 	strtvc	r0, [r3], #-0
     a24:	0100000b 	tsteq	r0, fp
     a28:	00330e10 	eorseq	r0, r3, r0, lsl lr
     a2c:	91020000 	mrsls	r0, (UNDEF: 2)
     a30:	0af7235c 	beq	ffdc97a8 <__bss_end+0xffdc07dc>
     a34:	10010000 	andne	r0, r1, r0
     a38:	0007ea1b 	andeq	lr, r7, fp, lsl sl
     a3c:	58910200 	ldmpl	r1, {r9}
     a40:	00077924 	andeq	r7, r7, r4, lsr #18
     a44:	0e120100 	mufeqs	f0, f2, f0
     a48:	00000048 	andeq	r0, r0, r8, asr #32
     a4c:	24709102 	ldrbtcs	r9, [r0], #-258	; 0xfffffefe
     a50:	00000b79 	andeq	r0, r0, r9, ror fp
     a54:	480e1301 	stmdami	lr, {r0, r8, r9, ip}
     a58:	02000000 	andeq	r0, r0, #0
     a5c:	0d246c91 	stceq	12, cr6, [r4, #-580]!	; 0xfffffdbc
     a60:	01000007 	tsteq	r0, r7
     a64:	00480e14 	subeq	r0, r8, r4, lsl lr
     a68:	91020000 	mrsls	r0, (UNDEF: 2)
     a6c:	07cd2468 	strbeq	r2, [sp, r8, ror #8]
     a70:	16010000 	strne	r0, [r1], -r0
     a74:	00005912 	andeq	r5, r0, r2, lsl r9
     a78:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     a7c:	00043224 	andeq	r3, r4, r4, lsr #4
     a80:	0a170100 	beq	5c0e88 <__bss_end+0x5b7ebc>
     a84:	000001a7 	andeq	r0, r0, r7, lsr #3
     a88:	24679102 	strbtcs	r9, [r7], #-258	; 0xfffffefe
     a8c:	000006db 	ldrdeq	r0, [r0], -fp
     a90:	a70a1801 	strge	r1, [sl, -r1, lsl #16]
     a94:	02000001 	andeq	r0, r0, #1
     a98:	a8256691 	stmdage	r5!, {r0, r4, r7, r9, sl, sp, lr}
     a9c:	10000082 	andne	r0, r0, r2, lsl #1
     aa0:	26000001 	strcs	r0, [r0], -r1
     aa4:	00706d74 	rsbseq	r6, r0, r4, ror sp
     aa8:	250e1e01 	strcs	r1, [lr, #-3585]	; 0xfffff1ff
     aac:	02000000 	andeq	r0, r0, #0
     ab0:	00006591 	muleq	r0, r1, r5
     ab4:	07f0040c 	ldrbeq	r0, [r0, ip, lsl #8]!
     ab8:	040c0000 	streq	r0, [ip], #-0
     abc:	00000025 	andeq	r0, r0, r5, lsr #32
     ac0:	000b1f00 	andeq	r1, fp, r0, lsl #30
     ac4:	06000400 	streq	r0, [r0], -r0, lsl #8
     ac8:	04000004 	streq	r0, [r0], #-4
     acc:	000d3d01 	andeq	r3, sp, r1, lsl #26
     ad0:	0c240400 	cfstrseq	mvf0, [r4], #-0
     ad4:	0e670000 	cdpeq	0, 6, cr0, cr7, cr0, {0}
     ad8:	83cc0000 	bichi	r0, ip, #0
     adc:	045c0000 	ldrbeq	r0, [ip], #-0
     ae0:	04e40000 	strbteq	r0, [r4], #0
     ae4:	01020000 	mrseq	r0, (UNDEF: 2)
     ae8:	0008e308 	andeq	lr, r8, r8, lsl #6
     aec:	00250300 	eoreq	r0, r5, r0, lsl #6
     af0:	02020000 	andeq	r0, r2, #0
     af4:	00091d05 	andeq	r1, r9, r5, lsl #26
     af8:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
     afc:	00746e69 	rsbseq	r6, r4, r9, ror #28
     b00:	da080102 	ble	200f10 <__bss_end+0x1f7f44>
     b04:	02000008 	andeq	r0, r0, #8
     b08:	07400702 	strbeq	r0, [r0, -r2, lsl #14]
     b0c:	a0050000 	andge	r0, r5, r0
     b10:	07000009 	streq	r0, [r0, -r9]
     b14:	005e0709 	subseq	r0, lr, r9, lsl #14
     b18:	4d030000 	stcmi	0, cr0, [r3, #-0]
     b1c:	02000000 	andeq	r0, r0, #0
     b20:	14c70704 	strbne	r0, [r7], #1796	; 0x704
     b24:	dd060000 	stcle	0, cr0, [r6, #-0]
     b28:	08000005 	stmdaeq	r0, {r0, r2}
     b2c:	8b080602 	blhi	20233c <__bss_end+0x1f9370>
     b30:	07000000 	streq	r0, [r0, -r0]
     b34:	02003072 	andeq	r3, r0, #114	; 0x72
     b38:	004d0e08 	subeq	r0, sp, r8, lsl #28
     b3c:	07000000 	streq	r0, [r0, -r0]
     b40:	02003172 	andeq	r3, r0, #-2147483620	; 0x8000001c
     b44:	004d0e09 	subeq	r0, sp, r9, lsl #28
     b48:	00040000 	andeq	r0, r4, r0
     b4c:	000f0f08 	andeq	r0, pc, r8, lsl #30
     b50:	38040500 	stmdacc	r4, {r8, sl}
     b54:	02000000 	andeq	r0, r0, #0
     b58:	00a90c0d 	adceq	r0, r9, sp, lsl #24
     b5c:	4f090000 	svcmi	0x00090000
     b60:	0a00004b 	beq	c94 <shift+0xc94>
     b64:	00000c70 	andeq	r0, r0, r0, ror ip
     b68:	b8080001 	stmdalt	r8, {r0}
     b6c:	05000004 	streq	r0, [r0, #-4]
     b70:	00003804 	andeq	r3, r0, r4, lsl #16
     b74:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
     b78:	000000e0 	andeq	r0, r0, r0, ror #1
     b7c:	0006440a 	andeq	r4, r6, sl, lsl #8
     b80:	b10a0000 	mrslt	r0, (UNDEF: 10)
     b84:	0100000b 	tsteq	r0, fp
     b88:	000b910a 	andeq	r9, fp, sl, lsl #2
     b8c:	730a0200 	movwvc	r0, #41472	; 0xa200
     b90:	03000007 	movweq	r0, #7
     b94:	0008690a 	andeq	r6, r8, sl, lsl #18
     b98:	0d0a0400 	cfstrseq	mvf0, [sl, #-0]
     b9c:	05000006 	streq	r0, [r0, #-6]
     ba0:	0b310800 	bleq	c42ba8 <__bss_end+0xc39bdc>
     ba4:	04050000 	streq	r0, [r5], #-0
     ba8:	00000038 	andeq	r0, r0, r8, lsr r0
     bac:	1d0c4002 	stcne	0, cr4, [ip, #-8]
     bb0:	0a000001 	beq	bbc <shift+0xbbc>
     bb4:	000003c3 	andeq	r0, r0, r3, asr #7
     bb8:	04cd0a00 	strbeq	r0, [sp], #2560	; 0xa00
     bbc:	0a010000 	beq	40bc4 <__bss_end+0x37bf8>
     bc0:	0000085c 	andeq	r0, r0, ip, asr r8
     bc4:	0b6e0a02 	bleq	1b833d4 <__bss_end+0x1b7a408>
     bc8:	0a030000 	beq	c0bd0 <__bss_end+0xb7c04>
     bcc:	00000bbb 			; <UNDEFINED> instruction: 0x00000bbb
     bd0:	08230a04 	stmdaeq	r3!, {r2, r9, fp}
     bd4:	0a050000 	beq	140bdc <__bss_end+0x137c10>
     bd8:	00000760 	andeq	r0, r0, r0, ror #14
     bdc:	85080006 	strhi	r0, [r8, #-6]
     be0:	0500000f 	streq	r0, [r0, #-15]
     be4:	00003804 	andeq	r3, r0, r4, lsl #16
     be8:	0c670200 	sfmeq	f0, 2, [r7], #-0
     bec:	00000148 	andeq	r0, r0, r8, asr #2
     bf0:	000eb40a 	andeq	fp, lr, sl, lsl #8
     bf4:	cd0a0000 	stcgt	0, cr0, [sl, #-0]
     bf8:	0100000c 	tsteq	r0, ip
     bfc:	000ed80a 	andeq	sp, lr, sl, lsl #16
     c00:	f20a0200 	vhsub.s8	d0, d10, d0
     c04:	0300000c 	movweq	r0, #12
     c08:	083d0b00 	ldmdaeq	sp!, {r8, r9, fp}
     c0c:	05030000 	streq	r0, [r3, #-0]
     c10:	00005914 	andeq	r5, r0, r4, lsl r9
     c14:	70030500 	andvc	r0, r3, r0, lsl #10
     c18:	0b00008f 	bleq	e5c <shift+0xe5c>
     c1c:	0000084b 	andeq	r0, r0, fp, asr #16
     c20:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
     c24:	05000000 	streq	r0, [r0, #-0]
     c28:	008f7403 	addeq	r7, pc, r3, lsl #8
     c2c:	080d0b00 	stmdaeq	sp, {r8, r9, fp}
     c30:	07040000 	streq	r0, [r4, -r0]
     c34:	0000591a 	andeq	r5, r0, sl, lsl r9
     c38:	78030500 	stmdavc	r3, {r8, sl}
     c3c:	0b00008f 	bleq	e80 <shift+0xe80>
     c40:	000004fc 	strdeq	r0, [r0], -ip
     c44:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
     c48:	05000000 	streq	r0, [r0, #-0]
     c4c:	008f7c03 	addeq	r7, pc, r3, lsl #24
     c50:	08cc0b00 	stmiaeq	ip, {r8, r9, fp}^
     c54:	0b040000 	bleq	100c5c <__bss_end+0xf7c90>
     c58:	0000591a 	andeq	r5, r0, sl, lsl r9
     c5c:	80030500 	andhi	r0, r3, r0, lsl #10
     c60:	0b00008f 	bleq	ea4 <shift+0xea4>
     c64:	0000071a 	andeq	r0, r0, sl, lsl r7
     c68:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
     c6c:	05000000 	streq	r0, [r0, #-0]
     c70:	008f8403 	addeq	r8, pc, r3, lsl #8
     c74:	05f60b00 	ldrbeq	r0, [r6, #2816]!	; 0xb00
     c78:	0f040000 	svceq	0x00040000
     c7c:	0000591a 	andeq	r5, r0, sl, lsl r9
     c80:	88030500 	stmdahi	r3, {r8, sl}
     c84:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     c88:	00000fd8 	ldrdeq	r0, [r0], -r8
     c8c:	00380405 	eorseq	r0, r8, r5, lsl #8
     c90:	1b040000 	blne	100c98 <__bss_end+0xf7ccc>
     c94:	0001eb0c 	andeq	lr, r1, ip, lsl #22
     c98:	09c80a00 	stmibeq	r8, {r9, fp}^
     c9c:	0a000000 	beq	ca4 <shift+0xca4>
     ca0:	00000b86 	andeq	r0, r0, r6, lsl #23
     ca4:	08570a01 	ldmdaeq	r7, {r0, r9, fp}^
     ca8:	00020000 	andeq	r0, r2, r0
     cac:	0008c60c 	andeq	ip, r8, ip, lsl #12
     cb0:	02010200 	andeq	r0, r1, #0, 4
     cb4:	00000786 	andeq	r0, r0, r6, lsl #15
     cb8:	002c040d 	eoreq	r0, ip, sp, lsl #8
     cbc:	040d0000 	streq	r0, [sp], #-0
     cc0:	000001eb 	andeq	r0, r0, fp, ror #3
     cc4:	00068c0b 	andeq	r8, r6, fp, lsl #24
     cc8:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     ccc:	00000059 	andeq	r0, r0, r9, asr r0
     cd0:	8f8c0305 	svchi	0x008c0305
     cd4:	b80b0000 	stmdalt	fp, {}	; <UNPREDICTABLE>
     cd8:	05000003 	streq	r0, [r0, #-3]
     cdc:	00591407 	subseq	r1, r9, r7, lsl #8
     ce0:	03050000 	movweq	r0, #20480	; 0x5000
     ce4:	00008f90 	muleq	r0, r0, pc	; <UNPREDICTABLE>
     ce8:	00052a0b 	andeq	r2, r5, fp, lsl #20
     cec:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     cf0:	00000059 	andeq	r0, r0, r9, asr r0
     cf4:	8f940305 	svchi	0x00940305
     cf8:	bb080000 	bllt	200d00 <__bss_end+0x1f7d34>
     cfc:	05000007 	streq	r0, [r0, #-7]
     d00:	00003804 	andeq	r3, r0, r4, lsl #16
     d04:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
     d08:	00000270 	andeq	r0, r0, r0, ror r2
     d0c:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
     d10:	b20a0000 	andlt	r0, sl, #0
     d14:	01000007 	tsteq	r0, r7
     d18:	0009980a 	andeq	r9, r9, sl, lsl #16
     d1c:	950a0200 	strls	r0, [sl, #-512]	; 0xfffffe00
     d20:	03000007 	movweq	r0, #7
     d24:	0007650a 	andeq	r6, r7, sl, lsl #10
     d28:	620a0400 	andvs	r0, sl, #0, 8
     d2c:	05000008 	streq	r0, [r0, #-8]
     d30:	06000600 	streq	r0, [r0], -r0, lsl #12
     d34:	05100000 	ldreq	r0, [r0, #-0]
     d38:	02af081d 	adceq	r0, pc, #1900544	; 0x1d0000
     d3c:	6c070000 	stcvs	0, cr0, [r7], {-0}
     d40:	1f050072 	svcne	0x00050072
     d44:	0002af13 	andeq	sl, r2, r3, lsl pc
     d48:	73070000 	movwvc	r0, #28672	; 0x7000
     d4c:	20050070 	andcs	r0, r5, r0, ror r0
     d50:	0002af13 	andeq	sl, r2, r3, lsl pc
     d54:	70070400 	andvc	r0, r7, r0, lsl #8
     d58:	21050063 	tstcs	r5, r3, rrx
     d5c:	0002af13 	andeq	sl, r2, r3, lsl pc
     d60:	160e0800 	strne	r0, [lr], -r0, lsl #16
     d64:	05000006 	streq	r0, [r0, #-6]
     d68:	02af1322 	adceq	r1, pc, #-2013265920	; 0x88000000
     d6c:	000c0000 	andeq	r0, ip, r0
     d70:	c2070402 	andgt	r0, r7, #33554432	; 0x2000000
     d74:	06000014 			; <UNDEFINED> instruction: 0x06000014
     d78:	00000425 	andeq	r0, r0, r5, lsr #8
     d7c:	082a0570 	stmdaeq	sl!, {r4, r5, r6, r8, sl}
     d80:	00000346 	andeq	r0, r0, r6, asr #6
     d84:	0009bc0e 	andeq	fp, r9, lr, lsl #24
     d88:	122c0500 	eorne	r0, ip, #0, 10
     d8c:	00000270 	andeq	r0, r0, r0, ror r2
     d90:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     d94:	2d050064 	stccs	0, cr0, [r5, #-400]	; 0xfffffe70
     d98:	00005e12 	andeq	r5, r0, r2, lsl lr
     d9c:	f60e1000 			; <UNDEFINED> instruction: 0xf60e1000
     da0:	05000004 	streq	r0, [r0, #-4]
     da4:	0239112e 	eorseq	r1, r9, #-2147483637	; 0x8000000b
     da8:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     dac:	000007c7 	andeq	r0, r0, r7, asr #15
     db0:	5e122f05 	cdppl	15, 1, cr2, cr2, cr5, {0}
     db4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     db8:	0007d50e 	andeq	sp, r7, lr, lsl #10
     dbc:	12310500 	eorsne	r0, r1, #0, 10
     dc0:	0000005e 	andeq	r0, r0, lr, asr r0
     dc4:	05e90e1c 	strbeq	r0, [r9, #3612]!	; 0xe1c
     dc8:	32050000 	andcc	r0, r5, #0
     dcc:	0003460c 	andeq	r4, r3, ip, lsl #12
     dd0:	eb0e2000 	bl	388dd8 <__bss_end+0x37fe0c>
     dd4:	05000007 	streq	r0, [r0, #-7]
     dd8:	00380534 	eorseq	r0, r8, r4, lsr r5
     ddc:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
     de0:	000009d2 	ldrdeq	r0, [r0], -r2
     de4:	4d0e3505 	cfstr32mi	mvfx3, [lr, #-20]	; 0xffffffec
     de8:	64000000 	strvs	r0, [r0], #-0
     dec:	00065f0e 	andeq	r5, r6, lr, lsl #30
     df0:	0e380500 	cfabs32eq	mvfx0, mvfx8
     df4:	0000004d 	andeq	r0, r0, sp, asr #32
     df8:	06560e68 	ldrbeq	r0, [r6], -r8, ror #28
     dfc:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
     e00:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e04:	0f006c00 	svceq	0x00006c00
     e08:	000001fd 	strdeq	r0, [r0], -sp
     e0c:	00000356 	andeq	r0, r0, r6, asr r3
     e10:	00005e10 	andeq	r5, r0, r0, lsl lr
     e14:	0b000f00 	bleq	4a1c <shift+0x4a1c>
     e18:	00000b49 	andeq	r0, r0, r9, asr #22
     e1c:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
     e20:	05000000 	streq	r0, [r0, #-0]
     e24:	008f9803 	addeq	r9, pc, r3, lsl #16
     e28:	079d0800 	ldreq	r0, [sp, r0, lsl #16]
     e2c:	04050000 	streq	r0, [r5], #-0
     e30:	00000038 	andeq	r0, r0, r8, lsr r0
     e34:	870c0d06 	strhi	r0, [ip, -r6, lsl #26]
     e38:	0a000003 	beq	e4c <shift+0xe4c>
     e3c:	000004d2 	ldrdeq	r0, [r0], -r2
     e40:	03ad0a00 			; <UNDEFINED> instruction: 0x03ad0a00
     e44:	00010000 	andeq	r0, r1, r0
     e48:	00036803 	andeq	r6, r3, r3, lsl #16
     e4c:	0e0b0800 	cdpeq	8, 0, cr0, cr11, cr0, {0}
     e50:	04050000 	streq	r0, [r5], #-0
     e54:	00000038 	andeq	r0, r0, r8, lsr r0
     e58:	ab0c1406 	blge	305e78 <__bss_end+0x2fceac>
     e5c:	0a000003 	beq	e70 <shift+0xe70>
     e60:	00000bc7 	andeq	r0, r0, r7, asr #23
     e64:	0eca0a00 	vdiveq.f32	s1, s20, s0
     e68:	00010000 	andeq	r0, r1, r0
     e6c:	00038c03 	andeq	r8, r3, r3, lsl #24
     e70:	0a860600 	beq	fe182678 <__bss_end+0xfe1796ac>
     e74:	060c0000 	streq	r0, [ip], -r0
     e78:	03e5081b 	mvneq	r0, #1769472	; 0x1b0000
     e7c:	f70e0000 			; <UNDEFINED> instruction: 0xf70e0000
     e80:	06000003 	streq	r0, [r0], -r3
     e84:	03e5191d 	mvneq	r1, #475136	; 0x74000
     e88:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     e8c:	00000495 	muleq	r0, r5, r4
     e90:	e5191e06 	ldr	r1, [r9, #-3590]	; 0xfffff1fa
     e94:	04000003 	streq	r0, [r0], #-3
     e98:	000a460e 	andeq	r4, sl, lr, lsl #12
     e9c:	131f0600 	tstne	pc, #0, 12
     ea0:	000003eb 	andeq	r0, r0, fp, ror #7
     ea4:	040d0008 	streq	r0, [sp], #-8
     ea8:	000003b0 			; <UNDEFINED> instruction: 0x000003b0
     eac:	02b6040d 	adcseq	r0, r6, #218103808	; 0xd000000
     eb0:	3d110000 	ldccc	0, cr0, [r1, #-0]
     eb4:	14000005 	strne	r0, [r0], #-5
     eb8:	73072206 	movwvc	r2, #29190	; 0x7206
     ebc:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
     ec0:	0000078b 	andeq	r0, r0, fp, lsl #15
     ec4:	4d0e2606 	stcmi	6, cr2, [lr, #-24]	; 0xffffffe8
     ec8:	00000000 	andeq	r0, r0, r0
     ecc:	0004540e 	andeq	r5, r4, lr, lsl #8
     ed0:	19290600 	stmdbne	r9!, {r9, sl}
     ed4:	000003e5 	andeq	r0, r0, r5, ror #7
     ed8:	09a90e04 	stmibeq	r9!, {r2, r9, sl, fp}
     edc:	2c060000 	stccs	0, cr0, [r6], {-0}
     ee0:	0003e519 	andeq	lr, r3, r9, lsl r5
     ee4:	27120800 	ldrcs	r0, [r2, -r0, lsl #16]
     ee8:	0600000b 	streq	r0, [r0], -fp
     eec:	0a630a2f 	beq	18c37b0 <__bss_end+0x18ba7e4>
     ef0:	04390000 	ldrteq	r0, [r9], #-0
     ef4:	04440000 	strbeq	r0, [r4], #-0
     ef8:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     efc:	14000006 	strne	r0, [r0], #-6
     f00:	000003e5 	andeq	r0, r0, r5, ror #7
     f04:	0a4b1500 	beq	12c630c <__bss_end+0x12bd340>
     f08:	31060000 	mrscc	r0, (UNDEF: 6)
     f0c:	0003fc0a 	andeq	pc, r3, sl, lsl #24
     f10:	0001f000 	andeq	pc, r1, r0
     f14:	00045c00 	andeq	r5, r4, r0, lsl #24
     f18:	00046700 	andeq	r6, r4, r0, lsl #14
     f1c:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     f20:	eb140000 	bl	500f28 <__bss_end+0x4f7f5c>
     f24:	00000003 	andeq	r0, r0, r3
     f28:	000a9916 	andeq	r9, sl, r6, lsl r9
     f2c:	19350600 	ldmdbne	r5!, {r9, sl}
     f30:	00000a21 	andeq	r0, r0, r1, lsr #20
     f34:	000003e5 	andeq	r0, r0, r5, ror #7
     f38:	00048002 	andeq	r8, r4, r2
     f3c:	00048600 	andeq	r8, r4, r0, lsl #12
     f40:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     f44:	16000000 	strne	r0, [r0], -r0
     f48:	00000753 	andeq	r0, r0, r3, asr r7
     f4c:	e8193706 	ldmda	r9, {r1, r2, r8, r9, sl, ip, sp}
     f50:	e5000008 	str	r0, [r0, #-8]
     f54:	02000003 	andeq	r0, r0, #3
     f58:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
     f5c:	000004a5 	andeq	r0, r0, r5, lsr #9
     f60:	00067813 	andeq	r7, r6, r3, lsl r8
     f64:	f5170000 			; <UNDEFINED> instruction: 0xf5170000
     f68:	06000007 	streq	r0, [r0], -r7
     f6c:	06912d39 			; <UNDEFINED> instruction: 0x06912d39
     f70:	020c0000 	andeq	r0, ip, #0
     f74:	00053d16 	andeq	r3, r5, r6, lsl sp
     f78:	053c0600 	ldreq	r0, [ip, #-1536]!	; 0xfffffa00
     f7c:	00000b97 	muleq	r0, r7, fp
     f80:	00000678 	andeq	r0, r0, r8, ror r6
     f84:	0004cc01 	andeq	ip, r4, r1, lsl #24
     f88:	0004d200 	andeq	sp, r4, r0, lsl #4
     f8c:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
     f90:	16000000 	strne	r0, [r0], -r0
     f94:	000004e7 	andeq	r0, r0, r7, ror #9
     f98:	fc0e3f06 	stc2	15, cr3, [lr], {6}
     f9c:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
     fa0:	01000000 	mrseq	r0, (UNDEF: 0)
     fa4:	000004eb 	andeq	r0, r0, fp, ror #9
     fa8:	00000500 	andeq	r0, r0, r0, lsl #10
     fac:	00067813 	andeq	r7, r6, r3, lsl r8
     fb0:	069a1400 	ldreq	r1, [sl], r0, lsl #8
     fb4:	5e140000 	cdppl	0, 1, cr0, cr4, cr0, {0}
     fb8:	14000000 	strne	r0, [r0], #-0
     fbc:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     fc0:	0a5a1800 	beq	1686fc8 <__bss_end+0x167dffc>
     fc4:	43060000 	movwmi	r0, #24576	; 0x6000
     fc8:	0008780a 	andeq	r7, r8, sl, lsl #16
     fcc:	05150100 	ldreq	r0, [r5, #-256]	; 0xffffff00
     fd0:	051b0000 	ldreq	r0, [fp, #-0]
     fd4:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     fd8:	00000006 	andeq	r0, r0, r6
     fdc:	0006e516 	andeq	lr, r6, r6, lsl r5
     fe0:	13460600 	movtne	r0, #26112	; 0x6600
     fe4:	00000467 	andeq	r0, r0, r7, ror #8
     fe8:	000003eb 	andeq	r0, r0, fp, ror #7
     fec:	00053401 	andeq	r3, r5, r1, lsl #8
     ff0:	00053a00 	andeq	r3, r5, r0, lsl #20
     ff4:	06a01300 	strteq	r1, [r0], r0, lsl #6
     ff8:	16000000 	strne	r0, [r0], -r0
     ffc:	0000049a 	muleq	r0, sl, r4
    1000:	de134906 	vnmlsle.f16	s8, s6, s12	; <UNPREDICTABLE>
    1004:	eb000009 	bl	1030 <shift+0x1030>
    1008:	01000003 	tsteq	r0, r3
    100c:	00000553 	andeq	r0, r0, r3, asr r5
    1010:	0000055e 	andeq	r0, r0, lr, asr r5
    1014:	0006a013 	andeq	sl, r6, r3, lsl r0
    1018:	004d1400 	subeq	r1, sp, r0, lsl #8
    101c:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1020:	00000b58 	andeq	r0, r0, r8, asr fp
    1024:	c80a4c06 	stmdagt	sl, {r1, r2, sl, fp, lr}
    1028:	01000003 	tsteq	r0, r3
    102c:	00000573 	andeq	r0, r0, r3, ror r5
    1030:	00000579 	andeq	r0, r0, r9, ror r5
    1034:	00067813 	andeq	r7, r6, r3, lsl r8
    1038:	4b160000 	blmi	581040 <__bss_end+0x578074>
    103c:	0600000a 	streq	r0, [r0], -sl
    1040:	061c0a4e 	ldreq	r0, [ip], -lr, asr #20
    1044:	01f00000 	mvnseq	r0, r0
    1048:	92010000 	andls	r0, r1, #0
    104c:	9d000005 	stcls	0, cr0, [r0, #-20]	; 0xffffffec
    1050:	13000005 	movwne	r0, #5
    1054:	00000678 	andeq	r0, r0, r8, ror r6
    1058:	00004d14 	andeq	r4, r0, r4, lsl sp
    105c:	f9160000 			; <UNDEFINED> instruction: 0xf9160000
    1060:	06000006 	streq	r0, [r0], -r6
    1064:	08990e51 	ldmeq	r9, {r0, r4, r6, r9, sl, fp}
    1068:	004d0000 	subeq	r0, sp, r0
    106c:	b6010000 	strlt	r0, [r1], -r0
    1070:	c1000005 	tstgt	r0, r5
    1074:	13000005 	movwne	r0, #5
    1078:	00000678 	andeq	r0, r0, r8, ror r6
    107c:	0001fd14 	andeq	pc, r1, r4, lsl sp	; <UNPREDICTABLE>
    1080:	37160000 	ldrcc	r0, [r6, -r0]
    1084:	06000004 	streq	r0, [r0], -r4
    1088:	06a50a54 	ssateq	r0, #6, r4, asr #20
    108c:	01f00000 	mvnseq	r0, r0
    1090:	da010000 	ble	41098 <__bss_end+0x380cc>
    1094:	e5000005 	str	r0, [r0, #-5]
    1098:	13000005 	movwne	r0, #5
    109c:	00000678 	andeq	r0, r0, r8, ror r6
    10a0:	00004d14 	andeq	r4, r0, r4, lsl sp
    10a4:	2d180000 	ldccs	0, cr0, [r8, #-0]
    10a8:	06000007 	streq	r0, [r0], -r7
    10ac:	0aa50a57 	beq	fe943a10 <__bss_end+0xfe93aa44>
    10b0:	fa010000 	blx	410b8 <__bss_end+0x380ec>
    10b4:	19000005 	stmdbne	r0, {r0, r2}
    10b8:	13000006 	movwne	r0, #6
    10bc:	00000678 	andeq	r0, r0, r8, ror r6
    10c0:	0000a914 	andeq	sl, r0, r4, lsl r9
    10c4:	004d1400 	subeq	r1, sp, r0, lsl #8
    10c8:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    10cc:	14000000 	strne	r0, [r0], #-0
    10d0:	0000004d 	andeq	r0, r0, sp, asr #32
    10d4:	0006a614 	andeq	sl, r6, r4, lsl r6
    10d8:	0b180000 	bleq	6010e0 <__bss_end+0x5f8114>
    10dc:	0600000a 	streq	r0, [r0], -sl
    10e0:	0591055a 	ldreq	r0, [r1, #1370]	; 0x55a
    10e4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    10e8:	4d000006 	stcmi	0, cr0, [r0, #-24]	; 0xffffffe8
    10ec:	13000006 	movwne	r0, #6
    10f0:	00000678 	andeq	r0, r0, r8, ror r6
    10f4:	0000e014 	andeq	lr, r0, r4, lsl r0
    10f8:	004d1400 	subeq	r1, sp, r0, lsl #8
    10fc:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1100:	14000000 	strne	r0, [r0], #-0
    1104:	0000004d 	andeq	r0, r0, sp, asr #32
    1108:	0006a614 	andeq	sl, r6, r4, lsl r6
    110c:	17190000 	ldrne	r0, [r9, -r0]
    1110:	06000005 	streq	r0, [r0], -r5
    1114:	054e0a5d 	strbeq	r0, [lr, #-2653]	; 0xfffff5a3
    1118:	01f00000 	mvnseq	r0, r0
    111c:	62010000 	andvs	r0, r1, #0
    1120:	13000006 	movwne	r0, #6
    1124:	00000678 	andeq	r0, r0, r8, ror r6
    1128:	00036814 	andeq	r6, r3, r4, lsl r8
    112c:	06ac1400 	strteq	r1, [ip], r0, lsl #8
    1130:	00000000 	andeq	r0, r0, r0
    1134:	0003f103 	andeq	pc, r3, r3, lsl #2
    1138:	f1040d00 			; <UNDEFINED> instruction: 0xf1040d00
    113c:	1a000003 	bne	1150 <shift+0x1150>
    1140:	000003e5 	andeq	r0, r0, r5, ror #7
    1144:	0000068b 	andeq	r0, r0, fp, lsl #13
    1148:	00000691 	muleq	r0, r1, r6
    114c:	00067813 	andeq	r7, r6, r3, lsl r8
    1150:	f11b0000 			; <UNDEFINED> instruction: 0xf11b0000
    1154:	7e000003 	cdpvc	0, 0, cr0, cr0, cr3, {0}
    1158:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
    115c:	00003f04 	andeq	r3, r0, r4, lsl #30
    1160:	73040d00 	movwvc	r0, #19712	; 0x4d00
    1164:	1c000006 	stcne	0, cr0, [r0], {6}
    1168:	00006504 	andeq	r6, r0, r4, lsl #10
    116c:	0f041d00 	svceq	0x00041d00
    1170:	0000002c 	andeq	r0, r0, ip, lsr #32
    1174:	000006be 			; <UNDEFINED> instruction: 0x000006be
    1178:	00005e10 	andeq	r5, r0, r0, lsl lr
    117c:	03000900 	movweq	r0, #2304	; 0x900
    1180:	000006ae 	andeq	r0, r0, lr, lsr #13
    1184:	000cbc1e 	andeq	fp, ip, lr, lsl ip
    1188:	0ca40100 	stfeqs	f0, [r4]
    118c:	000006be 			; <UNDEFINED> instruction: 0x000006be
    1190:	8f9c0305 	svchi	0x009c0305
    1194:	e01f0000 	ands	r0, pc, r0
    1198:	0100000b 	tsteq	r0, fp
    119c:	0dff0aa6 			; <UNDEFINED> instruction: 0x0dff0aa6
    11a0:	004d0000 	subeq	r0, sp, r0
    11a4:	87780000 	ldrbhi	r0, [r8, -r0]!
    11a8:	00b00000 	adcseq	r0, r0, r0
    11ac:	9c010000 	stcls	0, cr0, [r1], {-0}
    11b0:	00000733 	andeq	r0, r0, r3, lsr r7
    11b4:	000fbb20 	andeq	fp, pc, r0, lsr #22
    11b8:	1ba60100 	blne	fe9815c0 <__bss_end+0xfe9785f4>
    11bc:	000001f7 	strdeq	r0, [r0], -r7
    11c0:	7fac9103 	svcvc	0x00ac9103
    11c4:	000e5e20 	andeq	r5, lr, r0, lsr #28
    11c8:	2aa60100 	bcs	fe9815d0 <__bss_end+0xfe978604>
    11cc:	0000004d 	andeq	r0, r0, sp, asr #32
    11d0:	7fa89103 	svcvc	0x00a89103
    11d4:	000d371e 	andeq	r3, sp, lr, lsl r7
    11d8:	0aa80100 	beq	fea015e0 <__bss_end+0xfe9f8614>
    11dc:	00000733 	andeq	r0, r0, r3, lsr r7
    11e0:	7fb49103 	svcvc	0x00b49103
    11e4:	000bdb1e 	andeq	sp, fp, lr, lsl fp
    11e8:	09ac0100 	stmibeq	ip!, {r8}
    11ec:	00000038 	andeq	r0, r0, r8, lsr r0
    11f0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    11f4:	0000250f 	andeq	r2, r0, pc, lsl #10
    11f8:	00074300 	andeq	r4, r7, r0, lsl #6
    11fc:	005e1000 	subseq	r1, lr, r0
    1200:	003f0000 	eorseq	r0, pc, r0
    1204:	000e4321 	andeq	r4, lr, r1, lsr #6
    1208:	0a980100 	beq	fe601610 <__bss_end+0xfe5f8644>
    120c:	00000eef 	andeq	r0, r0, pc, ror #29
    1210:	0000004d 	andeq	r0, r0, sp, asr #32
    1214:	0000873c 	andeq	r8, r0, ip, lsr r7
    1218:	0000003c 	andeq	r0, r0, ip, lsr r0
    121c:	07809c01 	streq	r9, [r0, r1, lsl #24]
    1220:	72220000 	eorvc	r0, r2, #0
    1224:	01007165 	tsteq	r0, r5, ror #2
    1228:	03ab209a 			; <UNDEFINED> instruction: 0x03ab209a
    122c:	91020000 	mrsls	r0, (UNDEF: 2)
    1230:	0df41e74 	ldcleq	14, cr1, [r4, #464]!	; 0x1d0
    1234:	9b010000 	blls	4123c <__bss_end+0x38270>
    1238:	00004d0e 	andeq	r4, r0, lr, lsl #26
    123c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1240:	0ea22300 	cdpeq	3, 10, cr2, cr2, cr0, {0}
    1244:	8f010000 	svchi	0x00010000
    1248:	000bfc06 	andeq	pc, fp, r6, lsl #24
    124c:	00870000 	addeq	r0, r7, r0
    1250:	00003c00 	andeq	r3, r0, r0, lsl #24
    1254:	b99c0100 	ldmiblt	ip, {r8}
    1258:	20000007 	andcs	r0, r0, r7
    125c:	00000c8a 	andeq	r0, r0, sl, lsl #25
    1260:	4d218f01 	stcmi	15, cr8, [r1, #-4]!
    1264:	02000000 	andeq	r0, r0, #0
    1268:	72226c91 	eorvc	r6, r2, #37120	; 0x9100
    126c:	01007165 	tsteq	r0, r5, ror #2
    1270:	03ab2091 			; <UNDEFINED> instruction: 0x03ab2091
    1274:	91020000 	mrsls	r0, (UNDEF: 2)
    1278:	20210074 	eorcs	r0, r1, r4, ror r0
    127c:	0100000e 	tsteq	r0, lr
    1280:	0cd80a83 	vldmiaeq	r8, {s1-s131}
    1284:	004d0000 	subeq	r0, sp, r0
    1288:	86c40000 	strbhi	r0, [r4], r0
    128c:	003c0000 	eorseq	r0, ip, r0
    1290:	9c010000 	stcls	0, cr0, [r1], {-0}
    1294:	000007f6 	strdeq	r0, [r0], -r6
    1298:	71657222 	cmnvc	r5, r2, lsr #4
    129c:	20850100 	addcs	r0, r5, r0, lsl #2
    12a0:	00000387 	andeq	r0, r0, r7, lsl #7
    12a4:	1e749102 	expnes	f1, f2
    12a8:	00000bd4 	ldrdeq	r0, [r0], -r4
    12ac:	4d0e8601 	stcmi	6, cr8, [lr, #-4]
    12b0:	02000000 	andeq	r0, r0, #0
    12b4:	21007091 	swpcs	r7, r1, [r0]
    12b8:	00000f9e 	muleq	r0, lr, pc	; <UNPREDICTABLE>
    12bc:	9e0a7701 	cdpls	7, 0, cr7, cr10, cr1, {0}
    12c0:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    12c4:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
    12c8:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    12cc:	01000000 	mrseq	r0, (UNDEF: 0)
    12d0:	0008339c 	muleq	r8, ip, r3
    12d4:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    12d8:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    12dc:	00038720 	andeq	r8, r3, r0, lsr #14
    12e0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    12e4:	000bd41e 	andeq	sp, fp, lr, lsl r4
    12e8:	0e7a0100 	rpweqe	f0, f2, f0
    12ec:	0000004d 	andeq	r0, r0, sp, asr #32
    12f0:	00709102 	rsbseq	r9, r0, r2, lsl #2
    12f4:	000cec21 	andeq	lr, ip, r1, lsr #24
    12f8:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    12fc:	00000ebf 			; <UNDEFINED> instruction: 0x00000ebf
    1300:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1304:	00008634 	andeq	r8, r0, r4, lsr r6
    1308:	00000054 	andeq	r0, r0, r4, asr r0
    130c:	087f9c01 	ldmdaeq	pc!, {r0, sl, fp, ip, pc}^	; <UNPREDICTABLE>
    1310:	f4200000 	vld4.8	{d0-d3}, [r0], r0
    1314:	0100000d 	tsteq	r0, sp
    1318:	004d156b 	subeq	r1, sp, fp, ror #10
    131c:	91020000 	mrsls	r0, (UNDEF: 2)
    1320:	0656206c 	ldrbeq	r2, [r6], -ip, rrx
    1324:	6b010000 	blvs	4132c <__bss_end+0x38360>
    1328:	00004d25 	andeq	r4, r0, r5, lsr #26
    132c:	68910200 	ldmvs	r1, {r9}
    1330:	000f961e 	andeq	r9, pc, lr, lsl r6	; <UNPREDICTABLE>
    1334:	0e6d0100 	poweqe	f0, f5, f0
    1338:	0000004d 	andeq	r0, r0, sp, asr #32
    133c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1340:	000c1321 	andeq	r1, ip, r1, lsr #6
    1344:	125e0100 	subsne	r0, lr, #0, 2
    1348:	00000f26 	andeq	r0, r0, r6, lsr #30
    134c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1350:	000085e4 	andeq	r8, r0, r4, ror #11
    1354:	00000050 	andeq	r0, r0, r0, asr r0
    1358:	08da9c01 	ldmeq	sl, {r0, sl, fp, ip, pc}^
    135c:	81200000 			; <UNDEFINED> instruction: 0x81200000
    1360:	0100000b 	tsteq	r0, fp
    1364:	004d205e 	subeq	r2, sp, lr, asr r0
    1368:	91020000 	mrsls	r0, (UNDEF: 2)
    136c:	0e29206c 	cdpeq	0, 2, cr2, cr9, cr12, {3}
    1370:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1374:	00004d2f 	andeq	r4, r0, pc, lsr #26
    1378:	68910200 	ldmvs	r1, {r9}
    137c:	00065620 	andeq	r5, r6, r0, lsr #12
    1380:	3f5e0100 	svccc	0x005e0100
    1384:	0000004d 	andeq	r0, r0, sp, asr #32
    1388:	1e649102 	lgnnes	f1, f2
    138c:	00000f96 	muleq	r0, r6, pc	; <UNPREDICTABLE>
    1390:	8b166001 	blhi	59939c <__bss_end+0x5903d0>
    1394:	02000000 	andeq	r0, r0, #0
    1398:	21007491 			; <UNDEFINED> instruction: 0x21007491
    139c:	00000f5c 	andeq	r0, r0, ip, asr pc
    13a0:	180a5201 	stmdane	sl, {r0, r9, ip, lr}
    13a4:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    13a8:	a0000000 	andge	r0, r0, r0
    13ac:	44000085 	strmi	r0, [r0], #-133	; 0xffffff7b
    13b0:	01000000 	mrseq	r0, (UNDEF: 0)
    13b4:	0009269c 	muleq	r9, ip, r6
    13b8:	0b812000 	bleq	fe0493c0 <__bss_end+0xfe0403f4>
    13bc:	52010000 	andpl	r0, r1, #0
    13c0:	00004d1a 	andeq	r4, r0, sl, lsl sp
    13c4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    13c8:	000e2920 	andeq	r2, lr, r0, lsr #18
    13cc:	29520100 	ldmdbcs	r2, {r8}^
    13d0:	0000004d 	andeq	r0, r0, sp, asr #32
    13d4:	1e689102 	lgnnee	f1, f2
    13d8:	00000f55 	andeq	r0, r0, r5, asr pc
    13dc:	4d0e5401 	cfstrsmi	mvf5, [lr, #-4]
    13e0:	02000000 	andeq	r0, r0, #0
    13e4:	21007491 			; <UNDEFINED> instruction: 0x21007491
    13e8:	00000f4f 	andeq	r0, r0, pc, asr #30
    13ec:	310a4501 	tstcc	sl, r1, lsl #10
    13f0:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    13f4:	50000000 	andpl	r0, r0, r0
    13f8:	50000085 	andpl	r0, r0, r5, lsl #1
    13fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1400:	0009819c 	muleq	r9, ip, r1
    1404:	0b812000 	bleq	fe04940c <__bss_end+0xfe040440>
    1408:	45010000 	strmi	r0, [r1, #-0]
    140c:	00004d19 	andeq	r4, r0, r9, lsl sp
    1410:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1414:	000d1820 	andeq	r1, sp, r0, lsr #16
    1418:	30450100 	subcc	r0, r5, r0, lsl #2
    141c:	0000011d 	andeq	r0, r0, sp, lsl r1
    1420:	20689102 	rsbcs	r9, r8, r2, lsl #2
    1424:	00000e2f 	andeq	r0, r0, pc, lsr #28
    1428:	ac414501 	cfstr64ge	mvdx4, [r1], {1}
    142c:	02000006 	andeq	r0, r0, #6
    1430:	961e6491 			; <UNDEFINED> instruction: 0x961e6491
    1434:	0100000f 	tsteq	r0, pc
    1438:	004d0e47 	subeq	r0, sp, r7, asr #28
    143c:	91020000 	mrsls	r0, (UNDEF: 2)
    1440:	c1230074 			; <UNDEFINED> instruction: 0xc1230074
    1444:	0100000b 	tsteq	r0, fp
    1448:	0d22063f 	stceq	6, cr0, [r2, #-252]!	; 0xffffff04
    144c:	85240000 	strhi	r0, [r4, #-0]!
    1450:	002c0000 	eoreq	r0, ip, r0
    1454:	9c010000 	stcls	0, cr0, [r1], {-0}
    1458:	000009ab 	andeq	r0, r0, fp, lsr #19
    145c:	000b8120 	andeq	r8, fp, r0, lsr #2
    1460:	153f0100 	ldrne	r0, [pc, #-256]!	; 1368 <shift+0x1368>
    1464:	0000004d 	andeq	r0, r0, sp, asr #32
    1468:	00749102 	rsbseq	r9, r4, r2, lsl #2
    146c:	000dee21 	andeq	lr, sp, r1, lsr #28
    1470:	0a320100 	beq	c81878 <__bss_end+0xc788ac>
    1474:	00000e35 	andeq	r0, r0, r5, lsr lr
    1478:	0000004d 	andeq	r0, r0, sp, asr #32
    147c:	000084d4 	ldrdeq	r8, [r0], -r4
    1480:	00000050 	andeq	r0, r0, r0, asr r0
    1484:	0a069c01 	beq	1a8490 <__bss_end+0x19f4c4>
    1488:	81200000 			; <UNDEFINED> instruction: 0x81200000
    148c:	0100000b 	tsteq	r0, fp
    1490:	004d1932 	subeq	r1, sp, r2, lsr r9
    1494:	91020000 	mrsls	r0, (UNDEF: 2)
    1498:	0f72206c 	svceq	0x0072206c
    149c:	32010000 	andcc	r0, r1, #0
    14a0:	0001f72b 	andeq	pc, r1, fp, lsr #14
    14a4:	68910200 	ldmvs	r1, {r9}
    14a8:	000e6220 	andeq	r6, lr, r0, lsr #4
    14ac:	3c320100 	ldfccs	f0, [r2], #-0
    14b0:	0000004d 	andeq	r0, r0, sp, asr #32
    14b4:	1e649102 	lgnnes	f1, f2
    14b8:	00000f20 	andeq	r0, r0, r0, lsr #30
    14bc:	4d0e3401 	cfstrsmi	mvf3, [lr, #-4]
    14c0:	02000000 	andeq	r0, r0, #0
    14c4:	21007491 			; <UNDEFINED> instruction: 0x21007491
    14c8:	00000fc0 	andeq	r0, r0, r0, asr #31
    14cc:	790a2501 	stmdbvc	sl, {r0, r8, sl, sp}
    14d0:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    14d4:	84000000 	strhi	r0, [r0], #-0
    14d8:	50000084 	andpl	r0, r0, r4, lsl #1
    14dc:	01000000 	mrseq	r0, (UNDEF: 0)
    14e0:	000a619c 	muleq	sl, ip, r1
    14e4:	0b812000 	bleq	fe0494ec <__bss_end+0xfe040520>
    14e8:	25010000 	strcs	r0, [r1, #-0]
    14ec:	00004d18 	andeq	r4, r0, r8, lsl sp
    14f0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    14f4:	000f7220 	andeq	r7, pc, r0, lsr #4
    14f8:	2a250100 	bcs	941900 <__bss_end+0x938934>
    14fc:	00000a67 	andeq	r0, r0, r7, ror #20
    1500:	20689102 	rsbcs	r9, r8, r2, lsl #2
    1504:	00000e62 	andeq	r0, r0, r2, ror #28
    1508:	4d3b2501 	cfldr32mi	mvfx2, [fp, #-4]!
    150c:	02000000 	andeq	r0, r0, #0
    1510:	e51e6491 	ldr	r6, [lr, #-1169]	; 0xfffffb6f
    1514:	0100000b 	tsteq	r0, fp
    1518:	004d0e27 	subeq	r0, sp, r7, lsr #28
    151c:	91020000 	mrsls	r0, (UNDEF: 2)
    1520:	040d0074 	streq	r0, [sp], #-116	; 0xffffff8c
    1524:	00000025 	andeq	r0, r0, r5, lsr #32
    1528:	000a6103 	andeq	r6, sl, r3, lsl #2
    152c:	0dfa2100 	ldfeqe	f2, [sl]
    1530:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1534:	000fcc0a 	andeq	ip, pc, sl, lsl #24
    1538:	00004d00 	andeq	r4, r0, r0, lsl #26
    153c:	00844000 	addeq	r4, r4, r0
    1540:	00004400 	andeq	r4, r0, r0, lsl #8
    1544:	b89c0100 	ldmlt	ip, {r8}
    1548:	2000000a 	andcs	r0, r0, sl
    154c:	00000fb7 			; <UNDEFINED> instruction: 0x00000fb7
    1550:	f71b1901 			; <UNDEFINED> instruction: 0xf71b1901
    1554:	02000001 	andeq	r0, r0, #1
    1558:	6d206c91 	stcvs	12, cr6, [r0, #-580]!	; 0xfffffdbc
    155c:	0100000f 	tsteq	r0, pc
    1560:	01c63519 	biceq	r3, r6, r9, lsl r5
    1564:	91020000 	mrsls	r0, (UNDEF: 2)
    1568:	0b811e68 	bleq	fe048f10 <__bss_end+0xfe03ff44>
    156c:	1b010000 	blne	41574 <__bss_end+0x385a8>
    1570:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1574:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1578:	0c7e2400 	cfldrdeq	mvd2, [lr], #-0
    157c:	14010000 	strne	r0, [r1], #-0
    1580:	000beb06 	andeq	lr, fp, r6, lsl #22
    1584:	00842400 	addeq	r2, r4, r0, lsl #8
    1588:	00001c00 	andeq	r1, r0, r0, lsl #24
    158c:	239c0100 	orrscs	r0, ip, #0, 2
    1590:	00000f63 	andeq	r0, r0, r3, ror #30
    1594:	0a060e01 	beq	184da0 <__bss_end+0x17bdd4>
    1598:	f800000d 			; <UNDEFINED> instruction: 0xf800000d
    159c:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    15a0:	01000000 	mrseq	r0, (UNDEF: 0)
    15a4:	000af89c 	muleq	sl, ip, r8
    15a8:	0c752000 	ldcleq	0, cr2, [r5], #-0
    15ac:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    15b0:	00003814 	andeq	r3, r0, r4, lsl r8
    15b4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15b8:	0fc52500 	svceq	0x00c52500
    15bc:	04010000 	streq	r0, [r1], #-0
    15c0:	000d2c0a 	andeq	r2, sp, sl, lsl #24
    15c4:	00004d00 	andeq	r4, r0, r0, lsl #26
    15c8:	0083cc00 	addeq	ip, r3, r0, lsl #24
    15cc:	00002c00 	andeq	r2, r0, r0, lsl #24
    15d0:	229c0100 	addscs	r0, ip, #0, 2
    15d4:	00646970 	rsbeq	r6, r4, r0, ror r9
    15d8:	4d0e0601 	stcmi	6, cr0, [lr, #-4]
    15dc:	02000000 	andeq	r0, r0, #0
    15e0:	00007491 	muleq	r0, r1, r4
    15e4:	0000032e 	andeq	r0, r0, lr, lsr #6
    15e8:	066f0004 	strbteq	r0, [pc], -r4
    15ec:	01040000 	mrseq	r0, (UNDEF: 4)
    15f0:	00000d3d 	andeq	r0, r0, sp, lsr sp
    15f4:	0010a704 	andseq	sl, r0, r4, lsl #14
    15f8:	000e6700 	andeq	r6, lr, r0, lsl #14
    15fc:	00882800 	addeq	r2, r8, r0, lsl #16
    1600:	0004b800 	andeq	fp, r4, r0, lsl #16
    1604:	00077000 	andeq	r7, r7, r0
    1608:	00490200 	subeq	r0, r9, r0, lsl #4
    160c:	1f030000 	svcne	0x00030000
    1610:	01000010 	tsteq	r0, r0, lsl r0
    1614:	00611005 	rsbeq	r1, r1, r5
    1618:	30110000 	andscc	r0, r1, r0
    161c:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    1620:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    1624:	43424139 	movtmi	r4, #8505	; 0x2139
    1628:	00464544 	subeq	r4, r6, r4, asr #10
    162c:	03010400 	movweq	r0, #5120	; 0x1400
    1630:	00002501 	andeq	r2, r0, r1, lsl #10
    1634:	00740500 	rsbseq	r0, r4, r0, lsl #10
    1638:	00610000 	rsbeq	r0, r1, r0
    163c:	66060000 	strvs	r0, [r6], -r0
    1640:	10000000 	andne	r0, r0, r0
    1644:	00510700 	subseq	r0, r1, r0, lsl #14
    1648:	04080000 	streq	r0, [r8], #-0
    164c:	0014c707 	andseq	ip, r4, r7, lsl #14
    1650:	08010800 	stmdaeq	r1, {fp}
    1654:	000008e3 	andeq	r0, r0, r3, ror #17
    1658:	00006d07 	andeq	r6, r0, r7, lsl #26
    165c:	002a0900 	eoreq	r0, sl, r0, lsl #18
    1660:	490a0000 	stmdbmi	sl, {}	; <UNPREDICTABLE>
    1664:	01000010 	tsteq	r0, r0, lsl r0
    1668:	10390664 	eorsne	r0, r9, r4, ror #12
    166c:	8c600000 	stclhi	0, cr0, [r0], #-0
    1670:	00800000 	addeq	r0, r0, r0
    1674:	9c010000 	stcls	0, cr0, [r1], {-0}
    1678:	000000fb 	strdeq	r0, [r0], -fp
    167c:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1680:	19640100 	stmdbne	r4!, {r8}^
    1684:	000000fb 	strdeq	r0, [r0], -fp
    1688:	0b649102 	bleq	1925a98 <__bss_end+0x191cacc>
    168c:	00747364 	rsbseq	r7, r4, r4, ror #6
    1690:	02246401 	eoreq	r6, r4, #16777216	; 0x1000000
    1694:	02000001 	andeq	r0, r0, #1
    1698:	6e0b6091 	mcrvs	0, 0, r6, cr11, cr1, {4}
    169c:	01006d75 	tsteq	r0, r5, ror sp
    16a0:	01042d64 	tsteq	r4, r4, ror #26
    16a4:	91020000 	mrsls	r0, (UNDEF: 2)
    16a8:	109b0c5c 	addsne	r0, fp, ip, asr ip
    16ac:	66010000 	strvs	r0, [r1], -r0
    16b0:	00010b11 	andeq	r0, r1, r1, lsl fp
    16b4:	70910200 	addsvc	r0, r1, r0, lsl #4
    16b8:	00102b0c 	andseq	r2, r0, ip, lsl #22
    16bc:	0b670100 	bleq	19c1ac4 <__bss_end+0x19b8af8>
    16c0:	00000111 	andeq	r0, r0, r1, lsl r1
    16c4:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    16c8:	00008c88 	andeq	r8, r0, r8, lsl #25
    16cc:	00000048 	andeq	r0, r0, r8, asr #32
    16d0:	0100690e 	tsteq	r0, lr, lsl #18
    16d4:	01040e69 	tsteq	r4, r9, ror #28
    16d8:	91020000 	mrsls	r0, (UNDEF: 2)
    16dc:	0f000074 	svceq	0x00000074
    16e0:	00010104 	andeq	r0, r1, r4, lsl #2
    16e4:	04111000 	ldreq	r1, [r1], #-0
    16e8:	69050412 	stmdbvs	r5, {r1, r4, sl}
    16ec:	0f00746e 	svceq	0x0000746e
    16f0:	00007404 	andeq	r7, r0, r4, lsl #8
    16f4:	6d040f00 	stcvs	15, cr0, [r4, #-0]
    16f8:	0a000000 	beq	1700 <shift+0x1700>
    16fc:	00000ff3 	strdeq	r0, [r0], -r3
    1700:	00065c01 	andeq	r5, r6, r1, lsl #24
    1704:	f8000010 			; <UNDEFINED> instruction: 0xf8000010
    1708:	6800008b 	stmdavs	r0, {r0, r1, r3, r7}
    170c:	01000000 	mrseq	r0, (UNDEF: 0)
    1710:	0001769c 	muleq	r1, ip, r6
    1714:	10941300 	addsne	r1, r4, r0, lsl #6
    1718:	5c010000 	stcpl	0, cr0, [r1], {-0}
    171c:	00010212 	andeq	r0, r1, r2, lsl r2
    1720:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1724:	000ff913 	andeq	pc, pc, r3, lsl r9	; <UNPREDICTABLE>
    1728:	1e5c0100 	rdfnee	f0, f4, f0
    172c:	00000104 	andeq	r0, r0, r4, lsl #2
    1730:	0e689102 	lgneqe	f1, f2
    1734:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1738:	110b5e01 	tstne	fp, r1, lsl #28
    173c:	02000001 	andeq	r0, r0, #1
    1740:	140d7091 	strne	r7, [sp], #-145	; 0xffffff6f
    1744:	3c00008c 	stccc	0, cr0, [r0], {140}	; 0x8c
    1748:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    174c:	60010069 	andvs	r0, r1, r9, rrx
    1750:	0001040e 	andeq	r0, r1, lr, lsl #8
    1754:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1758:	50140000 	andspl	r0, r4, r0
    175c:	01000010 	tsteq	r0, r0, lsl r0
    1760:	10690552 	rsbne	r0, r9, r2, asr r5
    1764:	01040000 	mrseq	r0, (UNDEF: 4)
    1768:	8ba40000 	blhi	fe901770 <__bss_end+0xfe8f87a4>
    176c:	00540000 	subseq	r0, r4, r0
    1770:	9c010000 	stcls	0, cr0, [r1], {-0}
    1774:	000001af 	andeq	r0, r0, pc, lsr #3
    1778:	0100730b 	tsteq	r0, fp, lsl #6
    177c:	010b1852 	tsteq	fp, r2, asr r8
    1780:	91020000 	mrsls	r0, (UNDEF: 2)
    1784:	00690e6c 	rsbeq	r0, r9, ip, ror #28
    1788:	04095401 	streq	r5, [r9], #-1025	; 0xfffffbff
    178c:	02000001 	andeq	r0, r0, #1
    1790:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    1794:	0000108c 	andeq	r1, r0, ip, lsl #1
    1798:	57054201 	strpl	r4, [r5, -r1, lsl #4]
    179c:	04000010 	streq	r0, [r0], #-16
    17a0:	f8000001 			; <UNDEFINED> instruction: 0xf8000001
    17a4:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    17a8:	01000000 	mrseq	r0, (UNDEF: 0)
    17ac:	0002159c 	muleq	r2, ip, r5
    17b0:	31730b00 	cmncc	r3, r0, lsl #22
    17b4:	19420100 	stmdbne	r2, {r8}^
    17b8:	0000010b 	andeq	r0, r0, fp, lsl #2
    17bc:	0b6c9102 	bleq	1b25bcc <__bss_end+0x1b1cc00>
    17c0:	01003273 	tsteq	r0, r3, ror r2
    17c4:	010b2942 	tsteq	fp, r2, asr #18
    17c8:	91020000 	mrsls	r0, (UNDEF: 2)
    17cc:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    17d0:	4201006d 	andmi	r0, r1, #109	; 0x6d
    17d4:	00010431 	andeq	r0, r1, r1, lsr r4
    17d8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    17dc:	0031750e 	eorseq	r7, r1, lr, lsl #10
    17e0:	15134401 	ldrne	r4, [r3, #-1025]	; 0xfffffbff
    17e4:	02000002 	andeq	r0, r0, #2
    17e8:	750e7791 	strvc	r7, [lr, #-1937]	; 0xfffff86f
    17ec:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    17f0:	00021517 	andeq	r1, r2, r7, lsl r5
    17f4:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    17f8:	08010800 	stmdaeq	r1, {fp}
    17fc:	000008da 	ldrdeq	r0, [r0], -sl
    1800:	00100c14 	andseq	r0, r0, r4, lsl ip
    1804:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    1808:	0000107b 	andeq	r1, r0, fp, ror r0
    180c:	00000111 	andeq	r0, r0, r1, lsl r1
    1810:	00008a38 	andeq	r8, r0, r8, lsr sl
    1814:	000000c0 	andeq	r0, r0, r0, asr #1
    1818:	02759c01 	rsbseq	r9, r5, #256	; 0x100
    181c:	ee130000 	cdp	0, 1, cr0, cr3, cr0, {0}
    1820:	0100000f 	tsteq	r0, pc
    1824:	01111536 	tsteq	r1, r6, lsr r5
    1828:	91020000 	mrsls	r0, (UNDEF: 2)
    182c:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1830:	36010063 	strcc	r0, [r1], -r3, rrx
    1834:	00010b27 	andeq	r0, r1, r7, lsr #22
    1838:	68910200 	ldmvs	r1, {r9}
    183c:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1840:	30360100 	eorscc	r0, r6, r0, lsl #2
    1844:	00000104 	andeq	r0, r0, r4, lsl #2
    1848:	0e649102 	lgneqs	f1, f2
    184c:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    1850:	00010409 	andeq	r0, r1, r9, lsl #8
    1854:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1858:	10761400 	rsbsne	r1, r6, r0, lsl #8
    185c:	24010000 	strcs	r0, [r1], #-0
    1860:	00101405 	andseq	r1, r0, r5, lsl #8
    1864:	00010400 	andeq	r0, r1, r0, lsl #8
    1868:	00899c00 	addeq	r9, r9, r0, lsl #24
    186c:	00009c00 	andeq	r9, r0, r0, lsl #24
    1870:	b29c0100 	addslt	r0, ip, #0, 2
    1874:	13000002 	movwne	r0, #2
    1878:	00000fe8 	andeq	r0, r0, r8, ror #31
    187c:	0b162401 	bleq	58a888 <__bss_end+0x5818bc>
    1880:	02000001 	andeq	r0, r0, #1
    1884:	320c6c91 	andcc	r6, ip, #37120	; 0x9100
    1888:	01000010 	tsteq	r0, r0, lsl r0
    188c:	01040926 	tsteq	r4, r6, lsr #18
    1890:	91020000 	mrsls	r0, (UNDEF: 2)
    1894:	a2150074 	andsge	r0, r5, #116	; 0x74
    1898:	01000010 	tsteq	r0, r0, lsl r0
    189c:	10f50608 	rscsne	r0, r5, r8, lsl #12
    18a0:	88280000 	stmdahi	r8!, {}	; <UNPREDICTABLE>
    18a4:	01740000 	cmneq	r4, r0
    18a8:	9c010000 	stcls	0, cr0, [r1], {-0}
    18ac:	000fe813 	andeq	lr, pc, r3, lsl r8	; <UNPREDICTABLE>
    18b0:	18080100 	stmdane	r8, {r8}
    18b4:	00000066 	andeq	r0, r0, r6, rrx
    18b8:	13649102 	cmnne	r4, #-2147483648	; 0x80000000
    18bc:	00001032 	andeq	r1, r0, r2, lsr r0
    18c0:	11250801 			; <UNDEFINED> instruction: 0x11250801
    18c4:	02000001 	andeq	r0, r0, #1
    18c8:	c1136091 			; <UNDEFINED> instruction: 0xc1136091
    18cc:	01000011 	tsteq	r0, r1, lsl r0
    18d0:	00663a08 	rsbeq	r3, r6, r8, lsl #20
    18d4:	91020000 	mrsls	r0, (UNDEF: 2)
    18d8:	00690e5c 	rsbeq	r0, r9, ip, asr lr
    18dc:	04090a01 	streq	r0, [r9], #-2561	; 0xfffff5ff
    18e0:	02000001 	andeq	r0, r0, #1
    18e4:	f40d7491 	vst3.32	{d7-d9}, [sp :64], r1
    18e8:	98000088 	stmdals	r0, {r3, r7}
    18ec:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    18f0:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    18f4:	0001040e 	andeq	r0, r1, lr, lsl #8
    18f8:	70910200 	addsvc	r0, r1, r0, lsl #4
    18fc:	00891c0d 	addeq	r1, r9, sp, lsl #24
    1900:	00006000 	andeq	r6, r0, r0
    1904:	00630e00 	rsbeq	r0, r3, r0, lsl #28
    1908:	6d0e1e01 	stcvs	14, cr1, [lr, #-4]
    190c:	02000000 	andeq	r0, r0, #0
    1910:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    1914:	00220000 	eoreq	r0, r2, r0
    1918:	00020000 	andeq	r0, r2, r0
    191c:	00000796 	muleq	r0, r6, r7
    1920:	09fb0104 	ldmibeq	fp!, {r2, r8}^
    1924:	8ce00000 	stclhi	0, cr0, [r0]
    1928:	8eec0000 	cdphi	0, 14, cr0, cr12, cr0, {0}
    192c:	11010000 	mrsne	r0, (UNDEF: 1)
    1930:	11310000 	teqne	r1, r0
    1934:	11990000 	orrsne	r0, r9, r0
    1938:	80010000 	andhi	r0, r1, r0
    193c:	00000022 	andeq	r0, r0, r2, lsr #32
    1940:	07aa0002 	streq	r0, [sl, r2]!
    1944:	01040000 	mrseq	r0, (UNDEF: 4)
    1948:	00000a78 	andeq	r0, r0, r8, ror sl
    194c:	00008eec 	andeq	r8, r0, ip, ror #29
    1950:	00008ef0 	strdeq	r8, [r0], -r0
    1954:	00001101 	andeq	r1, r0, r1, lsl #2
    1958:	00001131 	andeq	r1, r0, r1, lsr r1
    195c:	00001199 	muleq	r0, r9, r1
    1960:	032a8001 			; <UNDEFINED> instruction: 0x032a8001
    1964:	00040000 	andeq	r0, r4, r0
    1968:	000007be 			; <UNDEFINED> instruction: 0x000007be
    196c:	12c50104 	sbcne	r0, r5, #4, 2
    1970:	7e0c0000 	cdpvc	0, 0, cr0, cr12, cr0, {0}
    1974:	31000014 	tstcc	r0, r4, lsl r0
    1978:	d8000011 	stmdale	r0, {r0, r4}
    197c:	0200000a 	andeq	r0, r0, #10
    1980:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1984:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    1988:	0014c707 	andseq	ip, r4, r7, lsl #14
    198c:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    1990:	000002b9 			; <UNDEFINED> instruction: 0x000002b9
    1994:	72040803 	andvc	r0, r4, #196608	; 0x30000
    1998:	03000014 	movweq	r0, #20
    199c:	08da0801 	ldmeq	sl, {r0, fp}^
    19a0:	01030000 	mrseq	r0, (UNDEF: 3)
    19a4:	0008dc06 	andeq	sp, r8, r6, lsl #24
    19a8:	164a0400 	strbne	r0, [sl], -r0, lsl #8
    19ac:	01070000 	mrseq	r0, (UNDEF: 7)
    19b0:	00000039 	andeq	r0, r0, r9, lsr r0
    19b4:	d4061701 	strle	r1, [r6], #-1793	; 0xfffff8ff
    19b8:	05000001 	streq	r0, [r0, #-1]
    19bc:	000011d4 	ldrdeq	r1, [r0], -r4
    19c0:	16f90500 	ldrbtne	r0, [r9], r0, lsl #10
    19c4:	05010000 	streq	r0, [r1, #-0]
    19c8:	000013a7 	andeq	r1, r0, r7, lsr #7
    19cc:	14650502 	strbtne	r0, [r5], #-1282	; 0xfffffafe
    19d0:	05030000 	streq	r0, [r3, #-0]
    19d4:	00001663 	andeq	r1, r0, r3, ror #12
    19d8:	17090504 	strne	r0, [r9, -r4, lsl #10]
    19dc:	05050000 	streq	r0, [r5, #-0]
    19e0:	00001679 	andeq	r1, r0, r9, ror r6
    19e4:	14ae0506 	strtne	r0, [lr], #1286	; 0x506
    19e8:	05070000 	streq	r0, [r7, #-0]
    19ec:	000015f4 	strdeq	r1, [r0], -r4
    19f0:	16020508 	strne	r0, [r2], -r8, lsl #10
    19f4:	05090000 	streq	r0, [r9, #-0]
    19f8:	00001610 	andeq	r1, r0, r0, lsl r6
    19fc:	1517050a 	ldrne	r0, [r7, #-1290]	; 0xfffffaf6
    1a00:	050b0000 	streq	r0, [fp, #-0]
    1a04:	00001507 	andeq	r1, r0, r7, lsl #10
    1a08:	11f0050c 	mvnsne	r0, ip, lsl #10
    1a0c:	050d0000 	streq	r0, [sp, #-0]
    1a10:	00001209 	andeq	r1, r0, r9, lsl #4
    1a14:	14f8050e 	ldrbtne	r0, [r8], #1294	; 0x50e
    1a18:	050f0000 	streq	r0, [pc, #-0]	; 1a20 <shift+0x1a20>
    1a1c:	000016bc 			; <UNDEFINED> instruction: 0x000016bc
    1a20:	16390510 			; <UNDEFINED> instruction: 0x16390510
    1a24:	05110000 	ldreq	r0, [r1, #-0]
    1a28:	000016ad 	andeq	r1, r0, sp, lsr #13
    1a2c:	12b60512 	adcsne	r0, r6, #75497472	; 0x4800000
    1a30:	05130000 	ldreq	r0, [r3, #-0]
    1a34:	00001233 	andeq	r1, r0, r3, lsr r2
    1a38:	11fd0514 	mvnsne	r0, r4, lsl r5
    1a3c:	05150000 	ldreq	r0, [r5, #-0]
    1a40:	00001596 	muleq	r0, r6, r5
    1a44:	126a0516 	rsbne	r0, sl, #92274688	; 0x5800000
    1a48:	05170000 	ldreq	r0, [r7, #-0]
    1a4c:	000011a5 	andeq	r1, r0, r5, lsr #3
    1a50:	169f0518 			; <UNDEFINED> instruction: 0x169f0518
    1a54:	05190000 	ldreq	r0, [r9, #-0]
    1a58:	000014d4 	ldrdeq	r1, [r0], -r4
    1a5c:	15ae051a 	strne	r0, [lr, #1306]!	; 0x51a
    1a60:	051b0000 	ldreq	r0, [fp, #-0]
    1a64:	0000123e 	andeq	r1, r0, lr, lsr r2
    1a68:	144a051c 	strbne	r0, [sl], #-1308	; 0xfffffae4
    1a6c:	051d0000 	ldreq	r0, [sp, #-0]
    1a70:	00001399 	muleq	r0, r9, r3
    1a74:	162b051e 			; <UNDEFINED> instruction: 0x162b051e
    1a78:	051f0000 	ldreq	r0, [pc, #-0]	; 1a80 <shift+0x1a80>
    1a7c:	00001687 	andeq	r1, r0, r7, lsl #13
    1a80:	16c80520 	strbne	r0, [r8], r0, lsr #10
    1a84:	05210000 	streq	r0, [r1, #-0]!
    1a88:	000016d6 	ldrdeq	r1, [r0], -r6
    1a8c:	14eb0522 	strbtne	r0, [fp], #1314	; 0x522
    1a90:	05230000 	streq	r0, [r3, #-0]!
    1a94:	0000140e 	andeq	r1, r0, lr, lsl #8
    1a98:	124d0524 	subne	r0, sp, #36, 10	; 0x9000000
    1a9c:	05250000 	streq	r0, [r5, #-0]!
    1aa0:	000014a1 	andeq	r1, r0, r1, lsr #9
    1aa4:	13b30526 			; <UNDEFINED> instruction: 0x13b30526
    1aa8:	05270000 	streq	r0, [r7, #-0]!
    1aac:	00001656 	andeq	r1, r0, r6, asr r6
    1ab0:	13c30528 	bicne	r0, r3, #40, 10	; 0xa000000
    1ab4:	05290000 	streq	r0, [r9, #-0]!
    1ab8:	000013d2 	ldrdeq	r1, [r0], -r2
    1abc:	13e1052a 	mvnne	r0, #176160768	; 0xa800000
    1ac0:	052b0000 	streq	r0, [fp, #-0]!
    1ac4:	000013f0 	strdeq	r1, [r0], -r0
    1ac8:	137e052c 	cmnne	lr, #44, 10	; 0xb000000
    1acc:	052d0000 	streq	r0, [sp, #-0]!
    1ad0:	000013ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1ad4:	15e5052e 	strbne	r0, [r5, #1326]!	; 0x52e
    1ad8:	052f0000 	streq	r0, [pc, #-0]!	; 1ae0 <shift+0x1ae0>
    1adc:	0000141d 	andeq	r1, r0, sp, lsl r4
    1ae0:	142c0530 	strtne	r0, [ip], #-1328	; 0xfffffad0
    1ae4:	05310000 	ldreq	r0, [r1, #-0]!
    1ae8:	000011de 	ldrdeq	r1, [r0], -lr
    1aec:	15360532 	ldrne	r0, [r6, #-1330]!	; 0xffffface
    1af0:	05330000 	ldreq	r0, [r3, #-0]!
    1af4:	00001546 	andeq	r1, r0, r6, asr #10
    1af8:	15560534 	ldrbne	r0, [r6, #-1332]	; 0xfffffacc
    1afc:	05350000 	ldreq	r0, [r5, #-0]!
    1b00:	0000136c 	andeq	r1, r0, ip, ror #6
    1b04:	15660536 	strbne	r0, [r6, #-1334]!	; 0xfffffaca
    1b08:	05370000 	ldreq	r0, [r7, #-0]!
    1b0c:	00001576 	andeq	r1, r0, r6, ror r5
    1b10:	15860538 	strne	r0, [r6, #1336]	; 0x538
    1b14:	05390000 	ldreq	r0, [r9, #-0]!
    1b18:	0000125d 	andeq	r1, r0, sp, asr r2
    1b1c:	1216053a 	andsne	r0, r6, #243269632	; 0xe800000
    1b20:	053b0000 	ldreq	r0, [fp, #-0]!
    1b24:	0000143b 	andeq	r1, r0, fp, lsr r4
    1b28:	11b5053c 			; <UNDEFINED> instruction: 0x11b5053c
    1b2c:	053d0000 	ldreq	r0, [sp, #-0]!
    1b30:	000015a1 	andeq	r1, r0, r1, lsr #11
    1b34:	9d06003e 	stcls	0, cr0, [r6, #-248]	; 0xffffff08
    1b38:	02000012 	andeq	r0, r0, #18
    1b3c:	08026b01 	stmdaeq	r2, {r0, r8, r9, fp, sp, lr}
    1b40:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1b44:	00146007 	andseq	r6, r4, r7
    1b48:	02700100 	rsbseq	r0, r0, #0, 2
    1b4c:	00004714 	andeq	r4, r0, r4, lsl r7
    1b50:	79070000 	stmdbvc	r7, {}	; <UNPREDICTABLE>
    1b54:	01000013 	tsteq	r0, r3, lsl r0
    1b58:	47140271 			; <UNDEFINED> instruction: 0x47140271
    1b5c:	01000000 	mrseq	r0, (UNDEF: 0)
    1b60:	01d40800 	bicseq	r0, r4, r0, lsl #16
    1b64:	ff090000 			; <UNDEFINED> instruction: 0xff090000
    1b68:	14000001 	strne	r0, [r0], #-1
    1b6c:	0a000002 	beq	1b7c <shift+0x1b7c>
    1b70:	00000024 	andeq	r0, r0, r4, lsr #32
    1b74:	04080011 	streq	r0, [r8], #-17	; 0xffffffef
    1b78:	0b000002 	bleq	1b88 <shift+0x1b88>
    1b7c:	00001524 	andeq	r1, r0, r4, lsr #10
    1b80:	26027401 	strcs	r7, [r2], -r1, lsl #8
    1b84:	00000214 	andeq	r0, r0, r4, lsl r2
    1b88:	0a3d3a24 	beq	f50420 <__bss_end+0xf47454>
    1b8c:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    1b90:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    1b94:	133d053d 	teqne	sp, #255852544	; 0xf400000
    1b98:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    1b9c:	113d233d 	teqne	sp, sp, lsr r3
    1ba0:	013d263d 	teqeq	sp, sp, lsr r6
    1ba4:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    1ba8:	003d093d 	eorseq	r0, sp, sp, lsr r9
    1bac:	07020300 	streq	r0, [r2, -r0, lsl #6]
    1bb0:	00000740 	andeq	r0, r0, r0, asr #14
    1bb4:	e3080103 	movw	r0, #33027	; 0x8103
    1bb8:	0c000008 	stceq	0, cr0, [r0], {8}
    1bbc:	0259040d 	subseq	r0, r9, #218103808	; 0xd000000
    1bc0:	e40e0000 	str	r0, [lr], #-0
    1bc4:	07000016 	smladeq	r0, r6, r0, r0
    1bc8:	00003901 	andeq	r3, r0, r1, lsl #18
    1bcc:	04f70200 	ldrbteq	r0, [r7], #512	; 0x200
    1bd0:	00029e06 	andeq	r9, r2, r6, lsl #28
    1bd4:	12770500 	rsbsne	r0, r7, #0, 10
    1bd8:	05000000 	streq	r0, [r0, #-0]
    1bdc:	00001282 	andeq	r1, r0, r2, lsl #5
    1be0:	12940501 	addsne	r0, r4, #4194304	; 0x400000
    1be4:	05020000 	streq	r0, [r2, #-0]
    1be8:	000012ae 	andeq	r1, r0, lr, lsr #5
    1bec:	161e0503 	ldrne	r0, [lr], -r3, lsl #10
    1bf0:	05040000 	streq	r0, [r4, #-0]
    1bf4:	0000138d 	andeq	r1, r0, sp, lsl #7
    1bf8:	15d70505 	ldrbne	r0, [r7, #1285]	; 0x505
    1bfc:	00060000 	andeq	r0, r6, r0
    1c00:	1d050203 	sfmne	f0, 4, [r5, #-12]
    1c04:	03000009 	movweq	r0, #9
    1c08:	14bd0708 	ldrtne	r0, [sp], #1800	; 0x708
    1c0c:	04030000 	streq	r0, [r3], #-0
    1c10:	0011ce04 	andseq	ip, r1, r4, lsl #28
    1c14:	03080300 	movweq	r0, #33536	; 0x8300
    1c18:	000011c6 	andeq	r1, r0, r6, asr #3
    1c1c:	77040803 	strvc	r0, [r4, -r3, lsl #16]
    1c20:	03000014 	movweq	r0, #20
    1c24:	15c80310 	strbne	r0, [r8, #784]	; 0x310
    1c28:	bf0f0000 	svclt	0x000f0000
    1c2c:	03000015 	movweq	r0, #21
    1c30:	025a102a 	subseq	r1, sl, #42	; 0x2a
    1c34:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    1c38:	df000002 	svcle	0x00000002
    1c3c:	10000002 	andne	r0, r0, r2
    1c40:	03821100 	orreq	r1, r2, #0, 2
    1c44:	2f030000 	svccs	0x00030000
    1c48:	0002d411 	andeq	sp, r2, r1, lsl r4
    1c4c:	02761100 	rsbseq	r1, r6, #0, 2
    1c50:	30030000 	andcc	r0, r3, r0
    1c54:	0002d411 	andeq	sp, r2, r1, lsl r4
    1c58:	02c80900 	sbceq	r0, r8, #0, 18
    1c5c:	03070000 	movweq	r0, #28672	; 0x7000
    1c60:	240a0000 	strcs	r0, [sl], #-0
    1c64:	01000000 	mrseq	r0, (UNDEF: 0)
    1c68:	02df1200 	sbcseq	r1, pc, #0, 4
    1c6c:	33040000 	movwcc	r0, #16384	; 0x4000
    1c70:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    1c74:	03050000 	movweq	r0, #20480	; 0x5000
    1c78:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    1c7c:	0002eb12 	andeq	lr, r2, r2, lsl fp
    1c80:	09340400 	ldmdbeq	r4!, {sl}
    1c84:	0002f70a 	andeq	pc, r2, sl, lsl #14
    1c88:	b9030500 	stmdblt	r3, {r8, sl}
    1c8c:	0000008f 	andeq	r0, r0, pc, lsl #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377c48>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9d50>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9d70>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9d88>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0xc4>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a8c8>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39dac>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377cf0>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79d4c>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5964>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a94c>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39e30>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9e44>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x194>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a984>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39e68>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9e78>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377e00>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c59f0>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5a04>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377e34>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79e44>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	0b002403 	bleq	91f8 <__bss_end+0x22c>
 1e8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 1ec:	04000008 	streq	r0, [r0], #-8
 1f0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 1f4:	0b3b0b3a 	bleq	ec2ee4 <__bss_end+0xeb9f18>
 1f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 1fc:	26050000 	strcs	r0, [r5], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2baa50>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeb9f30>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f7e54>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d81c>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeb9f58>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeb9f70>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0b0b000f 	bleq	2c02a8 <__bss_end+0x2b72dc>
 268:	00001349 	andeq	r1, r0, r9, asr #6
 26c:	0300280d 	movweq	r2, #2061	; 0x80d
 270:	000b1c08 	andeq	r1, fp, r8, lsl #24
 274:	000d0e00 	andeq	r0, sp, r0, lsl #28
 278:	0b3a0e03 	bleq	e83a8c <__bss_end+0xe7aac0>
 27c:	0b390b3b 	bleq	e42f70 <__bss_end+0xe39fa4>
 280:	0b381349 	bleq	e04fac <__bss_end+0xdfbfe0>
 284:	010f0000 	mrseq	r0, CPSR
 288:	01134901 	tsteq	r3, r1, lsl #18
 28c:	10000013 	andne	r0, r0, r3, lsl r0
 290:	13490021 	movtne	r0, #36897	; 0x9021
 294:	00000b2f 	andeq	r0, r0, pc, lsr #22
 298:	03010211 	movweq	r0, #4625	; 0x1211
 29c:	3a0b0b0e 	bcc	2c2edc <__bss_end+0x2b9f10>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0013010b 	andseq	r0, r3, fp, lsl #2
 2a8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2b0:	0b3b0b3a 	bleq	ec2fa0 <__bss_end+0xeb9fd4>
 2b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2bc:	00001301 	andeq	r1, r0, r1, lsl #6
 2c0:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 2c4:	00193413 	andseq	r3, r9, r3, lsl r4
 2c8:	00051400 	andeq	r1, r5, r0, lsl #8
 2cc:	00001349 	andeq	r1, r0, r9, asr #6
 2d0:	3f012e15 	svccc	0x00012e15
 2d4:	3a0e0319 	bcc	380f40 <__bss_end+0x377f74>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2e0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2e4:	00130113 	andseq	r0, r3, r3, lsl r1
 2e8:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 2ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2f0:	0b3b0b3a 	bleq	ec2fe0 <__bss_end+0xeba014>
 2f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f8:	0b321349 	bleq	c85024 <__bss_end+0xc7c058>
 2fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 300:	00001301 	andeq	r1, r0, r1, lsl #6
 304:	03000d17 	movweq	r0, #3351	; 0xd17
 308:	3b0b3a0e 	blcc	2ceb48 <__bss_end+0x2c5b7c>
 30c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 310:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 314:	1800000b 	stmdane	r0, {r0, r1, r3}
 318:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 31c:	0b3a0e03 	bleq	e83b30 <__bss_end+0xe7ab64>
 320:	0b390b3b 	bleq	e43014 <__bss_end+0xe3a048>
 324:	0b320e6e 	bleq	c83ce4 <__bss_end+0xc7ad18>
 328:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 32c:	00001301 	andeq	r1, r0, r1, lsl #6
 330:	3f012e19 	svccc	0x00012e19
 334:	3a0e0319 	bcc	380fa0 <__bss_end+0x377fd4>
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
 370:	0b3a0803 	bleq	e82384 <__bss_end+0xe793b8>
 374:	0b390b3b 	bleq	e43068 <__bss_end+0xe3a09c>
 378:	00001301 	andeq	r1, r0, r1, lsl #6
 37c:	0300341f 	movweq	r3, #1055	; 0x41f
 380:	3b0b3a0e 	blcc	2cebc0 <__bss_end+0x2c5bf4>
 384:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 388:	1c193c13 	ldcne	12, cr3, [r9], {19}
 38c:	00196c06 	andseq	r6, r9, r6, lsl #24
 390:	00342000 	eorseq	r2, r4, r0
 394:	0b3a0e03 	bleq	e83ba8 <__bss_end+0xe7abdc>
 398:	0b390b3b 	bleq	e4308c <__bss_end+0xe3a0c0>
 39c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3a0:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 3a4:	34210000 	strtcc	r0, [r1], #-0
 3a8:	00134700 	andseq	r4, r3, r0, lsl #14
 3ac:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 3b0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3b4:	0b3b0b3a 	bleq	ec30a4 <__bss_end+0xeba0d8>
 3b8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3bc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3c0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3c4:	00130119 	andseq	r0, r3, r9, lsl r1
 3c8:	00052300 	andeq	r2, r5, r0, lsl #6
 3cc:	0b3a0e03 	bleq	e83be0 <__bss_end+0xe7ac14>
 3d0:	0b390b3b 	bleq	e430c4 <__bss_end+0xe3a0f8>
 3d4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3d8:	34240000 	strtcc	r0, [r4], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x378018>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 3e8:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 3ec:	0111010b 	tsteq	r1, fp, lsl #2
 3f0:	00000612 	andeq	r0, r0, r2, lsl r6
 3f4:	03003426 	movweq	r3, #1062	; 0x426
 3f8:	3b0b3a08 	blcc	2cec20 <__bss_end+0x2c5c54>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	00180213 	andseq	r0, r8, r3, lsl r2
 404:	11010000 	mrsne	r0, (UNDEF: 1)
 408:	130e2501 	movwne	r2, #58625	; 0xe501
 40c:	1b0e030b 	blne	381040 <__bss_end+0x378074>
 410:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 414:	00171006 	andseq	r1, r7, r6
 418:	00240200 	eoreq	r0, r4, r0, lsl #4
 41c:	0b3e0b0b 	bleq	f83050 <__bss_end+0xf7a084>
 420:	00000e03 	andeq	r0, r0, r3, lsl #28
 424:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 428:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 42c:	0b0b0024 	bleq	2c04c4 <__bss_end+0x2b74f8>
 430:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 434:	16050000 	strne	r0, [r5], -r0
 438:	3a0e0300 	bcc	381040 <__bss_end+0x378074>
 43c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 440:	0013490b 	andseq	r4, r3, fp, lsl #18
 444:	01130600 	tsteq	r3, r0, lsl #12
 448:	0b0b0e03 	bleq	2c3c5c <__bss_end+0x2bac90>
 44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeba170>
 450:	13010b39 	movwne	r0, #6969	; 0x1b39
 454:	0d070000 	stceq	0, cr0, [r7, #-0]
 458:	3a080300 	bcc	201060 <__bss_end+0x1f8094>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 464:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 468:	0e030104 	adfeqs	f0, f3, f4
 46c:	0b3e196d 	bleq	f86a28 <__bss_end+0xf7da5c>
 470:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 474:	0b3b0b3a 	bleq	ec3164 <__bss_end+0xeba198>
 478:	13010b39 	movwne	r0, #6969	; 0x1b39
 47c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 480:	1c080300 	stcne	3, cr0, [r8], {-0}
 484:	0a00000b 	beq	4b8 <shift+0x4b8>
 488:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 48c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 490:	0300340b 	movweq	r3, #1035	; 0x40b
 494:	3b0b3a0e 	blcc	2cecd4 <__bss_end+0x2c5d08>
 498:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 49c:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 4a0:	0c000018 	stceq	0, cr0, [r0], {24}
 4a4:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 4a8:	0000193c 	andeq	r1, r0, ip, lsr r9
 4ac:	0b000f0d 	bleq	40e8 <shift+0x40e8>
 4b0:	0013490b 	andseq	r4, r3, fp, lsl #18
 4b4:	000d0e00 	andeq	r0, sp, r0, lsl #28
 4b8:	0b3a0e03 	bleq	e83ccc <__bss_end+0xe7ad00>
 4bc:	0b390b3b 	bleq	e431b0 <__bss_end+0xe3a1e4>
 4c0:	0b381349 	bleq	e051ec <__bss_end+0xdfc220>
 4c4:	010f0000 	mrseq	r0, CPSR
 4c8:	01134901 	tsteq	r3, r1, lsl #18
 4cc:	10000013 	andne	r0, r0, r3, lsl r0
 4d0:	13490021 	movtne	r0, #36897	; 0x9021
 4d4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 4d8:	03010211 	movweq	r0, #4625	; 0x1211
 4dc:	3a0b0b0e 	bcc	2c311c <__bss_end+0x2ba150>
 4e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4e8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 4ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 4f0:	0b3b0b3a 	bleq	ec31e0 <__bss_end+0xeba214>
 4f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 4f8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 4fc:	00001301 	andeq	r1, r0, r1, lsl #6
 500:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 504:	00193413 	andseq	r3, r9, r3, lsl r4
 508:	00051400 	andeq	r1, r5, r0, lsl #8
 50c:	00001349 	andeq	r1, r0, r9, asr #6
 510:	3f012e15 	svccc	0x00012e15
 514:	3a0e0319 	bcc	381180 <__bss_end+0x3781b4>
 518:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 51c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 520:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 524:	00130113 	andseq	r0, r3, r3, lsl r1
 528:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 52c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 530:	0b3b0b3a 	bleq	ec3220 <__bss_end+0xeba254>
 534:	0e6e0b39 	vmoveq.8	d14[5], r0
 538:	0b321349 	bleq	c85264 <__bss_end+0xc7c298>
 53c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 540:	00001301 	andeq	r1, r0, r1, lsl #6
 544:	03000d17 	movweq	r0, #3351	; 0xd17
 548:	3b0b3a0e 	blcc	2ced88 <__bss_end+0x2c5dbc>
 54c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 550:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 554:	1800000b 	stmdane	r0, {r0, r1, r3}
 558:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 55c:	0b3a0e03 	bleq	e83d70 <__bss_end+0xe7ada4>
 560:	0b390b3b 	bleq	e43254 <__bss_end+0xe3a288>
 564:	0b320e6e 	bleq	c83f24 <__bss_end+0xc7af58>
 568:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 56c:	00001301 	andeq	r1, r0, r1, lsl #6
 570:	3f012e19 	svccc	0x00012e19
 574:	3a0e0319 	bcc	3811e0 <__bss_end+0x378214>
 578:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 57c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 580:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 584:	00136419 	andseq	r6, r3, r9, lsl r4
 588:	01151a00 	tsteq	r5, r0, lsl #20
 58c:	13641349 	cmnne	r4, #603979777	; 0x24000001
 590:	00001301 	andeq	r1, r0, r1, lsl #6
 594:	1d001f1b 	stcne	15, cr1, [r0, #-108]	; 0xffffff94
 598:	00134913 	andseq	r4, r3, r3, lsl r9
 59c:	00101c00 	andseq	r1, r0, r0, lsl #24
 5a0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5a4:	0f1d0000 	svceq	0x001d0000
 5a8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 5ac:	00341e00 	eorseq	r1, r4, r0, lsl #28
 5b0:	0b3a0e03 	bleq	e83dc4 <__bss_end+0xe7adf8>
 5b4:	0b390b3b 	bleq	e432a8 <__bss_end+0xe3a2dc>
 5b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5bc:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
 5c0:	03193f01 	tsteq	r9, #1, 30
 5c4:	3b0b3a0e 	blcc	2cee04 <__bss_end+0x2c5e38>
 5c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5cc:	1113490e 	tstne	r3, lr, lsl #18
 5d0:	40061201 	andmi	r1, r6, r1, lsl #4
 5d4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 5d8:	00001301 	andeq	r1, r0, r1, lsl #6
 5dc:	03000520 	movweq	r0, #1312	; 0x520
 5e0:	3b0b3a0e 	blcc	2cee20 <__bss_end+0x2c5e54>
 5e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5e8:	00180213 	andseq	r0, r8, r3, lsl r2
 5ec:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
 5f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f4:	0b3b0b3a 	bleq	ec32e4 <__bss_end+0xeba318>
 5f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5fc:	01111349 	tsteq	r1, r9, asr #6
 600:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 604:	01194297 			; <UNDEFINED> instruction: 0x01194297
 608:	22000013 	andcs	r0, r0, #19
 60c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 610:	0b3b0b3a 	bleq	ec3300 <__bss_end+0xeba334>
 614:	13490b39 	movtne	r0, #39737	; 0x9b39
 618:	00001802 	andeq	r1, r0, r2, lsl #16
 61c:	3f012e23 	svccc	0x00012e23
 620:	3a0e0319 	bcc	38128c <__bss_end+0x3782c0>
 624:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 628:	110e6e0b 	tstne	lr, fp, lsl #28
 62c:	40061201 	andmi	r1, r6, r1, lsl #4
 630:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 634:	00001301 	andeq	r1, r0, r1, lsl #6
 638:	3f002e24 	svccc	0x00002e24
 63c:	3a0e0319 	bcc	3812a8 <__bss_end+0x3782dc>
 640:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 644:	110e6e0b 	tstne	lr, fp, lsl #28
 648:	40061201 	andmi	r1, r6, r1, lsl #4
 64c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 650:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 654:	03193f01 	tsteq	r9, #1, 30
 658:	3b0b3a0e 	blcc	2cee98 <__bss_end+0x2c5ecc>
 65c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 660:	1113490e 	tstne	r3, lr, lsl #18
 664:	40061201 	andmi	r1, r6, r1, lsl #4
 668:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 66c:	01000000 	mrseq	r0, (UNDEF: 0)
 670:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 674:	0e030b13 	vmoveq.32	d3[0], r0
 678:	01110e1b 	tsteq	r1, fp, lsl lr
 67c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 680:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 684:	00130101 	andseq	r0, r3, r1, lsl #2
 688:	00340300 	eorseq	r0, r4, r0, lsl #6
 68c:	0b3a0e03 	bleq	e83ea0 <__bss_end+0xe7aed4>
 690:	0b390b3b 	bleq	e43384 <__bss_end+0xe3a3b8>
 694:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 698:	00000a1c 	andeq	r0, r0, ip, lsl sl
 69c:	3a003a04 	bcc	eeb4 <__bss_end+0x5ee8>
 6a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6a4:	0013180b 	andseq	r1, r3, fp, lsl #16
 6a8:	01010500 	tsteq	r1, r0, lsl #10
 6ac:	13011349 	movwne	r1, #4937	; 0x1349
 6b0:	21060000 	mrscs	r0, (UNDEF: 6)
 6b4:	2f134900 	svccs	0x00134900
 6b8:	0700000b 	streq	r0, [r0, -fp]
 6bc:	13490026 	movtne	r0, #36902	; 0x9026
 6c0:	24080000 	strcs	r0, [r8], #-0
 6c4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 6c8:	000e030b 	andeq	r0, lr, fp, lsl #6
 6cc:	00340900 	eorseq	r0, r4, r0, lsl #18
 6d0:	00001347 	andeq	r1, r0, r7, asr #6
 6d4:	3f012e0a 	svccc	0x00012e0a
 6d8:	3a0e0319 	bcc	381344 <__bss_end+0x378378>
 6dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e0:	110e6e0b 	tstne	lr, fp, lsl #28
 6e4:	40061201 	andmi	r1, r6, r1, lsl #4
 6e8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6ec:	00001301 	andeq	r1, r0, r1, lsl #6
 6f0:	0300050b 	movweq	r0, #1291	; 0x50b
 6f4:	3b0b3a08 	blcc	2cef1c <__bss_end+0x2c5f50>
 6f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6fc:	00180213 	andseq	r0, r8, r3, lsl r2
 700:	00340c00 	eorseq	r0, r4, r0, lsl #24
 704:	0b3a0e03 	bleq	e83f18 <__bss_end+0xe7af4c>
 708:	0b390b3b 	bleq	e433fc <__bss_end+0xe3a430>
 70c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 710:	0b0d0000 	bleq	340718 <__bss_end+0x33774c>
 714:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 718:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 71c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 720:	0b3b0b3a 	bleq	ec3410 <__bss_end+0xeba444>
 724:	13490b39 	movtne	r0, #39737	; 0x9b39
 728:	00001802 	andeq	r1, r0, r2, lsl #16
 72c:	0b000f0f 	bleq	4370 <shift+0x4370>
 730:	0013490b 	andseq	r4, r3, fp, lsl #18
 734:	00261000 	eoreq	r1, r6, r0
 738:	0f110000 	svceq	0x00110000
 73c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 740:	00241200 	eoreq	r1, r4, r0, lsl #4
 744:	0b3e0b0b 	bleq	f83378 <__bss_end+0xf7a3ac>
 748:	00000803 	andeq	r0, r0, r3, lsl #16
 74c:	03000513 	movweq	r0, #1299	; 0x513
 750:	3b0b3a0e 	blcc	2cef90 <__bss_end+0x2c5fc4>
 754:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 758:	00180213 	andseq	r0, r8, r3, lsl r2
 75c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 760:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 764:	0b3b0b3a 	bleq	ec3454 <__bss_end+0xeba488>
 768:	0e6e0b39 	vmoveq.8	d14[5], r0
 76c:	01111349 	tsteq	r1, r9, asr #6
 770:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 774:	01194297 			; <UNDEFINED> instruction: 0x01194297
 778:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 77c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 780:	0b3a0e03 	bleq	e83f94 <__bss_end+0xe7afc8>
 784:	0b390b3b 	bleq	e43478 <__bss_end+0xe3a4ac>
 788:	01110e6e 	tsteq	r1, lr, ror #28
 78c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 790:	00194296 	mulseq	r9, r6, r2
 794:	11010000 	mrsne	r0, (UNDEF: 1)
 798:	11061000 	mrsne	r1, (UNDEF: 6)
 79c:	03011201 	movweq	r1, #4609	; 0x1201
 7a0:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 7a4:	0005130e 	andeq	r1, r5, lr, lsl #6
 7a8:	11010000 	mrsne	r0, (UNDEF: 1)
 7ac:	11061000 	mrsne	r1, (UNDEF: 6)
 7b0:	03011201 	movweq	r1, #4609	; 0x1201
 7b4:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 7b8:	0005130e 	andeq	r1, r5, lr, lsl #6
 7bc:	11010000 	mrsne	r0, (UNDEF: 1)
 7c0:	130e2501 	movwne	r2, #58625	; 0xe501
 7c4:	1b0e030b 	blne	3813f8 <__bss_end+0x37842c>
 7c8:	0017100e 	andseq	r1, r7, lr
 7cc:	00240200 	eoreq	r0, r4, r0, lsl #4
 7d0:	0b3e0b0b 	bleq	f83404 <__bss_end+0xf7a438>
 7d4:	00000803 	andeq	r0, r0, r3, lsl #16
 7d8:	0b002403 	bleq	97ec <__bss_end+0x820>
 7dc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 7e0:	0400000e 	streq	r0, [r0], #-14
 7e4:	0e030104 	adfeqs	f0, f3, f4
 7e8:	0b0b0b3e 	bleq	2c34e8 <__bss_end+0x2ba51c>
 7ec:	0b3a1349 	bleq	e85518 <__bss_end+0xe7c54c>
 7f0:	0b390b3b 	bleq	e434e4 <__bss_end+0xe3a518>
 7f4:	00001301 	andeq	r1, r0, r1, lsl #6
 7f8:	03002805 	movweq	r2, #2053	; 0x805
 7fc:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 800:	01130600 	tsteq	r3, r0, lsl #12
 804:	0b0b0e03 	bleq	2c4018 <__bss_end+0x2bb04c>
 808:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 80c:	13010b39 	movwne	r0, #6969	; 0x1b39
 810:	0d070000 	stceq	0, cr0, [r7, #-0]
 814:	3a0e0300 	bcc	38141c <__bss_end+0x378450>
 818:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 81c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 820:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 824:	13490026 	movtne	r0, #36902	; 0x9026
 828:	01090000 	mrseq	r0, (UNDEF: 9)
 82c:	01134901 	tsteq	r3, r1, lsl #18
 830:	0a000013 	beq	884 <shift+0x884>
 834:	13490021 	movtne	r0, #36897	; 0x9021
 838:	00000b2f 	andeq	r0, r0, pc, lsr #22
 83c:	0300340b 	movweq	r3, #1035	; 0x40b
 840:	3b0b3a0e 	blcc	2cf080 <__bss_end+0x2c60b4>
 844:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 848:	000a1c13 	andeq	r1, sl, r3, lsl ip
 84c:	00150c00 	andseq	r0, r5, r0, lsl #24
 850:	00001927 	andeq	r1, r0, r7, lsr #18
 854:	0b000f0d 	bleq	4490 <shift+0x4490>
 858:	0013490b 	andseq	r4, r3, fp, lsl #18
 85c:	01040e00 	tsteq	r4, r0, lsl #28
 860:	0b3e0e03 	bleq	f84074 <__bss_end+0xf7b0a8>
 864:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 868:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 86c:	13010b39 	movwne	r0, #6969	; 0x1b39
 870:	160f0000 	strne	r0, [pc], -r0
 874:	3a0e0300 	bcc	38147c <__bss_end+0x3784b0>
 878:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 87c:	0013490b 	andseq	r4, r3, fp, lsl #18
 880:	00211000 	eoreq	r1, r1, r0
 884:	34110000 	ldrcc	r0, [r1], #-0
 888:	3a0e0300 	bcc	381490 <__bss_end+0x3784c4>
 88c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 890:	3f13490b 	svccc	0x0013490b
 894:	00193c19 	andseq	r3, r9, r9, lsl ip
 898:	00341200 	eorseq	r1, r4, r0, lsl #4
 89c:	0b3a1347 	bleq	e855c0 <__bss_end+0xe7c5f4>
 8a0:	0b39053b 	bleq	e41d94 <__bss_end+0xe38dc8>
 8a4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 8a8:	Address 0x00000000000008a8 is out of bounds.


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
  74:	000001a0 	andeq	r0, r0, r0, lsr #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0ac10002 	beq	ff040094 <__bss_end+0xff0370c8>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083cc 	andeq	r8, r0, ip, asr #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	15e40002 	strbne	r0, [r4, #2]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008828 	andeq	r8, r0, r8, lsr #16
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	19160002 	ldmdbne	r6, {r1}
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008ce0 	andeq	r8, r0, r0, ror #25
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	193c0002 	ldmdbne	ip!, {r1}
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008eec 	andeq	r8, r0, ip, ror #29
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	19620002 	stmdbne	r2!, {r1}^
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff6d11>
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
      44:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe80 <__bss_end+0xffff6eb4>
      48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      50:	4b2f7372 	blmi	bdce20 <__bss_end+0xbd3e54>
      54:	2f616275 	svccs	0x00616275
      58:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      5c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      60:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      64:	614d6f72 	hvcvs	55026	; 0xd6f2
      68:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffafc <__bss_end+0xffff6b30>
      6c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      70:	2f73656c 	svccs	0x0073656c
      74:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
      78:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffa1c <__bss_end+0xffff6a50>
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
     114:	2b6b7a36 	blcs	1ade9f4 <__bss_end+0x1ad5a28>
     118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     11c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     120:	304f2d20 	subcc	r2, pc, r0, lsr #26
     124:	304f2d20 	subcc	r2, pc, r0, lsr #26
     128:	625f5f00 	subsvs	r5, pc, #0, 30
     12c:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffdc1 <__bss_end+0xffff6df5>
     130:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     134:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     138:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff70 <__bss_end+0xffff6fa4>
     13c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     140:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     144:	4b2f7372 	blmi	bdcf14 <__bss_end+0xbd3f48>
     148:	2f616275 	svccs	0x00616275
     14c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     150:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     154:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <__bss_end+0xffff6c24>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     16c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb10 <__bss_end+0xffff6b44>
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
     21c:	4b2f7372 	blmi	bdcfec <__bss_end+0xbd4020>
     220:	2f616275 	svccs	0x00616275
     224:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     228:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     22c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     230:	614d6f72 	hvcvs	55026	; 0xd6f2
     234:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffcc8 <__bss_end+0xffff6cfc>
     238:	706d6178 	rsbvc	r6, sp, r8, ror r1
     23c:	2f73656c 	svccs	0x0073656c
     240:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     244:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffbe8 <__bss_end+0xffff6c1c>
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
     3ac:	63695400 	cmnvs	r9, #0, 8
     3b0:	6f435f6b 	svcvs	0x00435f6b
     3b4:	00746e75 	rsbseq	r6, r4, r5, ror lr
     3b8:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     3bc:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     3c0:	4f006574 	svcmi	0x00006574
     3c4:	006e6570 	rsbeq	r6, lr, r0, ror r5
     3c8:	314e5a5f 	cmpcc	lr, pc, asr sl
     3cc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3d4:	614d5f73 	hvcvs	54771	; 0xd5f3
     3d8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     3dc:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     3e0:	6b636f6c 	blvs	18dc198 <__bss_end+0x18d31cc>
     3e4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     3e8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     3ec:	6f72505f 	svcvs	0x0072505f
     3f0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     3f4:	70007645 	andvc	r7, r0, r5, asr #12
     3f8:	00766572 	rsbseq	r6, r6, r2, ror r5
     3fc:	314e5a5f 	cmpcc	lr, pc, asr sl
     400:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     404:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     408:	614d5f73 	hvcvs	54771	; 0xd5f3
     40c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     410:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     414:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     418:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     41c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     420:	31504573 	cmpcc	r0, r3, ror r5
     424:	61545432 	cmpvs	r4, r2, lsr r4
     428:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     42c:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     430:	61660074 	smcvs	24580	; 0x6004
     434:	55007473 	strpl	r7, [r0, #-1139]	; 0xfffffb8d
     438:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     43c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     440:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     444:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     448:	53420074 	movtpl	r0, #8308	; 0x2074
     44c:	425f3243 	subsmi	r3, pc, #805306372	; 0x30000004
     450:	00657361 	rsbeq	r7, r5, r1, ror #6
     454:	6f72506d 	svcvs	0x0072506d
     458:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     45c:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     460:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     464:	5f006461 	svcpl	0x00006461
     468:	314b4e5a 	cmpcc	fp, sl, asr lr
     46c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     470:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     474:	614d5f73 	hvcvs	54771	; 0xd5f3
     478:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     47c:	47393172 			; <UNDEFINED> instruction: 0x47393172
     480:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     484:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     488:	505f746e 	subspl	r7, pc, lr, ror #8
     48c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     490:	76457373 			; <UNDEFINED> instruction: 0x76457373
     494:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     498:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     49c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4a4:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4a8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     4ac:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     4b0:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     4b4:	00657361 	rsbeq	r7, r5, r1, ror #6
     4b8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     4bc:	6f72505f 	svcvs	0x0072505f
     4c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4c4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     4c8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     4cc:	61655200 	cmnvs	r5, r0, lsl #4
     4d0:	63410064 	movtvs	r0, #4196	; 0x1064
     4d4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     4d8:	6f72505f 	svcvs	0x0072505f
     4dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4e0:	756f435f 	strbvc	r4, [pc, #-863]!	; 189 <shift+0x189>
     4e4:	4300746e 	movwmi	r7, #1134	; 0x46e
     4e8:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     4ec:	72505f65 	subsvc	r5, r0, #404	; 0x194
     4f0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4f4:	74730073 	ldrbtvc	r0, [r3], #-115	; 0xffffff8d
     4f8:	00657461 	rsbeq	r7, r5, r1, ror #8
     4fc:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     500:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     504:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     508:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     50c:	55410068 	strbpl	r0, [r1, #-104]	; 0xffffff98
     510:	61425f58 	cmpvs	r2, r8, asr pc
     514:	47006573 	smlsdxmi	r0, r3, r5, r6
     518:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     51c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     520:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     524:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     528:	6544006f 	strbvs	r0, [r4, #-111]	; 0xffffff91
     52c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     530:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ffffffca <__bss_end+0xffff6ffe>
     534:	6168636e 	cmnvs	r8, lr, ror #6
     538:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     53c:	72504300 	subsvc	r4, r0, #0, 6
     540:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     544:	614d5f73 	hvcvs	54771	; 0xd5f3
     548:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     54c:	5a5f0072 	bpl	17c071c <__bss_end+0x17b7750>
     550:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     554:	636f7250 	cmnvs	pc, #80, 4
     558:	5f737365 	svcpl	0x00737365
     55c:	616e614d 	cmnvs	lr, sp, asr #2
     560:	31726567 	cmncc	r2, r7, ror #10
     564:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     568:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     56c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     570:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     574:	456f666e 	strbmi	r6, [pc, #-1646]!	; ffffff0e <__bss_end+0xffff6f42>
     578:	474e3032 	smlaldxmi	r3, lr, r2, r0
     57c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     580:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     584:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     588:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     58c:	76506570 			; <UNDEFINED> instruction: 0x76506570
     590:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     594:	50433631 	subpl	r3, r3, r1, lsr r6
     598:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     59c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3d8 <shift+0x3d8>
     5a0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5a4:	31327265 	teqcc	r2, r5, ror #4
     5a8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5ac:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     5b0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     5b4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     5b8:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     5bc:	33324549 	teqcc	r2, #306184192	; 0x12400000
     5c0:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     5c4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     5c8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     5cc:	5f6d6574 	svcpl	0x006d6574
     5d0:	76726553 			; <UNDEFINED> instruction: 0x76726553
     5d4:	6a656369 	bvs	1959380 <__bss_end+0x19503b4>
     5d8:	31526a6a 	cmpcc	r2, sl, ror #20
     5dc:	57535431 	smmlarpl	r3, r1, r4, r5
     5e0:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     5e4:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     5e8:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     5ec:	5f64656e 	svcpl	0x0064656e
     5f0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     5f4:	6f4e0073 	svcvs	0x004e0073
     5f8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     5fc:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     600:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     604:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     608:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     60c:	61654400 	cmnvs	r5, r0, lsl #8
     610:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     614:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     618:	00307262 	eorseq	r7, r0, r2, ror #4
     61c:	314e5a5f 	cmpcc	lr, pc, asr sl
     620:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     624:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     628:	614d5f73 	hvcvs	54771	; 0xd5f3
     62c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     630:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     634:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     638:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     63c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     640:	006a4573 	rsbeq	r4, sl, r3, ror r5
     644:	5f746547 	svcpl	0x00746547
     648:	00444950 	subeq	r4, r4, r0, asr r9
     64c:	30435342 	subcc	r5, r3, r2, asr #6
     650:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     654:	6f6e0065 	svcvs	0x006e0065
     658:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     65c:	645f6465 	ldrbvs	r6, [pc], #-1125	; 664 <shift+0x664>
     660:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     664:	00656e69 	rsbeq	r6, r5, r9, ror #28
     668:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     66c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     670:	6f435f74 	svcvs	0x00435f74
     674:	6f72746e 	svcvs	0x0072746e
     678:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     67c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     680:	53420065 	movtpl	r0, #8293	; 0x2065
     684:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     688:	00657361 	rsbeq	r7, r5, r1, ror #6
     68c:	5f78614d 	svcpl	0x0078614d
     690:	636f7250 	cmnvs	pc, #80, 4
     694:	5f737365 	svcpl	0x00737365
     698:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     69c:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     6a0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6a4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6a8:	50433631 	subpl	r3, r3, r1, lsr r6
     6ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6b0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4ec <shift+0x4ec>
     6b4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6b8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     6bc:	616d6e55 	cmnvs	sp, r5, asr lr
     6c0:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     6c4:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     6c8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6cc:	6a45746e 	bvs	115d88c <__bss_end+0x11548c0>
     6d0:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     6d4:	61425f47 	cmpvs	r2, r7, asr #30
     6d8:	61006573 	tstvs	r0, r3, ror r5
     6dc:	6e656373 	mcrvs	3, 3, r6, cr5, cr3, {3}
     6e0:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     6e4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     6e8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     6ec:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     6f0:	6f72505f 	svcvs	0x0072505f
     6f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6f8:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     6fc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     700:	6f545f65 	svcvs	0x00545f65
     704:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     708:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     70c:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     710:	32686374 	rsbcc	r6, r8, #116, 6	; 0xd0000001
     714:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     718:	6f4e0065 	svcvs	0x004e0065
     71c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     720:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     724:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     728:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     72c:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     730:	5f656c64 	svcpl	0x00656c64
     734:	636f7250 	cmnvs	pc, #80, 4
     738:	5f737365 	svcpl	0x00737365
     73c:	00495753 	subeq	r5, r9, r3, asr r7
     740:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     744:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     748:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     74c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     750:	5300746e 	movwpl	r7, #1134	; 0x46e
     754:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     758:	5f656c75 	svcpl	0x00656c75
     75c:	00464445 	subeq	r4, r6, r5, asr #8
     760:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     764:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     768:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     76c:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     770:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     774:	7065656c 	rsbvc	r6, r5, ip, ror #10
     778:	73696400 	cmnvc	r9, #0, 8
     77c:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     780:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     784:	6f620065 	svcvs	0x00620065
     788:	6d006c6f 	stcvs	12, cr6, [r0, #-444]	; 0xfffffe44
     78c:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     790:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     794:	6f6c4200 	svcvs	0x006c4200
     798:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     79c:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     7a0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     7a4:	5f646568 	svcpl	0x00646568
     7a8:	6f666e49 	svcvs	0x00666e49
     7ac:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     7b0:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     7b4:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     7b8:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     7bc:	6b736154 	blvs	1cd8d14 <__bss_end+0x1ccfd48>
     7c0:	6174535f 	cmnvs	r4, pc, asr r3
     7c4:	73006574 	movwvc	r6, #1396	; 0x574
     7c8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     7cc:	756f635f 	strbvc	r6, [pc, #-863]!	; 475 <shift+0x475>
     7d0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     7d4:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     7d8:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     7dc:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     7e0:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     7e4:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     7e8:	65007974 	strvs	r7, [r0, #-2420]	; 0xfffff68c
     7ec:	5f746978 	svcpl	0x00746978
     7f0:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     7f4:	63536d00 	cmpvs	r3, #0, 26
     7f8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     7fc:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     800:	4700636e 	strmi	r6, [r0, -lr, ror #6]
     804:	5f4f4950 	svcpl	0x004f4950
     808:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     80c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     810:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     814:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     818:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     81c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     820:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     824:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     828:	65440079 	strbvs	r0, [r4, #-121]	; 0xffffff87
     82c:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     830:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     834:	5f6b636f 	svcpl	0x006b636f
     838:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     83c:	636f4c00 	cmnvs	pc, #0, 24
     840:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     844:	6b636f6c 	blvs	18dc5fc <__bss_end+0x18d3630>
     848:	4c006465 	cfstrsmi	mvf6, [r0], {101}	; 0x65
     84c:	5f6b636f 	svcpl	0x006b636f
     850:	6b636f4c 	blvs	18dc588 <__bss_end+0x18d35bc>
     854:	52006465 	andpl	r6, r0, #1694498816	; 0x65000000
     858:	5f646165 	svcpl	0x00646165
     85c:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     860:	6f5a0065 	svcvs	0x005a0065
     864:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     868:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     86c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     870:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     874:	006f666e 	rsbeq	r6, pc, lr, ror #12
     878:	314e5a5f 	cmpcc	lr, pc, asr sl
     87c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     880:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     884:	614d5f73 	hvcvs	54771	; 0xd5f3
     888:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     88c:	63533872 	cmpvs	r3, #7471104	; 0x720000
     890:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     894:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     898:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     89c:	50433631 	subpl	r3, r3, r1, lsr r6
     8a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8a4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 6e0 <shift+0x6e0>
     8a8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8ac:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     8b0:	5f70614d 	svcpl	0x0070614d
     8b4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8b8:	5f6f545f 	svcpl	0x006f545f
     8bc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     8c0:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     8c4:	46493550 			; <UNDEFINED> instruction: 0x46493550
     8c8:	00656c69 	rsbeq	r6, r5, r9, ror #24
     8cc:	5078614d 	rsbspl	r6, r8, sp, asr #2
     8d0:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     8d4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     8d8:	6e750068 	cdpvs	0, 7, cr0, cr5, cr8, {3}
     8dc:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     8e0:	63206465 			; <UNDEFINED> instruction: 0x63206465
     8e4:	00726168 	rsbseq	r6, r2, r8, ror #2
     8e8:	314e5a5f 	cmpcc	lr, pc, asr sl
     8ec:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8f0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8f4:	614d5f73 	hvcvs	54771	; 0xd5f3
     8f8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8fc:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     900:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     904:	5f656c75 	svcpl	0x00656c75
     908:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     90c:	50470076 	subpl	r0, r7, r6, ror r0
     910:	505f4f49 	subspl	r4, pc, r9, asr #30
     914:	435f6e69 	cmpmi	pc, #1680	; 0x690
     918:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     91c:	6f687300 	svcvs	0x00687300
     920:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     924:	2f00746e 	svccs	0x0000746e
     928:	2f746e6d 	svccs	0x00746e6d
     92c:	73552f63 	cmpvc	r5, #396	; 0x18c
     930:	2f737265 	svccs	0x00737265
     934:	6162754b 	cmnvs	r2, fp, asr #10
     938:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     93c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     940:	5a2f7374 	bpl	bdd718 <__bss_end+0xbd474c>
     944:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 7b8 <shift+0x7b8>
     948:	2f657461 	svccs	0x00657461
     94c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     950:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     954:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     958:	2f666465 	svccs	0x00666465
     95c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     960:	63617073 	cmnvs	r1, #115	; 0x73
     964:	6f632f65 	svcvs	0x00632f65
     968:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     96c:	61745f72 	cmnvs	r4, r2, ror pc
     970:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     974:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     978:	00707063 	rsbseq	r7, r0, r3, rrx
     97c:	61766e49 	cmnvs	r6, r9, asr #28
     980:	5f64696c 	svcpl	0x0064696c
     984:	006e6950 	rsbeq	r6, lr, r0, asr r9
     988:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     98c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     990:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     994:	00657361 	rsbeq	r7, r5, r1, ror #6
     998:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     99c:	00676e69 	rsbeq	r6, r7, r9, ror #28
     9a0:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     9a4:	745f3233 	ldrbvc	r3, [pc], #-563	; 9ac <shift+0x9ac>
     9a8:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     9ac:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9b0:	61545f74 	cmpvs	r4, r4, ror pc
     9b4:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     9b8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     9bc:	5f757063 	svcpl	0x00757063
     9c0:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     9c4:	00747865 	rsbseq	r7, r4, r5, ror #16
     9c8:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     9cc:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     9d0:	6c730079 	ldclvs	0, cr0, [r3], #-484	; 0xfffffe1c
     9d4:	5f706565 	svcpl	0x00706565
     9d8:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     9dc:	5a5f0072 	bpl	17c0bac <__bss_end+0x17b7be0>
     9e0:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     9e4:	6f725043 	svcvs	0x00725043
     9e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9ec:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9f4:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     9f8:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     9fc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a00:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a04:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     a08:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     a0c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a10:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     a14:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a18:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a1c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a20:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a24:	50433631 	subpl	r3, r3, r1, lsr r6
     a28:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a2c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 868 <shift+0x868>
     a30:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     a34:	31317265 	teqcc	r1, r5, ror #4
     a38:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     a3c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     a40:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     a44:	61740076 	cmnvs	r4, r6, ror r0
     a48:	4e006b73 	vmovmi.16	d0[1], r6
     a4c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     a50:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     a54:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a58:	63530073 	cmpvs	r3, #115	; 0x73
     a5c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     a60:	5f00656c 	svcpl	0x0000656c
     a64:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a68:	6f725043 	svcvs	0x00725043
     a6c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a70:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a74:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a78:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     a7c:	5f686374 	svcpl	0x00686374
     a80:	50456f54 	subpl	r6, r5, r4, asr pc
     a84:	50433831 	subpl	r3, r3, r1, lsr r8
     a88:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a8c:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     a90:	5f747369 	svcpl	0x00747369
     a94:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     a98:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     a9c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     aa0:	52525f65 	subspl	r5, r2, #404	; 0x194
     aa4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     aa8:	50433631 	subpl	r3, r3, r1, lsr r6
     aac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ab0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 8ec <shift+0x8ec>
     ab4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ab8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     abc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     ac0:	505f656c 	subspl	r6, pc, ip, ror #10
     ac4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ac8:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     acc:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     ad0:	57534e30 	smmlarpl	r3, r0, lr, r4
     ad4:	72505f49 	subsvc	r5, r0, #292	; 0x124
     ad8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     adc:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     ae0:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     ae4:	6a6a6a65 	bvs	1a9b480 <__bss_end+0x1a924b4>
     ae8:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     aec:	5f495753 	svcpl	0x00495753
     af0:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     af4:	6100746c 	tstvs	r0, ip, ror #8
     af8:	00766772 	rsbseq	r6, r6, r2, ror r7
     afc:	314e5a5f 	cmpcc	lr, pc, asr sl
     b00:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b04:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b08:	614d5f73 	hvcvs	54771	; 0xd5f3
     b0c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     b10:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
     b14:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     b18:	72505f65 	subsvc	r5, r0, #404	; 0x194
     b1c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b20:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
     b24:	5300626a 	movwpl	r6, #618	; 0x26a
     b28:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     b2c:	6f545f68 	svcvs	0x00545f68
     b30:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     b34:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     b38:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     b3c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     b40:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     b44:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     b48:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     b4c:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     b50:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     b54:	00656c64 	rsbeq	r6, r5, r4, ror #24
     b58:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     b5c:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     b60:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     b64:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     b68:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b6c:	6c430073 	mcrrvs	0, 7, r0, r3, cr3
     b70:	0065736f 	rsbeq	r7, r5, pc, ror #6
     b74:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     b78:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     b7c:	31686374 	smccc	34356	; 0x8634
     b80:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     b84:	72570065 	subsvc	r0, r7, #101	; 0x65
     b88:	5f657469 	svcpl	0x00657469
     b8c:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     b90:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     b94:	5f00646c 	svcpl	0x0000646c
     b98:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b9c:	6f725043 	svcvs	0x00725043
     ba0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ba4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     ba8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     bac:	76453443 	strbvc	r3, [r5], -r3, asr #8
     bb0:	72655400 	rsbvc	r5, r5, #0, 8
     bb4:	616e696d 	cmnvs	lr, sp, ror #18
     bb8:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     bbc:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     bc0:	6f6c6300 	svcvs	0x006c6300
     bc4:	53006573 	movwpl	r6, #1395	; 0x573
     bc8:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     bcc:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
     bd0:	00657669 	rsbeq	r7, r5, r9, ror #12
     bd4:	76746572 			; <UNDEFINED> instruction: 0x76746572
     bd8:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
     bdc:	00727563 	rsbseq	r7, r2, r3, ror #10
     be0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     be4:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     be8:	5f006d75 	svcpl	0x00006d75
     bec:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     bf0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     bf4:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     bf8:	0076646c 	rsbseq	r6, r6, ip, ror #8
     bfc:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
     c00:	5f746573 	svcpl	0x00746573
     c04:	6b736174 	blvs	1cd91dc <__bss_end+0x1cd0210>
     c08:	6165645f 	cmnvs	r5, pc, asr r4
     c0c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     c10:	77006a65 	strvc	r6, [r0, -r5, ror #20]
     c14:	00746961 	rsbseq	r6, r4, r1, ror #18
     c18:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     c1c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     c20:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     c24:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     c28:	552f632f 	strpl	r6, [pc, #-815]!	; 901 <shift+0x901>
     c2c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     c30:	62754b2f 	rsbsvs	r4, r5, #48128	; 0xbc00
     c34:	6f442f61 	svcvs	0x00442f61
     c38:	656d7563 	strbvs	r7, [sp, #-1379]!	; 0xfffffa9d
     c3c:	2f73746e 	svccs	0x0073746e
     c40:	6f72655a 	svcvs	0x0072655a
     c44:	6574614d 	ldrbvs	r6, [r4, #-333]!	; 0xfffffeb3
     c48:	6178652f 	cmnvs	r8, pc, lsr #10
     c4c:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     c50:	38312f73 	ldmdacc	r1!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp}
     c54:	6664652d 	strbtvs	r6, [r4], -sp, lsr #10
     c58:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     c5c:	2f62696c 	svccs	0x0062696c
     c60:	2f637273 	svccs	0x00637273
     c64:	66647473 			; <UNDEFINED> instruction: 0x66647473
     c68:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     c6c:	00707063 	rsbseq	r7, r0, r3, rrx
     c70:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
     c74:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     c78:	646f6374 	strbtvs	r6, [pc], #-884	; c80 <shift+0xc80>
     c7c:	63730065 	cmnvs	r3, #101	; 0x65
     c80:	5f646568 	svcpl	0x00646568
     c84:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     c88:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
     c8c:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     c90:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     c94:	7165725f 	cmnvc	r5, pc, asr r2
     c98:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     c9c:	5a5f0064 	bpl	17c0e34 <__bss_end+0x17b7e68>
     ca0:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
     ca4:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     ca8:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     cac:	6f72705f 	svcvs	0x0072705f
     cb0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     cb4:	756f635f 	strbvc	r6, [pc, #-863]!	; 95d <shift+0x95d>
     cb8:	0076746e 	rsbseq	r7, r6, lr, ror #8
     cbc:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
     cc0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     cc4:	72505f65 	subsvc	r5, r0, #404	; 0x194
     cc8:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
     ccc:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     cd0:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     cd4:	00736d61 	rsbseq	r6, r3, r1, ror #26
     cd8:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     cdc:	5f746567 	svcpl	0x00746567
     ce0:	6b636974 	blvs	18db2b8 <__bss_end+0x18d22ec>
     ce4:	756f635f 	strbvc	r6, [pc, #-863]!	; 98d <shift+0x98d>
     ce8:	0076746e 	rsbseq	r7, r6, lr, ror #8
     cec:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     cf0:	69440070 	stmdbvs	r4, {r4, r5, r6}^
     cf4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     cf8:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     cfc:	5f746e65 	svcpl	0x00746e65
     d00:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d04:	6f697463 	svcvs	0x00697463
     d08:	5a5f006e 	bpl	17c0ec8 <__bss_end+0x17b7efc>
     d0c:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     d10:	616e696d 	cmnvs	lr, sp, ror #18
     d14:	00696574 	rsbeq	r6, r9, r4, ror r5
     d18:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     d1c:	6f697461 	svcvs	0x00697461
     d20:	5a5f006e 	bpl	17c0ee0 <__bss_end+0x17b7f14>
     d24:	6f6c6335 	svcvs	0x006c6335
     d28:	006a6573 	rsbeq	r6, sl, r3, ror r5
     d2c:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     d30:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     d34:	66007664 	strvs	r7, [r0], -r4, ror #12
     d38:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     d3c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     d40:	2b2b4320 	blcs	ad19c8 <__bss_end+0xac89fc>
     d44:	31203431 			; <UNDEFINED> instruction: 0x31203431
     d48:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
     d4c:	30322031 	eorscc	r2, r2, r1, lsr r0
     d50:	36303132 			; <UNDEFINED> instruction: 0x36303132
     d54:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
     d58:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     d5c:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
     d60:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     d64:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     d68:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     d6c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     d70:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     d74:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     d78:	20706676 	rsbscs	r6, r0, r6, ror r6
     d7c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     d80:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     d84:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     d88:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     d8c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     d90:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     d94:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     d98:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     d9c:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     da0:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     da4:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     da8:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     dac:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     db0:	616d2d20 	cmnvs	sp, r0, lsr #26
     db4:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     db8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     dbc:	2b6b7a36 	blcs	1adf69c <__bss_end+0x1ad66d0>
     dc0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     dc4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     dc8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     dcc:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     dd0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     dd4:	6f6e662d 	svcvs	0x006e662d
     dd8:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     ddc:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     de0:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     de4:	6f6e662d 	svcvs	0x006e662d
     de8:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     dec:	72770069 	rsbsvc	r0, r7, #105	; 0x69
     df0:	00657469 	rsbeq	r7, r5, r9, ror #8
     df4:	6b636974 	blvs	18db3cc <__bss_end+0x18d2400>
     df8:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     dfc:	5f006e65 	svcpl	0x00006e65
     e00:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     e04:	4b506570 	blmi	141a3cc <__bss_end+0x1411400>
     e08:	4e006a63 	vmlsmi.f32	s12, s0, s7
     e0c:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     e10:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e14:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     e18:	76726573 			; <UNDEFINED> instruction: 0x76726573
     e1c:	00656369 	rsbeq	r6, r5, r9, ror #6
     e20:	5f746567 	svcpl	0x00746567
     e24:	6b636974 	blvs	18db3fc <__bss_end+0x18d2430>
     e28:	756f635f 	strbvc	r6, [pc, #-863]!	; ad1 <shift+0xad1>
     e2c:	7000746e 	andvc	r7, r0, lr, ror #8
     e30:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     e34:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     e38:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     e3c:	4b506a65 	blmi	141b7d8 <__bss_end+0x141280c>
     e40:	67006a63 	strvs	r6, [r0, -r3, ror #20]
     e44:	745f7465 	ldrbvc	r7, [pc], #-1125	; e4c <shift+0xe4c>
     e48:	5f6b7361 	svcpl	0x006b7361
     e4c:	6b636974 	blvs	18db424 <__bss_end+0x18d2458>
     e50:	6f745f73 	svcvs	0x00745f73
     e54:	6165645f 	cmnvs	r5, pc, asr r4
     e58:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e5c:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     e60:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e64:	2f00657a 	svccs	0x0000657a
     e68:	2f746e6d 	svccs	0x00746e6d
     e6c:	73552f63 	cmpvc	r5, #396	; 0x18c
     e70:	2f737265 	svccs	0x00737265
     e74:	6162754b 	cmnvs	r2, fp, asr #10
     e78:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     e7c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     e80:	5a2f7374 	bpl	bddc58 <__bss_end+0xbd4c8c>
     e84:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; cf8 <shift+0xcf8>
     e88:	2f657461 	svccs	0x00657461
     e8c:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     e90:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     e94:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     e98:	2f666465 	svccs	0x00666465
     e9c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     ea0:	65730064 	ldrbvs	r0, [r3, #-100]!	; 0xffffff9c
     ea4:	61745f74 	cmnvs	r4, r4, ror pc
     ea8:	645f6b73 	ldrbvs	r6, [pc], #-2931	; eb0 <shift+0xeb0>
     eac:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     eb0:	00656e69 	rsbeq	r6, r5, r9, ror #28
     eb4:	5f746547 	svcpl	0x00746547
     eb8:	61726150 	cmnvs	r2, r0, asr r1
     ebc:	5f00736d 	svcpl	0x0000736d
     ec0:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     ec4:	6a706565 	bvs	1c1a460 <__bss_end+0x1c11494>
     ec8:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     ecc:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     ed0:	6e69616d 	powvsez	f6, f1, #5.0
     ed4:	00676e69 	rsbeq	r6, r7, r9, ror #28
     ed8:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     edc:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 978 <shift+0x978>
     ee0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     ee4:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     ee8:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     eec:	5f006e6f 	svcpl	0x00006e6f
     ef0:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     ef4:	745f7465 	ldrbvc	r7, [pc], #-1125	; efc <shift+0xefc>
     ef8:	5f6b7361 	svcpl	0x006b7361
     efc:	6b636974 	blvs	18db4d4 <__bss_end+0x18d2508>
     f00:	6f745f73 	svcvs	0x00745f73
     f04:	6165645f 	cmnvs	r5, pc, asr r4
     f08:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     f0c:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     f10:	5f495753 	svcpl	0x00495753
     f14:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     f18:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     f1c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f20:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
     f24:	5a5f006d 	bpl	17c10e0 <__bss_end+0x17b8114>
     f28:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     f2c:	6a6a6a74 	bvs	1a9b904 <__bss_end+0x1a92938>
     f30:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f34:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     f38:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
     f3c:	434f494e 	movtmi	r4, #63822	; 0xf94e
     f40:	4f5f6c74 	svcmi	0x005f6c74
     f44:	61726570 	cmnvs	r2, r0, ror r5
     f48:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f4c:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
     f50:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     f54:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     f58:	00746e63 	rsbseq	r6, r4, r3, ror #28
     f5c:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     f60:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
     f64:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f68:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     f6c:	646f6d00 	strbtvs	r6, [pc], #-3328	; f74 <shift+0xf74>
     f70:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     f74:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     f78:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     f7c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     f80:	6a63506a 	bvs	18d5130 <__bss_end+0x18cc164>
     f84:	4f494e00 	svcmi	0x00494e00
     f88:	5f6c7443 	svcpl	0x006c7443
     f8c:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
     f90:	6f697461 	svcvs	0x00697461
     f94:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
     f98:	646f6374 	strbtvs	r6, [pc], #-884	; fa0 <shift+0xfa0>
     f9c:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
     fa0:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     fa4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     fa8:	6f72705f 	svcvs	0x0072705f
     fac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     fb0:	756f635f 	strbvc	r6, [pc, #-863]!	; c59 <shift+0xc59>
     fb4:	6600746e 	strvs	r7, [r0], -lr, ror #8
     fb8:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     fbc:	00656d61 	rsbeq	r6, r5, r1, ror #26
     fc0:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     fc4:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     fc8:	00646970 	rsbeq	r6, r4, r0, ror r9
     fcc:	6f345a5f 	svcvs	0x00345a5f
     fd0:	506e6570 	rsbpl	r6, lr, r0, ror r5
     fd4:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     fd8:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     fdc:	704f5f65 	subvc	r5, pc, r5, ror #30
     fe0:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; e54 <shift+0xe54>
     fe4:	0065646f 	rsbeq	r6, r5, pc, ror #8
     fe8:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
     fec:	65640074 	strbvs	r0, [r4, #-116]!	; 0xffffff8c
     ff0:	62007473 	andvs	r7, r0, #1929379840	; 0x73000000
     ff4:	6f72657a 	svcvs	0x0072657a
     ff8:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
     ffc:	00687467 	rsbeq	r7, r8, r7, ror #8
    1000:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1004:	6f72657a 	svcvs	0x0072657a
    1008:	00697650 	rsbeq	r7, r9, r0, asr r6
    100c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1010:	00797063 	rsbseq	r7, r9, r3, rrx
    1014:	61345a5f 	teqvs	r4, pc, asr sl
    1018:	50696f74 	rsbpl	r6, r9, r4, ror pc
    101c:	4300634b 	movwmi	r6, #843	; 0x34b
    1020:	43726168 	cmnmi	r2, #104, 2
    1024:	41766e6f 	cmnmi	r6, pc, ror #28
    1028:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    102c:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1030:	756f0074 	strbvc	r0, [pc, #-116]!	; fc4 <shift+0xfc4>
    1034:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1038:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    103c:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1040:	4b507970 	blmi	141f608 <__bss_end+0x141663c>
    1044:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1048:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    104c:	00797063 	rsbseq	r7, r9, r3, rrx
    1050:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1054:	5f006e65 	svcpl	0x00006e65
    1058:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    105c:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1060:	634b5070 	movtvs	r5, #45168	; 0xb070
    1064:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1068:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    106c:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1070:	4b506e65 	blmi	141ca0c <__bss_end+0x1413a40>
    1074:	74610063 	strbtvc	r0, [r1], #-99	; 0xffffff9d
    1078:	5f00696f 	svcpl	0x0000696f
    107c:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1080:	70636e72 	rsbvc	r6, r3, r2, ror lr
    1084:	50635079 	rsbpl	r5, r3, r9, ror r0
    1088:	0069634b 	rsbeq	r6, r9, fp, asr #6
    108c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1090:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1094:	6f6d656d 	svcvs	0x006d656d
    1098:	6d007972 	vstrvs.16	s14, [r0, #-228]	; 0xffffff1c	; <UNPREDICTABLE>
    109c:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    10a0:	74690063 	strbtvc	r0, [r9], #-99	; 0xffffff9d
    10a4:	2f00616f 	svccs	0x0000616f
    10a8:	2f746e6d 	svccs	0x00746e6d
    10ac:	73552f63 	cmpvc	r5, #396	; 0x18c
    10b0:	2f737265 	svccs	0x00737265
    10b4:	6162754b 	cmnvs	r2, fp, asr #10
    10b8:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
    10bc:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
    10c0:	5a2f7374 	bpl	bdde98 <__bss_end+0xbd4ecc>
    10c4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; f38 <shift+0xf38>
    10c8:	2f657461 	svccs	0x00657461
    10cc:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
    10d0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
    10d4:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
    10d8:	2f666465 	svccs	0x00666465
    10dc:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    10e0:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    10e4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    10e8:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    10ec:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    10f0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    10f4:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    10f8:	616f7469 	cmnvs	pc, r9, ror #8
    10fc:	6a63506a 	bvs	18d52ac <__bss_end+0x18cc2e0>
    1100:	2f2e2e00 	svccs	0x002e2e00
    1104:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1108:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    110c:	2f2e2e2f 	svccs	0x002e2e2f
    1110:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1060 <shift+0x1060>
    1114:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1118:	6f632f63 	svcvs	0x00632f63
    111c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1120:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1124:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1128:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    112c:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1130:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1134:	2f646c69 	svccs	0x00646c69
    1138:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    113c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1140:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1144:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1148:	59682d69 	stmdbpl	r8!, {r0, r3, r5, r6, r8, sl, fp, sp}^
    114c:	344b6766 	strbcc	r6, [fp], #-1894	; 0xfffff89a
    1150:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1154:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1158:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    115c:	61652d65 	cmnvs	r5, r5, ror #26
    1160:	312d6962 			; <UNDEFINED> instruction: 0x312d6962
    1164:	2d332e30 	ldccs	14, cr2, [r3, #-192]!	; 0xffffff40
    1168:	31323032 	teqcc	r2, r2, lsr r0
    116c:	2f37302e 	svccs	0x0037302e
    1170:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1174:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1178:	6f6e2d6d 	svcvs	0x006e2d6d
    117c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1180:	2f696261 	svccs	0x00696261
    1184:	2f6d7261 	svccs	0x006d7261
    1188:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    118c:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1190:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1194:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1198:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    119c:	20534120 	subscs	r4, r3, r0, lsr #2
    11a0:	37332e32 			; <UNDEFINED> instruction: 0x37332e32
    11a4:	61736900 	cmnvs	r3, r0, lsl #18
    11a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11ac:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    11b0:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    11b4:	61736900 	cmnvs	r3, r0, lsl #18
    11b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11bc:	7066765f 	rsbvc	r7, r6, pc, asr r6
    11c0:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    11c4:	6f630065 	svcvs	0x00630065
    11c8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    11cc:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    11d0:	0074616f 	rsbseq	r6, r4, pc, ror #2
    11d4:	5f617369 	svcpl	0x00617369
    11d8:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    11dc:	73690074 	cmnvc	r9, #116	; 0x74
    11e0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    11e4:	766d5f74 	uqsub16vc	r5, sp, r4
    11e8:	6c665f65 	stclvs	15, cr5, [r6], #-404	; 0xfffffe6c
    11ec:	0074616f 	rsbseq	r6, r4, pc, ror #2
    11f0:	5f617369 	svcpl	0x00617369
    11f4:	5f746962 	svcpl	0x00746962
    11f8:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    11fc:	61736900 	cmnvs	r3, r0, lsl #18
    1200:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1204:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1208:	61736900 	cmnvs	r3, r0, lsl #18
    120c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1210:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1214:	73690076 	cmnvc	r9, #118	; 0x76
    1218:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    121c:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1220:	5f6b7269 	svcpl	0x006b7269
    1224:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1228:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    122c:	5f656c69 	svcpl	0x00656c69
    1230:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    1234:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1238:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 109c <shift+0x109c>
    123c:	73690070 	cmnvc	r9, #112	; 0x70
    1240:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1244:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1248:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    124c:	61736900 	cmnvs	r3, r0, lsl #18
    1250:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1254:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1258:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    125c:	61736900 	cmnvs	r3, r0, lsl #18
    1260:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1264:	6f656e5f 	svcvs	0x00656e5f
    1268:	7369006e 	cmnvc	r9, #110	; 0x6e
    126c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1270:	66625f74 	uqsub16vs	r5, r2, r4
    1274:	46003631 			; <UNDEFINED> instruction: 0x46003631
    1278:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
    127c:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1280:	5046004d 	subpl	r0, r6, sp, asr #32
    1284:	5f524353 	svcpl	0x00524353
    1288:	76637a6e 	strbtvc	r7, [r3], -lr, ror #20
    128c:	455f6371 	ldrbmi	r6, [pc, #-881]	; f23 <shift+0xf23>
    1290:	004d554e 	subeq	r5, sp, lr, asr #10
    1294:	5f525056 	svcpl	0x00525056
    1298:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    129c:	69626600 	stmdbvs	r2!, {r9, sl, sp, lr}^
    12a0:	6d695f74 	stclvs	15, cr5, [r9, #-464]!	; 0xfffffe30
    12a4:	63696c70 	cmnvs	r9, #112, 24	; 0x7000
    12a8:	6f697461 	svcvs	0x00697461
    12ac:	3050006e 	subscc	r0, r0, lr, rrx
    12b0:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    12b4:	7369004d 	cmnvc	r9, #77	; 0x4d
    12b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12bc:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    12c0:	6f747079 	svcvs	0x00747079
    12c4:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    12c8:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    12cc:	2e303120 	rsfcssp	f3, f0, f0
    12d0:	20312e33 	eorscs	r2, r1, r3, lsr lr
    12d4:	31323032 	teqcc	r2, r2, lsr r0
    12d8:	31323630 	teqcc	r2, r0, lsr r6
    12dc:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    12e0:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    12e4:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
    12e8:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    12ec:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    12f0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    12f4:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    12f8:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    12fc:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1300:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1304:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1308:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    130c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1310:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1314:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1318:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    131c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1320:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1324:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1328:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    132c:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1330:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1334:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1338:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 11a8 <shift+0x11a8>
    133c:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1340:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1344:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1348:	20726f74 	rsbscs	r6, r2, r4, ror pc
    134c:	6f6e662d 	svcvs	0x006e662d
    1350:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1354:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1358:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    135c:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1360:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1364:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1368:	006e6564 	rsbeq	r6, lr, r4, ror #10
    136c:	5f617369 	svcpl	0x00617369
    1370:	5f746962 	svcpl	0x00746962
    1374:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1378:	6e6f6300 	cdpvs	3, 6, cr6, cr15, cr0, {0}
    137c:	73690073 	cmnvc	r9, #115	; 0x73
    1380:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1384:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1388:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    138c:	43504600 	cmpmi	r0, #0, 12
    1390:	5f535458 	svcpl	0x00535458
    1394:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1398:	61736900 	cmnvs	r3, r0, lsl #18
    139c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    13a4:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    13a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13ac:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1210 <shift+0x1210>
    13b0:	69006576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, sp, lr}
    13b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13b8:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    13bc:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    13c0:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    13c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13c8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    13cc:	70636564 	rsbvc	r6, r3, r4, ror #10
    13d0:	73690030 	cmnvc	r9, #48	; 0x30
    13d4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13d8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    13dc:	31706365 	cmncc	r0, r5, ror #6
    13e0:	61736900 	cmnvs	r3, r0, lsl #18
    13e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13e8:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    13ec:	00327063 	eorseq	r7, r2, r3, rrx
    13f0:	5f617369 	svcpl	0x00617369
    13f4:	5f746962 	svcpl	0x00746962
    13f8:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    13fc:	69003370 	stmdbvs	r0, {r4, r5, r6, r8, r9, ip, sp}
    1400:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1404:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1408:	70636564 	rsbvc	r6, r3, r4, ror #10
    140c:	73690034 	cmnvc	r9, #52	; 0x34
    1410:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1414:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1418:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    141c:	61736900 	cmnvs	r3, r0, lsl #18
    1420:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1424:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1428:	00367063 	eorseq	r7, r6, r3, rrx
    142c:	5f617369 	svcpl	0x00617369
    1430:	5f746962 	svcpl	0x00746962
    1434:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1438:	69003770 	stmdbvs	r0, {r4, r5, r6, r8, r9, sl, ip, sp}
    143c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1440:	615f7469 	cmpvs	pc, r9, ror #8
    1444:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1448:	7369006b 	cmnvc	r9, #107	; 0x6b
    144c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1450:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1454:	5f38766d 	svcpl	0x0038766d
    1458:	6d5f6d31 	ldclvs	13, cr6, [pc, #-196]	; 139c <shift+0x139c>
    145c:	006e6961 	rsbeq	r6, lr, r1, ror #18
    1460:	65746e61 	ldrbvs	r6, [r4, #-3681]!	; 0xfffff19f
    1464:	61736900 	cmnvs	r3, r0, lsl #18
    1468:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    146c:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1470:	6f6c0065 	svcvs	0x006c0065
    1474:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1478:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    147c:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    1480:	2f2e2e2f 	svccs	0x002e2e2f
    1484:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1488:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    148c:	2f2e2e2f 	svccs	0x002e2e2f
    1490:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1494:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1310 <shift+0x1310>
    1498:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    149c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    14a0:	61736900 	cmnvs	r3, r0, lsl #18
    14a4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14a8:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    14ac:	73690035 	cmnvc	r9, #53	; 0x35
    14b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14b4:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    14b8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    14bc:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    14c0:	6f6c2067 	svcvs	0x006c2067
    14c4:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    14c8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    14cc:	2064656e 	rsbcs	r6, r4, lr, ror #10
    14d0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    14d4:	5f617369 	svcpl	0x00617369
    14d8:	5f746962 	svcpl	0x00746962
    14dc:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    14e0:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    14e4:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    14e8:	69006472 	stmdbvs	r0, {r1, r4, r5, r6, sl, sp, lr}
    14ec:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14f0:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    14f4:	006d6d38 	rsbeq	r6, sp, r8, lsr sp
    14f8:	5f617369 	svcpl	0x00617369
    14fc:	5f746962 	svcpl	0x00746962
    1500:	645f7066 	ldrbvs	r7, [pc], #-102	; 1508 <shift+0x1508>
    1504:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    1508:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    150c:	615f7469 	cmpvs	pc, r9, ror #8
    1510:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1514:	69006d65 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
    1518:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    151c:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    1520:	00656170 	rsbeq	r6, r5, r0, ror r1
    1524:	5f6c6c61 	svcpl	0x006c6c61
    1528:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    152c:	5f646569 	svcpl	0x00646569
    1530:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    1534:	73690073 	cmnvc	r9, #115	; 0x73
    1538:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    153c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1540:	5f38766d 	svcpl	0x0038766d
    1544:	73690031 	cmnvc	r9, #49	; 0x31
    1548:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    154c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1550:	5f38766d 	svcpl	0x0038766d
    1554:	73690032 	cmnvc	r9, #50	; 0x32
    1558:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    155c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1560:	5f38766d 	svcpl	0x0038766d
    1564:	73690033 	cmnvc	r9, #51	; 0x33
    1568:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    156c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1570:	5f38766d 	svcpl	0x0038766d
    1574:	73690034 	cmnvc	r9, #52	; 0x34
    1578:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    157c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1580:	5f38766d 	svcpl	0x0038766d
    1584:	73690035 	cmnvc	r9, #53	; 0x35
    1588:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    158c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1590:	5f38766d 	svcpl	0x0038766d
    1594:	73690036 	cmnvc	r9, #54	; 0x36
    1598:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    159c:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    15a0:	61736900 	cmnvs	r3, r0, lsl #18
    15a4:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    15a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15ac:	73690073 	cmnvc	r9, #115	; 0x73
    15b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15b4:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    15b8:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    15bc:	66006c75 			; <UNDEFINED> instruction: 0x66006c75
    15c0:	5f636e75 	svcpl	0x00636e75
    15c4:	00727470 	rsbseq	r7, r2, r0, ror r4
    15c8:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    15cc:	2078656c 	rsbscs	r6, r8, ip, ror #10
    15d0:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    15d4:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
    15d8:	50465f42 	subpl	r5, r6, r2, asr #30
    15dc:	5359535f 	cmppl	r9, #2080374785	; 0x7c000001
    15e0:	53474552 	movtpl	r4, #30034	; 0x7552
    15e4:	61736900 	cmnvs	r3, r0, lsl #18
    15e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15ec:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    15f0:	00357063 	eorseq	r7, r5, r3, rrx
    15f4:	5f617369 	svcpl	0x00617369
    15f8:	5f746962 	svcpl	0x00746962
    15fc:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1600:	73690032 	cmnvc	r9, #50	; 0x32
    1604:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1608:	66765f74 	uhsub16vs	r5, r6, r4
    160c:	00337670 	eorseq	r7, r3, r0, ror r6
    1610:	5f617369 	svcpl	0x00617369
    1614:	5f746962 	svcpl	0x00746962
    1618:	76706676 			; <UNDEFINED> instruction: 0x76706676
    161c:	50460034 	subpl	r0, r6, r4, lsr r0
    1620:	4e545843 	cdpmi	8, 5, cr5, cr4, cr3, {2}
    1624:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    1628:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    162c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1630:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1638 <shift+0x1638>
    1634:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1638:	61736900 	cmnvs	r3, r0, lsl #18
    163c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1640:	3170665f 	cmncc	r0, pc, asr r6
    1644:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1648:	73690076 	cmnvc	r9, #118	; 0x76
    164c:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    1650:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    1654:	73690065 	cmnvc	r9, #101	; 0x65
    1658:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    165c:	6f6e5f74 	svcvs	0x006e5f74
    1660:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    1664:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1668:	715f7469 	cmpvc	pc, r9, ror #8
    166c:	6b726975 	blvs	1c9bc48 <__bss_end+0x1c92c7c>
    1670:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1674:	7a6b3676 	bvc	1acf054 <__bss_end+0x1ac6088>
    1678:	61736900 	cmnvs	r3, r0, lsl #18
    167c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1680:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1684:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    1688:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    168c:	715f7469 	cmpvc	pc, r9, ror #8
    1690:	6b726975 	blvs	1c9bc6c <__bss_end+0x1c92ca0>
    1694:	5f6f6e5f 	svcpl	0x006f6e5f
    1698:	636d7361 	cmnvs	sp, #-2080374783	; 0x84000001
    169c:	69007570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp, lr}
    16a0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16a4:	615f7469 	cmpvs	pc, r9, ror #8
    16a8:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    16ac:	61736900 	cmnvs	r3, r0, lsl #18
    16b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16b4:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    16b8:	0032626d 	eorseq	r6, r2, sp, ror #4
    16bc:	5f617369 	svcpl	0x00617369
    16c0:	5f746962 	svcpl	0x00746962
    16c4:	00386562 	eorseq	r6, r8, r2, ror #10
    16c8:	5f617369 	svcpl	0x00617369
    16cc:	5f746962 	svcpl	0x00746962
    16d0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    16d4:	73690037 	cmnvc	r9, #55	; 0x37
    16d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16dc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16e0:	0038766d 	eorseq	r7, r8, sp, ror #12
    16e4:	5f706676 	svcpl	0x00706676
    16e8:	72737973 	rsbsvc	r7, r3, #1884160	; 0x1cc000
    16ec:	5f736765 	svcpl	0x00736765
    16f0:	6f636e65 	svcvs	0x00636e65
    16f4:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    16f8:	61736900 	cmnvs	r3, r0, lsl #18
    16fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1700:	3170665f 	cmncc	r0, pc, asr r6
    1704:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1708:	61736900 	cmnvs	r3, r0, lsl #18
    170c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1710:	746f645f 	strbtvc	r6, [pc], #-1119	; 1718 <shift+0x1718>
    1714:	646f7270 	strbtvs	r7, [pc], #-624	; 171c <shift+0x171c>
	...

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa964>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347864>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa984>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9cb4>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa9b4>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x3478b4>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa9d4>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3478d4>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa9f4>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3478f4>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaa14>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347914>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaa34>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347934>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfaa54>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347954>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaa74>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347974>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faa8c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faaac>
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
 194:	000001a0 	andeq	r0, r0, r0, lsr #3
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faadc>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000083cc 	andeq	r8, r0, ip, asr #7
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfab08>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347a08>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfab28>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347a28>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008424 	andeq	r8, r0, r4, lsr #8
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfab48>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347a48>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008440 	andeq	r8, r0, r0, asr #8
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfab68>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347a68>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008484 	andeq	r8, r0, r4, lsl #9
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfab88>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347a88>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000084d4 	ldrdeq	r8, [r0], -r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfaba8>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347aa8>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008524 	andeq	r8, r0, r4, lsr #10
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfabc8>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347ac8>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008550 	andeq	r8, r0, r0, asr r5
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfabe8>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347ae8>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000085a0 	andeq	r8, r0, r0, lsr #11
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfac08>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347b08>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	000085e4 	andeq	r8, r0, r4, ror #11
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfac28>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347b28>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008634 	andeq	r8, r0, r4, lsr r6
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfac48>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347b48>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008688 	andeq	r8, r0, r8, lsl #13
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfac68>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347b68>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000086c4 	andeq	r8, r0, r4, asr #13
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfac88>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347b88>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008700 	andeq	r8, r0, r0, lsl #14
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfaca8>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347ba8>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	0000873c 	andeq	r8, r0, ip, lsr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfacc8>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347bc8>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008778 	andeq	r8, r0, r8, ror r7
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1face8>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008828 	andeq	r8, r0, r8, lsr #16
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fad18>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	0000899c 	muleq	r0, ip, r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfad38>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347c38>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008a38 	andeq	r8, r0, r8, lsr sl
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfad58>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347c58>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008af8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfad78>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347c78>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008ba4 	andeq	r8, r0, r4, lsr #23
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfad98>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347c98>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfadb8>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347cb8>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008c60 	andeq	r8, r0, r0, ror #24
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfadd8>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347cd8>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008ce0 	andeq	r8, r0, r0, ror #25
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
