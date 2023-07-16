
./tilt_task:     file format elf32-littlearm


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
    805c:	00008ee8 	andeq	r8, r0, r8, ror #29
    8060:	00008ef8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>

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
    81cc:	00008ee5 	andeq	r8, r0, r5, ror #29
    81d0:	00008ee5 	andeq	r8, r0, r5, ror #29

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
    8224:	00008ee5 	andeq	r8, r0, r5, ror #29
    8228:	00008ee5 	andeq	r8, r0, r5, ror #29

0000822c <main>:
main():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:15
 *
 * Ceka na vstup ze senzoru naklonu, a prehraje neco na buzzeru (PWM) dle naklonu
 **/

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:16
    char state = '0';
    8240:	e3a03030 	mov	r3, #48	; 0x30
    8244:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:17
    char oldstate = '0';
    8248:	e3a03030 	mov	r3, #48	; 0x30
    824c:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:19

    uint32_t tiltsensor_file = open("DEV:gpio/23", NFile_Open_Mode::Read_Only);
    8250:	e3a01000 	mov	r1, #0
    8254:	e59f008c 	ldr	r0, [pc, #140]	; 82e8 <main+0xbc>
    8258:	eb000043 	bl	836c <_Z4openPKc15NFile_Open_Mode>
    825c:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:27
    NGPIO_Interrupt_Type irtype;

    // irtype = NGPIO_Interrupt_Type::Rising_Edge;
    // ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

    irtype = NGPIO_Interrupt_Type::Falling_Edge;
    8260:	e3a03001 	mov	r3, #1
    8264:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:28
    ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8268:	e24b3018 	sub	r3, fp, #24
    826c:	e1a02003 	mov	r2, r3
    8270:	e3a01002 	mov	r1, #2
    8274:	e51b000c 	ldr	r0, [fp, #-12]
    8278:	eb00007f 	bl	847c <_Z5ioctlj16NIOCtl_OperationPv>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:30

    uint32_t logpipe = pipe("log", 32);
    827c:	e3a01020 	mov	r1, #32
    8280:	e59f0064 	ldr	r0, [pc, #100]	; 82ec <main+0xc0>
    8284:	eb000106 	bl	86a4 <_Z4pipePKcj>
    8288:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:39
        // wait(tiltsensor_file, 8);

        // "debounce" - tilt senzor bude chvili flappovat mezi vysokou a nizkou urovni
        // sleep(0x100, Deadline_Unchanged);

        read(tiltsensor_file, &state, 1);
    828c:	e24b3011 	sub	r3, fp, #17
    8290:	e3a02001 	mov	r2, #1
    8294:	e1a01003 	mov	r1, r3
    8298:	e51b000c 	ldr	r0, [fp, #-12]
    829c:	eb000043 	bl	83b0 <_Z4readjPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:43

        // if (state != oldstate)
        {
            if (state == '0')
    82a0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82a4:	e3530030 	cmp	r3, #48	; 0x30
    82a8:	1a000004 	bne	82c0 <main+0x94>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:45
            {
                write(logpipe, "Tilt UP", 7);
    82ac:	e3a02007 	mov	r2, #7
    82b0:	e59f1038 	ldr	r1, [pc, #56]	; 82f0 <main+0xc4>
    82b4:	e51b0010 	ldr	r0, [fp, #-16]
    82b8:	eb000050 	bl	8400 <_Z5writejPKcj>
    82bc:	ea000003 	b	82d0 <main+0xa4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:49
            }
            else
            {
                write(logpipe, "Tilt DOWN", 10);
    82c0:	e3a0200a 	mov	r2, #10
    82c4:	e59f1028 	ldr	r1, [pc, #40]	; 82f4 <main+0xc8>
    82c8:	e51b0010 	ldr	r0, [fp, #-16]
    82cc:	eb00004b 	bl	8400 <_Z5writejPKcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:51
            }
            oldstate = state;
    82d0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82d4:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:54
        }

        sleep(10, Indefinite /*0x100*/);
    82d8:	e3e01000 	mvn	r1, #0
    82dc:	e3a0000a 	mov	r0, #10
    82e0:	eb00009e 	bl	8560 <_Z5sleepjj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/userspace/tilt_task/main.cpp:39
        read(tiltsensor_file, &state, 1);
    82e4:	eaffffe8 	b	828c <main+0x60>
    82e8:	00008e78 	andeq	r8, r0, r8, ror lr
    82ec:	00008e84 	andeq	r8, r0, r4, lsl #29
    82f0:	00008e88 	andeq	r8, r0, r8, lsl #29
    82f4:	00008e90 	muleq	r0, r0, lr

000082f8 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    82f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82fc:	e28db000 	add	fp, sp, #0
    8300:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8304:	ef000000 	svc	0x00000000
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r"(pid));
    8308:	e1a03000 	mov	r3, r0
    830c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:11

    return pid;
    8310:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:12
}
    8314:	e1a00003 	mov	r0, r3
    8318:	e28bd000 	add	sp, fp, #0
    831c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8320:	e12fff1e 	bx	lr

00008324 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8324:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8328:	e28db000 	add	fp, sp, #0
    832c:	e24dd00c 	sub	sp, sp, #12
    8330:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r"(exitcode));
    8334:	e51b3008 	ldr	r3, [fp, #-8]
    8338:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    833c:	ef000001 	svc	0x00000001
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:18
}
    8340:	e320f000 	nop	{0}
    8344:	e28bd000 	add	sp, fp, #0
    8348:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    834c:	e12fff1e 	bx	lr

00008350 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8350:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8354:	e28db000 	add	fp, sp, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8358:	ef000002 	svc	0x00000002
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:23
}
    835c:	e320f000 	nop	{0}
    8360:	e28bd000 	add	sp, fp, #0
    8364:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8368:	e12fff1e 	bx	lr

0000836c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    836c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8370:	e28db000 	add	fp, sp, #0
    8374:	e24dd014 	sub	sp, sp, #20
    8378:	e50b0010 	str	r0, [fp, #-16]
    837c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r"(filename));
    8380:	e51b3010 	ldr	r3, [fp, #-16]
    8384:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r"(mode));
    8388:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    838c:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8390:	ef000040 	svc	0x00000040
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r"(file));
    8394:	e1a03000 	mov	r3, r0
    8398:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:34

    return file;
    839c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:35
}
    83a0:	e1a00003 	mov	r0, r3
    83a4:	e28bd000 	add	sp, fp, #0
    83a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83ac:	e12fff1e 	bx	lr

000083b0 <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83b4:	e28db000 	add	fp, sp, #0
    83b8:	e24dd01c 	sub	sp, sp, #28
    83bc:	e50b0010 	str	r0, [fp, #-16]
    83c0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83c4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r"(file));
    83c8:	e51b3010 	ldr	r3, [fp, #-16]
    83cc:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r"(buffer));
    83d0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83d4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r"(size));
    83d8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83dc:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    83e0:	ef000041 	svc	0x00000041
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r"(rdnum));
    83e4:	e1a03000 	mov	r3, r0
    83e8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:47

    return rdnum;
    83ec:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:48
}
    83f0:	e1a00003 	mov	r0, r3
    83f4:	e28bd000 	add	sp, fp, #0
    83f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83fc:	e12fff1e 	bx	lr

00008400 <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8400:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8404:	e28db000 	add	fp, sp, #0
    8408:	e24dd01c 	sub	sp, sp, #28
    840c:	e50b0010 	str	r0, [fp, #-16]
    8410:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8414:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r"(file));
    8418:	e51b3010 	ldr	r3, [fp, #-16]
    841c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r"(buffer));
    8420:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8424:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r"(size));
    8428:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    842c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8430:	ef000042 	svc	0x00000042
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r"(wrnum));
    8434:	e1a03000 	mov	r3, r0
    8438:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:60

    return wrnum;
    843c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:61
}
    8440:	e1a00003 	mov	r0, r3
    8444:	e28bd000 	add	sp, fp, #0
    8448:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    844c:	e12fff1e 	bx	lr

00008450 <_Z5closej>:
_Z5closej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8450:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8454:	e28db000 	add	fp, sp, #0
    8458:	e24dd00c 	sub	sp, sp, #12
    845c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r"(file));
    8460:	e51b3008 	ldr	r3, [fp, #-8]
    8464:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8468:	ef000043 	svc	0x00000043
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:67
}
    846c:	e320f000 	nop	{0}
    8470:	e28bd000 	add	sp, fp, #0
    8474:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8478:	e12fff1e 	bx	lr

0000847c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    847c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8480:	e28db000 	add	fp, sp, #0
    8484:	e24dd01c 	sub	sp, sp, #28
    8488:	e50b0010 	str	r0, [fp, #-16]
    848c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8490:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    8494:	e51b3010 	ldr	r3, [fp, #-16]
    8498:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r"(operation));
    849c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84a0:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r"(param));
    84a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84a8:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84ac:	ef000044 	svc	0x00000044
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r"(retcode));
    84b0:	e1a03000 	mov	r3, r0
    84b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:79

    return retcode;
    84b8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:80
}
    84bc:	e1a00003 	mov	r0, r3
    84c0:	e28bd000 	add	sp, fp, #0
    84c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84c8:	e12fff1e 	bx	lr

000084cc <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    84cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d0:	e28db000 	add	fp, sp, #0
    84d4:	e24dd014 	sub	sp, sp, #20
    84d8:	e50b0010 	str	r0, [fp, #-16]
    84dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r"(file));
    84e0:	e51b3010 	ldr	r3, [fp, #-16]
    84e4:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r"(count));
    84e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ec:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    84f0:	ef000045 	svc	0x00000045
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r"(retcnt));
    84f4:	e1a03000 	mov	r3, r0
    84f8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:91

    return retcnt;
    84fc:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:92
}
    8500:	e1a00003 	mov	r0, r3
    8504:	e28bd000 	add	sp, fp, #0
    8508:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    850c:	e12fff1e 	bx	lr

00008510 <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8510:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8514:	e28db000 	add	fp, sp, #0
    8518:	e24dd01c 	sub	sp, sp, #28
    851c:	e50b0010 	str	r0, [fp, #-16]
    8520:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8524:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r"(file));
    8528:	e51b3010 	ldr	r3, [fp, #-16]
    852c:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r"(count));
    8530:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8534:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r"(notified_deadline));
    8538:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    853c:	e1a02003 	mov	r2, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8540:	ef000046 	svc	0x00000046
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r"(retcode));
    8544:	e1a03000 	mov	r3, r0
    8548:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:104

    return retcode;
    854c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:105
}
    8550:	e1a00003 	mov	r0, r3
    8554:	e28bd000 	add	sp, fp, #0
    8558:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    855c:	e12fff1e 	bx	lr

00008560 <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8560:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8564:	e28db000 	add	fp, sp, #0
    8568:	e24dd014 	sub	sp, sp, #20
    856c:	e50b0010 	str	r0, [fp, #-16]
    8570:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r"(ticks));
    8574:	e51b3010 	ldr	r3, [fp, #-16]
    8578:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r"(notified_deadline));
    857c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8580:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8584:	ef000003 	svc	0x00000003
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r"(retcode));
    8588:	e1a03000 	mov	r3, r0
    858c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:116

    return retcode;
    8590:	e51b3008 	ldr	r3, [fp, #-8]
    8594:	e3530000 	cmp	r3, #0
    8598:	13a03001 	movne	r3, #1
    859c:	03a03000 	moveq	r3, #0
    85a0:	e6ef3073 	uxtb	r3, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:117
}
    85a4:	e1a00003 	mov	r0, r3
    85a8:	e28bd000 	add	sp, fp, #0
    85ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85b0:	e12fff1e 	bx	lr

000085b4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85b8:	e28db000 	add	fp, sp, #0
    85bc:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    85c8:	e3a03000 	mov	r3, #0
    85cc:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r"(&retval));
    85d0:	e24b300c 	sub	r3, fp, #12
    85d4:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    85d8:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:128

    return retval;
    85dc:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:129
}
    85e0:	e1a00003 	mov	r0, r3
    85e4:	e28bd000 	add	sp, fp, #0
    85e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85ec:	e12fff1e 	bx	lr

000085f0 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    85f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f4:	e28db000 	add	fp, sp, #0
    85f8:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    85fc:	e3a03001 	mov	r3, #1
    8600:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r"(req));
    8604:	e3a03001 	mov	r3, #1
    8608:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r"(&retval));
    860c:	e24b300c 	sub	r3, fp, #12
    8610:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8614:	ef000004 	svc	0x00000004
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:140

    return retval;
    8618:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:141
}
    861c:	e1a00003 	mov	r0, r3
    8620:	e28bd000 	add	sp, fp, #0
    8624:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8628:	e12fff1e 	bx	lr

0000862c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    862c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8630:	e28db000 	add	fp, sp, #0
    8634:	e24dd014 	sub	sp, sp, #20
    8638:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    863c:	e3a03000 	mov	r3, #0
    8640:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r"(req));
    8644:	e3a03000 	mov	r3, #0
    8648:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r"(&tick_count_required));
    864c:	e24b3010 	sub	r3, fp, #16
    8650:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8654:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:150
}
    8658:	e320f000 	nop	{0}
    865c:	e28bd000 	add	sp, fp, #0
    8660:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8664:	e12fff1e 	bx	lr

00008668 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8668:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    866c:	e28db000 	add	fp, sp, #0
    8670:	e24dd00c 	sub	sp, sp, #12
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8674:	e3a03001 	mov	r3, #1
    8678:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r"(req));
    867c:	e3a03001 	mov	r3, #1
    8680:	e1a00003 	mov	r0, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r"(&ticks));
    8684:	e24b300c 	sub	r3, fp, #12
    8688:	e1a01003 	mov	r1, r3
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    868c:	ef000005 	svc	0x00000005
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:161

    return ticks;
    8690:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:162
}
    8694:	e1a00003 	mov	r0, r3
    8698:	e28bd000 	add	sp, fp, #0
    869c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86a0:	e12fff1e 	bx	lr

000086a4 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86a4:	e92d4800 	push	{fp, lr}
    86a8:	e28db004 	add	fp, sp, #4
    86ac:	e24dd050 	sub	sp, sp, #80	; 0x50
    86b0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86b4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86b8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86bc:	e3a0200a 	mov	r2, #10
    86c0:	e59f1088 	ldr	r1, [pc, #136]	; 8750 <_Z4pipePKcj+0xac>
    86c4:	e1a00003 	mov	r0, r3
    86c8:	eb0000a5 	bl	8964 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    86cc:	e24b3048 	sub	r3, fp, #72	; 0x48
    86d0:	e283300a 	add	r3, r3, #10
    86d4:	e3a02035 	mov	r2, #53	; 0x35
    86d8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    86dc:	e1a00003 	mov	r0, r3
    86e0:	eb00009f 	bl	8964 <_Z7strncpyPcPKci>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    86e4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    86e8:	eb0000f8 	bl	8ad0 <_Z6strlenPKc>
    86ec:	e1a03000 	mov	r3, r0
    86f0:	e283300a 	add	r3, r3, #10
    86f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    86f8:	e51b3008 	ldr	r3, [fp, #-8]
    86fc:	e2832001 	add	r2, r3, #1
    8700:	e50b2008 	str	r2, [fp, #-8]
    8704:	e2433004 	sub	r3, r3, #4
    8708:	e083300b 	add	r3, r3, fp
    870c:	e3a02023 	mov	r2, #35	; 0x23
    8710:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8714:	e24b2048 	sub	r2, fp, #72	; 0x48
    8718:	e51b3008 	ldr	r3, [fp, #-8]
    871c:	e0823003 	add	r3, r2, r3
    8720:	e3a0200a 	mov	r2, #10
    8724:	e1a01003 	mov	r1, r3
    8728:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    872c:	eb000008 	bl	8754 <_Z4itoajPcj>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8730:	e24b3048 	sub	r3, fp, #72	; 0x48
    8734:	e3a01002 	mov	r1, #2
    8738:	e1a00003 	mov	r0, r3
    873c:	ebffff0a 	bl	836c <_Z4openPKc15NFile_Open_Mode>
    8740:	e1a03000 	mov	r3, r0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdfile.cpp:179
}
    8744:	e1a00003 	mov	r0, r3
    8748:	e24bd004 	sub	sp, fp, #4
    874c:	e8bd8800 	pop	{fp, pc}
    8750:	00008ec8 	andeq	r8, r0, r8, asr #29

00008754 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8754:	e92d4800 	push	{fp, lr}
    8758:	e28db004 	add	fp, sp, #4
    875c:	e24dd020 	sub	sp, sp, #32
    8760:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8764:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8768:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:10
    int i = 0;
    876c:	e3a03000 	mov	r3, #0
    8770:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12

    while (input > 0)
    8774:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8778:	e3530000 	cmp	r3, #0
    877c:	0a000014 	beq	87d4 <_Z4itoajPcj+0x80>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:14
    {
        output[i] = CharConvArr[input % base];
    8780:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8784:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8788:	e1a00003 	mov	r0, r3
    878c:	eb000199 	bl	8df8 <__aeabi_uidivmod>
    8790:	e1a03001 	mov	r3, r1
    8794:	e1a01003 	mov	r1, r3
    8798:	e51b3008 	ldr	r3, [fp, #-8]
    879c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87a0:	e0823003 	add	r3, r2, r3
    87a4:	e59f2118 	ldr	r2, [pc, #280]	; 88c4 <_Z4itoajPcj+0x170>
    87a8:	e7d22001 	ldrb	r2, [r2, r1]
    87ac:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:15
        input /= base;
    87b0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87b4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87b8:	eb000113 	bl	8c0c <__udivsi3>
    87bc:	e1a03000 	mov	r3, r0
    87c0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:16
        i++;
    87c4:	e51b3008 	ldr	r3, [fp, #-8]
    87c8:	e2833001 	add	r3, r3, #1
    87cc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:12
    while (input > 0)
    87d0:	eaffffe7 	b	8774 <_Z4itoajPcj+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:19
    }

    if (i == 0)
    87d4:	e51b3008 	ldr	r3, [fp, #-8]
    87d8:	e3530000 	cmp	r3, #0
    87dc:	1a000007 	bne	8800 <_Z4itoajPcj+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    87e0:	e51b3008 	ldr	r3, [fp, #-8]
    87e4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87e8:	e0823003 	add	r3, r2, r3
    87ec:	e3a02030 	mov	r2, #48	; 0x30
    87f0:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:22
        i++;
    87f4:	e51b3008 	ldr	r3, [fp, #-8]
    87f8:	e2833001 	add	r3, r3, #1
    87fc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:25
    }

    output[i] = '\0';
    8800:	e51b3008 	ldr	r3, [fp, #-8]
    8804:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8808:	e0823003 	add	r3, r2, r3
    880c:	e3a02000 	mov	r2, #0
    8810:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:26
    i--;
    8814:	e51b3008 	ldr	r3, [fp, #-8]
    8818:	e2433001 	sub	r3, r3, #1
    881c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28

    for (int j = 0; j <= i / 2; j++)
    8820:	e3a03000 	mov	r3, #0
    8824:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8828:	e51b3008 	ldr	r3, [fp, #-8]
    882c:	e1a02fa3 	lsr	r2, r3, #31
    8830:	e0823003 	add	r3, r2, r3
    8834:	e1a030c3 	asr	r3, r3, #1
    8838:	e1a02003 	mov	r2, r3
    883c:	e51b300c 	ldr	r3, [fp, #-12]
    8840:	e1530002 	cmp	r3, r2
    8844:	ca00001b 	bgt	88b8 <_Z4itoajPcj+0x164>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:30 (discriminator 2)
    {
        char c = output[i - j];
    8848:	e51b2008 	ldr	r2, [fp, #-8]
    884c:	e51b300c 	ldr	r3, [fp, #-12]
    8850:	e0423003 	sub	r3, r2, r3
    8854:	e1a02003 	mov	r2, r3
    8858:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    885c:	e0833002 	add	r3, r3, r2
    8860:	e5d33000 	ldrb	r3, [r3]
    8864:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:31 (discriminator 2)
        output[i - j] = output[j];
    8868:	e51b300c 	ldr	r3, [fp, #-12]
    886c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8870:	e0822003 	add	r2, r2, r3
    8874:	e51b1008 	ldr	r1, [fp, #-8]
    8878:	e51b300c 	ldr	r3, [fp, #-12]
    887c:	e0413003 	sub	r3, r1, r3
    8880:	e1a01003 	mov	r1, r3
    8884:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8888:	e0833001 	add	r3, r3, r1
    888c:	e5d22000 	ldrb	r2, [r2]
    8890:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:32 (discriminator 2)
        output[j] = c;
    8894:	e51b300c 	ldr	r3, [fp, #-12]
    8898:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    889c:	e0823003 	add	r3, r2, r3
    88a0:	e55b200d 	ldrb	r2, [fp, #-13]
    88a4:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:28 (discriminator 2)
    for (int j = 0; j <= i / 2; j++)
    88a8:	e51b300c 	ldr	r3, [fp, #-12]
    88ac:	e2833001 	add	r3, r3, #1
    88b0:	e50b300c 	str	r3, [fp, #-12]
    88b4:	eaffffdb 	b	8828 <_Z4itoajPcj+0xd4>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:34
    }
}
    88b8:	e320f000 	nop	{0}
    88bc:	e24bd004 	sub	sp, fp, #4
    88c0:	e8bd8800 	pop	{fp, pc}
    88c4:	00008ed4 	ldrdeq	r8, [r0], -r4

000088c8 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    88c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88cc:	e28db000 	add	fp, sp, #0
    88d0:	e24dd014 	sub	sp, sp, #20
    88d4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:38
    int output = 0;
    88d8:	e3a03000 	mov	r3, #0
    88dc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40

    while (*input != '\0')
    88e0:	e51b3010 	ldr	r3, [fp, #-16]
    88e4:	e5d33000 	ldrb	r3, [r3]
    88e8:	e3530000 	cmp	r3, #0
    88ec:	0a000017 	beq	8950 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:42
    {
        output *= 10;
    88f0:	e51b2008 	ldr	r2, [fp, #-8]
    88f4:	e1a03002 	mov	r3, r2
    88f8:	e1a03103 	lsl	r3, r3, #2
    88fc:	e0833002 	add	r3, r3, r2
    8900:	e1a03083 	lsl	r3, r3, #1
    8904:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43
        if (*input > '9' || *input < '0')
    8908:	e51b3010 	ldr	r3, [fp, #-16]
    890c:	e5d33000 	ldrb	r3, [r3]
    8910:	e3530039 	cmp	r3, #57	; 0x39
    8914:	8a00000d 	bhi	8950 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8918:	e51b3010 	ldr	r3, [fp, #-16]
    891c:	e5d33000 	ldrb	r3, [r3]
    8920:	e353002f 	cmp	r3, #47	; 0x2f
    8924:	9a000009 	bls	8950 <_Z4atoiPKc+0x88>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:46
            break;

        output += *input - '0';
    8928:	e51b3010 	ldr	r3, [fp, #-16]
    892c:	e5d33000 	ldrb	r3, [r3]
    8930:	e2433030 	sub	r3, r3, #48	; 0x30
    8934:	e51b2008 	ldr	r2, [fp, #-8]
    8938:	e0823003 	add	r3, r2, r3
    893c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:48

        input++;
    8940:	e51b3010 	ldr	r3, [fp, #-16]
    8944:	e2833001 	add	r3, r3, #1
    8948:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:40
    while (*input != '\0')
    894c:	eaffffe3 	b	88e0 <_Z4atoiPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:51
    }

    return output;
    8950:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:52
}
    8954:	e1a00003 	mov	r0, r3
    8958:	e28bd000 	add	sp, fp, #0
    895c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8960:	e12fff1e 	bx	lr

00008964 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char* src, int num)
{
    8964:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8968:	e28db000 	add	fp, sp, #0
    896c:	e24dd01c 	sub	sp, sp, #28
    8970:	e50b0010 	str	r0, [fp, #-16]
    8974:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8978:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    897c:	e3a03000 	mov	r3, #0
    8980:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8984:	e51b2008 	ldr	r2, [fp, #-8]
    8988:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    898c:	e1520003 	cmp	r2, r3
    8990:	aa000011 	bge	89dc <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8994:	e51b3008 	ldr	r3, [fp, #-8]
    8998:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    899c:	e0823003 	add	r3, r2, r3
    89a0:	e5d33000 	ldrb	r3, [r3]
    89a4:	e3530000 	cmp	r3, #0
    89a8:	0a00000b 	beq	89dc <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:59 (discriminator 3)
        dest[i] = src[i];
    89ac:	e51b3008 	ldr	r3, [fp, #-8]
    89b0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89b4:	e0822003 	add	r2, r2, r3
    89b8:	e51b3008 	ldr	r3, [fp, #-8]
    89bc:	e51b1010 	ldr	r1, [fp, #-16]
    89c0:	e0813003 	add	r3, r1, r3
    89c4:	e5d22000 	ldrb	r2, [r2]
    89c8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:58 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    89cc:	e51b3008 	ldr	r3, [fp, #-8]
    89d0:	e2833001 	add	r3, r3, #1
    89d4:	e50b3008 	str	r3, [fp, #-8]
    89d8:	eaffffe9 	b	8984 <_Z7strncpyPcPKci+0x20>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 2)
    for (; i < num; i++)
    89dc:	e51b2008 	ldr	r2, [fp, #-8]
    89e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89e4:	e1520003 	cmp	r2, r3
    89e8:	aa000008 	bge	8a10 <_Z7strncpyPcPKci+0xac>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:61 (discriminator 1)
        dest[i] = '\0';
    89ec:	e51b3008 	ldr	r3, [fp, #-8]
    89f0:	e51b2010 	ldr	r2, [fp, #-16]
    89f4:	e0823003 	add	r3, r2, r3
    89f8:	e3a02000 	mov	r2, #0
    89fc:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:60 (discriminator 1)
    for (; i < num; i++)
    8a00:	e51b3008 	ldr	r3, [fp, #-8]
    8a04:	e2833001 	add	r3, r3, #1
    8a08:	e50b3008 	str	r3, [fp, #-8]
    8a0c:	eafffff2 	b	89dc <_Z7strncpyPcPKci+0x78>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:63

    return dest;
    8a10:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:64
}
    8a14:	e1a00003 	mov	r0, r3
    8a18:	e28bd000 	add	sp, fp, #0
    8a1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a20:	e12fff1e 	bx	lr

00008a24 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:67

int strncmp(const char* s1, const char* s2, int num)
{
    8a24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a28:	e28db000 	add	fp, sp, #0
    8a2c:	e24dd01c 	sub	sp, sp, #28
    8a30:	e50b0010 	str	r0, [fp, #-16]
    8a34:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a38:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:69
    unsigned char u1, u2;
    while (num-- > 0)
    8a3c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a40:	e2432001 	sub	r2, r3, #1
    8a44:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a48:	e3530000 	cmp	r3, #0
    8a4c:	c3a03001 	movgt	r3, #1
    8a50:	d3a03000 	movle	r3, #0
    8a54:	e6ef3073 	uxtb	r3, r3
    8a58:	e3530000 	cmp	r3, #0
    8a5c:	0a000016 	beq	8abc <_Z7strncmpPKcS0_i+0x98>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:71
    {
        u1 = (unsigned char)*s1++;
    8a60:	e51b3010 	ldr	r3, [fp, #-16]
    8a64:	e2832001 	add	r2, r3, #1
    8a68:	e50b2010 	str	r2, [fp, #-16]
    8a6c:	e5d33000 	ldrb	r3, [r3]
    8a70:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:72
        u2 = (unsigned char)*s2++;
    8a74:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a78:	e2832001 	add	r2, r3, #1
    8a7c:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8a80:	e5d33000 	ldrb	r3, [r3]
    8a84:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:73
        if (u1 != u2)
    8a88:	e55b2005 	ldrb	r2, [fp, #-5]
    8a8c:	e55b3006 	ldrb	r3, [fp, #-6]
    8a90:	e1520003 	cmp	r2, r3
    8a94:	0a000003 	beq	8aa8 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:74
            return u1 - u2;
    8a98:	e55b2005 	ldrb	r2, [fp, #-5]
    8a9c:	e55b3006 	ldrb	r3, [fp, #-6]
    8aa0:	e0423003 	sub	r3, r2, r3
    8aa4:	ea000005 	b	8ac0 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:75
        if (u1 == '\0')
    8aa8:	e55b3005 	ldrb	r3, [fp, #-5]
    8aac:	e3530000 	cmp	r3, #0
    8ab0:	1affffe1 	bne	8a3c <_Z7strncmpPKcS0_i+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:76
            return 0;
    8ab4:	e3a03000 	mov	r3, #0
    8ab8:	ea000000 	b	8ac0 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:79
    }

    return 0;
    8abc:	e3a03000 	mov	r3, #0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:80
}
    8ac0:	e1a00003 	mov	r0, r3
    8ac4:	e28bd000 	add	sp, fp, #0
    8ac8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8acc:	e12fff1e 	bx	lr

00008ad0 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8ad0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ad4:	e28db000 	add	fp, sp, #0
    8ad8:	e24dd014 	sub	sp, sp, #20
    8adc:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:84
    int i = 0;
    8ae0:	e3a03000 	mov	r3, #0
    8ae4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86

    while (s[i] != '\0')
    8ae8:	e51b3008 	ldr	r3, [fp, #-8]
    8aec:	e51b2010 	ldr	r2, [fp, #-16]
    8af0:	e0823003 	add	r3, r2, r3
    8af4:	e5d33000 	ldrb	r3, [r3]
    8af8:	e3530000 	cmp	r3, #0
    8afc:	0a000003 	beq	8b10 <_Z6strlenPKc+0x40>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:87
        i++;
    8b00:	e51b3008 	ldr	r3, [fp, #-8]
    8b04:	e2833001 	add	r3, r3, #1
    8b08:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:86
    while (s[i] != '\0')
    8b0c:	eafffff5 	b	8ae8 <_Z6strlenPKc+0x18>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:89

    return i;
    8b10:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:90
}
    8b14:	e1a00003 	mov	r0, r3
    8b18:	e28bd000 	add	sp, fp, #0
    8b1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b20:	e12fff1e 	bx	lr

00008b24 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b28:	e28db000 	add	fp, sp, #0
    8b2c:	e24dd014 	sub	sp, sp, #20
    8b30:	e50b0010 	str	r0, [fp, #-16]
    8b34:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:94
    char* mem = reinterpret_cast<char*>(memory);
    8b38:	e51b3010 	ldr	r3, [fp, #-16]
    8b3c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96

    for (int i = 0; i < length; i++)
    8b40:	e3a03000 	mov	r3, #0
    8b44:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b48:	e51b2008 	ldr	r2, [fp, #-8]
    8b4c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b50:	e1520003 	cmp	r2, r3
    8b54:	aa000008 	bge	8b7c <_Z5bzeroPvi+0x58>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:97 (discriminator 2)
        mem[i] = 0;
    8b58:	e51b3008 	ldr	r3, [fp, #-8]
    8b5c:	e51b200c 	ldr	r2, [fp, #-12]
    8b60:	e0823003 	add	r3, r2, r3
    8b64:	e3a02000 	mov	r2, #0
    8b68:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:96 (discriminator 2)
    for (int i = 0; i < length; i++)
    8b6c:	e51b3008 	ldr	r3, [fp, #-8]
    8b70:	e2833001 	add	r3, r3, #1
    8b74:	e50b3008 	str	r3, [fp, #-8]
    8b78:	eafffff2 	b	8b48 <_Z5bzeroPvi+0x24>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:98
}
    8b7c:	e320f000 	nop	{0}
    8b80:	e28bd000 	add	sp, fp, #0
    8b84:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b88:	e12fff1e 	bx	lr

00008b8c <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8b8c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b90:	e28db000 	add	fp, sp, #0
    8b94:	e24dd024 	sub	sp, sp, #36	; 0x24
    8b98:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b9c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8ba0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:102
    const char* memsrc = reinterpret_cast<const char*>(src);
    8ba4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ba8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:103
    char* memdst = reinterpret_cast<char*>(dst);
    8bac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bb0:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105

    for (int i = 0; i < num; i++)
    8bb4:	e3a03000 	mov	r3, #0
    8bb8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8bbc:	e51b2008 	ldr	r2, [fp, #-8]
    8bc0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8bc4:	e1520003 	cmp	r2, r3
    8bc8:	aa00000b 	bge	8bfc <_Z6memcpyPKvPvi+0x70>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:106 (discriminator 2)
        memdst[i] = memsrc[i];
    8bcc:	e51b3008 	ldr	r3, [fp, #-8]
    8bd0:	e51b200c 	ldr	r2, [fp, #-12]
    8bd4:	e0822003 	add	r2, r2, r3
    8bd8:	e51b3008 	ldr	r3, [fp, #-8]
    8bdc:	e51b1010 	ldr	r1, [fp, #-16]
    8be0:	e0813003 	add	r3, r1, r3
    8be4:	e5d22000 	ldrb	r2, [r2]
    8be8:	e5c32000 	strb	r2, [r3]
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:105 (discriminator 2)
    for (int i = 0; i < num; i++)
    8bec:	e51b3008 	ldr	r3, [fp, #-8]
    8bf0:	e2833001 	add	r3, r3, #1
    8bf4:	e50b3008 	str	r3, [fp, #-8]
    8bf8:	eaffffef 	b	8bbc <_Z6memcpyPKvPvi+0x30>
/mnt/c/Users/Kuba/Documents/ZeroMate/examples/18-edf/stdlib/src/stdstring.cpp:107
}
    8bfc:	e320f000 	nop	{0}
    8c00:	e28bd000 	add	sp, fp, #0
    8c04:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c08:	e12fff1e 	bx	lr

00008c0c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8c0c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8c10:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    8c14:	3a000074 	bcc	8dec <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8c18:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    8c1c:	9a00006b 	bls	8dd0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8c20:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8c24:	0a00006c 	beq	8ddc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    8c28:	e16f3f10 	clz	r3, r0
    8c2c:	e16f2f11 	clz	r2, r1
    8c30:	e0423003 	sub	r3, r2, r3
    8c34:	e273301f 	rsbs	r3, r3, #31
    8c38:	10833083 	addne	r3, r3, r3, lsl #1
    8c3c:	e3a02000 	mov	r2, #0
    8c40:	108ff103 	addne	pc, pc, r3, lsl #2
    8c44:	e1a00000 	nop			; (mov r0, r0)
    8c48:	e1500f81 	cmp	r0, r1, lsl #31
    8c4c:	e0a22002 	adc	r2, r2, r2
    8c50:	20400f81 	subcs	r0, r0, r1, lsl #31
    8c54:	e1500f01 	cmp	r0, r1, lsl #30
    8c58:	e0a22002 	adc	r2, r2, r2
    8c5c:	20400f01 	subcs	r0, r0, r1, lsl #30
    8c60:	e1500e81 	cmp	r0, r1, lsl #29
    8c64:	e0a22002 	adc	r2, r2, r2
    8c68:	20400e81 	subcs	r0, r0, r1, lsl #29
    8c6c:	e1500e01 	cmp	r0, r1, lsl #28
    8c70:	e0a22002 	adc	r2, r2, r2
    8c74:	20400e01 	subcs	r0, r0, r1, lsl #28
    8c78:	e1500d81 	cmp	r0, r1, lsl #27
    8c7c:	e0a22002 	adc	r2, r2, r2
    8c80:	20400d81 	subcs	r0, r0, r1, lsl #27
    8c84:	e1500d01 	cmp	r0, r1, lsl #26
    8c88:	e0a22002 	adc	r2, r2, r2
    8c8c:	20400d01 	subcs	r0, r0, r1, lsl #26
    8c90:	e1500c81 	cmp	r0, r1, lsl #25
    8c94:	e0a22002 	adc	r2, r2, r2
    8c98:	20400c81 	subcs	r0, r0, r1, lsl #25
    8c9c:	e1500c01 	cmp	r0, r1, lsl #24
    8ca0:	e0a22002 	adc	r2, r2, r2
    8ca4:	20400c01 	subcs	r0, r0, r1, lsl #24
    8ca8:	e1500b81 	cmp	r0, r1, lsl #23
    8cac:	e0a22002 	adc	r2, r2, r2
    8cb0:	20400b81 	subcs	r0, r0, r1, lsl #23
    8cb4:	e1500b01 	cmp	r0, r1, lsl #22
    8cb8:	e0a22002 	adc	r2, r2, r2
    8cbc:	20400b01 	subcs	r0, r0, r1, lsl #22
    8cc0:	e1500a81 	cmp	r0, r1, lsl #21
    8cc4:	e0a22002 	adc	r2, r2, r2
    8cc8:	20400a81 	subcs	r0, r0, r1, lsl #21
    8ccc:	e1500a01 	cmp	r0, r1, lsl #20
    8cd0:	e0a22002 	adc	r2, r2, r2
    8cd4:	20400a01 	subcs	r0, r0, r1, lsl #20
    8cd8:	e1500981 	cmp	r0, r1, lsl #19
    8cdc:	e0a22002 	adc	r2, r2, r2
    8ce0:	20400981 	subcs	r0, r0, r1, lsl #19
    8ce4:	e1500901 	cmp	r0, r1, lsl #18
    8ce8:	e0a22002 	adc	r2, r2, r2
    8cec:	20400901 	subcs	r0, r0, r1, lsl #18
    8cf0:	e1500881 	cmp	r0, r1, lsl #17
    8cf4:	e0a22002 	adc	r2, r2, r2
    8cf8:	20400881 	subcs	r0, r0, r1, lsl #17
    8cfc:	e1500801 	cmp	r0, r1, lsl #16
    8d00:	e0a22002 	adc	r2, r2, r2
    8d04:	20400801 	subcs	r0, r0, r1, lsl #16
    8d08:	e1500781 	cmp	r0, r1, lsl #15
    8d0c:	e0a22002 	adc	r2, r2, r2
    8d10:	20400781 	subcs	r0, r0, r1, lsl #15
    8d14:	e1500701 	cmp	r0, r1, lsl #14
    8d18:	e0a22002 	adc	r2, r2, r2
    8d1c:	20400701 	subcs	r0, r0, r1, lsl #14
    8d20:	e1500681 	cmp	r0, r1, lsl #13
    8d24:	e0a22002 	adc	r2, r2, r2
    8d28:	20400681 	subcs	r0, r0, r1, lsl #13
    8d2c:	e1500601 	cmp	r0, r1, lsl #12
    8d30:	e0a22002 	adc	r2, r2, r2
    8d34:	20400601 	subcs	r0, r0, r1, lsl #12
    8d38:	e1500581 	cmp	r0, r1, lsl #11
    8d3c:	e0a22002 	adc	r2, r2, r2
    8d40:	20400581 	subcs	r0, r0, r1, lsl #11
    8d44:	e1500501 	cmp	r0, r1, lsl #10
    8d48:	e0a22002 	adc	r2, r2, r2
    8d4c:	20400501 	subcs	r0, r0, r1, lsl #10
    8d50:	e1500481 	cmp	r0, r1, lsl #9
    8d54:	e0a22002 	adc	r2, r2, r2
    8d58:	20400481 	subcs	r0, r0, r1, lsl #9
    8d5c:	e1500401 	cmp	r0, r1, lsl #8
    8d60:	e0a22002 	adc	r2, r2, r2
    8d64:	20400401 	subcs	r0, r0, r1, lsl #8
    8d68:	e1500381 	cmp	r0, r1, lsl #7
    8d6c:	e0a22002 	adc	r2, r2, r2
    8d70:	20400381 	subcs	r0, r0, r1, lsl #7
    8d74:	e1500301 	cmp	r0, r1, lsl #6
    8d78:	e0a22002 	adc	r2, r2, r2
    8d7c:	20400301 	subcs	r0, r0, r1, lsl #6
    8d80:	e1500281 	cmp	r0, r1, lsl #5
    8d84:	e0a22002 	adc	r2, r2, r2
    8d88:	20400281 	subcs	r0, r0, r1, lsl #5
    8d8c:	e1500201 	cmp	r0, r1, lsl #4
    8d90:	e0a22002 	adc	r2, r2, r2
    8d94:	20400201 	subcs	r0, r0, r1, lsl #4
    8d98:	e1500181 	cmp	r0, r1, lsl #3
    8d9c:	e0a22002 	adc	r2, r2, r2
    8da0:	20400181 	subcs	r0, r0, r1, lsl #3
    8da4:	e1500101 	cmp	r0, r1, lsl #2
    8da8:	e0a22002 	adc	r2, r2, r2
    8dac:	20400101 	subcs	r0, r0, r1, lsl #2
    8db0:	e1500081 	cmp	r0, r1, lsl #1
    8db4:	e0a22002 	adc	r2, r2, r2
    8db8:	20400081 	subcs	r0, r0, r1, lsl #1
    8dbc:	e1500001 	cmp	r0, r1
    8dc0:	e0a22002 	adc	r2, r2, r2
    8dc4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8dc8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8dcc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    8dd0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8dd4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8dd8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    8ddc:	e16f2f11 	clz	r2, r1
    8de0:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8de4:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    8de8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    8dec:	e3500000 	cmp	r0, #0
    8df0:	13e00000 	mvnne	r0, #0
    8df4:	ea000007 	b	8e18 <__aeabi_idiv0>

00008df8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8df8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8dfc:	0afffffa 	beq	8dec <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8e00:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    8e04:	ebffff80 	bl	8c0c <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8e08:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8e0c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8e10:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    8e14:	e12fff1e 	bx	lr

00008e18 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    8e18:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008e1c <_ZL13Lock_Unlocked>:
    8e1c:	00000000 	andeq	r0, r0, r0

00008e20 <_ZL11Lock_Locked>:
    8e20:	00000001 	andeq	r0, r0, r1

00008e24 <_ZL21MaxFSDriverNameLength>:
    8e24:	00000010 	andeq	r0, r0, r0, lsl r0

00008e28 <_ZL17MaxFilenameLength>:
    8e28:	00000010 	andeq	r0, r0, r0, lsl r0

00008e2c <_ZL13MaxPathLength>:
    8e2c:	00000080 	andeq	r0, r0, r0, lsl #1

00008e30 <_ZL18NoFilesystemDriver>:
    8e30:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e34 <_ZL9NotifyAll>:
    8e34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e38 <_ZL24Max_Process_Opened_Files>:
    8e38:	00000010 	andeq	r0, r0, r0, lsl r0

00008e3c <_ZL10Indefinite>:
    8e3c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e40 <_ZL18Deadline_Unchanged>:
    8e40:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008e44 <_ZL14Invalid_Handle>:
    8e44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e48 <_ZN3halL18Default_Clock_RateE>:
    8e48:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008e4c <_ZN3halL15Peripheral_BaseE>:
    8e4c:	20000000 	andcs	r0, r0, r0

00008e50 <_ZN3halL9GPIO_BaseE>:
    8e50:	20200000 	eorcs	r0, r0, r0

00008e54 <_ZN3halL14GPIO_Pin_CountE>:
    8e54:	00000036 	andeq	r0, r0, r6, lsr r0

00008e58 <_ZN3halL8AUX_BaseE>:
    8e58:	20215000 	eorcs	r5, r1, r0

00008e5c <_ZN3halL25Interrupt_Controller_BaseE>:
    8e5c:	2000b200 	andcs	fp, r0, r0, lsl #4

00008e60 <_ZN3halL10Timer_BaseE>:
    8e60:	2000b400 	andcs	fp, r0, r0, lsl #8

00008e64 <_ZN3halL9TRNG_BaseE>:
    8e64:	20104000 	andscs	r4, r0, r0

00008e68 <_ZN3halL9BSC0_BaseE>:
    8e68:	20205000 	eorcs	r5, r0, r0

00008e6c <_ZN3halL9BSC1_BaseE>:
    8e6c:	20804000 	addcs	r4, r0, r0

00008e70 <_ZN3halL9BSC2_BaseE>:
    8e70:	20805000 	addcs	r5, r0, r0

00008e74 <_ZL11Invalid_Pin>:
    8e74:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8e78:	3a564544 	bcc	159a390 <__bss_end+0x1591498>
    8e7c:	6f697067 	svcvs	0x00697067
    8e80:	0033322f 	eorseq	r3, r3, pc, lsr #4
    8e84:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8e88:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    8e8c:	00505520 	subseq	r5, r0, r0, lsr #10
    8e90:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    8e94:	574f4420 	strbpl	r4, [pc, -r0, lsr #8]
    8e98:	0000004e 	andeq	r0, r0, lr, asr #32

00008e9c <_ZL13Lock_Unlocked>:
    8e9c:	00000000 	andeq	r0, r0, r0

00008ea0 <_ZL11Lock_Locked>:
    8ea0:	00000001 	andeq	r0, r0, r1

00008ea4 <_ZL21MaxFSDriverNameLength>:
    8ea4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ea8 <_ZL17MaxFilenameLength>:
    8ea8:	00000010 	andeq	r0, r0, r0, lsl r0

00008eac <_ZL13MaxPathLength>:
    8eac:	00000080 	andeq	r0, r0, r0, lsl #1

00008eb0 <_ZL18NoFilesystemDriver>:
    8eb0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008eb4 <_ZL9NotifyAll>:
    8eb4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008eb8 <_ZL24Max_Process_Opened_Files>:
    8eb8:	00000010 	andeq	r0, r0, r0, lsl r0

00008ebc <_ZL10Indefinite>:
    8ebc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ec0 <_ZL18Deadline_Unchanged>:
    8ec0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008ec4 <_ZL14Invalid_Handle>:
    8ec4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ec8 <_ZL16Pipe_File_Prefix>:
    8ec8:	3a535953 	bcc	14df41c <__bss_end+0x14d6524>
    8ecc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8ed0:	0000002f 	andeq	r0, r0, pc, lsr #32

00008ed4 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8ed4:	33323130 	teqcc	r2, #48, 2
    8ed8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8edc:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8ee0:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008ee8 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684934>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3952c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d140>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7e2c>
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
  34:	5a2f7374 	bpl	bdce0c <__bss_end+0xbd3f14>
  38:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; fffffeac <__bss_end+0xffff6fb4>
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
 124:	fb010200 	blx	4092e <__bss_end+0x37a36>
 128:	01000d0e 	tsteq	r0, lr, lsl #26
 12c:	00010101 	andeq	r0, r1, r1, lsl #2
 130:	00010000 	andeq	r0, r1, r0
 134:	6d2f0100 	stfvss	f0, [pc, #-0]	; 13c <shift+0x13c>
 138:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 13c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 140:	4b2f7372 	blmi	bdcf10 <__bss_end+0xbd4018>
 144:	2f616275 	svccs	0x00616275
 148:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 14c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 150:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 154:	614d6f72 	hvcvs	55026	; 0xd6f2
 158:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbec <__bss_end+0xffff6cf4>
 15c:	706d6178 	rsbvc	r6, sp, r8, ror r1
 160:	2f73656c 	svccs	0x0073656c
 164:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 168:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb0c <__bss_end+0xffff6c14>
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
 1cc:	4a030402 	bmi	c11dc <__bss_end+0xb82e4>
 1d0:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 1d4:	05830204 	streq	r0, [r3, #516]	; 0x204
 1d8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 1dc:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 1e0:	02040200 	andeq	r0, r4, #0, 4
 1e4:	850c052d 	strhi	r0, [ip, #-1325]	; 0xfffffad3
 1e8:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 1ec:	056a1005 	strbeq	r1, [sl, #-5]!
 1f0:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
 1f4:	0a054a03 	beq	152a08 <__bss_end+0x149b10>
 1f8:	02040200 	andeq	r0, r4, #0, 4
 1fc:	00110583 	andseq	r0, r1, r3, lsl #11
 200:	4a020402 	bmi	81210 <__bss_end+0x78318>
 204:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 208:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 20c:	0105850c 	tsteq	r5, ip, lsl #10
 210:	000a022f 	andeq	r0, sl, pc, lsr #4
 214:	027d0101 	rsbseq	r0, sp, #1073741824	; 0x40000000
 218:	00030000 	andeq	r0, r3, r0
 21c:	0000023e 	andeq	r0, r0, lr, lsr r2
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
 270:	746c6974 	strbtvc	r6, [ip], #-2420	; 0xfffff68c
 274:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 278:	6d2f006b 	stcvs	0, cr0, [pc, #-428]!	; d4 <shift+0xd4>
 27c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 280:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 284:	4b2f7372 	blmi	bdd054 <__bss_end+0xbd415c>
 288:	2f616275 	svccs	0x00616275
 28c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 290:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 294:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 298:	614d6f72 	hvcvs	55026	; 0xd6f2
 29c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffd30 <__bss_end+0xffff6e38>
 2a0:	706d6178 	rsbvc	r6, sp, r8, ror r1
 2a4:	2f73656c 	svccs	0x0073656c
 2a8:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 2ac:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffc50 <__bss_end+0xffff6d58>
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
 2ec:	5a2f7374 	bpl	bdd0c4 <__bss_end+0xbd41cc>
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
 340:	5a2f7374 	bpl	bdd118 <__bss_end+0xbd4220>
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
 384:	2f006c61 	svccs	0x00006c61
 388:	2f746e6d 	svccs	0x00746e6d
 38c:	73552f63 	cmpvc	r5, #396	; 0x18c
 390:	2f737265 	svccs	0x00737265
 394:	6162754b 	cmnvs	r2, fp, asr #10
 398:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
 39c:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
 3a0:	5a2f7374 	bpl	bdd178 <__bss_end+0xbd4280>
 3a4:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 218 <shift+0x218>
 3a8:	2f657461 	svccs	0x00657461
 3ac:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
 3b0:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
 3b4:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
 3b8:	2f666465 	svccs	0x00666465
 3bc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 3c0:	63617073 	cmnvs	r1, #115	; 0x73
 3c4:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 3c8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 3cc:	2f6c656e 	svccs	0x006c656e
 3d0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 3d4:	2f656475 	svccs	0x00656475
 3d8:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 3dc:	00737265 	rsbseq	r7, r3, r5, ror #4
 3e0:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 3e4:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 3e8:	00010070 	andeq	r0, r1, r0, ror r0
 3ec:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 3f0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3f4:	70730000 	rsbsvc	r0, r3, r0
 3f8:	6f6c6e69 	svcvs	0x006c6e69
 3fc:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 400:	00000200 	andeq	r0, r0, r0, lsl #4
 404:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 408:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 40c:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 410:	00000300 	andeq	r0, r0, r0, lsl #6
 414:	636f7270 	cmnvs	pc, #112, 4
 418:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 41c:	00020068 	andeq	r0, r2, r8, rrx
 420:	6f727000 	svcvs	0x00727000
 424:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 428:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 42c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 430:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 434:	65700000 	ldrbvs	r0, [r0, #-0]!
 438:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 43c:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 440:	00682e73 	rsbeq	r2, r8, r3, ror lr
 444:	67000004 	strvs	r0, [r0, -r4]
 448:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
 44c:	00050068 	andeq	r0, r5, r8, rrx
 450:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 454:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 458:	00040068 	andeq	r0, r4, r8, rrx
 45c:	01050000 	mrseq	r0, (UNDEF: 5)
 460:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
 464:	03000082 	movweq	r0, #130	; 0x82
 468:	0a05010e 	beq	1408a8 <__bss_end+0x1379b0>
 46c:	24054b9f 	strcs	r4, [r5], #-2975	; 0xfffff461
 470:	8a0c054c 	bhi	3019a8 <__bss_end+0x2f8ab0>
 474:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
 478:	0d05a01c 	stceq	0, cr10, [r5, #-112]	; 0xffffff90
 47c:	05820903 	streq	r0, [r2, #2307]	; 0x903
 480:	0d05a217 	sfmeq	f2, 1, [r5, #-92]	; 0xffffffa4
 484:	4c16052e 	cfldr32mi	mvfx0, [r6], {46}	; 0x2e
 488:	0e0584a2 	cdpeq	4, 0, cr8, cr5, cr2, {5}
 48c:	030d054d 	movweq	r0, #54605	; 0xd54d
 490:	0a026671 	beq	99e5c <__bss_end+0x90f64>
 494:	88010100 	stmdahi	r1, {r8}
 498:	03000002 	movweq	r0, #2
 49c:	00019d00 	andeq	r9, r1, r0, lsl #26
 4a0:	fb010200 	blx	40caa <__bss_end+0x37db2>
 4a4:	01000d0e 	tsteq	r0, lr, lsl #26
 4a8:	00010101 	andeq	r0, r1, r1, lsl #2
 4ac:	00010000 	andeq	r0, r1, r0
 4b0:	6d2f0100 	stfvss	f0, [pc, #-0]	; 4b8 <shift+0x4b8>
 4b4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 4b8:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 4bc:	4b2f7372 	blmi	bdd28c <__bss_end+0xbd4394>
 4c0:	2f616275 	svccs	0x00616275
 4c4:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 4c8:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 4cc:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 4d0:	614d6f72 	hvcvs	55026	; 0xd6f2
 4d4:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffff68 <__bss_end+0xffff7070>
 4d8:	706d6178 	rsbvc	r6, sp, r8, ror r1
 4dc:	2f73656c 	svccs	0x0073656c
 4e0:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 4e4:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
 4e8:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 4ec:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 4f0:	6d2f0063 	stcvs	0, cr0, [pc, #-396]!	; 36c <shift+0x36c>
 4f4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 4f8:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 4fc:	4b2f7372 	blmi	bdd2cc <__bss_end+0xbd43d4>
 500:	2f616275 	svccs	0x00616275
 504:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 508:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 50c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 510:	614d6f72 	hvcvs	55026	; 0xd6f2
 514:	652f6574 	strvs	r6, [pc, #-1396]!	; ffffffa8 <__bss_end+0xffff70b0>
 518:	706d6178 	rsbvc	r6, sp, r8, ror r1
 51c:	2f73656c 	svccs	0x0073656c
 520:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 524:	6b2f6664 	blvs	bd9ebc <__bss_end+0xbd0fc4>
 528:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 52c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 530:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 534:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 538:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 53c:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 378 <shift+0x378>
 540:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 544:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 548:	4b2f7372 	blmi	bdd318 <__bss_end+0xbd4420>
 54c:	2f616275 	svccs	0x00616275
 550:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 554:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 558:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 55c:	614d6f72 	hvcvs	55026	; 0xd6f2
 560:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffff4 <__bss_end+0xffff70fc>
 564:	706d6178 	rsbvc	r6, sp, r8, ror r1
 568:	2f73656c 	svccs	0x0073656c
 56c:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 570:	6b2f6664 	blvs	bd9f08 <__bss_end+0xbd1010>
 574:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 578:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 57c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 580:	73662f65 	cmnvc	r6, #404	; 0x194
 584:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 588:	2f632f74 	svccs	0x00632f74
 58c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
 590:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
 594:	442f6162 	strtmi	r6, [pc], #-354	; 59c <shift+0x59c>
 598:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
 59c:	73746e65 	cmnvc	r4, #1616	; 0x650
 5a0:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 5a4:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 5a8:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 5ac:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 5b0:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
 5b4:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
 5b8:	656b2f66 	strbvs	r2, [fp, #-3942]!	; 0xfffff09a
 5bc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 5c0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 5c4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 5c8:	616f622f 	cmnvs	pc, pc, lsr #4
 5cc:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 5d0:	2f306970 	svccs	0x00306970
 5d4:	006c6168 	rsbeq	r6, ip, r8, ror #2
 5d8:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 5dc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5e0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 5e4:	00000100 	andeq	r0, r0, r0, lsl #2
 5e8:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 5ec:	00020068 	andeq	r0, r2, r8, rrx
 5f0:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 5f4:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 5f8:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 5fc:	66000002 	strvs	r0, [r0], -r2
 600:	73656c69 	cmnvc	r5, #26880	; 0x6900
 604:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 608:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 60c:	70000003 	andvc	r0, r0, r3
 610:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 614:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 618:	00000200 	andeq	r0, r0, r0, lsl #4
 61c:	636f7270 	cmnvs	pc, #112, 4
 620:	5f737365 	svcpl	0x00737365
 624:	616e616d 	cmnvs	lr, sp, ror #2
 628:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 62c:	00020068 	andeq	r0, r2, r8, rrx
 630:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 634:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 638:	00040068 	andeq	r0, r4, r8, rrx
 63c:	01050000 	mrseq	r0, (UNDEF: 5)
 640:	f8020500 			; <UNDEFINED> instruction: 0xf8020500
 644:	16000082 	strne	r0, [r0], -r2, lsl #1
 648:	2f690505 	svccs	0x00690505
 64c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 650:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 654:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
 658:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 65c:	01054b05 	tsteq	r5, r5, lsl #22
 660:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 664:	2f4b4ba1 	svccs	0x004b4ba1
 668:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 66c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 670:	4b4bbd05 	blmi	12efa8c <__bss_end+0x12e6b94>
 674:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 678:	2f01054c 	svccs	0x0001054c
 67c:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 680:	2f4b4b4b 	svccs	0x004b4b4b
 684:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 688:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 68c:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
 690:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 694:	4b4bbd05 	blmi	12efab0 <__bss_end+0x12e6bb8>
 698:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 69c:	2f01054c 	svccs	0x0001054c
 6a0:	a1050585 	smlabbge	r5, r5, r5, r0
 6a4:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffb61 <__bss_end+0xffff6c69>
 6a8:	01054c0c 	tsteq	r5, ip, lsl #24
 6ac:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 6b0:	4b4b4bbd 	blmi	12d35ac <__bss_end+0x12ca6b4>
 6b4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6b8:	852f0105 	strhi	r0, [pc, #-261]!	; 5bb <shift+0x5bb>
 6bc:	4ba10505 	blmi	fe841ad8 <__bss_end+0xfe838be0>
 6c0:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 6c4:	9f01054c 	svcls	0x0001054c
 6c8:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6cc:	4b4d0505 	blmi	1341ae8 <__bss_end+0x1338bf0>
 6d0:	300c054b 	andcc	r0, ip, fp, asr #10
 6d4:	852f0105 	strhi	r0, [pc, #-261]!	; 5d7 <shift+0x5d7>
 6d8:	05672005 	strbeq	r2, [r7, #-5]!
 6dc:	4b4b4d05 	blmi	12d3af8 <__bss_end+0x12cac00>
 6e0:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6e4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6e8:	05058320 	streq	r8, [r5, #-800]	; 0xfffffce0
 6ec:	054b4b4c 	strbeq	r4, [fp, #-2892]	; 0xfffff4b4
 6f0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6f4:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
 6f8:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
 6fc:	0105300c 	tsteq	r5, ip
 700:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 704:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 708:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 70c:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 710:	1305300f 	movwne	r3, #20495	; 0x500f
 714:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 718:	05d81005 	ldrbeq	r1, [r8, #5]
 71c:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 720:	87010100 	strhi	r0, [r1, -r0, lsl #2]
 724:	03000002 	movweq	r0, #2
 728:	00006400 	andeq	r6, r0, r0, lsl #8
 72c:	fb010200 	blx	40f36 <__bss_end+0x3803e>
 730:	01000d0e 	tsteq	r0, lr, lsl #26
 734:	00010101 	andeq	r0, r1, r1, lsl #2
 738:	00010000 	andeq	r0, r1, r0
 73c:	6d2f0100 	stfvss	f0, [pc, #-0]	; 744 <shift+0x744>
 740:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 744:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
 748:	4b2f7372 	blmi	bdd518 <__bss_end+0xbd4620>
 74c:	2f616275 	svccs	0x00616275
 750:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
 754:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
 758:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
 75c:	614d6f72 	hvcvs	55026	; 0xd6f2
 760:	652f6574 	strvs	r6, [pc, #-1396]!	; 1f4 <shift+0x1f4>
 764:	706d6178 	rsbvc	r6, sp, r8, ror r1
 768:	2f73656c 	svccs	0x0073656c
 76c:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
 770:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
 774:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 778:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 77c:	73000063 	movwvc	r0, #99	; 0x63
 780:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 784:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 788:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 78c:	00000100 	andeq	r0, r0, r0, lsl #2
 790:	00010500 	andeq	r0, r1, r0, lsl #10
 794:	87540205 	ldrbhi	r0, [r4, -r5, lsl #4]
 798:	051a0000 	ldreq	r0, [sl, #-0]
 79c:	1205bb09 	andne	fp, r5, #9216	; 0x2400
 7a0:	6827054c 	stmdavs	r7!, {r2, r3, r6, r8, sl}
 7a4:	05ba1005 	ldreq	r1, [sl, #5]!
 7a8:	2d052e11 	stccs	14, cr2, [r5, #-68]	; 0xffffffbc
 7ac:	4a13054a 	bmi	4c1cdc <__bss_end+0x4b8de4>
 7b0:	052f0f05 	streq	r0, [pc, #-3845]!	; fffff8b3 <__bss_end+0xffff69bb>
 7b4:	05059f0a 	streq	r9, [r5, #-3850]	; 0xfffff0f6
 7b8:	10053562 	andne	r3, r5, r2, ror #10
 7bc:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 7c0:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 7c4:	0a052e13 	beq	14c018 <__bss_end+0x143120>
 7c8:	690c052f 	stmdbvs	ip, {r0, r1, r2, r3, r5, r8, sl}
 7cc:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
 7d0:	06054a0f 	streq	r4, [r5], -pc, lsl #20
 7d4:	680e054b 	stmdavs	lr, {r0, r1, r3, r6, r8, sl}
 7d8:	02001c05 	andeq	r1, r0, #1280	; 0x500
 7dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 7e0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 7e4:	1b059e03 	blne	167ff8 <__bss_end+0x15f100>
 7e8:	02040200 	andeq	r0, r4, #0, 4
 7ec:	001e0568 	andseq	r0, lr, r8, ror #10
 7f0:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 7f4:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 7f8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 7fc:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 800:	21054b02 	tstcs	r5, r2, lsl #22
 804:	02040200 	andeq	r0, r4, #0, 4
 808:	0012052e 	andseq	r0, r2, lr, lsr #10
 80c:	4a020402 	bmi	8181c <__bss_end+0x78924>
 810:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 814:	05820204 	streq	r0, [r2, #516]	; 0x204
 818:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 81c:	17054a02 	strne	r4, [r5, -r2, lsl #20]
 820:	02040200 	andeq	r0, r4, #0, 4
 824:	0010052e 	andseq	r0, r0, lr, lsr #10
 828:	2f020402 	svccs	0x00020402
 82c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 830:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 834:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 838:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 83c:	02040200 	andeq	r0, r4, #0, 4
 840:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 844:	83090585 	movwhi	r0, #38277	; 0x9585
 848:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 84c:	10054a13 	andne	r4, r5, r3, lsl sl
 850:	bb0d054c 	bllt	341d88 <__bss_end+0x338e90>
 854:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 858:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 85c:	1a054a01 	bne	153068 <__bss_end+0x14a170>
 860:	01040200 	mrseq	r0, R12_usr
 864:	4d13054a 	cfldr32mi	mvfx0, [r3, #-296]	; 0xfffffed8
 868:	054a1a05 	strbeq	r1, [sl, #-2565]	; 0xfffff5fb
 86c:	0e052e10 	mcreq	14, 0, r2, cr5, cr0, {0}
 870:	03050568 	movweq	r0, #21864	; 0x5568
 874:	0c056678 	stceq	6, cr6, [r5], {120}	; 0x78
 878:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
 87c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 880:	1905bd0c 	stmdbne	r5, {r2, r3, r8, sl, fp, ip, sp, pc}
 884:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 888:	0020054a 	eoreq	r0, r0, sl, asr #10
 88c:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 890:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
 894:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 898:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 89c:	17056602 	strne	r6, [r5, -r2, lsl #12]
 8a0:	03040200 	movweq	r0, #16896	; 0x4200
 8a4:	0018054b 	andseq	r0, r8, fp, asr #10
 8a8:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 8ac:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 8b0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 8b4:	0402000f 	streq	r0, [r2], #-15
 8b8:	18052e03 	stmdane	r5, {r0, r1, r9, sl, fp, sp}
 8bc:	03040200 	movweq	r0, #16896	; 0x4200
 8c0:	0011054a 	andseq	r0, r1, sl, asr #10
 8c4:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 8c8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 8cc:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
 8d0:	0402000e 	streq	r0, [r2], #-14
 8d4:	02008402 	andeq	r8, r0, #33554432	; 0x2000000
 8d8:	05830104 	streq	r0, [r3, #260]	; 0x104
 8dc:	0402000f 	streq	r0, [r2], #-15
 8e0:	11052e01 	tstne	r5, r1, lsl #28
 8e4:	01040200 	mrseq	r0, R12_usr
 8e8:	0005054a 	andeq	r0, r5, sl, asr #10
 8ec:	49010402 	stmdbmi	r1, {r1, sl}
 8f0:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 8f4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 8f8:	1205bc0f 	andne	fp, r5, #3840	; 0xf00
 8fc:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 900:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
 904:	0c054b20 			; <UNDEFINED> instruction: 0x0c054b20
 908:	4b090566 	blmi	241ea8 <__bss_end+0x238fb0>
 90c:	05831405 	streq	r1, [r3, #1029]	; 0x405
 910:	09052e19 	stmdbeq	r5, {r0, r3, r4, r9, sl, fp, sp}
 914:	67140567 	ldrvs	r0, [r4, -r7, ror #10]
 918:	054d0c05 	strbeq	r0, [sp, #-3077]	; 0xfffff3fb
 91c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 920:	0e058309 	cdpeq	3, 0, cr8, cr5, cr9, {0}
 924:	2e0f054c 	cfsh32cs	mvfx0, mvfx15, #44
 928:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
 92c:	05054b0a 	streq	r4, [r5, #-2826]	; 0xfffff4f6
 930:	310c0565 	tstcc	ip, r5, ror #10
 934:	852f0105 	strhi	r0, [pc, #-261]!	; 837 <shift+0x837>
 938:	059f0b05 	ldreq	r0, [pc, #2821]	; 1445 <shift+0x1445>
 93c:	17054c0e 	strne	r4, [r5, -lr, lsl #24]
 940:	03040200 	movweq	r0, #16896	; 0x4200
 944:	000d054a 	andeq	r0, sp, sl, asr #10
 948:	83020402 	movwhi	r0, #9218	; 0x2402
 94c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 950:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 954:	04020010 	streq	r0, [r2], #-16
 958:	05054a02 	streq	r4, [r5, #-2562]	; 0xfffff5fe
 95c:	02040200 	andeq	r0, r4, #0, 4
 960:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 964:	bb110585 	bllt	441f80 <__bss_end+0x439088>
 968:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
 96c:	17054c0e 	strne	r4, [r5, -lr, lsl #24]
 970:	03040200 	movweq	r0, #16896	; 0x4200
 974:	001c054a 	andseq	r0, ip, sl, asr #10
 978:	83020402 	movwhi	r0, #9218	; 0x2402
 97c:	02001d05 	andeq	r1, r0, #320	; 0x140
 980:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 984:	04020010 	streq	r0, [r2], #-16
 988:	11054a02 	tstne	r5, r2, lsl #20
 98c:	02040200 	andeq	r0, r4, #0, 4
 990:	001d052e 	andseq	r0, sp, lr, lsr #10
 994:	4a020402 	bmi	819a4 <__bss_end+0x78aac>
 998:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 99c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 9a0:	04020005 	streq	r0, [r2], #-5
 9a4:	01052d02 	tsteq	r5, r2, lsl #26
 9a8:	00080284 	andeq	r0, r8, r4, lsl #5
 9ac:	00790101 	rsbseq	r0, r9, r1, lsl #2
 9b0:	00030000 	andeq	r0, r3, r0
 9b4:	00000046 	andeq	r0, r0, r6, asr #32
 9b8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 9bc:	0101000d 	tsteq	r1, sp
 9c0:	00000101 	andeq	r0, r0, r1, lsl #2
 9c4:	00000100 	andeq	r0, r0, r0, lsl #2
 9c8:	2f2e2e01 	svccs	0x002e2e01
 9cc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9d0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9d4:	2f2e2e2f 	svccs	0x002e2e2f
 9d8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 928 <shift+0x928>
 9dc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 9e0:	6f632f63 	svcvs	0x00632f63
 9e4:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 9e8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 9ec:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 9f0:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 9f4:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 9f8:	00010053 	andeq	r0, r1, r3, asr r0
 9fc:	05000000 	streq	r0, [r0, #-0]
 a00:	008c0c02 	addeq	r0, ip, r2, lsl #24
 a04:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
 a08:	2f2f3001 	svccs	0x002f3001
 a0c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 a10:	1401d002 	strne	sp, [r1], #-2
 a14:	2f2f312f 	svccs	0x002f312f
 a18:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 a1c:	2f661f03 	svccs	0x00661f03
 a20:	2f2f2f2f 	svccs	0x002f2f2f
 a24:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 a28:	5c010100 	stfpls	f0, [r1], {-0}
 a2c:	03000000 	movweq	r0, #0
 a30:	00004600 	andeq	r4, r0, r0, lsl #12
 a34:	fb010200 	blx	4123e <__bss_end+0x38346>
 a38:	01000d0e 	tsteq	r0, lr, lsl #26
 a3c:	00010101 	andeq	r0, r1, r1, lsl #2
 a40:	00010000 	andeq	r0, r1, r0
 a44:	2e2e0100 	sufcse	f0, f6, f0
 a48:	2f2e2e2f 	svccs	0x002e2e2f
 a4c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a54:	2f2e2e2f 	svccs	0x002e2e2f
 a58:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a5c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 a60:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 a64:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 a68:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 a6c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 a70:	73636e75 	cmnvc	r3, #1872	; 0x750
 a74:	0100532e 	tsteq	r0, lr, lsr #6
 a78:	00000000 	andeq	r0, r0, r0
 a7c:	8e180205 	cdphi	2, 1, cr0, cr8, cr5, {0}
 a80:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
 a84:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 a88:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
 a8c:	03000000 	movweq	r0, #0
 a90:	00009e00 	andeq	r9, r0, r0, lsl #28
 a94:	fb010200 	blx	4129e <__bss_end+0x383a6>
 a98:	01000d0e 	tsteq	r0, lr, lsl #26
 a9c:	00010101 	andeq	r0, r1, r1, lsl #2
 aa0:	00010000 	andeq	r0, r1, r0
 aa4:	2e2e0100 	sufcse	f0, f6, f0
 aa8:	2f2e2e2f 	svccs	0x002e2e2f
 aac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ab0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ab4:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 ab8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 abc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ac0:	2f2e2e2f 	svccs	0x002e2e2f
 ac4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ac8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 acc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 ad0:	2f636367 	svccs	0x00636367
 ad4:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 ad8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 adc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 ae0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 ae4:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 ae8:	2f2e2e2f 	svccs	0x002e2e2f
 aec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 af0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 af4:	2f2e2e2f 	svccs	0x002e2e2f
 af8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 afc:	00006363 	andeq	r6, r0, r3, ror #6
 b00:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 b04:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 b08:	00010068 	andeq	r0, r1, r8, rrx
 b0c:	6d726100 	ldfvse	f6, [r2, #-0]
 b10:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 b14:	62670000 	rsbvs	r0, r7, #0
 b18:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 b1c:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 b20:	00030068 	andeq	r0, r3, r8, rrx
 b24:	62696c00 	rsbvs	r6, r9, #0, 24
 b28:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 b2c:	0300632e 	movweq	r6, #814	; 0x32e
 b30:	Address 0x0000000000000b30 is out of bounds.


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
      34:	3a0c0000 	bcc	30003c <__bss_end+0x2f7144>
      38:	46000001 	strmi	r0, [r0], -r1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	76000000 	strvc	r0, [r0], -r0
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a1 	andeq	r0, r0, r1, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	14de0704 	ldrbne	r0, [lr], #1796	; 0x704
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x371c0>
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
     11c:	14de0704 	ldrbne	r0, [lr], #1796	; 0x704
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
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7688>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ee 	andeq	r0, r0, lr, ror #3
     184:	d20f4901 	andle	r4, pc, #16384	; 0x4000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x144e0>
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
     254:	cb140a01 	blgt	502a60 <__bss_end+0x4f9b68>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37568>
     2c0:	00019e31 	andeq	r9, r1, r1, lsr lr
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	08210000 	stmdaeq	r1!, {}	; <UNPREDICTABLE>
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02d40104 	sbcseq	r0, r4, #4, 2
     2d8:	8f040000 	svchi	0x00040000
     2dc:	46000005 	strmi	r0, [r0], -r5
     2e0:	2c000000 	stccs	0, cr0, [r0], {-0}
     2e4:	cc000082 	stcgt	0, cr0, [r0], {130}	; 0x82
     2e8:	16000000 	strne	r0, [r0], -r0
     2ec:	02000002 	andeq	r0, r0, #2
     2f0:	09670801 	stmdbeq	r7!, {r0, fp}^
     2f4:	02020000 	andeq	r0, r2, #0
     2f8:	0009a105 	andeq	sl, r9, r5, lsl #2
     2fc:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
     300:	00746e69 	rsbseq	r6, r4, r9, ror #28
     304:	5e080102 	adfple	f0, f0, f2
     308:	02000009 	andeq	r0, r0, #9
     30c:	07a20702 	streq	r0, [r2, r2, lsl #14]!
     310:	ea040000 	b	100318 <__bss_end+0xf7420>
     314:	09000009 	stmdbeq	r0, {r0, r3}
     318:	00590709 	subseq	r0, r9, r9, lsl #14
     31c:	48050000 	stmdami	r5, {}	; <UNPREDICTABLE>
     320:	02000000 	andeq	r0, r0, #0
     324:	14de0704 	ldrbne	r0, [lr], #1796	; 0x704
     328:	59050000 	stmdbpl	r5, {}	; <UNPREDICTABLE>
     32c:	06000000 	streq	r0, [r0], -r0
     330:	0000062d 	andeq	r0, r0, sp, lsr #12
     334:	08060208 	stmdaeq	r6, {r3, r9}
     338:	0000008b 	andeq	r0, r0, fp, lsl #1
     33c:	00307207 	eorseq	r7, r0, r7, lsl #4
     340:	480e0802 	stmdami	lr, {r1, fp}
     344:	00000000 	andeq	r0, r0, r0
     348:	00317207 	eorseq	r7, r1, r7, lsl #4
     34c:	480e0902 	stmdami	lr, {r1, r8, fp}
     350:	04000000 	streq	r0, [r0], #-0
     354:	04bc0800 	ldrteq	r0, [ip], #2048	; 0x800
     358:	04050000 	streq	r0, [r5], #-0
     35c:	00000033 	andeq	r0, r0, r3, lsr r0
     360:	c20c1e02 	andgt	r1, ip, #2, 28
     364:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     368:	000006a1 	andeq	r0, r0, r1, lsr #13
     36c:	0c1b0900 			; <UNDEFINED> instruction: 0x0c1b0900
     370:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     374:	00000bfb 	strdeq	r0, [r0], -fp
     378:	07ed0902 	strbeq	r0, [sp, r2, lsl #18]!
     37c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     380:	000008e2 	andeq	r0, r0, r2, ror #17
     384:	066a0904 	strbteq	r0, [sl], -r4, lsl #18
     388:	00050000 	andeq	r0, r5, r0
     38c:	000ba808 	andeq	sl, fp, r8, lsl #16
     390:	33040500 	movwcc	r0, #17664	; 0x4500
     394:	02000000 	andeq	r0, r0, #0
     398:	00ff0c40 	rscseq	r0, pc, r0, asr #24
     39c:	c3090000 	movwgt	r0, #36864	; 0x9000
     3a0:	00000003 	andeq	r0, r0, r3
     3a4:	0004d109 	andeq	sp, r4, r9, lsl #2
     3a8:	d5090100 	strle	r0, [r9, #-256]	; 0xffffff00
     3ac:	02000008 	andeq	r0, r0, #8
     3b0:	000be509 	andeq	lr, fp, r9, lsl #10
     3b4:	25090300 	strcs	r0, [r9, #-768]	; 0xfffffd00
     3b8:	0400000c 	streq	r0, [r0], #-12
     3bc:	00089c09 	andeq	r9, r8, r9, lsl #24
     3c0:	c2090500 	andgt	r0, r9, #0, 10
     3c4:	06000007 	streq	r0, [r0], -r7
     3c8:	0b620800 	bleq	18823d0 <__bss_end+0x18794d8>
     3cc:	04050000 	streq	r0, [r5], #-0
     3d0:	00000033 	andeq	r0, r0, r3, lsr r0
     3d4:	2a0c6702 	bcs	319fe4 <__bss_end+0x3110ec>
     3d8:	09000001 	stmdbeq	r0, {r0}
     3dc:	00000945 	andeq	r0, r0, r5, asr #18
     3e0:	07840900 	streq	r0, [r4, r0, lsl #18]
     3e4:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     3e8:	000009ab 	andeq	r0, r0, fp, lsr #19
     3ec:	07c70902 	strbeq	r0, [r7, r2, lsl #18]
     3f0:	00030000 	andeq	r0, r3, r0
     3f4:	0008b60a 	andeq	fp, r8, sl, lsl #12
     3f8:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     3fc:	00000054 	andeq	r0, r0, r4, asr r0
     400:	8e1c0305 	cdphi	3, 1, cr0, cr12, cr5, {0}
     404:	c40a0000 	strgt	r0, [sl], #-0
     408:	03000008 	movweq	r0, #8
     40c:	00541406 	subseq	r1, r4, r6, lsl #8
     410:	03050000 	movweq	r0, #20480	; 0x5000
     414:	00008e20 	andeq	r8, r0, r0, lsr #28
     418:	0008860a 	andeq	r8, r8, sl, lsl #12
     41c:	1a070400 	bne	1c1424 <__bss_end+0x1b852c>
     420:	00000054 	andeq	r0, r0, r4, asr r0
     424:	8e240305 	cdphi	3, 2, cr0, cr4, cr5, {0}
     428:	fa0a0000 	blx	280430 <__bss_end+0x277538>
     42c:	04000004 	streq	r0, [r0], #-4
     430:	00541a09 	subseq	r1, r4, r9, lsl #20
     434:	03050000 	movweq	r0, #20480	; 0x5000
     438:	00008e28 	andeq	r8, r0, r8, lsr #28
     43c:	0009500a 	andeq	r5, r9, sl
     440:	1a0b0400 	bne	2c1448 <__bss_end+0x2b8550>
     444:	00000054 	andeq	r0, r0, r4, asr r0
     448:	8e2c0305 	cdphi	3, 2, cr0, cr12, cr5, {0}
     44c:	710a0000 	mrsvc	r0, (UNDEF: 10)
     450:	04000007 	streq	r0, [r0], #-7
     454:	00541a0d 	subseq	r1, r4, sp, lsl #20
     458:	03050000 	movweq	r0, #20480	; 0x5000
     45c:	00008e30 	andeq	r8, r0, r0, lsr lr
     460:	0006530a 	andeq	r5, r6, sl, lsl #6
     464:	1a0f0400 	bne	3c146c <__bss_end+0x3b8574>
     468:	00000054 	andeq	r0, r0, r4, asr r0
     46c:	8e340305 	cdphi	3, 3, cr0, cr4, cr5, {0}
     470:	ef080000 	svc	0x00080000
     474:	0500000f 	streq	r0, [r0, #-15]
     478:	00003304 	andeq	r3, r0, r4, lsl #6
     47c:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     480:	000001cd 	andeq	r0, r0, sp, asr #3
     484:	000a2709 	andeq	r2, sl, r9, lsl #14
     488:	f0090000 			; <UNDEFINED> instruction: 0xf0090000
     48c:	0100000b 	tsteq	r0, fp
     490:	0008d009 	andeq	sp, r8, r9
     494:	0b000200 	bleq	c9c <shift+0xc9c>
     498:	0000093f 	andeq	r0, r0, pc, lsr r9
     49c:	f3020102 	vrhadd.u8	d0, d2, d2
     4a0:	0c000007 	stceq	0, cr0, [r0], {7}
     4a4:	0001cd04 	andeq	ip, r1, r4, lsl #26
     4a8:	06e90a00 	strbteq	r0, [r9], r0, lsl #20
     4ac:	04050000 	streq	r0, [r5], #-0
     4b0:	00005414 	andeq	r5, r0, r4, lsl r4
     4b4:	38030500 	stmdacc	r3, {r8, sl}
     4b8:	0a00008e 	beq	6f8 <shift+0x6f8>
     4bc:	000003b8 			; <UNDEFINED> instruction: 0x000003b8
     4c0:	54140705 	ldrpl	r0, [r4], #-1797	; 0xfffff8fb
     4c4:	05000000 	streq	r0, [r0, #-0]
     4c8:	008e3c03 	addeq	r3, lr, r3, lsl #24
     4cc:	05280a00 	streq	r0, [r8, #-2560]!	; 0xfffff600
     4d0:	0a050000 	beq	1404d8 <__bss_end+0x1375e0>
     4d4:	00005414 	andeq	r5, r0, r4, lsl r4
     4d8:	40030500 	andmi	r0, r3, r0, lsl #10
     4dc:	0800008e 	stmdaeq	r0, {r1, r2, r3, r7}
     4e0:	00000828 	andeq	r0, r0, r8, lsr #16
     4e4:	00330405 	eorseq	r0, r3, r5, lsl #8
     4e8:	0d050000 	stceq	0, cr0, [r5, #-0]
     4ec:	00024c0c 	andeq	r4, r2, ip, lsl #24
     4f0:	654e0d00 	strbvs	r0, [lr, #-3328]	; 0xfffff300
     4f4:	09000077 	stmdbeq	r0, {r0, r1, r2, r4, r5, r6}
     4f8:	0000081f 	andeq	r0, r0, pc, lsl r8
     4fc:	09d20901 	ldmibeq	r2, {r0, r8, fp}^
     500:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     504:	00000802 	andeq	r0, r0, r2, lsl #16
     508:	07df0903 	ldrbeq	r0, [pc, r3, lsl #18]
     50c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     510:	000008db 	ldrdeq	r0, [r0], -fp
     514:	5d060005 	stcpl	0, cr0, [r6, #-20]	; 0xffffffec
     518:	10000006 	andne	r0, r0, r6
     51c:	8b081d05 	blhi	207938 <__bss_end+0x1fea40>
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
     548:	00000673 	andeq	r0, r0, r3, ror r6
     54c:	8b132205 	blhi	4c8d68 <__bss_end+0x4bfe70>
     550:	0c000002 	stceq	0, cr0, [r0], {2}
     554:	07040200 	streq	r0, [r4, -r0, lsl #4]
     558:	000014d9 	ldrdeq	r1, [r0], -r9
     55c:	00028b05 	andeq	r8, r2, r5, lsl #22
     560:	04250600 	strteq	r0, [r5], #-1536	; 0xfffffa00
     564:	05700000 	ldrbeq	r0, [r0, #-0]!
     568:	0327082a 			; <UNDEFINED> instruction: 0x0327082a
     56c:	1b0e0000 	blne	380574 <__bss_end+0x37767c>
     570:	0500000a 	streq	r0, [r0, #-10]
     574:	024c122c 	subeq	r1, ip, #44, 4	; 0xc0000002
     578:	07000000 	streq	r0, [r0, -r0]
     57c:	00646970 	rsbeq	r6, r4, r0, ror r9
     580:	59122d05 	ldmdbpl	r2, {r0, r2, r8, sl, fp, sp}
     584:	10000000 	andne	r0, r0, r0
     588:	0004980e 	andeq	r9, r4, lr, lsl #16
     58c:	112e0500 			; <UNDEFINED> instruction: 0x112e0500
     590:	00000215 	andeq	r0, r0, r5, lsl r2
     594:	08340e14 	ldmdaeq	r4!, {r2, r4, r9, sl, fp}
     598:	2f050000 	svccs	0x00050000
     59c:	00005912 	andeq	r5, r0, r2, lsl r9
     5a0:	420e1800 	andmi	r1, lr, #0, 16
     5a4:	05000008 	streq	r0, [r0, #-8]
     5a8:	00591231 	subseq	r1, r9, r1, lsr r2
     5ac:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     5b0:	00000646 	andeq	r0, r0, r6, asr #12
     5b4:	270c3205 	strcs	r3, [ip, -r5, lsl #4]
     5b8:	20000003 	andcs	r0, r0, r3
     5bc:	0008580e 	andeq	r5, r8, lr, lsl #16
     5c0:	05340500 	ldreq	r0, [r4, #-1280]!	; 0xfffffb00
     5c4:	00000033 	andeq	r0, r0, r3, lsr r0
     5c8:	0a310e60 	beq	c43f50 <__bss_end+0xc3b058>
     5cc:	35050000 	strcc	r0, [r5, #-0]
     5d0:	0000480e 	andeq	r4, r0, lr, lsl #16
     5d4:	bc0e6400 	cfstrslt	mvf6, [lr], {-0}
     5d8:	05000006 	streq	r0, [r0, #-6]
     5dc:	00480e38 	subeq	r0, r8, r8, lsr lr
     5e0:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     5e4:	000006b3 			; <UNDEFINED> instruction: 0x000006b3
     5e8:	480e3905 	stmdami	lr, {r0, r2, r8, fp, ip, sp}
     5ec:	6c000000 	stcvs	0, cr0, [r0], {-0}
     5f0:	01d90f00 	bicseq	r0, r9, r0, lsl #30
     5f4:	03370000 	teqeq	r7, #0
     5f8:	59100000 	ldmdbpl	r0, {}	; <UNPREDICTABLE>
     5fc:	0f000000 	svceq	0x00000000
     600:	0bc00a00 	bleq	ff002e08 <__bss_end+0xfeff9f10>
     604:	0a060000 	beq	18060c <__bss_end+0x177714>
     608:	00005414 	andeq	r5, r0, r4, lsl r4
     60c:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
     610:	0800008e 	stmdaeq	r0, {r1, r2, r3, r7}
     614:	0000080a 	andeq	r0, r0, sl, lsl #16
     618:	00330405 	eorseq	r0, r3, r5, lsl #8
     61c:	0d060000 	stceq	0, cr0, [r6, #-0]
     620:	0003680c 	andeq	r6, r3, ip, lsl #16
     624:	04d60900 	ldrbeq	r0, [r6], #2304	; 0x900
     628:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     62c:	000003ad 	andeq	r0, r0, sp, lsr #7
     630:	ec060001 	stc	0, cr0, [r6], {1}
     634:	0c00000a 	stceq	0, cr0, [r0], {10}
     638:	9d081b06 	vstrls	d1, [r8, #-24]	; 0xffffffe8
     63c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     640:	000003f7 	strdeq	r0, [r0], -r7
     644:	9d191d06 	ldcls	13, cr1, [r9, #-24]	; 0xffffffe8
     648:	00000003 	andeq	r0, r0, r3
     64c:	0004900e 	andeq	r9, r4, lr
     650:	191e0600 	ldmdbne	lr, {r9, sl}
     654:	0000039d 	muleq	r0, sp, r3
     658:	0aa50e04 	beq	fe943e70 <__bss_end+0xfe93af78>
     65c:	1f060000 	svcne	0x00060000
     660:	0003a313 	andeq	sl, r3, r3, lsl r3
     664:	0c000800 	stceq	8, cr0, [r0], {-0}
     668:	00036804 	andeq	r6, r3, r4, lsl #16
     66c:	97040c00 	strls	r0, [r4, -r0, lsl #24]
     670:	11000002 	tstne	r0, r2
     674:	0000053b 	andeq	r0, r0, fp, lsr r5
     678:	07220614 			; <UNDEFINED> instruction: 0x07220614
     67c:	0000062b 	andeq	r0, r0, fp, lsr #12
     680:	0007f80e 	andeq	pc, r7, lr, lsl #16
     684:	0e260600 	cfmadda32eq	mvax0, mvax0, mvfx6, mvfx0
     688:	00000048 	andeq	r0, r0, r8, asr #32
     68c:	044f0e00 	strbeq	r0, [pc], #-3584	; 694 <shift+0x694>
     690:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
     694:	00039d19 	andeq	r9, r3, r9, lsl sp
     698:	080e0400 	stmdaeq	lr, {sl}
     69c:	0600000a 	streq	r0, [r0], -sl
     6a0:	039d192c 	orrseq	r1, sp, #44, 18	; 0xb0000
     6a4:	12080000 	andne	r0, r8, #0
     6a8:	00000b9e 	muleq	r0, lr, fp
     6ac:	c90a2f06 	stmdbgt	sl, {r1, r2, r8, r9, sl, fp, sp}
     6b0:	f100000a 	cps	#10
     6b4:	fc000003 	stc2	0, cr0, [r0], {3}
     6b8:	13000003 	movwne	r0, #3
     6bc:	00000630 	andeq	r0, r0, r0, lsr r6
     6c0:	00039d14 	andeq	r9, r3, r4, lsl sp
     6c4:	b1150000 	tstlt	r5, r0
     6c8:	0600000a 	streq	r0, [r0], -sl
     6cc:	03fc0a31 	mvnseq	r0, #200704	; 0x31000
     6d0:	01d20000 	bicseq	r0, r2, r0
     6d4:	04140000 	ldreq	r0, [r4], #-0
     6d8:	041f0000 	ldreq	r0, [pc], #-0	; 6e0 <shift+0x6e0>
     6dc:	30130000 	andscc	r0, r3, r0
     6e0:	14000006 	strne	r0, [r0], #-6
     6e4:	000003a3 	andeq	r0, r0, r3, lsr #7
     6e8:	0aff1600 	beq	fffc5ef0 <__bss_end+0xfffbcff8>
     6ec:	35060000 	strcc	r0, [r6, #-0]
     6f0:	000a8019 	andeq	r8, sl, r9, lsl r0
     6f4:	00039d00 	andeq	r9, r3, r0, lsl #26
     6f8:	04380200 	ldrteq	r0, [r8], #-512	; 0xfffffe00
     6fc:	043e0000 	ldrteq	r0, [lr], #-0
     700:	30130000 	andscc	r0, r3, r0
     704:	00000006 	andeq	r0, r0, r6
     708:	0007b516 	andeq	fp, r7, r6, lsl r5
     70c:	19370600 	ldmdbne	r7!, {r9, sl}
     710:	0000096c 	andeq	r0, r0, ip, ror #18
     714:	0000039d 	muleq	r0, sp, r3
     718:	00045702 	andeq	r5, r4, r2, lsl #14
     71c:	00045d00 	andeq	r5, r4, r0, lsl #26
     720:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     724:	17000000 	strne	r0, [r0, -r0]
     728:	0000086e 	andeq	r0, r0, lr, ror #16
     72c:	492d3906 	pushmi	{r1, r2, r8, fp, ip, sp}
     730:	0c000006 	stceq	0, cr0, [r0], {6}
     734:	053b1602 	ldreq	r1, [fp, #-1538]!	; 0xfffff9fe
     738:	3c060000 	stccc	0, cr0, [r6], {-0}
     73c:	000c0105 	andeq	r0, ip, r5, lsl #2
     740:	00063000 	andeq	r3, r6, r0
     744:	04840100 	streq	r0, [r4], #256	; 0x100
     748:	048a0000 	streq	r0, [sl], #0
     74c:	30130000 	andscc	r0, r3, r0
     750:	00000006 	andeq	r0, r0, r6
     754:	0004eb16 	andeq	lr, r4, r6, lsl fp
     758:	0e3f0600 	cfmsuba32eq	mvax0, mvax0, mvfx15, mvfx0
     75c:	00000b73 	andeq	r0, r0, r3, ror fp
     760:	00000048 	andeq	r0, r0, r8, asr #32
     764:	0004a301 	andeq	sl, r4, r1, lsl #6
     768:	0004b800 	andeq	fp, r4, r0, lsl #16
     76c:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     770:	52140000 	andspl	r0, r4, #0
     774:	14000006 	strne	r0, [r0], #-6
     778:	00000059 	andeq	r0, r0, r9, asr r0
     77c:	0001d214 	andeq	sp, r1, r4, lsl r2
     780:	c0180000 	andsgt	r0, r8, r0
     784:	0600000a 	streq	r0, [r0], -sl
     788:	08f10a43 	ldmeq	r1!, {r0, r1, r6, r9, fp}^
     78c:	cd010000 	stcgt	0, cr0, [r1, #-0]
     790:	d3000004 	movwle	r0, #4
     794:	13000004 	movwne	r0, #4
     798:	00000630 	andeq	r0, r0, r0, lsr r6
     79c:	07491600 	strbeq	r1, [r9, -r0, lsl #12]
     7a0:	46060000 	strmi	r0, [r6], -r0
     7a4:	00046213 	andeq	r6, r4, r3, lsl r2
     7a8:	0003a300 	andeq	sl, r3, r0, lsl #6
     7ac:	04ec0100 	strbteq	r0, [ip], #256	; 0x100
     7b0:	04f20000 	ldrbteq	r0, [r2], #0
     7b4:	58130000 	ldmdapl	r3, {}	; <UNPREDICTABLE>
     7b8:	00000006 	andeq	r0, r0, r6
     7bc:	00049e16 	andeq	r9, r4, r6, lsl lr
     7c0:	13490600 	movtne	r0, #38400	; 0x9600
     7c4:	00000a3d 	andeq	r0, r0, sp, lsr sl
     7c8:	000003a3 	andeq	r0, r0, r3, lsr #7
     7cc:	00050b01 	andeq	r0, r5, r1, lsl #22
     7d0:	00051600 	andeq	r1, r5, r0, lsl #12
     7d4:	06581300 	ldrbeq	r1, [r8], -r0, lsl #6
     7d8:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     7dc:	00000000 	andeq	r0, r0, r0
     7e0:	000bcf18 	andeq	ip, fp, r8, lsl pc
     7e4:	0a4c0600 	beq	1301fec <__bss_end+0x12f90f4>
     7e8:	000003c8 	andeq	r0, r0, r8, asr #7
     7ec:	00052b01 	andeq	r2, r5, r1, lsl #22
     7f0:	00053100 	andeq	r3, r5, r0, lsl #2
     7f4:	06301300 	ldrteq	r1, [r0], -r0, lsl #6
     7f8:	16000000 	strne	r0, [r0], -r0
     7fc:	00000ab1 			; <UNDEFINED> instruction: 0x00000ab1
     800:	790a4e06 	stmdbvc	sl, {r1, r2, r9, sl, fp, lr}
     804:	d2000006 	andle	r0, r0, #6
     808:	01000001 	tsteq	r0, r1
     80c:	0000054a 	andeq	r0, r0, sl, asr #10
     810:	00000555 	andeq	r0, r0, r5, asr r5
     814:	00063013 	andeq	r3, r6, r3, lsl r0
     818:	00481400 	subeq	r1, r8, r0, lsl #8
     81c:	16000000 	strne	r0, [r0], -r0
     820:	0000075d 	andeq	r0, r0, sp, asr r7
     824:	120e5106 	andne	r5, lr, #-2147483647	; 0x80000001
     828:	48000009 	stmdami	r0, {r0, r3}
     82c:	01000000 	mrseq	r0, (UNDEF: 0)
     830:	0000056e 	andeq	r0, r0, lr, ror #10
     834:	00000579 	andeq	r0, r0, r9, ror r5
     838:	00063013 	andeq	r3, r6, r3, lsl r0
     83c:	01d91400 	bicseq	r1, r9, r0, lsl #8
     840:	16000000 	strne	r0, [r0], -r0
     844:	00000432 	andeq	r0, r0, r2, lsr r4
     848:	020a5406 	andeq	r5, sl, #100663296	; 0x6000000
     84c:	d2000007 	andle	r0, r0, #7
     850:	01000001 	tsteq	r0, r1
     854:	00000592 	muleq	r0, r2, r5
     858:	0000059d 	muleq	r0, sp, r5
     85c:	00063013 	andeq	r3, r6, r3, lsl r0
     860:	00481400 	subeq	r1, r8, r0, lsl #8
     864:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     868:	0000078f 	andeq	r0, r0, pc, lsl #15
     86c:	0b0a5706 	bleq	29648c <__bss_end+0x28d594>
     870:	0100000b 	tsteq	r0, fp
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
     89c:	00000a6a 	andeq	r0, r0, sl, ror #20
     8a0:	e1055a06 	tst	r5, r6, lsl #20
     8a4:	01000005 	tsteq	r0, r5
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
     8d0:	00000515 	andeq	r0, r0, r5, lsl r5
     8d4:	4c0a5d06 	stcmi	13, cr5, [sl], {6}
     8d8:	d2000005 	andle	r0, r0, #5
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
     934:	0b050700 	bleq	14253c <__bss_end+0x139644>
     938:	00000720 	andeq	r0, r0, r0, lsr #14
     93c:	0008a31f 	andeq	sl, r8, pc, lsl r3
     940:	1c070700 	stcne	7, cr0, [r7], {-0}
     944:	00000060 	andeq	r0, r0, r0, rrx
     948:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     94c:	0009c21f 	andeq	ip, r9, pc, lsl r2
     950:	1d0a0700 	stcne	7, cr0, [sl, #-0]
     954:	00000292 	muleq	r0, r2, r2
     958:	20000000 	andcs	r0, r0, r0
     95c:	00087c1f 	andeq	r7, r8, pc, lsl ip
     960:	1d0d0700 	stcne	7, cr0, [sp, #-0]
     964:	00000292 	muleq	r0, r2, r2
     968:	20200000 	eorcs	r0, r0, r0
     96c:	00099220 	andeq	r9, r9, r0, lsr #4
     970:	18100700 	ldmdane	r0, {r8, r9, sl}
     974:	00000054 	andeq	r0, r0, r4, asr r0
     978:	050c1f36 	streq	r1, [ip, #-3894]	; 0xfffff0ca
     97c:	42070000 	andmi	r0, r7, #0
     980:	0002921d 	andeq	r9, r2, sp, lsl r2
     984:	21500000 	cmpcs	r0, r0
     988:	06c51f20 	strbeq	r1, [r5], r0, lsr #30
     98c:	71070000 	mrsvc	r0, (UNDEF: 7)
     990:	0002921d 	andeq	r9, r2, sp, lsl r2
     994:	00b20000 	adcseq	r0, r2, r0
     998:	04b11f20 	ldrteq	r1, [r1], #3872	; 0xf20
     99c:	a4070000 	strge	r0, [r7], #-0
     9a0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9a4:	00b40000 	adcseq	r0, r4, r0
     9a8:	072e1f20 	streq	r1, [lr, -r0, lsr #30]!
     9ac:	b3070000 	movwlt	r0, #28672	; 0x7000
     9b0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9b4:	10400000 	subne	r0, r0, r0
     9b8:	06a91f20 	strteq	r1, [r9], r0, lsr #30
     9bc:	be070000 	cdplt	0, 0, cr0, cr7, cr0, {0}
     9c0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9c4:	20500000 	subscs	r0, r0, r0
     9c8:	06df1f20 	ldrbeq	r1, [pc], r0, lsr #30
     9cc:	bf070000 	svclt	0x00070000
     9d0:	0002921d 	andeq	r9, r2, sp, lsl r2
     9d4:	80400000 	subhi	r0, r0, r0
     9d8:	04451f20 	strbeq	r1, [r5], #-3872	; 0xfffff0e0
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
     a20:	08620a00 	stmdaeq	r2!, {r9, fp}^
     a24:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
     a28:	00005414 	andeq	r5, r0, r4, lsl r4
     a2c:	74030500 	strvc	r0, [r3], #-1280	; 0xfffffb00
     a30:	0800008e 	stmdaeq	r0, {r1, r2, r3, r7}
     a34:	000009f3 	strdeq	r0, [r0], -r3
     a38:	00330405 	eorseq	r0, r3, r5, lsl #8
     a3c:	1d080000 	stcne	0, cr0, [r8, #-0]
     a40:	0007940c 	andeq	r9, r7, ip, lsl #8
     a44:	073d0900 	ldreq	r0, [sp, -r0, lsl #18]!
     a48:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     a4c:	00000639 	andeq	r0, r0, r9, lsr r6
     a50:	07380901 	ldreq	r0, [r8, -r1, lsl #18]!
     a54:	0d020000 	stceq	0, cr0, [r2, #-0]
     a58:	00776f4c 	rsbseq	r6, r7, ip, asr #30
     a5c:	72220003 	eorvc	r0, r2, #3
     a60:	01000014 	tsteq	r0, r4, lsl r0
     a64:	0033050e 	eorseq	r0, r3, lr, lsl #10
     a68:	822c0000 	eorhi	r0, ip, #0
     a6c:	00cc0000 	sbceq	r0, ip, r0
     a70:	9c010000 	stcls	0, cr0, [r1], {-0}
     a74:	00000818 	andeq	r0, r0, r8, lsl r8
     a78:	000beb23 	andeq	lr, fp, r3, lsr #22
     a7c:	0e0e0100 	adfeqe	f0, f6, f0
     a80:	00000033 	andeq	r0, r0, r3, lsr r0
     a84:	235c9102 	cmpcs	ip, #-2147483648	; 0x80000000
     a88:	00000b5d 	andeq	r0, r0, sp, asr fp
     a8c:	181b0e01 	ldmdane	fp, {r0, r9, sl, fp}
     a90:	02000008 	andeq	r0, r0, #8
     a94:	98245891 	stmdals	r4!, {r0, r4, r7, fp, ip, lr}
     a98:	01000004 	tsteq	r0, r4
     a9c:	00250a10 	eoreq	r0, r5, r0, lsl sl
     aa0:	91020000 	mrsls	r0, (UNDEF: 2)
     aa4:	0495246b 	ldreq	r2, [r5], #1131	; 0x46b
     aa8:	11010000 	mrsne	r0, (UNDEF: 1)
     aac:	0000250a 	andeq	r2, r0, sl, lsl #10
     ab0:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
     ab4:	0009da24 	andeq	sp, r9, r4, lsr #20
     ab8:	0e130100 	mufeqs	f0, f3, f0
     abc:	00000048 	andeq	r0, r0, r8, asr #32
     ac0:	24709102 	ldrbtcs	r9, [r0], #-258	; 0xfffffefe
     ac4:	00000aaa 	andeq	r0, r0, sl, lsr #21
     ac8:	691a1601 	ldmdbvs	sl, {r0, r9, sl, ip}
     acc:	02000007 	andeq	r0, r0, #7
     ad0:	2b246491 	blcs	919d1c <__bss_end+0x910e24>
     ad4:	0100000c 	tsteq	r0, ip
     ad8:	00480e1e 	subeq	r0, r8, lr, lsl lr
     adc:	91020000 	mrsls	r0, (UNDEF: 2)
     ae0:	040c006c 	streq	r0, [ip], #-108	; 0xffffff94
     ae4:	0000081e 	andeq	r0, r0, lr, lsl r8
     ae8:	0025040c 	eoreq	r0, r5, ip, lsl #8
     aec:	1f000000 	svcne	0x00000000
     af0:	0400000b 	streq	r0, [r0], #-11
     af4:	0003ec00 	andeq	lr, r3, r0, lsl #24
     af8:	87010400 	strhi	r0, [r1, -r0, lsl #8]
     afc:	0400000d 	streq	r0, [r0], #-13
     b00:	00000c91 	muleq	r0, r1, ip
     b04:	00000eb1 			; <UNDEFINED> instruction: 0x00000eb1
     b08:	000082f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
     b0c:	0000045c 	andeq	r0, r0, ip, asr r4
     b10:	00000497 	muleq	r0, r7, r4
     b14:	67080102 	strvs	r0, [r8, -r2, lsl #2]
     b18:	03000009 	movweq	r0, #9
     b1c:	00000025 	andeq	r0, r0, r5, lsr #32
     b20:	a1050202 	tstge	r5, r2, lsl #4
     b24:	04000009 	streq	r0, [r0], #-9
     b28:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     b2c:	01020074 	tsteq	r2, r4, ror r0
     b30:	00095e08 	andeq	r5, r9, r8, lsl #28
     b34:	07020200 	streq	r0, [r2, -r0, lsl #4]
     b38:	000007a2 	andeq	r0, r0, r2, lsr #15
     b3c:	0009ea05 	andeq	lr, r9, r5, lsl #20
     b40:	07090700 	streq	r0, [r9, -r0, lsl #14]
     b44:	0000005e 	andeq	r0, r0, lr, asr r0
     b48:	00004d03 	andeq	r4, r0, r3, lsl #26
     b4c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     b50:	000014de 	ldrdeq	r1, [r0], -lr
     b54:	00062d06 	andeq	r2, r6, r6, lsl #26
     b58:	06020800 	streq	r0, [r2], -r0, lsl #16
     b5c:	00008b08 	andeq	r8, r0, r8, lsl #22
     b60:	30720700 	rsbscc	r0, r2, r0, lsl #14
     b64:	0e080200 	cdpeq	2, 0, cr0, cr8, cr0, {0}
     b68:	0000004d 	andeq	r0, r0, sp, asr #32
     b6c:	31720700 	cmncc	r2, r0, lsl #14
     b70:	0e090200 	cdpeq	2, 0, cr0, cr9, cr0, {0}
     b74:	0000004d 	andeq	r0, r0, sp, asr #32
     b78:	37080004 	strcc	r0, [r8, -r4]
     b7c:	0500000f 	streq	r0, [r0, #-15]
     b80:	00003804 	andeq	r3, r0, r4, lsl #16
     b84:	0c0d0200 	sfmeq	f0, 4, [sp], {-0}
     b88:	000000a9 	andeq	r0, r0, r9, lsr #1
     b8c:	004b4f09 	subeq	r4, fp, r9, lsl #30
     b90:	0cdd0a00 	vldmiaeq	sp, {s1-s0}
     b94:	00010000 	andeq	r0, r1, r0
     b98:	0004bc08 	andeq	fp, r4, r8, lsl #24
     b9c:	38040500 	stmdacc	r4, {r8, sl}
     ba0:	02000000 	andeq	r0, r0, #0
     ba4:	00e00c1e 	rsceq	r0, r0, lr, lsl ip
     ba8:	a10a0000 	mrsge	r0, (UNDEF: 10)
     bac:	00000006 	andeq	r0, r0, r6
     bb0:	000c1b0a 	andeq	r1, ip, sl, lsl #22
     bb4:	fb0a0100 	blx	280fbe <__bss_end+0x2780c6>
     bb8:	0200000b 	andeq	r0, r0, #11
     bbc:	0007ed0a 	andeq	lr, r7, sl, lsl #26
     bc0:	e20a0300 	and	r0, sl, #0, 6
     bc4:	04000008 	streq	r0, [r0], #-8
     bc8:	00066a0a 	andeq	r6, r6, sl, lsl #20
     bcc:	08000500 	stmdaeq	r0, {r8, sl}
     bd0:	00000ba8 	andeq	r0, r0, r8, lsr #23
     bd4:	00380405 	eorseq	r0, r8, r5, lsl #8
     bd8:	40020000 	andmi	r0, r2, r0
     bdc:	00011d0c 	andeq	r1, r1, ip, lsl #26
     be0:	03c30a00 	biceq	r0, r3, #0, 20
     be4:	0a000000 	beq	bec <shift+0xbec>
     be8:	000004d1 	ldrdeq	r0, [r0], -r1
     bec:	08d50a01 	ldmeq	r5, {r0, r9, fp}^
     bf0:	0a020000 	beq	80bf8 <__bss_end+0x77d00>
     bf4:	00000be5 	andeq	r0, r0, r5, ror #23
     bf8:	0c250a03 			; <UNDEFINED> instruction: 0x0c250a03
     bfc:	0a040000 	beq	100c04 <__bss_end+0xf7d0c>
     c00:	0000089c 	muleq	r0, ip, r8
     c04:	07c20a05 	strbeq	r0, [r2, r5, lsl #20]
     c08:	00060000 	andeq	r0, r6, r0
     c0c:	000b6208 	andeq	r6, fp, r8, lsl #4
     c10:	38040500 	stmdacc	r4, {r8, sl}
     c14:	02000000 	andeq	r0, r0, #0
     c18:	01480c67 	cmpeq	r8, r7, ror #24
     c1c:	450a0000 	strmi	r0, [sl, #-0]
     c20:	00000009 	andeq	r0, r0, r9
     c24:	0007840a 	andeq	r8, r7, sl, lsl #8
     c28:	ab0a0100 	blge	281030 <__bss_end+0x278138>
     c2c:	02000009 	andeq	r0, r0, #9
     c30:	0007c70a 	andeq	ip, r7, sl, lsl #14
     c34:	0b000300 	bleq	183c <shift+0x183c>
     c38:	000008b6 			; <UNDEFINED> instruction: 0x000008b6
     c3c:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     c40:	05000000 	streq	r0, [r0, #-0]
     c44:	008e9c03 	addeq	r9, lr, r3, lsl #24
     c48:	08c40b00 	stmiaeq	r4, {r8, r9, fp}^
     c4c:	06030000 	streq	r0, [r3], -r0
     c50:	00005914 	andeq	r5, r0, r4, lsl r9
     c54:	a0030500 	andge	r0, r3, r0, lsl #10
     c58:	0b00008e 	bleq	e98 <shift+0xe98>
     c5c:	00000886 	andeq	r0, r0, r6, lsl #17
     c60:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     c64:	05000000 	streq	r0, [r0, #-0]
     c68:	008ea403 	addeq	sl, lr, r3, lsl #8
     c6c:	04fa0b00 	ldrbteq	r0, [sl], #2816	; 0xb00
     c70:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     c74:	0000591a 	andeq	r5, r0, sl, lsl r9
     c78:	a8030500 	stmdage	r3, {r8, sl}
     c7c:	0b00008e 	bleq	ebc <shift+0xebc>
     c80:	00000950 	andeq	r0, r0, r0, asr r9
     c84:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     c88:	05000000 	streq	r0, [r0, #-0]
     c8c:	008eac03 	addeq	sl, lr, r3, lsl #24
     c90:	07710b00 	ldrbeq	r0, [r1, -r0, lsl #22]!
     c94:	0d040000 	stceq	0, cr0, [r4, #-0]
     c98:	0000591a 	andeq	r5, r0, sl, lsl r9
     c9c:	b0030500 	andlt	r0, r3, r0, lsl #10
     ca0:	0b00008e 	bleq	ee0 <shift+0xee0>
     ca4:	00000653 	andeq	r0, r0, r3, asr r6
     ca8:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     cac:	05000000 	streq	r0, [r0, #-0]
     cb0:	008eb403 	addeq	fp, lr, r3, lsl #8
     cb4:	0fef0800 	svceq	0x00ef0800
     cb8:	04050000 	streq	r0, [r5], #-0
     cbc:	00000038 	andeq	r0, r0, r8, lsr r0
     cc0:	eb0c1b04 	bl	3078d8 <__bss_end+0x2fe9e0>
     cc4:	0a000001 	beq	cd0 <shift+0xcd0>
     cc8:	00000a27 	andeq	r0, r0, r7, lsr #20
     ccc:	0bf00a00 	bleq	ffc034d4 <__bss_end+0xffbfa5dc>
     cd0:	0a010000 	beq	40cd8 <__bss_end+0x37de0>
     cd4:	000008d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     cd8:	3f0c0002 	svccc	0x000c0002
     cdc:	02000009 	andeq	r0, r0, #9
     ce0:	07f30201 	ldrbeq	r0, [r3, r1, lsl #4]!
     ce4:	040d0000 	streq	r0, [sp], #-0
     ce8:	0000002c 	andeq	r0, r0, ip, lsr #32
     cec:	01eb040d 	mvneq	r0, sp, lsl #8
     cf0:	e90b0000 	stmdb	fp, {}	; <UNPREDICTABLE>
     cf4:	05000006 	streq	r0, [r0, #-6]
     cf8:	00591404 	subseq	r1, r9, r4, lsl #8
     cfc:	03050000 	movweq	r0, #20480	; 0x5000
     d00:	00008eb8 			; <UNDEFINED> instruction: 0x00008eb8
     d04:	0003b80b 	andeq	fp, r3, fp, lsl #16
     d08:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     d0c:	00000059 	andeq	r0, r0, r9, asr r0
     d10:	8ebc0305 	cdphi	3, 11, cr0, cr12, cr5, {0}
     d14:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
     d18:	05000005 	streq	r0, [r0, #-5]
     d1c:	0059140a 	subseq	r1, r9, sl, lsl #8
     d20:	03050000 	movweq	r0, #20480	; 0x5000
     d24:	00008ec0 	andeq	r8, r0, r0, asr #29
     d28:	00082808 	andeq	r2, r8, r8, lsl #16
     d2c:	38040500 	stmdacc	r4, {r8, sl}
     d30:	05000000 	streq	r0, [r0, #-0]
     d34:	02700c0d 	rsbseq	r0, r0, #3328	; 0xd00
     d38:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
     d3c:	00007765 	andeq	r7, r0, r5, ror #14
     d40:	00081f0a 	andeq	r1, r8, sl, lsl #30
     d44:	d20a0100 	andle	r0, sl, #0, 2
     d48:	02000009 	andeq	r0, r0, #9
     d4c:	0008020a 	andeq	r0, r8, sl, lsl #4
     d50:	df0a0300 	svcle	0x000a0300
     d54:	04000007 	streq	r0, [r0], #-7
     d58:	0008db0a 	andeq	sp, r8, sl, lsl #22
     d5c:	06000500 	streq	r0, [r0], -r0, lsl #10
     d60:	0000065d 	andeq	r0, r0, sp, asr r6
     d64:	081d0510 	ldmdaeq	sp, {r4, r8, sl}
     d68:	000002af 	andeq	r0, r0, pc, lsr #5
     d6c:	00726c07 	rsbseq	r6, r2, r7, lsl #24
     d70:	af131f05 	svcge	0x00131f05
     d74:	00000002 	andeq	r0, r0, r2
     d78:	00707307 	rsbseq	r7, r0, r7, lsl #6
     d7c:	af132005 	svcge	0x00132005
     d80:	04000002 	streq	r0, [r0], #-2
     d84:	00637007 	rsbeq	r7, r3, r7
     d88:	af132105 	svcge	0x00132105
     d8c:	08000002 	stmdaeq	r0, {r1}
     d90:	0006730e 	andeq	r7, r6, lr, lsl #6
     d94:	13220500 			; <UNDEFINED> instruction: 0x13220500
     d98:	000002af 	andeq	r0, r0, pc, lsr #5
     d9c:	0402000c 	streq	r0, [r2], #-12
     da0:	0014d907 	andseq	sp, r4, r7, lsl #18
     da4:	04250600 	strteq	r0, [r5], #-1536	; 0xfffffa00
     da8:	05700000 	ldrbeq	r0, [r0, #-0]!
     dac:	0346082a 	movteq	r0, #26666	; 0x682a
     db0:	1b0e0000 	blne	380db8 <__bss_end+0x377ec0>
     db4:	0500000a 	streq	r0, [r0, #-10]
     db8:	0270122c 	rsbseq	r1, r0, #44, 4	; 0xc0000002
     dbc:	07000000 	streq	r0, [r0, -r0]
     dc0:	00646970 	rsbeq	r6, r4, r0, ror r9
     dc4:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
     dc8:	10000000 	andne	r0, r0, r0
     dcc:	0004980e 	andeq	r9, r4, lr, lsl #16
     dd0:	112e0500 			; <UNDEFINED> instruction: 0x112e0500
     dd4:	00000239 	andeq	r0, r0, r9, lsr r2
     dd8:	08340e14 	ldmdaeq	r4!, {r2, r4, r9, sl, fp}
     ddc:	2f050000 	svccs	0x00050000
     de0:	00005e12 	andeq	r5, r0, r2, lsl lr
     de4:	420e1800 	andmi	r1, lr, #0, 16
     de8:	05000008 	streq	r0, [r0, #-8]
     dec:	005e1231 	subseq	r1, lr, r1, lsr r2
     df0:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     df4:	00000646 	andeq	r0, r0, r6, asr #12
     df8:	460c3205 	strmi	r3, [ip], -r5, lsl #4
     dfc:	20000003 	andcs	r0, r0, r3
     e00:	0008580e 	andeq	r5, r8, lr, lsl #16
     e04:	05340500 	ldreq	r0, [r4, #-1280]!	; 0xfffffb00
     e08:	00000038 	andeq	r0, r0, r8, lsr r0
     e0c:	0a310e60 	beq	c44794 <__bss_end+0xc3b89c>
     e10:	35050000 	strcc	r0, [r5, #-0]
     e14:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e18:	bc0e6400 	cfstrslt	mvf6, [lr], {-0}
     e1c:	05000006 	streq	r0, [r0, #-6]
     e20:	004d0e38 	subeq	r0, sp, r8, lsr lr
     e24:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     e28:	000006b3 			; <UNDEFINED> instruction: 0x000006b3
     e2c:	4d0e3905 	vstrmi.16	s6, [lr, #-10]	; <UNPREDICTABLE>
     e30:	6c000000 	stcvs	0, cr0, [r0], {-0}
     e34:	01fd0f00 	mvnseq	r0, r0, lsl #30
     e38:	03560000 	cmpeq	r6, #0
     e3c:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
     e40:	0f000000 	svceq	0x00000000
     e44:	0bc00b00 	bleq	ff003a4c <__bss_end+0xfeffab54>
     e48:	0a060000 	beq	180e50 <__bss_end+0x177f58>
     e4c:	00005914 	andeq	r5, r0, r4, lsl r9
     e50:	c4030500 	strgt	r0, [r3], #-1280	; 0xfffffb00
     e54:	0800008e 	stmdaeq	r0, {r1, r2, r3, r7}
     e58:	0000080a 	andeq	r0, r0, sl, lsl #16
     e5c:	00380405 	eorseq	r0, r8, r5, lsl #8
     e60:	0d060000 	stceq	0, cr0, [r6, #-0]
     e64:	0003870c 	andeq	r8, r3, ip, lsl #14
     e68:	04d60a00 	ldrbeq	r0, [r6], #2560	; 0xa00
     e6c:	0a000000 	beq	e74 <shift+0xe74>
     e70:	000003ad 	andeq	r0, r0, sp, lsr #7
     e74:	68030001 	stmdavs	r3, {r0}
     e78:	08000003 	stmdaeq	r0, {r0, r1}
     e7c:	00000e55 	andeq	r0, r0, r5, asr lr
     e80:	00380405 	eorseq	r0, r8, r5, lsl #8
     e84:	14060000 	strne	r0, [r6], #-0
     e88:	0003ab0c 	andeq	sl, r3, ip, lsl #22
     e8c:	0c390a00 			; <UNDEFINED> instruction: 0x0c390a00
     e90:	0a000000 	beq	e98 <shift+0xe98>
     e94:	00000f09 	andeq	r0, r0, r9, lsl #30
     e98:	8c030001 	stchi	0, cr0, [r3], {1}
     e9c:	06000003 	streq	r0, [r0], -r3
     ea0:	00000aec 	andeq	r0, r0, ip, ror #21
     ea4:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     ea8:	000003e5 	andeq	r0, r0, r5, ror #7
     eac:	0003f70e 	andeq	pc, r3, lr, lsl #14
     eb0:	191d0600 	ldmdbne	sp, {r9, sl}
     eb4:	000003e5 	andeq	r0, r0, r5, ror #7
     eb8:	04900e00 	ldreq	r0, [r0], #3584	; 0xe00
     ebc:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     ec0:	0003e519 	andeq	lr, r3, r9, lsl r5
     ec4:	a50e0400 	strge	r0, [lr, #-1024]	; 0xfffffc00
     ec8:	0600000a 	streq	r0, [r0], -sl
     ecc:	03eb131f 	mvneq	r1, #2080374784	; 0x7c000000
     ed0:	00080000 	andeq	r0, r8, r0
     ed4:	03b0040d 	movseq	r0, #218103808	; 0xd000000
     ed8:	040d0000 	streq	r0, [sp], #-0
     edc:	000002b6 			; <UNDEFINED> instruction: 0x000002b6
     ee0:	00053b11 	andeq	r3, r5, r1, lsl fp
     ee4:	22061400 	andcs	r1, r6, #0, 8
     ee8:	00067307 	andeq	r7, r6, r7, lsl #6
     eec:	07f80e00 	ldrbeq	r0, [r8, r0, lsl #28]!
     ef0:	26060000 	strcs	r0, [r6], -r0
     ef4:	00004d0e 	andeq	r4, r0, lr, lsl #26
     ef8:	4f0e0000 	svcmi	0x000e0000
     efc:	06000004 	streq	r0, [r0], -r4
     f00:	03e51929 	mvneq	r1, #671744	; 0xa4000
     f04:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     f08:	00000a08 	andeq	r0, r0, r8, lsl #20
     f0c:	e5192c06 	ldr	r2, [r9, #-3078]	; 0xfffff3fa
     f10:	08000003 	stmdaeq	r0, {r0, r1}
     f14:	000b9e12 	andeq	r9, fp, r2, lsl lr
     f18:	0a2f0600 	beq	bc2720 <__bss_end+0xbb9828>
     f1c:	00000ac9 	andeq	r0, r0, r9, asr #21
     f20:	00000439 	andeq	r0, r0, r9, lsr r4
     f24:	00000444 	andeq	r0, r0, r4, asr #8
     f28:	00067813 	andeq	r7, r6, r3, lsl r8
     f2c:	03e51400 	mvneq	r1, #0, 8
     f30:	15000000 	strne	r0, [r0, #-0]
     f34:	00000ab1 			; <UNDEFINED> instruction: 0x00000ab1
     f38:	fc0a3106 	stc2	1, cr3, [sl], {6}
     f3c:	f0000003 			; <UNDEFINED> instruction: 0xf0000003
     f40:	5c000001 	stcpl	0, cr0, [r0], {1}
     f44:	67000004 	strvs	r0, [r0, -r4]
     f48:	13000004 	movwne	r0, #4
     f4c:	00000678 	andeq	r0, r0, r8, ror r6
     f50:	0003eb14 	andeq	lr, r3, r4, lsl fp
     f54:	ff160000 			; <UNDEFINED> instruction: 0xff160000
     f58:	0600000a 	streq	r0, [r0], -sl
     f5c:	0a801935 	beq	fe007438 <__bss_end+0xfdffe540>
     f60:	03e50000 	mvneq	r0, #0
     f64:	80020000 	andhi	r0, r2, r0
     f68:	86000004 	strhi	r0, [r0], -r4
     f6c:	13000004 	movwne	r0, #4
     f70:	00000678 	andeq	r0, r0, r8, ror r6
     f74:	07b51600 	ldreq	r1, [r5, r0, lsl #12]!
     f78:	37060000 	strcc	r0, [r6, -r0]
     f7c:	00096c19 	andeq	r6, r9, r9, lsl ip
     f80:	0003e500 	andeq	lr, r3, r0, lsl #10
     f84:	049f0200 	ldreq	r0, [pc], #512	; f8c <shift+0xf8c>
     f88:	04a50000 	strteq	r0, [r5], #0
     f8c:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     f90:	00000006 	andeq	r0, r0, r6
     f94:	00086e17 	andeq	r6, r8, r7, lsl lr
     f98:	2d390600 	ldccs	6, cr0, [r9, #-0]
     f9c:	00000691 	muleq	r0, r1, r6
     fa0:	3b16020c 	blcc	5817d8 <__bss_end+0x5788e0>
     fa4:	06000005 	streq	r0, [r0], -r5
     fa8:	0c01053c 	cfstr32eq	mvfx0, [r1], {60}	; 0x3c
     fac:	06780000 	ldrbteq	r0, [r8], -r0
     fb0:	cc010000 	stcgt	0, cr0, [r1], {-0}
     fb4:	d2000004 	andle	r0, r0, #4
     fb8:	13000004 	movwne	r0, #4
     fbc:	00000678 	andeq	r0, r0, r8, ror r6
     fc0:	04eb1600 	strbteq	r1, [fp], #1536	; 0x600
     fc4:	3f060000 	svccc	0x00060000
     fc8:	000b730e 	andeq	r7, fp, lr, lsl #6
     fcc:	00004d00 	andeq	r4, r0, r0, lsl #26
     fd0:	04eb0100 	strbteq	r0, [fp], #256	; 0x100
     fd4:	05000000 	streq	r0, [r0, #-0]
     fd8:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
     fdc:	14000006 	strne	r0, [r0], #-6
     fe0:	0000069a 	muleq	r0, sl, r6
     fe4:	00005e14 	andeq	r5, r0, r4, lsl lr
     fe8:	01f01400 	mvnseq	r1, r0, lsl #8
     fec:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     ff0:	00000ac0 	andeq	r0, r0, r0, asr #21
     ff4:	f10a4306 			; <UNDEFINED> instruction: 0xf10a4306
     ff8:	01000008 	tsteq	r0, r8
     ffc:	00000515 	andeq	r0, r0, r5, lsl r5
    1000:	0000051b 	andeq	r0, r0, fp, lsl r5
    1004:	00067813 	andeq	r7, r6, r3, lsl r8
    1008:	49160000 	ldmdbmi	r6, {}	; <UNPREDICTABLE>
    100c:	06000007 	streq	r0, [r0], -r7
    1010:	04621346 	strbteq	r1, [r2], #-838	; 0xfffffcba
    1014:	03eb0000 	mvneq	r0, #0
    1018:	34010000 	strcc	r0, [r1], #-0
    101c:	3a000005 	bcc	1038 <shift+0x1038>
    1020:	13000005 	movwne	r0, #5
    1024:	000006a0 	andeq	r0, r0, r0, lsr #13
    1028:	049e1600 	ldreq	r1, [lr], #1536	; 0x600
    102c:	49060000 	stmdbmi	r6, {}	; <UNPREDICTABLE>
    1030:	000a3d13 	andeq	r3, sl, r3, lsl sp
    1034:	0003eb00 	andeq	lr, r3, r0, lsl #22
    1038:	05530100 	ldrbeq	r0, [r3, #-256]	; 0xffffff00
    103c:	055e0000 	ldrbeq	r0, [lr, #-0]
    1040:	a0130000 	andsge	r0, r3, r0
    1044:	14000006 	strne	r0, [r0], #-6
    1048:	0000004d 	andeq	r0, r0, sp, asr #32
    104c:	0bcf1800 	bleq	ff3c7054 <__bss_end+0xff3be15c>
    1050:	4c060000 	stcmi	0, cr0, [r6], {-0}
    1054:	0003c80a 	andeq	ip, r3, sl, lsl #16
    1058:	05730100 	ldrbeq	r0, [r3, #-256]!	; 0xffffff00
    105c:	05790000 	ldrbeq	r0, [r9, #-0]!
    1060:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    1064:	00000006 	andeq	r0, r0, r6
    1068:	000ab116 	andeq	fp, sl, r6, lsl r1
    106c:	0a4e0600 	beq	1382874 <__bss_end+0x137997c>
    1070:	00000679 	andeq	r0, r0, r9, ror r6
    1074:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1078:	00059201 	andeq	r9, r5, r1, lsl #4
    107c:	00059d00 	andeq	r9, r5, r0, lsl #26
    1080:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    1084:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1088:	00000000 	andeq	r0, r0, r0
    108c:	00075d16 	andeq	r5, r7, r6, lsl sp
    1090:	0e510600 	cdpeq	6, 5, cr0, cr1, cr0, {0}
    1094:	00000912 	andeq	r0, r0, r2, lsl r9
    1098:	0000004d 	andeq	r0, r0, sp, asr #32
    109c:	0005b601 	andeq	fp, r5, r1, lsl #12
    10a0:	0005c100 	andeq	ip, r5, r0, lsl #2
    10a4:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    10a8:	fd140000 	ldc2	0, cr0, [r4, #-0]
    10ac:	00000001 	andeq	r0, r0, r1
    10b0:	00043216 	andeq	r3, r4, r6, lsl r2
    10b4:	0a540600 	beq	15028bc <__bss_end+0x14f99c4>
    10b8:	00000702 	andeq	r0, r0, r2, lsl #14
    10bc:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    10c0:	0005da01 	andeq	sp, r5, r1, lsl #20
    10c4:	0005e500 	andeq	lr, r5, r0, lsl #10
    10c8:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    10cc:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    10d0:	00000000 	andeq	r0, r0, r0
    10d4:	00078f18 	andeq	r8, r7, r8, lsl pc
    10d8:	0a570600 	beq	15c28e0 <__bss_end+0x15b99e8>
    10dc:	00000b0b 	andeq	r0, r0, fp, lsl #22
    10e0:	0005fa01 	andeq	pc, r5, r1, lsl #20
    10e4:	00061900 	andeq	r1, r6, r0, lsl #18
    10e8:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    10ec:	a9140000 	ldmdbge	r4, {}	; <UNPREDICTABLE>
    10f0:	14000000 	strne	r0, [r0], #-0
    10f4:	0000004d 	andeq	r0, r0, sp, asr #32
    10f8:	00004d14 	andeq	r4, r0, r4, lsl sp
    10fc:	004d1400 	subeq	r1, sp, r0, lsl #8
    1100:	a6140000 	ldrge	r0, [r4], -r0
    1104:	00000006 	andeq	r0, r0, r6
    1108:	000a6a18 	andeq	r6, sl, r8, lsl sl
    110c:	055a0600 	ldrbeq	r0, [sl, #-1536]	; 0xfffffa00
    1110:	000005e1 	andeq	r0, r0, r1, ror #11
    1114:	00062e01 	andeq	r2, r6, r1, lsl #28
    1118:	00064d00 	andeq	r4, r6, r0, lsl #26
    111c:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    1120:	e0140000 	ands	r0, r4, r0
    1124:	14000000 	strne	r0, [r0], #-0
    1128:	0000004d 	andeq	r0, r0, sp, asr #32
    112c:	00004d14 	andeq	r4, r0, r4, lsl sp
    1130:	004d1400 	subeq	r1, sp, r0, lsl #8
    1134:	a6140000 	ldrge	r0, [r4], -r0
    1138:	00000006 	andeq	r0, r0, r6
    113c:	00051519 	andeq	r1, r5, r9, lsl r5
    1140:	0a5d0600 	beq	1742948 <__bss_end+0x1739a50>
    1144:	0000054c 	andeq	r0, r0, ip, asr #10
    1148:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    114c:	00066201 	andeq	r6, r6, r1, lsl #4
    1150:	06781300 	ldrbteq	r1, [r8], -r0, lsl #6
    1154:	68140000 	ldmdavs	r4, {}	; <UNPREDICTABLE>
    1158:	14000003 	strne	r0, [r0], #-3
    115c:	000006ac 	andeq	r0, r0, ip, lsr #13
    1160:	f1030000 			; <UNDEFINED> instruction: 0xf1030000
    1164:	0d000003 	stceq	0, cr0, [r0, #-12]
    1168:	0003f104 	andeq	pc, r3, r4, lsl #2
    116c:	03e51a00 	mvneq	r1, #0, 20
    1170:	068b0000 	streq	r0, [fp], r0
    1174:	06910000 	ldreq	r0, [r1], r0
    1178:	78130000 	ldmdavc	r3, {}	; <UNPREDICTABLE>
    117c:	00000006 	andeq	r0, r0, r6
    1180:	0003f11b 	andeq	pc, r3, fp, lsl r1	; <UNPREDICTABLE>
    1184:	00067e00 	andeq	r7, r6, r0, lsl #28
    1188:	3f040d00 	svccc	0x00040d00
    118c:	0d000000 	stceq	0, cr0, [r0, #-0]
    1190:	00067304 	andeq	r7, r6, r4, lsl #6
    1194:	65041c00 	strvs	r1, [r4, #-3072]	; 0xfffff400
    1198:	1d000000 	stcne	0, cr0, [r0, #-0]
    119c:	002c0f04 	eoreq	r0, ip, r4, lsl #30
    11a0:	06be0000 	ldrteq	r0, [lr], r0
    11a4:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    11a8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    11ac:	06ae0300 	strteq	r0, [lr], r0, lsl #6
    11b0:	291e0000 	ldmdbcs	lr, {}	; <UNPREDICTABLE>
    11b4:	0100000d 	tsteq	r0, sp
    11b8:	06be0ca4 	ldrteq	r0, [lr], r4, lsr #25
    11bc:	03050000 	movweq	r0, #20480	; 0x5000
    11c0:	00008ec8 	andeq	r8, r0, r8, asr #29
    11c4:	000c2e1f 	andeq	r2, ip, pc, lsl lr
    11c8:	0aa60100 	beq	fe9815d0 <__bss_end+0xfe9786d8>
    11cc:	00000e49 	andeq	r0, r0, r9, asr #28
    11d0:	0000004d 	andeq	r0, r0, sp, asr #32
    11d4:	000086a4 	andeq	r8, r0, r4, lsr #13
    11d8:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    11dc:	07339c01 	ldreq	r9, [r3, -r1, lsl #24]!
    11e0:	d2200000 	eorle	r0, r0, #0
    11e4:	0100000f 	tsteq	r0, pc
    11e8:	01f71ba6 	mvnseq	r1, r6, lsr #23
    11ec:	91030000 	mrsls	r0, (UNDEF: 3)
    11f0:	a8207fac 	stmdage	r0!, {r2, r3, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    11f4:	0100000e 	tsteq	r0, lr
    11f8:	004d2aa6 	subeq	r2, sp, r6, lsr #21
    11fc:	91030000 	mrsls	r0, (UNDEF: 3)
    1200:	811e7fa8 	tsthi	lr, r8, lsr #31
    1204:	0100000d 	tsteq	r0, sp
    1208:	07330aa8 	ldreq	r0, [r3, -r8, lsr #21]!
    120c:	91030000 	mrsls	r0, (UNDEF: 3)
    1210:	4d1e7fb4 	ldcmi	15, cr7, [lr, #-720]	; 0xfffffd30
    1214:	0100000c 	tsteq	r0, ip
    1218:	003809ac 	eorseq	r0, r8, ip, lsr #19
    121c:	91020000 	mrsls	r0, (UNDEF: 2)
    1220:	250f0074 	strcs	r0, [pc, #-116]	; 11b4 <shift+0x11b4>
    1224:	43000000 	movwmi	r0, #0
    1228:	10000007 	andne	r0, r0, r7
    122c:	0000005e 	andeq	r0, r0, lr, asr r0
    1230:	8d21003f 	stchi	0, cr0, [r1, #-252]!	; 0xffffff04
    1234:	0100000e 	tsteq	r0, lr
    1238:	0f170a98 	svceq	0x00170a98
    123c:	004d0000 	subeq	r0, sp, r0
    1240:	86680000 	strbthi	r0, [r8], -r0
    1244:	003c0000 	eorseq	r0, ip, r0
    1248:	9c010000 	stcls	0, cr0, [r1], {-0}
    124c:	00000780 	andeq	r0, r0, r0, lsl #15
    1250:	71657222 	cmnvc	r5, r2, lsr #4
    1254:	209a0100 	addscs	r0, sl, r0, lsl #2
    1258:	000003ab 	andeq	r0, r0, fp, lsr #7
    125c:	1e749102 	expnes	f1, f2
    1260:	00000e3e 	andeq	r0, r0, lr, lsr lr
    1264:	4d0e9b01 	vstrmi	d9, [lr, #-4]
    1268:	02000000 	andeq	r0, r0, #0
    126c:	23007091 	movwcs	r7, #145	; 0x91
    1270:	00000eec 	andeq	r0, r0, ip, ror #29
    1274:	69068f01 	stmdbvs	r6, {r0, r8, r9, sl, fp, pc}
    1278:	2c00000c 	stccs	0, cr0, [r0], {12}
    127c:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1280:	01000000 	mrseq	r0, (UNDEF: 0)
    1284:	0007b99c 	muleq	r7, ip, r9
    1288:	0cf72000 	ldcleq	0, cr2, [r7]
    128c:	8f010000 	svchi	0x00010000
    1290:	00004d21 	andeq	r4, r0, r1, lsr #26
    1294:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1298:	71657222 	cmnvc	r5, r2, lsr #4
    129c:	20910100 	addscs	r0, r1, r0, lsl #2
    12a0:	000003ab 	andeq	r0, r0, fp, lsr #7
    12a4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    12a8:	000e6a21 	andeq	r6, lr, r1, lsr #20
    12ac:	0a830100 	beq	fe0c16b4 <__bss_end+0xfe0b87bc>
    12b0:	00000d3a 	andeq	r0, r0, sl, lsr sp
    12b4:	0000004d 	andeq	r0, r0, sp, asr #32
    12b8:	000085f0 	strdeq	r8, [r0], -r0
    12bc:	0000003c 	andeq	r0, r0, ip, lsr r0
    12c0:	07f69c01 	ldrbeq	r9, [r6, r1, lsl #24]!
    12c4:	72220000 	eorvc	r0, r2, #0
    12c8:	01007165 	tsteq	r0, r5, ror #2
    12cc:	03872085 	orreq	r2, r7, #133	; 0x85
    12d0:	91020000 	mrsls	r0, (UNDEF: 2)
    12d4:	0c461e74 	mcrreq	14, 7, r1, r6, cr4
    12d8:	86010000 	strhi	r0, [r1], -r0
    12dc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12e0:	70910200 	addsvc	r0, r1, r0, lsl #4
    12e4:	0fb52100 	svceq	0x00b52100
    12e8:	77010000 	strvc	r0, [r1, -r0]
    12ec:	000d0b0a 	andeq	r0, sp, sl, lsl #22
    12f0:	00004d00 	andeq	r4, r0, r0, lsl #26
    12f4:	0085b400 	addeq	fp, r5, r0, lsl #8
    12f8:	00003c00 	andeq	r3, r0, r0, lsl #24
    12fc:	339c0100 	orrscc	r0, ip, #0, 2
    1300:	22000008 	andcs	r0, r0, #8
    1304:	00716572 	rsbseq	r6, r1, r2, ror r5
    1308:	87207901 	strhi	r7, [r0, -r1, lsl #18]!
    130c:	02000003 	andeq	r0, r0, #3
    1310:	461e7491 			; <UNDEFINED> instruction: 0x461e7491
    1314:	0100000c 	tsteq	r0, ip
    1318:	004d0e7a 	subeq	r0, sp, sl, ror lr
    131c:	91020000 	mrsls	r0, (UNDEF: 2)
    1320:	4e210070 	mcrmi	0, 1, r0, cr1, cr0, {3}
    1324:	0100000d 	tsteq	r0, sp
    1328:	0efe066b 	cdpeq	6, 15, cr0, cr14, cr11, {3}
    132c:	01f00000 	mvnseq	r0, r0
    1330:	85600000 	strbhi	r0, [r0, #-0]!
    1334:	00540000 	subseq	r0, r4, r0
    1338:	9c010000 	stcls	0, cr0, [r1], {-0}
    133c:	0000087f 	andeq	r0, r0, pc, ror r8
    1340:	000e3e20 	andeq	r3, lr, r0, lsr #28
    1344:	156b0100 	strbne	r0, [fp, #-256]!	; 0xffffff00
    1348:	0000004d 	andeq	r0, r0, sp, asr #32
    134c:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    1350:	000006b3 			; <UNDEFINED> instruction: 0x000006b3
    1354:	4d256b01 	fstmdbxmi	r5!, {d6-d5}	;@ Deprecated
    1358:	02000000 	andeq	r0, r0, #0
    135c:	ad1e6891 	ldcge	8, cr6, [lr, #-580]	; 0xfffffdbc
    1360:	0100000f 	tsteq	r0, pc
    1364:	004d0e6d 	subeq	r0, sp, sp, ror #28
    1368:	91020000 	mrsls	r0, (UNDEF: 2)
    136c:	80210074 	eorhi	r0, r1, r4, ror r0
    1370:	0100000c 	tsteq	r0, ip
    1374:	0f4e125e 	svceq	0x004e125e
    1378:	008b0000 	addeq	r0, fp, r0
    137c:	85100000 	ldrhi	r0, [r0, #-0]
    1380:	00500000 	subseq	r0, r0, r0
    1384:	9c010000 	stcls	0, cr0, [r1], {-0}
    1388:	000008da 	ldrdeq	r0, [r0], -sl
    138c:	0009e520 	andeq	lr, r9, r0, lsr #10
    1390:	205e0100 	subscs	r0, lr, r0, lsl #2
    1394:	0000004d 	andeq	r0, r0, sp, asr #32
    1398:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    139c:	00000e73 	andeq	r0, r0, r3, ror lr
    13a0:	4d2f5e01 	stcmi	14, cr5, [pc, #-4]!	; 13a4 <shift+0x13a4>
    13a4:	02000000 	andeq	r0, r0, #0
    13a8:	b3206891 			; <UNDEFINED> instruction: 0xb3206891
    13ac:	01000006 	tsteq	r0, r6
    13b0:	004d3f5e 	subeq	r3, sp, lr, asr pc
    13b4:	91020000 	mrsls	r0, (UNDEF: 2)
    13b8:	0fad1e64 	svceq	0x00ad1e64
    13bc:	60010000 	andvs	r0, r1, r0
    13c0:	00008b16 	andeq	r8, r0, r6, lsl fp
    13c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    13c8:	0f842100 	svceq	0x00842100
    13cc:	52010000 	andpl	r0, r1, #0
    13d0:	000c850a 	andeq	r8, ip, sl, lsl #10
    13d4:	00004d00 	andeq	r4, r0, r0, lsl #26
    13d8:	0084cc00 	addeq	ip, r4, r0, lsl #24
    13dc:	00004400 	andeq	r4, r0, r0, lsl #8
    13e0:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    13e4:	20000009 	andcs	r0, r0, r9
    13e8:	000009e5 	andeq	r0, r0, r5, ror #19
    13ec:	4d1a5201 	lfmmi	f5, 4, [sl, #-4]
    13f0:	02000000 	andeq	r0, r0, #0
    13f4:	73206c91 			; <UNDEFINED> instruction: 0x73206c91
    13f8:	0100000e 	tsteq	r0, lr
    13fc:	004d2952 	subeq	r2, sp, r2, asr r9
    1400:	91020000 	mrsls	r0, (UNDEF: 2)
    1404:	0f7d1e68 	svceq	0x007d1e68
    1408:	54010000 	strpl	r0, [r1], #-0
    140c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1410:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1414:	0f772100 	svceq	0x00772100
    1418:	45010000 	strmi	r0, [r1, #-0]
    141c:	000f590a 	andeq	r5, pc, sl, lsl #18
    1420:	00004d00 	andeq	r4, r0, r0, lsl #26
    1424:	00847c00 	addeq	r7, r4, r0, lsl #24
    1428:	00005000 	andeq	r5, r0, r0
    142c:	819c0100 	orrshi	r0, ip, r0, lsl #2
    1430:	20000009 	andcs	r0, r0, r9
    1434:	000009e5 	andeq	r0, r0, r5, ror #19
    1438:	4d194501 	cfldr32mi	mvfx4, [r9, #-4]
    143c:	02000000 	andeq	r0, r0, #0
    1440:	62206c91 	eorvs	r6, r0, #37120	; 0x9100
    1444:	0100000d 	tsteq	r0, sp
    1448:	011d3045 	tsteq	sp, r5, asr #32
    144c:	91020000 	mrsls	r0, (UNDEF: 2)
    1450:	0e792068 	cdpeq	0, 7, cr2, cr9, cr8, {3}
    1454:	45010000 	strmi	r0, [r1, #-0]
    1458:	0006ac41 	andeq	sl, r6, r1, asr #24
    145c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1460:	000fad1e 	andeq	sl, pc, lr, lsl sp	; <UNPREDICTABLE>
    1464:	0e470100 	dvfeqs	f0, f7, f0
    1468:	0000004d 	andeq	r0, r0, sp, asr #32
    146c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1470:	000c3323 	andeq	r3, ip, r3, lsr #6
    1474:	063f0100 	ldrteq	r0, [pc], -r0, lsl #2
    1478:	00000d6c 	andeq	r0, r0, ip, ror #26
    147c:	00008450 	andeq	r8, r0, r0, asr r4
    1480:	0000002c 	andeq	r0, r0, ip, lsr #32
    1484:	09ab9c01 	stmibeq	fp!, {r0, sl, fp, ip, pc}
    1488:	e5200000 	str	r0, [r0, #-0]!
    148c:	01000009 	tsteq	r0, r9
    1490:	004d153f 	subeq	r1, sp, pc, lsr r5
    1494:	91020000 	mrsls	r0, (UNDEF: 2)
    1498:	38210074 	stmdacc	r1!, {r2, r4, r5, r6}
    149c:	0100000e 	tsteq	r0, lr
    14a0:	0e7f0a32 			; <UNDEFINED> instruction: 0x0e7f0a32
    14a4:	004d0000 	subeq	r0, sp, r0
    14a8:	84000000 	strhi	r0, [r0], #-0
    14ac:	00500000 	subseq	r0, r0, r0
    14b0:	9c010000 	stcls	0, cr0, [r1], {-0}
    14b4:	00000a06 	andeq	r0, r0, r6, lsl #20
    14b8:	0009e520 	andeq	lr, r9, r0, lsr #10
    14bc:	19320100 	ldmdbne	r2!, {r8}
    14c0:	0000004d 	andeq	r0, r0, sp, asr #32
    14c4:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    14c8:	00000f9a 	muleq	r0, sl, pc	; <UNPREDICTABLE>
    14cc:	f72b3201 			; <UNDEFINED> instruction: 0xf72b3201
    14d0:	02000001 	andeq	r0, r0, #1
    14d4:	ac206891 	stcge	8, cr6, [r0], #-580	; 0xfffffdbc
    14d8:	0100000e 	tsteq	r0, lr
    14dc:	004d3c32 	subeq	r3, sp, r2, lsr ip
    14e0:	91020000 	mrsls	r0, (UNDEF: 2)
    14e4:	0f481e64 	svceq	0x00481e64
    14e8:	34010000 	strcc	r0, [r1], #-0
    14ec:	00004d0e 	andeq	r4, r0, lr, lsl #26
    14f0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14f4:	0fd72100 	svceq	0x00d72100
    14f8:	25010000 	strcs	r0, [r1, #-0]
    14fc:	000fa10a 	andeq	sl, pc, sl, lsl #2
    1500:	00004d00 	andeq	r4, r0, r0, lsl #26
    1504:	0083b000 	addeq	fp, r3, r0
    1508:	00005000 	andeq	r5, r0, r0
    150c:	619c0100 	orrsvs	r0, ip, r0, lsl #2
    1510:	2000000a 	andcs	r0, r0, sl
    1514:	000009e5 	andeq	r0, r0, r5, ror #19
    1518:	4d182501 	cfldr32mi	mvfx2, [r8, #-4]
    151c:	02000000 	andeq	r0, r0, #0
    1520:	9a206c91 	bls	81c76c <__bss_end+0x813874>
    1524:	0100000f 	tsteq	r0, pc
    1528:	0a672a25 	beq	19cbdc4 <__bss_end+0x19c2ecc>
    152c:	91020000 	mrsls	r0, (UNDEF: 2)
    1530:	0eac2068 	cdpeq	0, 10, cr2, cr12, cr8, {3}
    1534:	25010000 	strcs	r0, [r1, #-0]
    1538:	00004d3b 	andeq	r4, r0, fp, lsr sp
    153c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1540:	000c521e 	andeq	r5, ip, lr, lsl r2
    1544:	0e270100 	sufeqs	f0, f7, f0
    1548:	0000004d 	andeq	r0, r0, sp, asr #32
    154c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1550:	0025040d 	eoreq	r0, r5, sp, lsl #8
    1554:	61030000 	mrsvs	r0, (UNDEF: 3)
    1558:	2100000a 	tstcs	r0, sl
    155c:	00000e44 	andeq	r0, r0, r4, asr #28
    1560:	e30a1901 	movw	r1, #43265	; 0xa901
    1564:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    1568:	6c000000 	stcvs	0, cr0, [r0], {-0}
    156c:	44000083 	strmi	r0, [r0], #-131	; 0xffffff7d
    1570:	01000000 	mrseq	r0, (UNDEF: 0)
    1574:	000ab89c 	muleq	sl, ip, r8
    1578:	0fce2000 	svceq	0x00ce2000
    157c:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1580:	0001f71b 	andeq	pc, r1, fp, lsl r7	; <UNPREDICTABLE>
    1584:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1588:	000f9520 	andeq	r9, pc, r0, lsr #10
    158c:	35190100 	ldrcc	r0, [r9, #-256]	; 0xffffff00
    1590:	000001c6 	andeq	r0, r0, r6, asr #3
    1594:	1e689102 	lgnnee	f1, f2
    1598:	000009e5 	andeq	r0, r0, r5, ror #19
    159c:	4d0e1b01 	vstrmi	d1, [lr, #-4]
    15a0:	02000000 	andeq	r0, r0, #0
    15a4:	24007491 	strcs	r7, [r0], #-1169	; 0xfffffb6f
    15a8:	00000ceb 	andeq	r0, r0, fp, ror #25
    15ac:	58061401 	stmdapl	r6, {r0, sl, ip}
    15b0:	5000000c 	andpl	r0, r0, ip
    15b4:	1c000083 	stcne	0, cr0, [r0], {131}	; 0x83
    15b8:	01000000 	mrseq	r0, (UNDEF: 0)
    15bc:	0f8b239c 	svceq	0x008b239c
    15c0:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    15c4:	000d5406 	andeq	r5, sp, r6, lsl #8
    15c8:	00832400 	addeq	r2, r3, r0, lsl #8
    15cc:	00002c00 	andeq	r2, r0, r0, lsl #24
    15d0:	f89c0100 			; <UNDEFINED> instruction: 0xf89c0100
    15d4:	2000000a 	andcs	r0, r0, sl
    15d8:	00000ce2 	andeq	r0, r0, r2, ror #25
    15dc:	38140e01 	ldmdacc	r4, {r0, r9, sl, fp}
    15e0:	02000000 	andeq	r0, r0, #0
    15e4:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    15e8:	00000fdc 	ldrdeq	r0, [r0], -ip
    15ec:	760a0401 	strvc	r0, [sl], -r1, lsl #8
    15f0:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    15f4:	f8000000 			; <UNDEFINED> instruction: 0xf8000000
    15f8:	2c000082 	stccs	0, cr0, [r0], {130}	; 0x82
    15fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1600:	6970229c 	ldmdbvs	r0!, {r2, r3, r4, r7, r9, sp}^
    1604:	06010064 	streq	r0, [r1], -r4, rrx
    1608:	00004d0e 	andeq	r4, r0, lr, lsl #26
    160c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1610:	032e0000 			; <UNDEFINED> instruction: 0x032e0000
    1614:	00040000 	andeq	r0, r4, r0
    1618:	00000655 	andeq	r0, r0, r5, asr r6
    161c:	0d870104 	stfeqs	f0, [r7, #16]
    1620:	be040000 	cdplt	0, 0, cr0, cr4, cr0, {0}
    1624:	b1000010 	tstlt	r0, r0, lsl r0
    1628:	5400000e 	strpl	r0, [r0], #-14
    162c:	b8000087 	stmdalt	r0, {r0, r1, r2, r7}
    1630:	23000004 	movwcs	r0, #4
    1634:	02000007 	andeq	r0, r0, #7
    1638:	00000049 	andeq	r0, r0, r9, asr #32
    163c:	00103603 	andseq	r3, r0, r3, lsl #12
    1640:	10050100 	andne	r0, r5, r0, lsl #2
    1644:	00000061 	andeq	r0, r0, r1, rrx
    1648:	32313011 	eorscc	r3, r1, #17
    164c:	36353433 			; <UNDEFINED> instruction: 0x36353433
    1650:	41393837 	teqmi	r9, r7, lsr r8
    1654:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    1658:	04000046 	streq	r0, [r0], #-70	; 0xffffffba
    165c:	25010301 	strcs	r0, [r1, #-769]	; 0xfffffcff
    1660:	05000000 	streq	r0, [r0, #-0]
    1664:	00000074 	andeq	r0, r0, r4, ror r0
    1668:	00000061 	andeq	r0, r0, r1, rrx
    166c:	00006606 	andeq	r6, r0, r6, lsl #12
    1670:	07001000 	streq	r1, [r0, -r0]
    1674:	00000051 	andeq	r0, r0, r1, asr r0
    1678:	de070408 	cdple	4, 0, cr0, cr7, cr8, {0}
    167c:	08000014 	stmdaeq	r0, {r2, r4}
    1680:	09670801 	stmdbeq	r7!, {r0, fp}^
    1684:	6d070000 	stcvs	0, cr0, [r7, #-0]
    1688:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    168c:	0000002a 	andeq	r0, r0, sl, lsr #32
    1690:	0010600a 	andseq	r6, r0, sl
    1694:	06640100 	strbteq	r0, [r4], -r0, lsl #2
    1698:	00001050 	andeq	r1, r0, r0, asr r0
    169c:	00008b8c 	andeq	r8, r0, ip, lsl #23
    16a0:	00000080 	andeq	r0, r0, r0, lsl #1
    16a4:	00fb9c01 	rscseq	r9, fp, r1, lsl #24
    16a8:	730b0000 	movwvc	r0, #45056	; 0xb000
    16ac:	01006372 	tsteq	r0, r2, ror r3
    16b0:	00fb1964 	rscseq	r1, fp, r4, ror #18
    16b4:	91020000 	mrsls	r0, (UNDEF: 2)
    16b8:	73640b64 	cmnvc	r4, #100, 22	; 0x19000
    16bc:	64010074 	strvs	r0, [r1], #-116	; 0xffffff8c
    16c0:	00010224 	andeq	r0, r1, r4, lsr #4
    16c4:	60910200 	addsvs	r0, r1, r0, lsl #4
    16c8:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    16cc:	2d640100 	stfcse	f0, [r4, #-0]
    16d0:	00000104 	andeq	r0, r0, r4, lsl #2
    16d4:	0c5c9102 	ldfeqp	f1, [ip], {2}
    16d8:	000010b2 	strheq	r1, [r0], -r2
    16dc:	0b116601 	bleq	45aee8 <__bss_end+0x451ff0>
    16e0:	02000001 	andeq	r0, r0, #1
    16e4:	420c7091 	andmi	r7, ip, #145	; 0x91
    16e8:	01000010 	tsteq	r0, r0, lsl r0
    16ec:	01110b67 	tsteq	r1, r7, ror #22
    16f0:	91020000 	mrsls	r0, (UNDEF: 2)
    16f4:	8bb40d6c 	blhi	fed04cac <__bss_end+0xfecfbdb4>
    16f8:	00480000 	subeq	r0, r8, r0
    16fc:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    1700:	0e690100 	poweqe	f0, f1, f0
    1704:	00000104 	andeq	r0, r0, r4, lsl #2
    1708:	00749102 	rsbseq	r9, r4, r2, lsl #2
    170c:	01040f00 	tsteq	r4, r0, lsl #30
    1710:	10000001 	andne	r0, r0, r1
    1714:	04120411 	ldreq	r0, [r2], #-1041	; 0xfffffbef
    1718:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    171c:	74040f00 	strvc	r0, [r4], #-3840	; 0xfffff100
    1720:	0f000000 	svceq	0x00000000
    1724:	00006d04 	andeq	r6, r0, r4, lsl #26
    1728:	100a0a00 	andne	r0, sl, r0, lsl #20
    172c:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1730:	00101706 	andseq	r1, r0, r6, lsl #14
    1734:	008b2400 	addeq	r2, fp, r0, lsl #8
    1738:	00006800 	andeq	r6, r0, r0, lsl #16
    173c:	769c0100 	ldrvc	r0, [ip], r0, lsl #2
    1740:	13000001 	movwne	r0, #1
    1744:	000010ab 	andeq	r1, r0, fp, lsr #1
    1748:	02125c01 	andseq	r5, r2, #256	; 0x100
    174c:	02000001 	andeq	r0, r0, #1
    1750:	10136c91 	mulsne	r3, r1, ip
    1754:	01000010 	tsteq	r0, r0, lsl r0
    1758:	01041e5c 	tsteq	r4, ip, asr lr
    175c:	91020000 	mrsls	r0, (UNDEF: 2)
    1760:	656d0e68 	strbvs	r0, [sp, #-3688]!	; 0xfffff198
    1764:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    1768:	0001110b 	andeq	r1, r1, fp, lsl #2
    176c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1770:	008b400d 	addeq	r4, fp, sp
    1774:	00003c00 	andeq	r3, r0, r0, lsl #24
    1778:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    177c:	040e6001 	streq	r6, [lr], #-1
    1780:	02000001 	andeq	r0, r0, #1
    1784:	00007491 	muleq	r0, r1, r4
    1788:	00106714 	andseq	r6, r0, r4, lsl r7
    178c:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    1790:	00001080 	andeq	r1, r0, r0, lsl #1
    1794:	00000104 	andeq	r0, r0, r4, lsl #2
    1798:	00008ad0 	ldrdeq	r8, [r0], -r0
    179c:	00000054 	andeq	r0, r0, r4, asr r0
    17a0:	01af9c01 			; <UNDEFINED> instruction: 0x01af9c01
    17a4:	730b0000 	movwvc	r0, #45056	; 0xb000
    17a8:	18520100 	ldmdane	r2, {r8}^
    17ac:	0000010b 	andeq	r0, r0, fp, lsl #2
    17b0:	0e6c9102 	lgneqe	f1, f2
    17b4:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    17b8:	00010409 	andeq	r0, r1, r9, lsl #8
    17bc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    17c0:	10a31400 	adcne	r1, r3, r0, lsl #8
    17c4:	42010000 	andmi	r0, r1, #0
    17c8:	00106e05 	andseq	r6, r0, r5, lsl #28
    17cc:	00010400 	andeq	r0, r1, r0, lsl #8
    17d0:	008a2400 	addeq	r2, sl, r0, lsl #8
    17d4:	0000ac00 	andeq	sl, r0, r0, lsl #24
    17d8:	159c0100 	ldrne	r0, [ip, #256]	; 0x100
    17dc:	0b000002 	bleq	17ec <shift+0x17ec>
    17e0:	01003173 	tsteq	r0, r3, ror r1
    17e4:	010b1942 	tsteq	fp, r2, asr #18
    17e8:	91020000 	mrsls	r0, (UNDEF: 2)
    17ec:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    17f0:	29420100 	stmdbcs	r2, {r8}^
    17f4:	0000010b 	andeq	r0, r0, fp, lsl #2
    17f8:	0b689102 	bleq	1a25c08 <__bss_end+0x1a1cd10>
    17fc:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1800:	04314201 	ldrteq	r4, [r1], #-513	; 0xfffffdff
    1804:	02000001 	andeq	r0, r0, #1
    1808:	750e6491 	strvc	r6, [lr, #-1169]	; 0xfffffb6f
    180c:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    1810:	00021513 	andeq	r1, r2, r3, lsl r5
    1814:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1818:	0032750e 	eorseq	r7, r2, lr, lsl #10
    181c:	15174401 	ldrne	r4, [r7, #-1025]	; 0xfffffbff
    1820:	02000002 	andeq	r0, r0, #2
    1824:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    1828:	095e0801 	ldmdbeq	lr, {r0, fp}^
    182c:	23140000 	tstcs	r4, #0
    1830:	01000010 	tsteq	r0, r0, lsl r0
    1834:	10920736 	addsne	r0, r2, r6, lsr r7
    1838:	01110000 	tsteq	r1, r0
    183c:	89640000 	stmdbhi	r4!, {}^	; <UNPREDICTABLE>
    1840:	00c00000 	sbceq	r0, r0, r0
    1844:	9c010000 	stcls	0, cr0, [r1], {-0}
    1848:	00000275 	andeq	r0, r0, r5, ror r2
    184c:	00100513 	andseq	r0, r0, r3, lsl r5
    1850:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    1854:	00000111 	andeq	r0, r0, r1, lsl r1
    1858:	0b6c9102 	bleq	1b25c68 <__bss_end+0x1b1cd70>
    185c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1860:	0b273601 	bleq	9cf06c <__bss_end+0x9c6174>
    1864:	02000001 	andeq	r0, r0, #1
    1868:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    186c:	01006d75 	tsteq	r0, r5, ror sp
    1870:	01043036 	tsteq	r4, r6, lsr r0
    1874:	91020000 	mrsls	r0, (UNDEF: 2)
    1878:	00690e64 	rsbeq	r0, r9, r4, ror #28
    187c:	04093801 	streq	r3, [r9], #-2049	; 0xfffff7ff
    1880:	02000001 	andeq	r0, r0, #1
    1884:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    1888:	0000108d 	andeq	r1, r0, sp, lsl #1
    188c:	2b052401 	blcs	14a898 <__bss_end+0x1419a0>
    1890:	04000010 	streq	r0, [r0], #-16
    1894:	c8000001 	stmdagt	r0, {r0}
    1898:	9c000088 	stcls	0, cr0, [r0], {136}	; 0x88
    189c:	01000000 	mrseq	r0, (UNDEF: 0)
    18a0:	0002b29c 	muleq	r2, ip, r2
    18a4:	0fff1300 	svceq	0x00ff1300
    18a8:	24010000 	strcs	r0, [r1], #-0
    18ac:	00010b16 	andeq	r0, r1, r6, lsl fp
    18b0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    18b4:	0010490c 	andseq	r4, r0, ip, lsl #18
    18b8:	09260100 	stmdbeq	r6!, {r8}
    18bc:	00000104 	andeq	r0, r0, r4, lsl #2
    18c0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18c4:	0010b915 	andseq	fp, r0, r5, lsl r9
    18c8:	06080100 	streq	r0, [r8], -r0, lsl #2
    18cc:	0000110c 	andeq	r1, r0, ip, lsl #2
    18d0:	00008754 	andeq	r8, r0, r4, asr r7
    18d4:	00000174 	andeq	r0, r0, r4, ror r1
    18d8:	ff139c01 			; <UNDEFINED> instruction: 0xff139c01
    18dc:	0100000f 	tsteq	r0, pc
    18e0:	00661808 	rsbeq	r1, r6, r8, lsl #16
    18e4:	91020000 	mrsls	r0, (UNDEF: 2)
    18e8:	10491364 	subne	r1, r9, r4, ror #6
    18ec:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    18f0:	00011125 	andeq	r1, r1, r5, lsr #2
    18f4:	60910200 	addsvs	r0, r1, r0, lsl #4
    18f8:	0011d813 	andseq	sp, r1, r3, lsl r8
    18fc:	3a080100 	bcc	201d04 <__bss_end+0x1f8e0c>
    1900:	00000066 	andeq	r0, r0, r6, rrx
    1904:	0e5c9102 	logeqe	f1, f2
    1908:	0a010069 	beq	41ab4 <__bss_end+0x38bbc>
    190c:	00010409 	andeq	r0, r1, r9, lsl #8
    1910:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1914:	0088200d 	addeq	r2, r8, sp
    1918:	00009800 	andeq	r9, r0, r0, lsl #16
    191c:	006a0e00 	rsbeq	r0, sl, r0, lsl #28
    1920:	040e1c01 	streq	r1, [lr], #-3073	; 0xfffff3ff
    1924:	02000001 	andeq	r0, r0, #1
    1928:	480d7091 	stmdami	sp, {r0, r4, r7, ip, sp, lr}
    192c:	60000088 	andvs	r0, r0, r8, lsl #1
    1930:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1934:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    1938:	00006d0e 	andeq	r6, r0, lr, lsl #26
    193c:	6f910200 	svcvs	0x00910200
    1940:	00000000 	andeq	r0, r0, r0
    1944:	00000022 	andeq	r0, r0, r2, lsr #32
    1948:	077c0002 	ldrbeq	r0, [ip, -r2]!
    194c:	01040000 	mrseq	r0, (UNDEF: 4)
    1950:	000009ae 	andeq	r0, r0, lr, lsr #19
    1954:	00008c0c 	andeq	r8, r0, ip, lsl #24
    1958:	00008e18 	andeq	r8, r0, r8, lsl lr
    195c:	00001118 	andeq	r1, r0, r8, lsl r1
    1960:	00001148 	andeq	r1, r0, r8, asr #2
    1964:	000011b0 			; <UNDEFINED> instruction: 0x000011b0
    1968:	00228001 	eoreq	r8, r2, r1
    196c:	00020000 	andeq	r0, r2, r0
    1970:	00000790 	muleq	r0, r0, r7
    1974:	0a2b0104 	beq	ac1d8c <__bss_end+0xab8e94>
    1978:	8e180000 	cdphi	0, 1, cr0, cr8, cr0, {0}
    197c:	8e1c0000 	cdphi	0, 1, cr0, cr12, cr0, {0}
    1980:	11180000 	tstne	r8, r0
    1984:	11480000 	mrsne	r0, (UNDEF: 72)
    1988:	11b00000 	movsne	r0, r0
    198c:	80010000 	andhi	r0, r1, r0
    1990:	0000032a 	andeq	r0, r0, sl, lsr #6
    1994:	07a40004 	streq	r0, [r4, r4]!
    1998:	01040000 	mrseq	r0, (UNDEF: 4)
    199c:	000012dc 	ldrdeq	r1, [r0], -ip
    19a0:	0014950c 	andseq	r9, r4, ip, lsl #10
    19a4:	00114800 	andseq	r4, r1, r0, lsl #16
    19a8:	000a8b00 	andeq	r8, sl, r0, lsl #22
    19ac:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    19b0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    19b4:	de070403 	cdple	4, 0, cr0, cr7, cr3, {0}
    19b8:	03000014 	movweq	r0, #20
    19bc:	02b90508 	adcseq	r0, r9, #8, 10	; 0x2000000
    19c0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    19c4:	00148904 	andseq	r8, r4, r4, lsl #18
    19c8:	08010300 	stmdaeq	r1, {r8, r9}
    19cc:	0000095e 	andeq	r0, r0, lr, asr r9
    19d0:	60060103 	andvs	r0, r6, r3, lsl #2
    19d4:	04000009 	streq	r0, [r0], #-9
    19d8:	00001661 	andeq	r1, r0, r1, ror #12
    19dc:	00390107 	eorseq	r0, r9, r7, lsl #2
    19e0:	17010000 	strne	r0, [r1, -r0]
    19e4:	0001d406 	andeq	sp, r1, r6, lsl #8
    19e8:	11eb0500 	mvnne	r0, r0, lsl #10
    19ec:	05000000 	streq	r0, [r0, #-0]
    19f0:	00001710 	andeq	r1, r0, r0, lsl r7
    19f4:	13be0501 			; <UNDEFINED> instruction: 0x13be0501
    19f8:	05020000 	streq	r0, [r2, #-0]
    19fc:	0000147c 	andeq	r1, r0, ip, ror r4
    1a00:	167a0503 	ldrbtne	r0, [sl], -r3, lsl #10
    1a04:	05040000 	streq	r0, [r4, #-0]
    1a08:	00001720 	andeq	r1, r0, r0, lsr #14
    1a0c:	16900505 	ldrne	r0, [r0], r5, lsl #10
    1a10:	05060000 	streq	r0, [r6, #-0]
    1a14:	000014c5 	andeq	r1, r0, r5, asr #9
    1a18:	160b0507 	strne	r0, [fp], -r7, lsl #10
    1a1c:	05080000 	streq	r0, [r8, #-0]
    1a20:	00001619 	andeq	r1, r0, r9, lsl r6
    1a24:	16270509 	strtne	r0, [r7], -r9, lsl #10
    1a28:	050a0000 	streq	r0, [sl, #-0]
    1a2c:	0000152e 	andeq	r1, r0, lr, lsr #10
    1a30:	151e050b 	ldrne	r0, [lr, #-1291]	; 0xfffffaf5
    1a34:	050c0000 	streq	r0, [ip, #-0]
    1a38:	00001207 	andeq	r1, r0, r7, lsl #4
    1a3c:	1220050d 	eorne	r0, r0, #54525952	; 0x3400000
    1a40:	050e0000 	streq	r0, [lr, #-0]
    1a44:	0000150f 	andeq	r1, r0, pc, lsl #10
    1a48:	16d3050f 	ldrbne	r0, [r3], pc, lsl #10
    1a4c:	05100000 	ldreq	r0, [r0, #-0]
    1a50:	00001650 	andeq	r1, r0, r0, asr r6
    1a54:	16c40511 			; <UNDEFINED> instruction: 0x16c40511
    1a58:	05120000 	ldreq	r0, [r2, #-0]
    1a5c:	000012cd 	andeq	r1, r0, sp, asr #5
    1a60:	124a0513 	subne	r0, sl, #79691776	; 0x4c00000
    1a64:	05140000 	ldreq	r0, [r4, #-0]
    1a68:	00001214 	andeq	r1, r0, r4, lsl r2
    1a6c:	15ad0515 	strne	r0, [sp, #1301]!	; 0x515
    1a70:	05160000 	ldreq	r0, [r6, #-0]
    1a74:	00001281 	andeq	r1, r0, r1, lsl #5
    1a78:	11bc0517 			; <UNDEFINED> instruction: 0x11bc0517
    1a7c:	05180000 	ldreq	r0, [r8, #-0]
    1a80:	000016b6 			; <UNDEFINED> instruction: 0x000016b6
    1a84:	14eb0519 	strbtne	r0, [fp], #1305	; 0x519
    1a88:	051a0000 	ldreq	r0, [sl, #-0]
    1a8c:	000015c5 	andeq	r1, r0, r5, asr #11
    1a90:	1255051b 	subsne	r0, r5, #113246208	; 0x6c00000
    1a94:	051c0000 	ldreq	r0, [ip, #-0]
    1a98:	00001461 	andeq	r1, r0, r1, ror #8
    1a9c:	13b0051d 	movsne	r0, #121634816	; 0x7400000
    1aa0:	051e0000 	ldreq	r0, [lr, #-0]
    1aa4:	00001642 	andeq	r1, r0, r2, asr #12
    1aa8:	169e051f 			; <UNDEFINED> instruction: 0x169e051f
    1aac:	05200000 	streq	r0, [r0, #-0]!
    1ab0:	000016df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1ab4:	16ed0521 	strbtne	r0, [sp], r1, lsr #10
    1ab8:	05220000 	streq	r0, [r2, #-0]!
    1abc:	00001502 	andeq	r1, r0, r2, lsl #10
    1ac0:	14250523 	strtne	r0, [r5], #-1315	; 0xfffffadd
    1ac4:	05240000 	streq	r0, [r4, #-0]!
    1ac8:	00001264 	andeq	r1, r0, r4, ror #4
    1acc:	14b80525 	ldrtne	r0, [r8], #1317	; 0x525
    1ad0:	05260000 	streq	r0, [r6, #-0]!
    1ad4:	000013ca 	andeq	r1, r0, sl, asr #7
    1ad8:	166d0527 	strbtne	r0, [sp], -r7, lsr #10
    1adc:	05280000 	streq	r0, [r8, #-0]!
    1ae0:	000013da 	ldrdeq	r1, [r0], -sl
    1ae4:	13e90529 	mvnne	r0, #171966464	; 0xa400000
    1ae8:	052a0000 	streq	r0, [sl, #-0]!
    1aec:	000013f8 	strdeq	r1, [r0], -r8
    1af0:	1407052b 	strne	r0, [r7], #-1323	; 0xfffffad5
    1af4:	052c0000 	streq	r0, [ip, #-0]!
    1af8:	00001395 	muleq	r0, r5, r3
    1afc:	1416052d 	ldrne	r0, [r6], #-1325	; 0xfffffad3
    1b00:	052e0000 	streq	r0, [lr, #-0]!
    1b04:	000015fc 	strdeq	r1, [r0], -ip
    1b08:	1434052f 	ldrtne	r0, [r4], #-1327	; 0xfffffad1
    1b0c:	05300000 	ldreq	r0, [r0, #-0]!
    1b10:	00001443 	andeq	r1, r0, r3, asr #8
    1b14:	11f50531 	mvnsne	r0, r1, lsr r5
    1b18:	05320000 	ldreq	r0, [r2, #-0]!
    1b1c:	0000154d 	andeq	r1, r0, sp, asr #10
    1b20:	155d0533 	ldrbne	r0, [sp, #-1331]	; 0xfffffacd
    1b24:	05340000 	ldreq	r0, [r4, #-0]!
    1b28:	0000156d 	andeq	r1, r0, sp, ror #10
    1b2c:	13830535 	orrne	r0, r3, #222298112	; 0xd400000
    1b30:	05360000 	ldreq	r0, [r6, #-0]!
    1b34:	0000157d 	andeq	r1, r0, sp, ror r5
    1b38:	158d0537 	strne	r0, [sp, #1335]	; 0x537
    1b3c:	05380000 	ldreq	r0, [r8, #-0]!
    1b40:	0000159d 	muleq	r0, sp, r5
    1b44:	12740539 	rsbsne	r0, r4, #239075328	; 0xe400000
    1b48:	053a0000 	ldreq	r0, [sl, #-0]!
    1b4c:	0000122d 	andeq	r1, r0, sp, lsr #4
    1b50:	1452053b 	ldrbne	r0, [r2], #-1339	; 0xfffffac5
    1b54:	053c0000 	ldreq	r0, [ip, #-0]!
    1b58:	000011cc 	andeq	r1, r0, ip, asr #3
    1b5c:	15b8053d 	ldrne	r0, [r8, #1341]!	; 0x53d
    1b60:	003e0000 	eorseq	r0, lr, r0
    1b64:	0012b406 	andseq	fp, r2, r6, lsl #8
    1b68:	6b010200 	blvs	42370 <__bss_end+0x39478>
    1b6c:	01ff0802 	mvnseq	r0, r2, lsl #16
    1b70:	77070000 	strvc	r0, [r7, -r0]
    1b74:	01000014 	tsteq	r0, r4, lsl r0
    1b78:	47140270 			; <UNDEFINED> instruction: 0x47140270
    1b7c:	00000000 	andeq	r0, r0, r0
    1b80:	00139007 	andseq	r9, r3, r7
    1b84:	02710100 	rsbseq	r0, r1, #0, 2
    1b88:	00004714 	andeq	r4, r0, r4, lsl r7
    1b8c:	08000100 	stmdaeq	r0, {r8}
    1b90:	000001d4 	ldrdeq	r0, [r0], -r4
    1b94:	0001ff09 	andeq	pc, r1, r9, lsl #30
    1b98:	00021400 	andeq	r1, r2, r0, lsl #8
    1b9c:	00240a00 	eoreq	r0, r4, r0, lsl #20
    1ba0:	00110000 	andseq	r0, r1, r0
    1ba4:	00020408 	andeq	r0, r2, r8, lsl #8
    1ba8:	153b0b00 	ldrne	r0, [fp, #-2816]!	; 0xfffff500
    1bac:	74010000 	strvc	r0, [r1], #-0
    1bb0:	02142602 	andseq	r2, r4, #2097152	; 0x200000
    1bb4:	3a240000 	bcc	901bbc <__bss_end+0x8f8cc4>
    1bb8:	0f3d0a3d 	svceq	0x003d0a3d
    1bbc:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    1bc0:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    1bc4:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    1bc8:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    1bcc:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    1bd0:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    1bd4:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    1bd8:	0300003d 	movweq	r0, #61	; 0x3d
    1bdc:	07a20702 	streq	r0, [r2, r2, lsl #14]!
    1be0:	01030000 	mrseq	r0, (UNDEF: 3)
    1be4:	00096708 	andeq	r6, r9, r8, lsl #14
    1be8:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
    1bec:	00000259 	andeq	r0, r0, r9, asr r2
    1bf0:	0016fb0e 	andseq	pc, r6, lr, lsl #22
    1bf4:	39010700 	stmdbcc	r1, {r8, r9, sl}
    1bf8:	02000000 	andeq	r0, r0, #0
    1bfc:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
    1c00:	05000002 	streq	r0, [r0, #-2]
    1c04:	0000128e 	andeq	r1, r0, lr, lsl #5
    1c08:	12990500 	addsne	r0, r9, #0, 10
    1c0c:	05010000 	streq	r0, [r1, #-0]
    1c10:	000012ab 	andeq	r1, r0, fp, lsr #5
    1c14:	12c50502 	sbcne	r0, r5, #8388608	; 0x800000
    1c18:	05030000 	streq	r0, [r3, #-0]
    1c1c:	00001635 	andeq	r1, r0, r5, lsr r6
    1c20:	13a40504 			; <UNDEFINED> instruction: 0x13a40504
    1c24:	05050000 	streq	r0, [r5, #-0]
    1c28:	000015ee 	andeq	r1, r0, lr, ror #11
    1c2c:	02030006 	andeq	r0, r3, #6
    1c30:	0009a105 	andeq	sl, r9, r5, lsl #2
    1c34:	07080300 	streq	r0, [r8, -r0, lsl #6]
    1c38:	000014d4 	ldrdeq	r1, [r0], -r4
    1c3c:	e5040403 	str	r0, [r4, #-1027]	; 0xfffffbfd
    1c40:	03000011 	movweq	r0, #17
    1c44:	11dd0308 	bicsne	r0, sp, r8, lsl #6
    1c48:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1c4c:	00148e04 	andseq	r8, r4, r4, lsl #28
    1c50:	03100300 	tsteq	r0, #0, 6
    1c54:	000015df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1c58:	0015d60f 	andseq	sp, r5, pc, lsl #12
    1c5c:	102a0300 	eorne	r0, sl, r0, lsl #6
    1c60:	0000025a 	andeq	r0, r0, sl, asr r2
    1c64:	0002c809 	andeq	ip, r2, r9, lsl #16
    1c68:	0002df00 	andeq	sp, r2, r0, lsl #30
    1c6c:	11001000 	mrsne	r1, (UNDEF: 0)
    1c70:	00000382 	andeq	r0, r0, r2, lsl #7
    1c74:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
    1c78:	11000002 	tstne	r0, r2
    1c7c:	00000276 	andeq	r0, r0, r6, ror r2
    1c80:	d4113003 	ldrle	r3, [r1], #-3
    1c84:	09000002 	stmdbeq	r0, {r1}
    1c88:	000002c8 	andeq	r0, r0, r8, asr #5
    1c8c:	00000307 	andeq	r0, r0, r7, lsl #6
    1c90:	0000240a 	andeq	r2, r0, sl, lsl #8
    1c94:	12000100 	andne	r0, r0, #0, 2
    1c98:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1c9c:	0a093304 	beq	24e8b4 <__bss_end+0x2459bc>
    1ca0:	000002f7 	strdeq	r0, [r0], -r7
    1ca4:	8ee50305 	cdphi	3, 14, cr0, cr5, cr5, {0}
    1ca8:	eb120000 	bl	481cb0 <__bss_end+0x478db8>
    1cac:	04000002 	streq	r0, [r0], #-2
    1cb0:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
    1cb4:	05000002 	streq	r0, [r0, #-2]
    1cb8:	008ee503 	addeq	lr, lr, r3, lsl #10
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377d1c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9e24>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9e44>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9e5c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x198>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a99c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39e80>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377dc4>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79e20>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5a38>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7aa20>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39f04>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9f18>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x268>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7aa58>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39f3c>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9f4c>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377ed4>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5ac4>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5ad8>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377f08>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79f18>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	0b002403 	bleq	91f8 <__bss_end+0x300>
 1e8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 1ec:	04000008 	streq	r0, [r0], #-8
 1f0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 1f4:	0b3b0b3a 	bleq	ec2ee4 <__bss_end+0xeb9fec>
 1f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 1fc:	26050000 	strcs	r0, [r5], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2bab24>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeba004>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f7f28>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d8f0>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeba02c>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeba044>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0b0b000f 	bleq	2c02a8 <__bss_end+0x2b73b0>
 268:	00001349 	andeq	r1, r0, r9, asr #6
 26c:	0300280d 	movweq	r2, #2061	; 0x80d
 270:	000b1c08 	andeq	r1, fp, r8, lsl #24
 274:	000d0e00 	andeq	r0, sp, r0, lsl #28
 278:	0b3a0e03 	bleq	e83a8c <__bss_end+0xe7ab94>
 27c:	0b390b3b 	bleq	e42f70 <__bss_end+0xe3a078>
 280:	0b381349 	bleq	e04fac <__bss_end+0xdfc0b4>
 284:	010f0000 	mrseq	r0, CPSR
 288:	01134901 	tsteq	r3, r1, lsl #18
 28c:	10000013 	andne	r0, r0, r3, lsl r0
 290:	13490021 	movtne	r0, #36897	; 0x9021
 294:	00000b2f 	andeq	r0, r0, pc, lsr #22
 298:	03010211 	movweq	r0, #4625	; 0x1211
 29c:	3a0b0b0e 	bcc	2c2edc <__bss_end+0x2b9fe4>
 2a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2a4:	0013010b 	andseq	r0, r3, fp, lsl #2
 2a8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2b0:	0b3b0b3a 	bleq	ec2fa0 <__bss_end+0xeba0a8>
 2b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2bc:	00001301 	andeq	r1, r0, r1, lsl #6
 2c0:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 2c4:	00193413 	andseq	r3, r9, r3, lsl r4
 2c8:	00051400 	andeq	r1, r5, r0, lsl #8
 2cc:	00001349 	andeq	r1, r0, r9, asr #6
 2d0:	3f012e15 	svccc	0x00012e15
 2d4:	3a0e0319 	bcc	380f40 <__bss_end+0x378048>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2e0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2e4:	00130113 	andseq	r0, r3, r3, lsl r1
 2e8:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 2ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2f0:	0b3b0b3a 	bleq	ec2fe0 <__bss_end+0xeba0e8>
 2f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f8:	0b321349 	bleq	c85024 <__bss_end+0xc7c12c>
 2fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 300:	00001301 	andeq	r1, r0, r1, lsl #6
 304:	03000d17 	movweq	r0, #3351	; 0xd17
 308:	3b0b3a0e 	blcc	2ceb48 <__bss_end+0x2c5c50>
 30c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 310:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 314:	1800000b 	stmdane	r0, {r0, r1, r3}
 318:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 31c:	0b3a0e03 	bleq	e83b30 <__bss_end+0xe7ac38>
 320:	0b390b3b 	bleq	e43014 <__bss_end+0xe3a11c>
 324:	0b320e6e 	bleq	c83ce4 <__bss_end+0xc7adec>
 328:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 32c:	00001301 	andeq	r1, r0, r1, lsl #6
 330:	3f012e19 	svccc	0x00012e19
 334:	3a0e0319 	bcc	380fa0 <__bss_end+0x3780a8>
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
 370:	0b3a0803 	bleq	e82384 <__bss_end+0xe7948c>
 374:	0b390b3b 	bleq	e43068 <__bss_end+0xe3a170>
 378:	00001301 	andeq	r1, r0, r1, lsl #6
 37c:	0300341f 	movweq	r3, #1055	; 0x41f
 380:	3b0b3a0e 	blcc	2cebc0 <__bss_end+0x2c5cc8>
 384:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 388:	1c193c13 	ldcne	12, cr3, [r9], {19}
 38c:	00196c06 	andseq	r6, r9, r6, lsl #24
 390:	00342000 	eorseq	r2, r4, r0
 394:	0b3a0e03 	bleq	e83ba8 <__bss_end+0xe7acb0>
 398:	0b390b3b 	bleq	e4308c <__bss_end+0xe3a194>
 39c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3a0:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 3a4:	34210000 	strtcc	r0, [r1], #-0
 3a8:	00134700 	andseq	r4, r3, r0, lsl #14
 3ac:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 3b0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3b4:	0b3b0b3a 	bleq	ec30a4 <__bss_end+0xeba1ac>
 3b8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3bc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3c0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3c4:	00130119 	andseq	r0, r3, r9, lsl r1
 3c8:	00052300 	andeq	r2, r5, r0, lsl #6
 3cc:	0b3a0e03 	bleq	e83be0 <__bss_end+0xe7ace8>
 3d0:	0b390b3b 	bleq	e430c4 <__bss_end+0xe3a1cc>
 3d4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3d8:	34240000 	strtcc	r0, [r4], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x3780ec>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 3e8:	00000018 	andeq	r0, r0, r8, lsl r0
 3ec:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 3f0:	030b130e 	movweq	r1, #45838	; 0xb30e
 3f4:	110e1b0e 	tstne	lr, lr, lsl #22
 3f8:	10061201 	andne	r1, r6, r1, lsl #4
 3fc:	02000017 	andeq	r0, r0, #23
 400:	0b0b0024 	bleq	2c0498 <__bss_end+0x2b75a0>
 404:	0e030b3e 	vmoveq.16	d3[0], r0
 408:	26030000 	strcs	r0, [r3], -r0
 40c:	00134900 	andseq	r4, r3, r0, lsl #18
 410:	00240400 	eoreq	r0, r4, r0, lsl #8
 414:	0b3e0b0b 	bleq	f83048 <__bss_end+0xf7a150>
 418:	00000803 	andeq	r0, r0, r3, lsl #16
 41c:	03001605 	movweq	r1, #1541	; 0x605
 420:	3b0b3a0e 	blcc	2cec60 <__bss_end+0x2c5d68>
 424:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 428:	06000013 			; <UNDEFINED> instruction: 0x06000013
 42c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 430:	0b3a0b0b 	bleq	e83064 <__bss_end+0xe7a16c>
 434:	0b390b3b 	bleq	e43128 <__bss_end+0xe3a230>
 438:	00001301 	andeq	r1, r0, r1, lsl #6
 43c:	03000d07 	movweq	r0, #3335	; 0xd07
 440:	3b0b3a08 	blcc	2cec68 <__bss_end+0x2c5d70>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	000b3813 	andeq	r3, fp, r3, lsl r8
 44c:	01040800 	tsteq	r4, r0, lsl #16
 450:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 454:	0b0b0b3e 	bleq	2c3154 <__bss_end+0x2ba25c>
 458:	0b3a1349 	bleq	e85184 <__bss_end+0xe7c28c>
 45c:	0b390b3b 	bleq	e43150 <__bss_end+0xe3a258>
 460:	00001301 	andeq	r1, r0, r1, lsl #6
 464:	03002809 	movweq	r2, #2057	; 0x809
 468:	000b1c08 	andeq	r1, fp, r8, lsl #24
 46c:	00280a00 	eoreq	r0, r8, r0, lsl #20
 470:	0b1c0e03 	bleq	703c84 <__bss_end+0x6fad8c>
 474:	340b0000 	strcc	r0, [fp], #-0
 478:	3a0e0300 	bcc	381080 <__bss_end+0x378188>
 47c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 480:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 484:	00180219 	andseq	r0, r8, r9, lsl r2
 488:	00020c00 	andeq	r0, r2, r0, lsl #24
 48c:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 490:	0f0d0000 	svceq	0x000d0000
 494:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 498:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 49c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 4a0:	0b3b0b3a 	bleq	ec3190 <__bss_end+0xeba298>
 4a4:	13490b39 	movtne	r0, #39737	; 0x9b39
 4a8:	00000b38 	andeq	r0, r0, r8, lsr fp
 4ac:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 4b0:	00130113 	andseq	r0, r3, r3, lsl r1
 4b4:	00211000 	eoreq	r1, r1, r0
 4b8:	0b2f1349 	bleq	bc51e4 <__bss_end+0xbbc2ec>
 4bc:	02110000 	andseq	r0, r1, #0
 4c0:	0b0e0301 	bleq	3810cc <__bss_end+0x3781d4>
 4c4:	3b0b3a0b 	blcc	2cecf8 <__bss_end+0x2c5e00>
 4c8:	010b390b 	tsteq	fp, fp, lsl #18
 4cc:	12000013 	andne	r0, r0, #19
 4d0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4d4:	0b3a0e03 	bleq	e83ce8 <__bss_end+0xe7adf0>
 4d8:	0b390b3b 	bleq	e431cc <__bss_end+0xe3a2d4>
 4dc:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 4e0:	13011364 	movwne	r1, #4964	; 0x1364
 4e4:	05130000 	ldreq	r0, [r3, #-0]
 4e8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 4ec:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 4f0:	13490005 	movtne	r0, #36869	; 0x9005
 4f4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 4f8:	03193f01 	tsteq	r9, #1, 30
 4fc:	3b0b3a0e 	blcc	2ced3c <__bss_end+0x2c5e44>
 500:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 504:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 508:	01136419 	tsteq	r3, r9, lsl r4
 50c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 510:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 514:	0b3a0e03 	bleq	e83d28 <__bss_end+0xe7ae30>
 518:	0b390b3b 	bleq	e4320c <__bss_end+0xe3a314>
 51c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 520:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 524:	13011364 	movwne	r1, #4964	; 0x1364
 528:	0d170000 	ldceq	0, cr0, [r7, #-0]
 52c:	3a0e0300 	bcc	381134 <__bss_end+0x37823c>
 530:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 534:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 538:	000b320b 	andeq	r3, fp, fp, lsl #4
 53c:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 540:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 544:	0b3b0b3a 	bleq	ec3234 <__bss_end+0xeba33c>
 548:	0e6e0b39 	vmoveq.8	d14[5], r0
 54c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 550:	13011364 	movwne	r1, #4964	; 0x1364
 554:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 558:	03193f01 	tsteq	r9, #1, 30
 55c:	3b0b3a0e 	blcc	2ced9c <__bss_end+0x2c5ea4>
 560:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 564:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 568:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 56c:	1a000013 	bne	5c0 <shift+0x5c0>
 570:	13490115 	movtne	r0, #37141	; 0x9115
 574:	13011364 	movwne	r1, #4964	; 0x1364
 578:	1f1b0000 	svcne	0x001b0000
 57c:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 580:	1c000013 	stcne	0, cr0, [r0], {19}
 584:	0b0b0010 	bleq	2c05cc <__bss_end+0x2b76d4>
 588:	00001349 	andeq	r1, r0, r9, asr #6
 58c:	0b000f1d 	bleq	4208 <shift+0x4208>
 590:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 594:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 598:	0b3b0b3a 	bleq	ec3288 <__bss_end+0xeba390>
 59c:	13490b39 	movtne	r0, #39737	; 0x9b39
 5a0:	00001802 	andeq	r1, r0, r2, lsl #16
 5a4:	3f012e1f 	svccc	0x00012e1f
 5a8:	3a0e0319 	bcc	381214 <__bss_end+0x37831c>
 5ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5b0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5b4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 5b8:	96184006 	ldrls	r4, [r8], -r6
 5bc:	13011942 	movwne	r1, #6466	; 0x1942
 5c0:	05200000 	streq	r0, [r0, #-0]!
 5c4:	3a0e0300 	bcc	3811cc <__bss_end+0x3782d4>
 5c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5cc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 5d0:	21000018 	tstcs	r0, r8, lsl r0
 5d4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5d8:	0b3a0e03 	bleq	e83dec <__bss_end+0xe7aef4>
 5dc:	0b390b3b 	bleq	e432d0 <__bss_end+0xe3a3d8>
 5e0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5e4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5e8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 5ec:	00130119 	andseq	r0, r3, r9, lsl r1
 5f0:	00342200 	eorseq	r2, r4, r0, lsl #4
 5f4:	0b3a0803 	bleq	e82608 <__bss_end+0xe79710>
 5f8:	0b390b3b 	bleq	e432ec <__bss_end+0xe3a3f4>
 5fc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 600:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 604:	03193f01 	tsteq	r9, #1, 30
 608:	3b0b3a0e 	blcc	2cee48 <__bss_end+0x2c5f50>
 60c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 610:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 614:	97184006 	ldrls	r4, [r8, -r6]
 618:	13011942 	movwne	r1, #6466	; 0x1942
 61c:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 620:	03193f00 	tsteq	r9, #0, 30
 624:	3b0b3a0e 	blcc	2cee64 <__bss_end+0x2c5f6c>
 628:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 62c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 630:	97184006 	ldrls	r4, [r8, -r6]
 634:	00001942 	andeq	r1, r0, r2, asr #18
 638:	3f012e25 	svccc	0x00012e25
 63c:	3a0e0319 	bcc	3812a8 <__bss_end+0x3783b0>
 640:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 644:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 648:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 64c:	97184006 	ldrls	r4, [r8, -r6]
 650:	00001942 	andeq	r1, r0, r2, asr #18
 654:	01110100 	tsteq	r1, r0, lsl #2
 658:	0b130e25 	bleq	4c3ef4 <__bss_end+0x4baffc>
 65c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 660:	06120111 			; <UNDEFINED> instruction: 0x06120111
 664:	00001710 	andeq	r1, r0, r0, lsl r7
 668:	01013902 	tsteq	r1, r2, lsl #18
 66c:	03000013 	movweq	r0, #19
 670:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 674:	0b3b0b3a 	bleq	ec3364 <__bss_end+0xeba46c>
 678:	13490b39 	movtne	r0, #39737	; 0x9b39
 67c:	0a1c193c 	beq	706b74 <__bss_end+0x6fdc7c>
 680:	3a040000 	bcc	100688 <__bss_end+0xf7790>
 684:	3b0b3a00 	blcc	2cee8c <__bss_end+0x2c5f94>
 688:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 68c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 690:	13490101 	movtne	r0, #37121	; 0x9101
 694:	00001301 	andeq	r1, r0, r1, lsl #6
 698:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
 69c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 6a0:	00260700 	eoreq	r0, r6, r0, lsl #14
 6a4:	00001349 	andeq	r1, r0, r9, asr #6
 6a8:	0b002408 	bleq	96d0 <__bss_end+0x7d8>
 6ac:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6b0:	0900000e 	stmdbeq	r0, {r1, r2, r3}
 6b4:	13470034 	movtne	r0, #28724	; 0x7034
 6b8:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 6bc:	03193f01 	tsteq	r9, #1, 30
 6c0:	3b0b3a0e 	blcc	2cef00 <__bss_end+0x2c6008>
 6c4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6c8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6cc:	97184006 	ldrls	r4, [r8, -r6]
 6d0:	13011942 	movwne	r1, #6466	; 0x1942
 6d4:	050b0000 	streq	r0, [fp, #-0]
 6d8:	3a080300 	bcc	2012e0 <__bss_end+0x1f83e8>
 6dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 6e4:	0c000018 	stceq	0, cr0, [r0], {24}
 6e8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 6ec:	0b3b0b3a 	bleq	ec33dc <__bss_end+0xeba4e4>
 6f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6f4:	00001802 	andeq	r1, r0, r2, lsl #16
 6f8:	11010b0d 	tstne	r1, sp, lsl #22
 6fc:	00061201 	andeq	r1, r6, r1, lsl #4
 700:	00340e00 	eorseq	r0, r4, r0, lsl #28
 704:	0b3a0803 	bleq	e82718 <__bss_end+0xe79820>
 708:	0b390b3b 	bleq	e433fc <__bss_end+0xe3a504>
 70c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 710:	0f0f0000 	svceq	0x000f0000
 714:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 718:	10000013 	andne	r0, r0, r3, lsl r0
 71c:	00000026 	andeq	r0, r0, r6, lsr #32
 720:	0b000f11 	bleq	436c <shift+0x436c>
 724:	1200000b 	andne	r0, r0, #11
 728:	0b0b0024 	bleq	2c07c0 <__bss_end+0x2b78c8>
 72c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 730:	05130000 	ldreq	r0, [r3, #-0]
 734:	3a0e0300 	bcc	38133c <__bss_end+0x378444>
 738:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 73c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 740:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 744:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 748:	0b3a0e03 	bleq	e83f5c <__bss_end+0xe7b064>
 74c:	0b390b3b 	bleq	e43440 <__bss_end+0xe3a548>
 750:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 754:	06120111 			; <UNDEFINED> instruction: 0x06120111
 758:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 75c:	00130119 	andseq	r0, r3, r9, lsl r1
 760:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 764:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 768:	0b3b0b3a 	bleq	ec3458 <__bss_end+0xeba560>
 76c:	0e6e0b39 	vmoveq.8	d14[5], r0
 770:	06120111 			; <UNDEFINED> instruction: 0x06120111
 774:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 778:	00000019 	andeq	r0, r0, r9, lsl r0
 77c:	10001101 	andne	r1, r0, r1, lsl #2
 780:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 784:	1b0e0301 	blne	381390 <__bss_end+0x378498>
 788:	130e250e 	movwne	r2, #58638	; 0xe50e
 78c:	00000005 	andeq	r0, r0, r5
 790:	10001101 	andne	r1, r0, r1, lsl #2
 794:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 798:	1b0e0301 	blne	3813a4 <__bss_end+0x3784ac>
 79c:	130e250e 	movwne	r2, #58638	; 0xe50e
 7a0:	00000005 	andeq	r0, r0, r5
 7a4:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 7a8:	030b130e 	movweq	r1, #45838	; 0xb30e
 7ac:	100e1b0e 	andne	r1, lr, lr, lsl #22
 7b0:	02000017 	andeq	r0, r0, #23
 7b4:	0b0b0024 	bleq	2c084c <__bss_end+0x2b7954>
 7b8:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 7bc:	24030000 	strcs	r0, [r3], #-0
 7c0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7c4:	000e030b 	andeq	r0, lr, fp, lsl #6
 7c8:	01040400 	tsteq	r4, r0, lsl #8
 7cc:	0b3e0e03 	bleq	f83fe0 <__bss_end+0xf7b0e8>
 7d0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7d4:	0b3b0b3a 	bleq	ec34c4 <__bss_end+0xeba5cc>
 7d8:	13010b39 	movwne	r0, #6969	; 0x1b39
 7dc:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 7e0:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 7e4:	0600000b 	streq	r0, [r0], -fp
 7e8:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 7ec:	0b3a0b0b 	bleq	e83420 <__bss_end+0xe7a528>
 7f0:	0b39053b 	bleq	e41ce4 <__bss_end+0xe38dec>
 7f4:	00001301 	andeq	r1, r0, r1, lsl #6
 7f8:	03000d07 	movweq	r0, #3335	; 0xd07
 7fc:	3b0b3a0e 	blcc	2cf03c <__bss_end+0x2c6144>
 800:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 804:	000b3813 	andeq	r3, fp, r3, lsl r8
 808:	00260800 	eoreq	r0, r6, r0, lsl #16
 80c:	00001349 	andeq	r1, r0, r9, asr #6
 810:	49010109 	stmdbmi	r1, {r0, r3, r8}
 814:	00130113 	andseq	r0, r3, r3, lsl r1
 818:	00210a00 	eoreq	r0, r1, r0, lsl #20
 81c:	0b2f1349 	bleq	bc5548 <__bss_end+0xbbc650>
 820:	340b0000 	strcc	r0, [fp], #-0
 824:	3a0e0300 	bcc	38142c <__bss_end+0x378534>
 828:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 82c:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 830:	0c00000a 	stceq	0, cr0, [r0], {10}
 834:	19270015 	stmdbne	r7!, {r0, r2, r4}
 838:	0f0d0000 	svceq	0x000d0000
 83c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 840:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 844:	0e030104 	adfeqs	f0, f3, f4
 848:	0b0b0b3e 	bleq	2c3548 <__bss_end+0x2ba650>
 84c:	0b3a1349 	bleq	e85578 <__bss_end+0xe7c680>
 850:	0b39053b 	bleq	e41d44 <__bss_end+0xe38e4c>
 854:	00001301 	andeq	r1, r0, r1, lsl #6
 858:	0300160f 	movweq	r1, #1551	; 0x60f
 85c:	3b0b3a0e 	blcc	2cf09c <__bss_end+0x2c61a4>
 860:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 864:	10000013 	andne	r0, r0, r3, lsl r0
 868:	00000021 	andeq	r0, r0, r1, lsr #32
 86c:	03003411 	movweq	r3, #1041	; 0x411
 870:	3b0b3a0e 	blcc	2cf0b0 <__bss_end+0x2c61b8>
 874:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 878:	3c193f13 	ldccc	15, cr3, [r9], {19}
 87c:	12000019 	andne	r0, r0, #25
 880:	13470034 	movtne	r0, #28724	; 0x7034
 884:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 888:	13490b39 	movtne	r0, #39737	; 0x9b39
 88c:	00001802 	andeq	r1, r0, r2, lsl #16
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
  74:	000000cc 	andeq	r0, r0, ip, asr #1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0aef0002 	beq	ffbc0094 <__bss_end+0xffbb719c>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000082f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	16120002 	ldrne	r0, [r2], -r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008754 	andeq	r8, r0, r4, asr r7
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	19440002 	stmdbne	r4, {r1}^
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c0c 	andeq	r8, r0, ip, lsl #24
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	196a0002 	stmdbne	sl!, {r1}^
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008e18 	andeq	r8, r0, r8, lsl lr
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	19900002 	ldmibne	r0, {r1}
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	552f632f 	strpl	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff6de5>
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
      44:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe80 <__bss_end+0xffff6f88>
      48:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      4c:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
      50:	4b2f7372 	blmi	bdce20 <__bss_end+0xbd3f28>
      54:	2f616275 	svccs	0x00616275
      58:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
      5c:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
      60:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
      64:	614d6f72 	hvcvs	55026	; 0xd6f2
      68:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffafc <__bss_end+0xffff6c04>
      6c:	706d6178 	rsbvc	r6, sp, r8, ror r1
      70:	2f73656c 	svccs	0x0073656c
      74:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
      78:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffa1c <__bss_end+0xffff6b24>
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
     114:	2b6b7a36 	blcs	1ade9f4 <__bss_end+0x1ad5afc>
     118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     11c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     120:	304f2d20 	subcc	r2, pc, r0, lsr #26
     124:	304f2d20 	subcc	r2, pc, r0, lsr #26
     128:	625f5f00 	subsvs	r5, pc, #0, 30
     12c:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffdc1 <__bss_end+0xffff6ec9>
     130:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     134:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     138:	6d2f0074 	stcvs	0, cr0, [pc, #-464]!	; ffffff70 <__bss_end+0xffff7078>
     13c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     140:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
     144:	4b2f7372 	blmi	bdcf14 <__bss_end+0xbd401c>
     148:	2f616275 	svccs	0x00616275
     14c:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     150:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     154:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     158:	614d6f72 	hvcvs	55026	; 0xd6f2
     15c:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffbf0 <__bss_end+0xffff6cf8>
     160:	706d6178 	rsbvc	r6, sp, r8, ror r1
     164:	2f73656c 	svccs	0x0073656c
     168:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     16c:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffb10 <__bss_end+0xffff6c18>
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
     21c:	4b2f7372 	blmi	bdcfec <__bss_end+0xbd40f4>
     220:	2f616275 	svccs	0x00616275
     224:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
     228:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     22c:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
     230:	614d6f72 	hvcvs	55026	; 0xd6f2
     234:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffcc8 <__bss_end+0xffff6dd0>
     238:	706d6178 	rsbvc	r6, sp, r8, ror r1
     23c:	2f73656c 	svccs	0x0073656c
     240:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
     244:	752f6664 	strvc	r6, [pc, #-1636]!	; fffffbe8 <__bss_end+0xffff6cf0>
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
     3e0:	6b636f6c 	blvs	18dc198 <__bss_end+0x18d32a0>
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
     430:	6e550074 	mrcvs	0, 2, r0, cr5, cr4, {3}
     434:	5f70616d 	svcpl	0x0070616d
     438:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     43c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     440:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     444:	43534200 	cmpmi	r3, #0, 4
     448:	61425f32 	cmpvs	r2, r2, lsr pc
     44c:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
     450:	636f7250 	cmnvs	pc, #80, 4
     454:	5f737365 	svcpl	0x00737365
     458:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     45c:	6165485f 	cmnvs	r5, pc, asr r8
     460:	5a5f0064 	bpl	17c05f8 <__bss_end+0x17b7700>
     464:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     468:	6f725043 	svcvs	0x00725043
     46c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     470:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     474:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     478:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     47c:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     480:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     484:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     488:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     48c:	00764573 	rsbseq	r4, r6, r3, ror r5
     490:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     494:	646c6f00 	strbtvs	r6, [ip], #-3840	; 0xfffff100
     498:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     49c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     4a0:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4a8:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4ac:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     4b0:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     4b4:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     4b8:	00657361 	rsbeq	r7, r5, r1, ror #6
     4bc:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     4c0:	6f72505f 	svcvs	0x0072505f
     4c4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4c8:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     4cc:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     4d0:	61655200 	cmnvs	r5, r0, lsl #4
     4d4:	63410064 	movtvs	r0, #4196	; 0x1064
     4d8:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     4dc:	6f72505f 	svcvs	0x0072505f
     4e0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4e4:	756f435f 	strbvc	r4, [pc, #-863]!	; 18d <shift+0x18d>
     4e8:	4300746e 	movwmi	r7, #1134	; 0x46e
     4ec:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     4f0:	72505f65 	subsvc	r5, r0, #404	; 0x194
     4f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4f8:	614d0073 	hvcvs	53251	; 0xd003
     4fc:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     500:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     504:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     508:	00687467 	rsbeq	r7, r8, r7, ror #8
     50c:	5f585541 	svcpl	0x00585541
     510:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     514:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     518:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     51c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     520:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     524:	006f666e 	rsbeq	r6, pc, lr, ror #12
     528:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     52c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     530:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     534:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     538:	43006465 	movwmi	r6, #1125	; 0x465
     53c:	636f7250 	cmnvs	pc, #80, 4
     540:	5f737365 	svcpl	0x00737365
     544:	616e614d 	cmnvs	lr, sp, asr #2
     548:	00726567 	rsbseq	r6, r2, r7, ror #10
     54c:	314e5a5f 	cmpcc	lr, pc, asr sl
     550:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     554:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     558:	614d5f73 	hvcvs	54771	; 0xd5f3
     55c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     560:	47383172 			; <UNDEFINED> instruction: 0x47383172
     564:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     568:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     56c:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     570:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     574:	3032456f 	eorscc	r4, r2, pc, ror #10
     578:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     57c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     580:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     584:	5f6f666e 	svcpl	0x006f666e
     588:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     58c:	2f007650 	svccs	0x00007650
     590:	2f746e6d 	svccs	0x00746e6d
     594:	73552f63 	cmpvc	r5, #396	; 0x18c
     598:	2f737265 	svccs	0x00737265
     59c:	6162754b 	cmnvs	r2, fp, asr #10
     5a0:	636f442f 	cmnvs	pc, #788529152	; 0x2f000000
     5a4:	6e656d75 	mcrvs	13, 3, r6, cr5, cr5, {3}
     5a8:	5a2f7374 	bpl	bdd380 <__bss_end+0xbd4488>
     5ac:	4d6f7265 	sfmmi	f7, 2, [pc, #-404]!	; 420 <shift+0x420>
     5b0:	2f657461 	svccs	0x00657461
     5b4:	6d617865 	stclvs	8, cr7, [r1, #-404]!	; 0xfffffe6c
     5b8:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     5bc:	2d38312f 	ldfcss	f3, [r8, #-188]!	; 0xffffff44
     5c0:	2f666465 	svccs	0x00666465
     5c4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     5c8:	63617073 	cmnvs	r1, #115	; 0x73
     5cc:	69742f65 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     5d0:	745f746c 	ldrbvc	r7, [pc], #-1132	; 5d8 <shift+0x5d8>
     5d4:	2f6b7361 	svccs	0x006b7361
     5d8:	6e69616d 	powvsez	f6, f1, #5.0
     5dc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     5e0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5e4:	50433631 	subpl	r3, r3, r1, lsr r6
     5e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5ec:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 428 <shift+0x428>
     5f0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5f4:	31327265 	teqcc	r2, r5, ror #4
     5f8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5fc:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     600:	73656c69 	cmnvc	r5, #26880	; 0x6900
     604:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     608:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     60c:	33324549 	teqcc	r2, #306184192	; 0x12400000
     610:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     614:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     618:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     61c:	5f6d6574 	svcpl	0x006d6574
     620:	76726553 			; <UNDEFINED> instruction: 0x76726553
     624:	6a656369 	bvs	19593d0 <__bss_end+0x19504d8>
     628:	31526a6a 	cmpcc	r2, sl, ror #20
     62c:	57535431 	smmlarpl	r3, r1, r4, r5
     630:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     634:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     638:	6c614600 	stclvs	6, cr4, [r1], #-0
     63c:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     640:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     644:	706f0065 	rsbvc	r0, pc, r5, rrx
     648:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     64c:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     650:	4e007365 	cdpmi	3, 0, cr7, cr0, cr5, {3}
     654:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     658:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     65c:	50435400 	subpl	r5, r3, r0, lsl #8
     660:	6f435f55 	svcvs	0x00435f55
     664:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     668:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
     66c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     670:	7400656e 	strvc	r6, [r0], #-1390	; 0xfffffa92
     674:	30726274 	rsbscc	r6, r2, r4, ror r2
     678:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     67c:	50433631 	subpl	r3, r3, r1, lsr r6
     680:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     684:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4c0 <shift+0x4c0>
     688:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     68c:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     690:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     694:	505f7966 	subspl	r7, pc, r6, ror #18
     698:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     69c:	6a457373 	bvs	115d470 <__bss_end+0x1154578>
     6a0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     6a4:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     6a8:	43534200 	cmpmi	r3, #0, 4
     6ac:	61425f30 	cmpvs	r2, r0, lsr pc
     6b0:	6e006573 	cfrshl64vs	mvdx0, mvdx3, r6
     6b4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     6b8:	5f646569 	svcpl	0x00646569
     6bc:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     6c0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     6c4:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     6c8:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     6cc:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     6d0:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     6d4:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     6d8:	61425f72 	hvcvs	9714	; 0x25f2
     6dc:	42006573 	andmi	r6, r0, #482344960	; 0x1cc00000
     6e0:	5f314353 	svcpl	0x00314353
     6e4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     6e8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     6ec:	6f72505f 	svcvs	0x0072505f
     6f0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6f4:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     6f8:	5f64656e 	svcpl	0x0064656e
     6fc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     700:	5a5f0073 	bpl	17c08d4 <__bss_end+0x17b79dc>
     704:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     708:	636f7250 	cmnvs	pc, #80, 4
     70c:	5f737365 	svcpl	0x00737365
     710:	616e614d 	cmnvs	lr, sp, asr #2
     714:	31726567 	cmncc	r2, r7, ror #10
     718:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     71c:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     720:	5f656c69 	svcpl	0x00656c69
     724:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     728:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     72c:	5254006a 	subspl	r0, r4, #106	; 0x6a
     730:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     734:	00657361 	rsbeq	r7, r5, r1, ror #6
     738:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     73c:	73695200 	cmnvc	r9, #0, 4
     740:	5f676e69 	svcpl	0x00676e69
     744:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     748:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     74c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     750:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     754:	6f72505f 	svcvs	0x0072505f
     758:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     75c:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     760:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     764:	6f545f65 	svcvs	0x00545f65
     768:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     76c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     770:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     774:	73656c69 	cmnvc	r5, #26880	; 0x6900
     778:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     77c:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     780:	00726576 	rsbseq	r6, r2, r6, ror r5
     784:	5f746553 	svcpl	0x00746553
     788:	61726150 	cmnvs	r2, r0, asr r1
     78c:	4800736d 	stmdami	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp, lr}
     790:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     794:	72505f65 	subsvc	r5, r0, #404	; 0x194
     798:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     79c:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     7a0:	68730049 	ldmdavs	r3!, {r0, r3, r6}^
     7a4:	2074726f 	rsbscs	r7, r4, pc, ror #4
     7a8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     7ac:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     7b0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     7b4:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     7b8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     7bc:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     7c0:	61570046 	cmpvs	r7, r6, asr #32
     7c4:	44007469 	strmi	r7, [r0], #-1129	; 0xfffffb97
     7c8:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     7cc:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 268 <shift+0x268>
     7d0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     7d4:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     7d8:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     7dc:	49006e6f 	stmdbmi	r0, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}
     7e0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     7e4:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     7e8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     7ec:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
     7f0:	62007065 	andvs	r7, r0, #101	; 0x65
     7f4:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     7f8:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     7fc:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     800:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     804:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     808:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     80c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     810:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     814:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     818:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     81c:	52006570 	andpl	r6, r0, #112, 10	; 0x1c000000
     820:	616e6e75 	smcvs	59109	; 0xe6e5
     824:	00656c62 	rsbeq	r6, r5, r2, ror #24
     828:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     82c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     830:	00657461 	rsbeq	r7, r5, r1, ror #8
     834:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     838:	6f635f64 	svcvs	0x00635f64
     83c:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     840:	63730072 	cmnvs	r3, #114	; 0x72
     844:	5f646568 	svcpl	0x00646568
     848:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     84c:	705f6369 	subsvc	r6, pc, r9, ror #6
     850:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     854:	00797469 	rsbseq	r7, r9, r9, ror #8
     858:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     85c:	646f635f 	strbtvs	r6, [pc], #-863	; 864 <shift+0x864>
     860:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     864:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     868:	69505f64 	ldmdbvs	r0, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     86c:	536d006e 	cmnpl	sp, #110	; 0x6e
     870:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     874:	5f656c75 	svcpl	0x00656c75
     878:	00636e46 	rsbeq	r6, r3, r6, asr #28
     87c:	4f495047 	svcmi	0x00495047
     880:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     884:	614d0065 	cmpvs	sp, r5, rrx
     888:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     88c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     890:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     894:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     898:	00687467 	rsbeq	r7, r8, r7, ror #8
     89c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     8a0:	44007966 	strmi	r7, [r0], #-2406	; 0xfffff69a
     8a4:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
     8a8:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     8ac:	6b636f6c 	blvs	18dc664 <__bss_end+0x18d376c>
     8b0:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     8b4:	6f4c0065 	svcvs	0x004c0065
     8b8:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; fffffd5d <__bss_end+0xffff6e65>
     8bc:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     8c0:	0064656b 	rsbeq	r6, r4, fp, ror #10
     8c4:	6b636f4c 	blvs	18dc5fc <__bss_end+0x18d3704>
     8c8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     8cc:	0064656b 	rsbeq	r6, r4, fp, ror #10
     8d0:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     8d4:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     8d8:	5a006574 	bpl	19eb0 <__bss_end+0x10fb8>
     8dc:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     8e0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     8e4:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     8e8:	5f646568 	svcpl	0x00646568
     8ec:	6f666e49 	svcvs	0x00666e49
     8f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8f4:	50433631 	subpl	r3, r3, r1, lsr r6
     8f8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8fc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 738 <shift+0x738>
     900:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     904:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     908:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     90c:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     910:	5a5f0076 	bpl	17c0af0 <__bss_end+0x17b7bf8>
     914:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     918:	636f7250 	cmnvs	pc, #80, 4
     91c:	5f737365 	svcpl	0x00737365
     920:	616e614d 	cmnvs	lr, sp, asr #2
     924:	31726567 	cmncc	r2, r7, ror #10
     928:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     92c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     930:	6f545f65 	svcvs	0x00545f65
     934:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     938:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     93c:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     940:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     944:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     948:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     94c:	00736d61 	rsbseq	r6, r3, r1, ror #26
     950:	5078614d 	rsbspl	r6, r8, sp, asr #2
     954:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     958:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     95c:	6e750068 	cdpvs	0, 7, cr0, cr5, cr8, {3}
     960:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     964:	63206465 			; <UNDEFINED> instruction: 0x63206465
     968:	00726168 	rsbseq	r6, r2, r8, ror #2
     96c:	314e5a5f 	cmpcc	lr, pc, asr sl
     970:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     974:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     978:	614d5f73 	hvcvs	54771	; 0xd5f3
     97c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     980:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     984:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     988:	5f656c75 	svcpl	0x00656c75
     98c:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     990:	50470076 	subpl	r0, r7, r6, ror r0
     994:	505f4f49 	subspl	r4, pc, r9, asr #30
     998:	435f6e69 	cmpmi	pc, #1680	; 0x690
     99c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     9a0:	6f687300 	svcvs	0x00687300
     9a4:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     9a8:	4500746e 	strmi	r7, [r0, #-1134]	; 0xfffffb92
     9ac:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     9b0:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     9b4:	5f746e65 	svcpl	0x00746e65
     9b8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     9bc:	6f697463 	svcvs	0x00697463
     9c0:	6550006e 	ldrbvs	r0, [r0, #-110]	; 0xffffff92
     9c4:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     9c8:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     9cc:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     9d0:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     9d4:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     9d8:	69740067 	ldmdbvs	r4!, {r0, r1, r2, r5, r6}^
     9dc:	6573746c 	ldrbvs	r7, [r3, #-1132]!	; 0xfffffb94
     9e0:	726f736e 	rsbvc	r7, pc, #-1207959551	; 0xb8000001
     9e4:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     9e8:	69750065 	ldmdbvs	r5!, {r0, r2, r5, r6}^
     9ec:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     9f0:	4e00745f 	cfmvsrmi	mvf0, r7
     9f4:	4f495047 	svcmi	0x00495047
     9f8:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     9fc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     a00:	545f7470 	ldrbpl	r7, [pc], #-1136	; a08 <shift+0xa08>
     a04:	00657079 	rsbeq	r7, r5, r9, ror r0
     a08:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     a0c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     a10:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     a14:	6f4e5f6b 	svcvs	0x004e5f6b
     a18:	63006564 	movwvs	r6, #1380	; 0x564
     a1c:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     a20:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     a24:	52007478 	andpl	r7, r0, #120, 8	; 0x78000000
     a28:	5f646165 	svcpl	0x00646165
     a2c:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     a30:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     a34:	745f7065 	ldrbvc	r7, [pc], #-101	; a3c <shift+0xa3c>
     a38:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     a3c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a40:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     a44:	636f7250 	cmnvs	pc, #80, 4
     a48:	5f737365 	svcpl	0x00737365
     a4c:	616e614d 	cmnvs	lr, sp, asr #2
     a50:	31726567 	cmncc	r2, r7, ror #10
     a54:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     a58:	6f72505f 	svcvs	0x0072505f
     a5c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a60:	5f79425f 	svcpl	0x0079425f
     a64:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     a68:	6148006a 	cmpvs	r8, sl, rrx
     a6c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a70:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     a74:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a78:	5f6d6574 	svcpl	0x006d6574
     a7c:	00495753 	subeq	r5, r9, r3, asr r7
     a80:	314e5a5f 	cmpcc	lr, pc, asr sl
     a84:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     a88:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a8c:	614d5f73 	hvcvs	54771	; 0xd5f3
     a90:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     a94:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     a98:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a9c:	5f656c75 	svcpl	0x00656c75
     aa0:	76455252 			; <UNDEFINED> instruction: 0x76455252
     aa4:	73617400 	cmnvc	r1, #0, 8
     aa8:	7269006b 	rsbvc	r0, r9, #107	; 0x6b
     aac:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     ab0:	746f4e00 	strbtvc	r4, [pc], #-3584	; ab8 <shift+0xab8>
     ab4:	5f796669 	svcpl	0x00796669
     ab8:	636f7250 	cmnvs	pc, #80, 4
     abc:	00737365 	rsbseq	r7, r3, r5, ror #6
     ac0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ac4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     ac8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     acc:	50433631 	subpl	r3, r3, r1, lsr r6
     ad0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ad4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 910 <shift+0x910>
     ad8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     adc:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     ae0:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     ae4:	6f545f68 	svcvs	0x00545f68
     ae8:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     aec:	6f725043 	svcvs	0x00725043
     af0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     af4:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     af8:	6f4e5f74 	svcvs	0x004e5f74
     afc:	53006564 	movwpl	r6, #1380	; 0x564
     b00:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b04:	5f656c75 	svcpl	0x00656c75
     b08:	5f005252 	svcpl	0x00005252
     b0c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b10:	6f725043 	svcvs	0x00725043
     b14:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b18:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b1c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b20:	61483831 	cmpvs	r8, r1, lsr r8
     b24:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     b28:	6f72505f 	svcvs	0x0072505f
     b2c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b30:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b34:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     b38:	5f495753 	svcpl	0x00495753
     b3c:	636f7250 	cmnvs	pc, #80, 4
     b40:	5f737365 	svcpl	0x00737365
     b44:	76726553 			; <UNDEFINED> instruction: 0x76726553
     b48:	6a656369 	bvs	19598f4 <__bss_end+0x19509fc>
     b4c:	31526a6a 	cmpcc	r2, sl, ror #20
     b50:	57535431 	smmlarpl	r3, r1, r4, r5
     b54:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     b58:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     b5c:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     b60:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
     b64:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     b68:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     b6c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     b70:	5f006e6f 	svcpl	0x00006e6f
     b74:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b78:	6f725043 	svcvs	0x00725043
     b7c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b80:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b84:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b88:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     b8c:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     b90:	6f72505f 	svcvs	0x0072505f
     b94:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b98:	6a685045 	bvs	1a14cb4 <__bss_end+0x1a0bdbc>
     b9c:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     ba0:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     ba4:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     ba8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     bac:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     bb0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     bb4:	5f6d6574 	svcpl	0x006d6574
     bb8:	76726553 			; <UNDEFINED> instruction: 0x76726553
     bbc:	00656369 	rsbeq	r6, r5, r9, ror #6
     bc0:	61766e49 	cmnvs	r6, r9, asr #28
     bc4:	5f64696c 	svcpl	0x0064696c
     bc8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     bcc:	4200656c 	andmi	r6, r0, #108, 10	; 0x1b000000
     bd0:	6b636f6c 	blvs	18dc988 <__bss_end+0x18d3a90>
     bd4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     bd8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     bdc:	6f72505f 	svcvs	0x0072505f
     be0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     be4:	6f6c4300 	svcvs	0x006c4300
     be8:	61006573 	tstvs	r0, r3, ror r5
     bec:	00636772 	rsbeq	r6, r3, r2, ror r7
     bf0:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     bf4:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     bf8:	5900796c 	stmdbpl	r0, {r2, r3, r5, r6, r8, fp, ip, sp, lr}
     bfc:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     c00:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c04:	50433631 	subpl	r3, r3, r1, lsr r6
     c08:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c0c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a48 <shift+0xa48>
     c10:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c14:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     c18:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     c1c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     c20:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     c24:	434f4900 	movtmi	r4, #63744	; 0xf900
     c28:	6c006c74 	stcvs	12, cr6, [r0], {116}	; 0x74
     c2c:	6970676f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     c30:	63006570 	movwvs	r6, #1392	; 0x570
     c34:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     c38:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     c3c:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     c40:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     c44:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     c48:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
     c4c:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
     c50:	64720072 	ldrbtvs	r0, [r2], #-114	; 0xffffff8e
     c54:	006d756e 	rsbeq	r7, sp, lr, ror #10
     c58:	31315a5f 	teqcc	r1, pc, asr sl
     c5c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     c60:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     c64:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     c68:	315a5f00 	cmpcc	sl, r0, lsl #30
     c6c:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
     c70:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     c74:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     c78:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     c7c:	006a656e 	rsbeq	r6, sl, lr, ror #10
     c80:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     c84:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     c88:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     c8c:	6a6a7966 	bvs	1a9f22c <__bss_end+0x1a96334>
     c90:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     c94:	2f632f74 	svccs	0x00632f74
     c98:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     c9c:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     ca0:	442f6162 	strtmi	r6, [pc], #-354	; ca8 <shift+0xca8>
     ca4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     ca8:	73746e65 	cmnvc	r4, #1616	; 0x650
     cac:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     cb0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     cb4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     cb8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     cbc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     cc0:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
     cc4:	74732f66 	ldrbtvc	r2, [r3], #-3942	; 0xfffff09a
     cc8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     ccc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     cd0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     cd4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     cd8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     cdc:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     ce0:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
     ce4:	6f637469 	svcvs	0x00637469
     ce8:	73006564 	movwvc	r6, #1380	; 0x564
     cec:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     cf0:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     cf4:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     cf8:	5f6b6369 	svcpl	0x006b6369
     cfc:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     d00:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     d04:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     d08:	5f006465 	svcpl	0x00006465
     d0c:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     d10:	615f7465 	cmpvs	pc, r5, ror #8
     d14:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     d18:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     d1c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d20:	6f635f73 	svcvs	0x00635f73
     d24:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     d28:	70695000 	rsbvc	r5, r9, r0
     d2c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d30:	505f656c 	subspl	r6, pc, ip, ror #10
     d34:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     d38:	5a5f0078 	bpl	17c0f20 <__bss_end+0x17b8028>
     d3c:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
     d40:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d44:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     d48:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     d4c:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
     d50:	00706565 	rsbseq	r6, r0, r5, ror #10
     d54:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
     d58:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     d5c:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     d60:	706f0069 	rsbvc	r0, pc, r9, rrx
     d64:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     d68:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     d6c:	63355a5f 	teqvs	r5, #389120	; 0x5f000
     d70:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     d74:	5a5f006a 	bpl	17c0f24 <__bss_end+0x17b802c>
     d78:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     d7c:	76646970 			; <UNDEFINED> instruction: 0x76646970
     d80:	616e6600 	cmnvs	lr, r0, lsl #12
     d84:	4700656d 	strmi	r6, [r0, -sp, ror #10]
     d88:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     d8c:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     d90:	2e303120 	rsfcssp	f3, f0, f0
     d94:	20312e33 	eorscs	r2, r1, r3, lsr lr
     d98:	31323032 	teqcc	r2, r2, lsr r0
     d9c:	31323630 	teqcc	r2, r0, lsr r6
     da0:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     da4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     da8:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
     dac:	6f6c666d 	svcvs	0x006c666d
     db0:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     db4:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     db8:	20647261 	rsbcs	r7, r4, r1, ror #4
     dbc:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     dc0:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     dc4:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     dc8:	616f6c66 	cmnvs	pc, r6, ror #24
     dcc:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     dd0:	61683d69 	cmnvs	r8, r9, ror #26
     dd4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     dd8:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     ddc:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     de0:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     de4:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     de8:	316d7261 	cmncc	sp, r1, ror #4
     dec:	6a363731 	bvs	d8eab8 <__bss_end+0xd85bc0>
     df0:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     df4:	616d2d20 	cmnvs	sp, r0, lsr #26
     df8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     dfc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     e00:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     e04:	7a36766d 	bvc	d9e7c0 <__bss_end+0xd958c8>
     e08:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     e0c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     e10:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     e14:	4f2d2067 	svcmi	0x002d2067
     e18:	4f2d2030 	svcmi	0x002d2030
     e1c:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
     e20:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
     e24:	70656378 	rsbvc	r6, r5, r8, ror r3
     e28:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e2c:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
     e30:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
     e34:	00697474 	rsbeq	r7, r9, r4, ror r4
     e38:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     e3c:	69740065 	ldmdbvs	r4!, {r0, r2, r5, r6}^
     e40:	00736b63 	rsbseq	r6, r3, r3, ror #22
     e44:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     e48:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     e4c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     e50:	6a634b50 	bvs	18d3b98 <__bss_end+0x18caca0>
     e54:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
     e58:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     e5c:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
     e60:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
     e64:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     e68:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
     e6c:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     e70:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     e74:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     e78:	72617000 	rsbvc	r7, r1, #0
     e7c:	5f006d61 	svcpl	0x00006d61
     e80:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
     e84:	6a657469 	bvs	195e030 <__bss_end+0x1955138>
     e88:	6a634b50 	bvs	18d3bd0 <__bss_end+0x18cacd8>
     e8c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     e90:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     e94:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     e98:	5f736b63 	svcpl	0x00736b63
     e9c:	645f6f74 	ldrbvs	r6, [pc], #-3956	; ea4 <shift+0xea4>
     ea0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     ea4:	00656e69 	rsbeq	r6, r5, r9, ror #28
     ea8:	5f667562 	svcpl	0x00667562
     eac:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
     eb0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     eb4:	2f632f74 	svccs	0x00632f74
     eb8:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     ebc:	754b2f73 	strbvc	r2, [fp, #-3955]	; 0xfffff08d
     ec0:	442f6162 	strtmi	r6, [pc], #-354	; ec8 <shift+0xec8>
     ec4:	6d75636f 	ldclvs	3, cr6, [r5, #-444]!	; 0xfffffe44
     ec8:	73746e65 	cmnvc	r4, #1616	; 0x650
     ecc:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
     ed0:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
     ed4:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     ed8:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     edc:	312f7365 			; <UNDEFINED> instruction: 0x312f7365
     ee0:	64652d38 	strbtvs	r2, [r5], #-3384	; 0xfffff2c8
     ee4:	75622f66 	strbvc	r2, [r2, #-3942]!	; 0xfffff09a
     ee8:	00646c69 	rsbeq	r6, r4, r9, ror #24
     eec:	5f746573 	svcpl	0x00746573
     ef0:	6b736174 	blvs	1cd94c8 <__bss_end+0x1cd05d0>
     ef4:	6165645f 	cmnvs	r5, pc, asr r4
     ef8:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     efc:	5a5f0065 	bpl	17c1098 <__bss_end+0x17b81a0>
     f00:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     f04:	6a6a7065 	bvs	1a9d0a0 <__bss_end+0x1a941a8>
     f08:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f0c:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
     f10:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
     f14:	5f00676e 	svcpl	0x0000676e
     f18:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     f1c:	745f7465 	ldrbvc	r7, [pc], #-1125	; f24 <shift+0xf24>
     f20:	5f6b7361 	svcpl	0x006b7361
     f24:	6b636974 	blvs	18db4fc <__bss_end+0x18d2604>
     f28:	6f745f73 	svcvs	0x00745f73
     f2c:	6165645f 	cmnvs	r5, pc, asr r4
     f30:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     f34:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     f38:	5f495753 	svcpl	0x00495753
     f3c:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     f40:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     f44:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f48:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
     f4c:	5a5f006d 	bpl	17c1108 <__bss_end+0x17b8210>
     f50:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     f54:	6a6a6a74 	bvs	1a9b92c <__bss_end+0x1a92a34>
     f58:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f5c:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     f60:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
     f64:	434f494e 	movtmi	r4, #63822	; 0xf94e
     f68:	4f5f6c74 	svcmi	0x005f6c74
     f6c:	61726570 	cmnvs	r2, r0, ror r5
     f70:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f74:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
     f78:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     f7c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     f80:	00746e63 	rsbseq	r6, r4, r3, ror #28
     f84:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     f88:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
     f8c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f90:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     f94:	646f6d00 	strbtvs	r6, [pc], #-3328	; f9c <shift+0xf9c>
     f98:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     f9c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     fa0:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     fa4:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     fa8:	6a63506a 	bvs	18d5158 <__bss_end+0x18cc260>
     fac:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     fb0:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     fb4:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     fb8:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     fbc:	5f657669 	svcpl	0x00657669
     fc0:	636f7270 	cmnvs	pc, #112, 4
     fc4:	5f737365 	svcpl	0x00737365
     fc8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     fcc:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
     fd0:	616e656c 	cmnvs	lr, ip, ror #10
     fd4:	7200656d 	andvc	r6, r0, #457179136	; 0x1b400000
     fd8:	00646165 	rsbeq	r6, r4, r5, ror #2
     fdc:	70746567 	rsbsvc	r6, r4, r7, ror #10
     fe0:	5f006469 	svcpl	0x00006469
     fe4:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
     fe8:	4b506e65 	blmi	141c984 <__bss_end+0x1413a8c>
     fec:	4e353163 	rsfmisz	f3, f5, f3
     ff0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ff4:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     ff8:	6f4d5f6e 	svcvs	0x004d5f6e
     ffc:	69006564 	stmdbvs	r0, {r2, r5, r6, r8, sl, sp, lr}
    1000:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1004:	73656400 	cmnvc	r5, #0, 8
    1008:	7a620074 	bvc	18811e0 <__bss_end+0x18782e8>
    100c:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1010:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    1014:	5f006874 	svcpl	0x00006874
    1018:	7a62355a 	bvc	188e588 <__bss_end+0x1885690>
    101c:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1020:	73006976 	movwvc	r6, #2422	; 0x976
    1024:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1028:	5f007970 	svcpl	0x00007970
    102c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1030:	4b50696f 	blmi	141b5f4 <__bss_end+0x14126fc>
    1034:	68430063 	stmdavs	r3, {r0, r1, r5, r6}^
    1038:	6f437261 	svcvs	0x00437261
    103c:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1040:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    1044:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    1048:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    104c:	00747570 	rsbseq	r7, r4, r0, ror r5
    1050:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    1054:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1058:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    105c:	00697650 	rsbeq	r7, r9, r0, asr r6
    1060:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1064:	73007970 	movwvc	r7, #2416	; 0x970
    1068:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    106c:	5a5f006e 	bpl	17c122c <__bss_end+0x17b8334>
    1070:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1074:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1078:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    107c:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    1080:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1084:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1088:	634b506e 	movtvs	r5, #45166	; 0xb06e
    108c:	6f746100 	svcvs	0x00746100
    1090:	5a5f0069 	bpl	17c123c <__bss_end+0x17b8344>
    1094:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1098:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    109c:	4b506350 	blmi	1419de4 <__bss_end+0x1410eec>
    10a0:	73006963 	movwvc	r6, #2403	; 0x963
    10a4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    10a8:	6d00706d 	stcvs	0, cr7, [r0, #-436]	; 0xfffffe4c
    10ac:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    10b0:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    10b4:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    10b8:	6f746900 	svcvs	0x00746900
    10bc:	6d2f0061 	stcvs	0, cr0, [pc, #-388]!	; f40 <shift+0xf40>
    10c0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    10c4:	6573552f 	ldrbvs	r5, [r3, #-1327]!	; 0xfffffad1
    10c8:	4b2f7372 	blmi	bdde98 <__bss_end+0xbd4fa0>
    10cc:	2f616275 	svccs	0x00616275
    10d0:	75636f44 	strbvc	r6, [r3, #-3908]!	; 0xfffff0bc
    10d4:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
    10d8:	655a2f73 	ldrbvs	r2, [sl, #-3955]	; 0xfffff08d
    10dc:	614d6f72 	hvcvs	55026	; 0xd6f2
    10e0:	652f6574 	strvs	r6, [pc, #-1396]!	; b74 <shift+0xb74>
    10e4:	706d6178 	rsbvc	r6, sp, r8, ror r1
    10e8:	2f73656c 	svccs	0x0073656c
    10ec:	652d3831 	strvs	r3, [sp, #-2097]!	; 0xfffff7cf
    10f0:	732f6664 			; <UNDEFINED> instruction: 0x732f6664
    10f4:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    10f8:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    10fc:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1100:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1104:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1108:	00707063 	rsbseq	r7, r0, r3, rrx
    110c:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1110:	6a616f74 	bvs	185cee8 <__bss_end+0x1853ff0>
    1114:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1118:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    111c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1120:	2f2e2e2f 	svccs	0x002e2e2f
    1124:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1128:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    112c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1130:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1134:	2f676966 	svccs	0x00676966
    1138:	2f6d7261 	svccs	0x006d7261
    113c:	3162696c 	cmncc	r2, ip, ror #18
    1140:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1144:	00532e73 	subseq	r2, r3, r3, ror lr
    1148:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    114c:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1150:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1154:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1158:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    115c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1160:	6659682d 	ldrbvs	r6, [r9], -sp, lsr #16
    1164:	2f344b67 	svccs	0x00344b67
    1168:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    116c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1170:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1174:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1178:	30312d69 	eorscc	r2, r1, r9, ror #26
    117c:	322d332e 	eorcc	r3, sp, #-1207959552	; 0xb8000000
    1180:	2e313230 	mrccs	2, 1, r3, cr1, cr0, {1}
    1184:	622f3730 	eorvs	r3, pc, #48, 14	; 0xc00000
    1188:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    118c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1190:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1194:	61652d65 	cmnvs	r5, r5, ror #26
    1198:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    119c:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    11a0:	2f657435 	svccs	0x00657435
    11a4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    11a8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11ac:	00636367 	rsbeq	r6, r3, r7, ror #6
    11b0:	20554e47 	subscs	r4, r5, r7, asr #28
    11b4:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    11b8:	0037332e 	eorseq	r3, r7, lr, lsr #6
    11bc:	5f617369 	svcpl	0x00617369
    11c0:	5f746962 	svcpl	0x00746962
    11c4:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    11c8:	00736572 	rsbseq	r6, r3, r2, ror r5
    11cc:	5f617369 	svcpl	0x00617369
    11d0:	5f746962 	svcpl	0x00746962
    11d4:	5f706676 	svcpl	0x00706676
    11d8:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    11dc:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 11e4 <shift+0x11e4>
    11e0:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    11e4:	6f6c6620 	svcvs	0x006c6620
    11e8:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    11ec:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    11f0:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    11f4:	61736900 	cmnvs	r3, r0, lsl #18
    11f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11fc:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    1200:	6f6c665f 	svcvs	0x006c665f
    1204:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    1208:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    120c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1210:	00363170 	eorseq	r3, r6, r0, ror r1
    1214:	5f617369 	svcpl	0x00617369
    1218:	5f746962 	svcpl	0x00746962
    121c:	00636573 	rsbeq	r6, r3, r3, ror r5
    1220:	5f617369 	svcpl	0x00617369
    1224:	5f746962 	svcpl	0x00746962
    1228:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    122c:	61736900 	cmnvs	r3, r0, lsl #18
    1230:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1234:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1238:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    123c:	6f765f6f 	svcvs	0x00765f6f
    1240:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1244:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1248:	73690065 	cmnvc	r9, #101	; 0x65
    124c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1250:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    1254:	61736900 	cmnvs	r3, r0, lsl #18
    1258:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    125c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1260:	00743576 	rsbseq	r3, r4, r6, ror r5
    1264:	5f617369 	svcpl	0x00617369
    1268:	5f746962 	svcpl	0x00746962
    126c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1270:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1274:	5f617369 	svcpl	0x00617369
    1278:	5f746962 	svcpl	0x00746962
    127c:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1280:	61736900 	cmnvs	r3, r0, lsl #18
    1284:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1288:	3166625f 	cmncc	r6, pc, asr r2
    128c:	50460036 	subpl	r0, r6, r6, lsr r0
    1290:	5f524353 	svcpl	0x00524353
    1294:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1298:	53504600 	cmppl	r0, #0, 12
    129c:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
    12a0:	7176637a 	cmnvc	r6, sl, ror r3
    12a4:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
    12a8:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
    12ac:	455f5250 	ldrbmi	r5, [pc, #-592]	; 1064 <shift+0x1064>
    12b0:	004d554e 	subeq	r5, sp, lr, asr #10
    12b4:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    12b8:	706d695f 	rsbvc	r6, sp, pc, asr r9
    12bc:	6163696c 	cmnvs	r3, ip, ror #18
    12c0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    12c4:	5f305000 	svcpl	0x00305000
    12c8:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    12cc:	61736900 	cmnvs	r3, r0, lsl #18
    12d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12d4:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    12d8:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    12dc:	20554e47 	subscs	r4, r5, r7, asr #28
    12e0:	20373143 	eorscs	r3, r7, r3, asr #2
    12e4:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    12e8:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    12ec:	30313230 	eorscc	r3, r1, r0, lsr r2
    12f0:	20313236 	eorscs	r3, r1, r6, lsr r2
    12f4:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    12f8:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    12fc:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    1300:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1304:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1308:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    130c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1310:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1314:	616d2d20 	cmnvs	sp, r0, lsr #26
    1318:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    131c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1320:	2b657435 	blcs	195e3fc <__bss_end+0x1955504>
    1324:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1328:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    132c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1330:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1334:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1338:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    133c:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1340:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1344:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1348:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    134c:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1350:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1354:	6b636174 	blvs	18d992c <__bss_end+0x18d0a34>
    1358:	6f72702d 	svcvs	0x0072702d
    135c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1360:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1364:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 11d4 <shift+0x11d4>
    1368:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    136c:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1370:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1374:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1378:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    137c:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1380:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    1384:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1388:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1390 <shift+0x1390>
    138c:	00766964 	rsbseq	r6, r6, r4, ror #18
    1390:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1394:	61736900 	cmnvs	r3, r0, lsl #18
    1398:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    139c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    13a0:	0074786d 	rsbseq	r7, r4, sp, ror #16
    13a4:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    13a8:	455f5354 	ldrbmi	r5, [pc, #-852]	; 105c <shift+0x105c>
    13ac:	004d554e 	subeq	r5, sp, lr, asr #10
    13b0:	5f617369 	svcpl	0x00617369
    13b4:	5f746962 	svcpl	0x00746962
    13b8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13bc:	73690036 	cmnvc	r9, #54	; 0x36
    13c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13c4:	766d5f74 	uqsub16vc	r5, sp, r4
    13c8:	73690065 	cmnvc	r9, #101	; 0x65
    13cc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13d0:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    13d4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    13d8:	73690032 	cmnvc	r9, #50	; 0x32
    13dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13e0:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    13e4:	30706365 	rsbscc	r6, r0, r5, ror #6
    13e8:	61736900 	cmnvs	r3, r0, lsl #18
    13ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13f0:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    13f4:	00317063 	eorseq	r7, r1, r3, rrx
    13f8:	5f617369 	svcpl	0x00617369
    13fc:	5f746962 	svcpl	0x00746962
    1400:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1404:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    1408:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    140c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1410:	70636564 	rsbvc	r6, r3, r4, ror #10
    1414:	73690033 	cmnvc	r9, #51	; 0x33
    1418:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    141c:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1420:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    1424:	61736900 	cmnvs	r3, r0, lsl #18
    1428:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    142c:	5f70665f 	svcpl	0x0070665f
    1430:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1434:	5f617369 	svcpl	0x00617369
    1438:	5f746962 	svcpl	0x00746962
    143c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1440:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    1444:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1448:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    144c:	70636564 	rsbvc	r6, r3, r4, ror #10
    1450:	73690037 	cmnvc	r9, #55	; 0x37
    1454:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1458:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    145c:	6b36766d 	blvs	d9ee18 <__bss_end+0xd95f20>
    1460:	61736900 	cmnvs	r3, r0, lsl #18
    1464:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1468:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    146c:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1470:	616d5f6d 	cmnvs	sp, sp, ror #30
    1474:	61006e69 	tstvs	r0, r9, ror #28
    1478:	0065746e 	rsbeq	r7, r5, lr, ror #8
    147c:	5f617369 	svcpl	0x00617369
    1480:	5f746962 	svcpl	0x00746962
    1484:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1488:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    148c:	6f642067 	svcvs	0x00642067
    1490:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1494:	2f2e2e00 	svccs	0x002e2e00
    1498:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    149c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    14a0:	2f2e2e2f 	svccs	0x002e2e2f
    14a4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 13f4 <shift+0x13f4>
    14a8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    14ac:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    14b0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    14b4:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    14b8:	5f617369 	svcpl	0x00617369
    14bc:	5f746962 	svcpl	0x00746962
    14c0:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    14c4:	61736900 	cmnvs	r3, r0, lsl #18
    14c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14cc:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    14d0:	00656c61 	rsbeq	r6, r5, r1, ror #24
    14d4:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    14d8:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    14dc:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    14e0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    14e4:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    14e8:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    14ec:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14f0:	715f7469 	cmpvc	pc, r9, ror #8
    14f4:	6b726975 	blvs	1c9bad0 <__bss_end+0x1c92bd8>
    14f8:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    14fc:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    1500:	73690064 	cmnvc	r9, #100	; 0x64
    1504:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1508:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    150c:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    1510:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1514:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1518:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    151c:	73690032 	cmnvc	r9, #50	; 0x32
    1520:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1524:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1528:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    152c:	7369006d 	cmnvc	r9, #109	; 0x6d
    1530:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1534:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1538:	61006561 	tstvs	r0, r1, ror #10
    153c:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1540:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    1544:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    1548:	73746962 	cmnvc	r4, #1605632	; 0x188000
    154c:	61736900 	cmnvs	r3, r0, lsl #18
    1550:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1554:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1558:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    155c:	61736900 	cmnvs	r3, r0, lsl #18
    1560:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1564:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1568:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    156c:	61736900 	cmnvs	r3, r0, lsl #18
    1570:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1574:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1578:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    157c:	61736900 	cmnvs	r3, r0, lsl #18
    1580:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1584:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1588:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1590 <shift+0x1590>
    158c:	61736900 	cmnvs	r3, r0, lsl #18
    1590:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1594:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1598:	355f3876 	ldrbcc	r3, [pc, #-2166]	; d2a <shift+0xd2a>
    159c:	61736900 	cmnvs	r3, r0, lsl #18
    15a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15a4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15a8:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    15ac:	61736900 	cmnvs	r3, r0, lsl #18
    15b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15b4:	0062735f 	rsbeq	r7, r2, pc, asr r3
    15b8:	5f617369 	svcpl	0x00617369
    15bc:	5f6d756e 	svcpl	0x006d756e
    15c0:	73746962 	cmnvc	r4, #1605632	; 0x188000
    15c4:	61736900 	cmnvs	r3, r0, lsl #18
    15c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15cc:	616d735f 	cmnvs	sp, pc, asr r3
    15d0:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    15d4:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    15d8:	705f636e 	subsvc	r6, pc, lr, ror #6
    15dc:	63007274 	movwvs	r7, #628	; 0x274
    15e0:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    15e4:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    15e8:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    15ec:	424e0065 	submi	r0, lr, #101	; 0x65
    15f0:	5f50465f 	svcpl	0x0050465f
    15f4:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    15f8:	00534745 	subseq	r4, r3, r5, asr #14
    15fc:	5f617369 	svcpl	0x00617369
    1600:	5f746962 	svcpl	0x00746962
    1604:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1608:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    160c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1610:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1614:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1618:	61736900 	cmnvs	r3, r0, lsl #18
    161c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1620:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1624:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1628:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    162c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1630:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    1634:	43504600 	cmpmi	r0, #0, 12
    1638:	534e5458 	movtpl	r5, #58456	; 0xe458
    163c:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1640:	7369004d 	cmnvc	r9, #77	; 0x4d
    1644:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1648:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    164c:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1650:	5f617369 	svcpl	0x00617369
    1654:	5f746962 	svcpl	0x00746962
    1658:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    165c:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1660:	61736900 	cmnvs	r3, r0, lsl #18
    1664:	6165665f 	cmnvs	r5, pc, asr r6
    1668:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    166c:	61736900 	cmnvs	r3, r0, lsl #18
    1670:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1674:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 167c <shift+0x167c>
    1678:	7369006d 	cmnvc	r9, #109	; 0x6d
    167c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1680:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1684:	5f6b7269 	svcpl	0x006b7269
    1688:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    168c:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    1690:	5f617369 	svcpl	0x00617369
    1694:	5f746962 	svcpl	0x00746962
    1698:	33637263 	cmncc	r3, #805306374	; 0x30000006
    169c:	73690032 	cmnvc	r9, #50	; 0x32
    16a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16a4:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    16a8:	5f6b7269 	svcpl	0x006b7269
    16ac:	615f6f6e 	cmpvs	pc, lr, ror #30
    16b0:	70636d73 	rsbvc	r6, r3, r3, ror sp
    16b4:	73690075 	cmnvc	r9, #117	; 0x75
    16b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16bc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16c0:	0034766d 	eorseq	r7, r4, sp, ror #12
    16c4:	5f617369 	svcpl	0x00617369
    16c8:	5f746962 	svcpl	0x00746962
    16cc:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    16d0:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    16d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16d8:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    16dc:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    16e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16e4:	615f7469 	cmpvs	pc, r9, ror #8
    16e8:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    16ec:	61736900 	cmnvs	r3, r0, lsl #18
    16f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16f4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16f8:	76003876 			; <UNDEFINED> instruction: 0x76003876
    16fc:	735f7066 	cmpvc	pc, #102	; 0x66
    1700:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    1704:	655f7367 	ldrbvs	r7, [pc, #-871]	; 13a5 <shift+0x13a5>
    1708:	646f636e 	strbtvs	r6, [pc], #-878	; 1710 <shift+0x1710>
    170c:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1710:	5f617369 	svcpl	0x00617369
    1714:	5f746962 	svcpl	0x00746962
    1718:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    171c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1720:	5f617369 	svcpl	0x00617369
    1724:	5f746962 	svcpl	0x00746962
    1728:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    172c:	00646f72 	rsbeq	r6, r4, r2, ror pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfaa38>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347938>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1faa58>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9d88>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfaa88>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347988>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaaa8>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3479a8>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfaac8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3479c8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaae8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3479e8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfab08>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347a08>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfab28>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347a28>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfab48>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347a48>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fab60>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fab80>
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
 194:	000000cc 	andeq	r0, r0, ip, asr #1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fabb0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000082f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfabdc>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347adc>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008324 	andeq	r8, r0, r4, lsr #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfabfc>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347afc>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008350 	andeq	r8, r0, r0, asr r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfac1c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347b1c>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	0000836c 	andeq	r8, r0, ip, ror #6
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfac3c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347b3c>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083b0 			; <UNDEFINED> instruction: 0x000083b0
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfac5c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347b5c>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008400 	andeq	r8, r0, r0, lsl #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfac7c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347b7c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008450 	andeq	r8, r0, r0, asr r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfac9c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347b9c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	0000847c 	andeq	r8, r0, ip, ror r4
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfacbc>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347bbc>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000084cc 	andeq	r8, r0, ip, asr #9
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfacdc>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347bdc>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008510 	andeq	r8, r0, r0, lsl r5
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfacfc>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347bfc>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008560 	andeq	r8, r0, r0, ror #10
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfad1c>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347c1c>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085b4 			; <UNDEFINED> instruction: 0x000085b4
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfad3c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347c3c>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000085f0 	strdeq	r8, [r0], -r0
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfad5c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347c5c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000862c 	andeq	r8, r0, ip, lsr #12
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfad7c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347c7c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008668 	andeq	r8, r0, r8, ror #12
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfad9c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347c9c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086a4 	andeq	r8, r0, r4, lsr #13
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fadbc>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008754 	andeq	r8, r0, r4, asr r7
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fadec>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	000088c8 	andeq	r8, r0, r8, asr #17
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfae0c>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347d0c>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008964 	andeq	r8, r0, r4, ror #18
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfae2c>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347d2c>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a24 	andeq	r8, r0, r4, lsr #20
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfae4c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347d4c>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008ad0 	ldrdeq	r8, [r0], -r0
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfae6c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347d6c>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b24 	andeq	r8, r0, r4, lsr #22
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfae8c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347d8c>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008b8c 	andeq	r8, r0, ip, lsl #23
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfaeac>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347dac>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008c0c 	andeq	r8, r0, ip, lsl #24
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
