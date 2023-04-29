
./kernel:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:6
.global _start

.section .text.start

_start:
	ldr pc, _reset_ptr
    8000:	e59ff018 	ldr	pc, [pc, #24]	; 8020 <_reset_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:7
	ldr pc, _undefined_instruction_ptr
    8004:	e59ff018 	ldr	pc, [pc, #24]	; 8024 <_undefined_instruction_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:8
	ldr pc, _software_interrupt_ptr
    8008:	e59ff018 	ldr	pc, [pc, #24]	; 8028 <_software_interrupt_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:9
	ldr pc, _prefetch_abort_ptr
    800c:	e59ff018 	ldr	pc, [pc, #24]	; 802c <_prefetch_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:10
	ldr pc, _data_abort_ptr
    8010:	e59ff018 	ldr	pc, [pc, #24]	; 8030 <_data_abort_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:11
	ldr pc, _unused_handler_ptr
    8014:	e59ff018 	ldr	pc, [pc, #24]	; 8034 <_unused_handler_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:12
	ldr pc, _irq_ptr
    8018:	e59ff018 	ldr	pc, [pc, #24]	; 8038 <_irq_ptr>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
	ldr pc, _fast_interrupt_ptr
    801c:	e59ff018 	ldr	pc, [pc, #24]	; 803c <_fast_interrupt_ptr>

00008020 <_reset_ptr>:
_reset_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    8020:	00008040 	andeq	r8, r0, r0, asr #32

00008024 <_undefined_instruction_ptr>:
_undefined_instruction_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    8024:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>

00008028 <_software_interrupt_ptr>:
_software_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    8028:	000080a4 	andeq	r8, r0, r4, lsr #1

0000802c <_prefetch_abort_ptr>:
_prefetch_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    802c:	000080fc 	strdeq	r8, [r0], -ip

00008030 <_data_abort_ptr>:
_data_abort_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    8030:	00008100 	andeq	r8, r0, r0, lsl #2

00008034 <_unused_handler_ptr>:
_unused_handler_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    8034:	00008040 	andeq	r8, r0, r0, asr #32

00008038 <_irq_ptr>:
_irq_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    8038:	00008104 	andeq	r8, r0, r4, lsl #2

0000803c <_fast_interrupt_ptr>:
_fast_interrupt_ptr():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:13
    803c:	00008108 	andeq	r8, r0, r8, lsl #2

00008040 <_reset>:
_reset():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:45
.equ    C_FLAG,  0x20000000
.equ    V_FLAG,  0x10000000


_reset:
	mov sp, #0x8000
    8040:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:47

	mov r0, #0x8000
    8044:	e3a00902 	mov	r0, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:48
    mov r1, #0x0000
    8048:	e3a01000 	mov	r1, #0
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:50

    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    804c:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:51
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8050:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:52
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8054:	e8b003fc 	ldm	r0!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:53
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    8058:	e8a103fc 	stmia	r1!, {r2, r3, r4, r5, r6, r7, r8, r9}
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:55

    mov r0, #(CPSR_MODE_USER | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
    805c:	e3a000d0 	mov	r0, #208	; 0xd0
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:56
	orr r0, #N_FLAG
    8060:	e3800102 	orr	r0, r0, #-2147483648	; 0x80000000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:57
	orr r0, #Z_FLAG
    8064:	e3800101 	orr	r0, r0, #1073741824	; 0x40000000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:58
	orr r0, #C_FLAG
    8068:	e3800202 	orr	r0, r0, #536870912	; 0x20000000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:59
	orr r0, #V_FLAG
    806c:	e3800201 	orr	r0, r0, #268435456	; 0x10000000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:61

    msr cpsr_cf, r0
    8070:	e129f000 	msr	CPSR_fc, r0
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:62
    mov sp, #0x8000
    8074:	e3a0d902 	mov	sp, #32768	; 0x8000
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:64

	mov r0, #0x0
    8078:	e3a00000 	mov	r0, #0
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:65
	mov r1, #0x1
    807c:	e3a01001 	mov	r1, #1
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:66
	mov r2, #0x2
    8080:	e3a02002 	mov	r2, #2
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:67
	mov r3, #0x3
    8084:	e3a03003 	mov	r3, #3
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:68
	mov r4, #0x4
    8088:	e3a04004 	mov	r4, #4
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:69
	mov r5, #0x5
    808c:	e3a05005 	mov	r5, #5
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:70
	mov r6, #0x6
    8090:	e3a06006 	mov	r6, #6
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:71
	mov r7, #0x7
    8094:	e3a07007 	mov	r7, #7
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:72
	mov r8, #0x8
    8098:	e3a08008 	mov	r8, #8
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:74
	
	svc 0
    809c:	ef000000 	svc	0x00000000

000080a0 <hang>:
hang():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:77

hang:
	b hang
    80a0:	eafffffe 	b	80a0 <hang>

000080a4 <software_interrupt_handler>:
software_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:2
extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    80a4:	e92d0808 	push	{r3, fp}
    80a8:	e28db004 	add	fp, sp, #4
    80ac:	e24dd008 	sub	sp, sp, #8
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:3
    int count = 0;
    80b0:	e3a03000 	mov	r3, #0
    80b4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:4
    for (int i = 0; i < 10; ++i)
    80b8:	e3a03000 	mov	r3, #0
    80bc:	e50b300c 	str	r3, [fp, #-12]
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:4 (discriminator 3)
    80c0:	e51b300c 	ldr	r3, [fp, #-12]
    80c4:	e3530009 	cmp	r3, #9
    80c8:	ca000006 	bgt	80e8 <software_interrupt_handler+0x44>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:5 (discriminator 2)
        count++;
    80cc:	e51b3008 	ldr	r3, [fp, #-8]
    80d0:	e2833001 	add	r3, r3, #1
    80d4:	e50b3008 	str	r3, [fp, #-8]
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:4 (discriminator 2)
    for (int i = 0; i < 10; ++i)
    80d8:	e51b300c 	ldr	r3, [fp, #-12]
    80dc:	e2833001 	add	r3, r3, #1
    80e0:	e50b300c 	str	r3, [fp, #-12]
    80e4:	eafffff5 	b	80c0 <software_interrupt_handler+0x1c>
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/interrupts.cpp:6
}
    80e8:	e320f000 	nop	{0}
    80ec:	e24bd004 	sub	sp, fp, #4
    80f0:	e8bd0808 	pop	{r3, fp}
    80f4:	e1b0f00e 	movs	pc, lr

000080f8 <undefined_instruction_handler>:
undefined_instruction_handler():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:82

.section .text

undefined_instruction_handler:
	b hang
    80f8:	eaffffe8 	b	80a0 <hang>

000080fc <prefetch_abort_handler>:
prefetch_abort_handler():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:85

prefetch_abort_handler:
	b hang
    80fc:	eaffffe7 	b	80a0 <hang>

00008100 <data_abort_handler>:
data_abort_handler():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:88

data_abort_handler:
	b hang
    8100:	eaffffe6 	b	80a0 <hang>

00008104 <irq_handler>:
irq_handler():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:91

irq_handler:
	b hang
    8104:	eaffffe5 	b	80a0 <hang>

00008108 <fast_interrupt_handler>:
fast_interrupt_handler():
/home/silhavyj/School/ZeroMate/examples/08-software_interrupt/kernel/src/start.s:94

fast_interrupt_handler:
    8108:	eaffffe4 	b	80a0 <hang>

Disassembly of section .ARM.exidx:

0000810c <__CTOR_END__-0x8>:
    810c:	7fffff98 	svcvc	0x00ffff98
    8110:	00000001 	andeq	r0, r0, r1

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	00000066 	andeq	r0, r0, r6, rrx
   4:	00000004 	andeq	r0, r0, r4
   8:	01040000 	mrseq	r0, (UNDEF: 4)
   c:	000000b7 	strheq	r0, [r0], -r7
  10:	00001b04 	andeq	r1, r0, r4, lsl #22
  14:	00007300 	andeq	r7, r0, r0, lsl #6
  18:	0080a400 	addeq	sl, r0, r0, lsl #8
  1c:	00005400 	andeq	r5, r0, r0, lsl #8
  20:	00000000 	andeq	r0, r0, r0
  24:	00000200 	andeq	r0, r0, r0, lsl #4
  28:	01010000 	mrseq	r0, (UNDEF: 1)
  2c:	0080a433 	addeq	sl, r0, r3, lsr r4
  30:	00005400 	andeq	r5, r0, r0, lsl #8
  34:	629c0100 	addsvs	r0, ip, #0, 2
  38:	03000000 	movweq	r0, #0
  3c:	0000016d 	andeq	r0, r0, sp, ror #2
  40:	62090301 	andvs	r0, r9, #67108864	; 0x4000000
  44:	02000000 	andeq	r0, r0, #0
  48:	b8047491 	stmdalt	r4, {r0, r4, r7, sl, ip, sp, lr}
  4c:	30000080 	andcc	r0, r0, r0, lsl #1
  50:	05000000 	streq	r0, [r0, #-0]
  54:	04010069 	streq	r0, [r1], #-105	; 0xffffff97
  58:	0000620e 	andeq	r6, r0, lr, lsl #4
  5c:	70910200 	addsvc	r0, r1, r0, lsl #4
  60:	04060000 	streq	r0, [r6], #-0
  64:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
  68:	001e0000 	andseq	r0, lr, r0
  6c:	00020000 	andeq	r0, r2, r0
  70:	00000064 	andeq	r0, r0, r4, rrx
  74:	00a50104 	adceq	r0, r5, r4, lsl #2
  78:	00000000 	andeq	r0, r0, r0
  7c:	01730000 	cmneq	r3, r0
  80:	00730000 	rsbseq	r0, r3, r0
  84:	01c40000 	biceq	r0, r4, r0
  88:	80010000 	andhi	r0, r1, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	030b130e 	movweq	r1, #45838	; 0xb30e
   8:	110e1b0e 	tstne	lr, lr, lsl #22
   c:	10061201 	andne	r1, r6, r1, lsl #4
  10:	02000017 	andeq	r0, r0, #23
  14:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  18:	0b3a0e03 	bleq	e8382c <__CTOR_END__+0xe7b718>
  1c:	0b390b3b 	bleq	e42d10 <__CTOR_END__+0xe3abfc>
  20:	06120111 			; <UNDEFINED> instruction: 0x06120111
  24:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  28:	00130119 	andseq	r0, r3, r9, lsl r1
  2c:	00340300 	eorseq	r0, r4, r0, lsl #6
  30:	0b3a0e03 	bleq	e83844 <__CTOR_END__+0xe7b730>
  34:	0b390b3b 	bleq	e42d28 <__CTOR_END__+0xe3ac14>
  38:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
  3c:	0b040000 	bleq	100044 <__CTOR_END__+0xf7f30>
  40:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
  44:	05000006 	streq	r0, [r0, #-6]
  48:	08030034 	stmdaeq	r3, {r2, r4, r5}
  4c:	0b3b0b3a 	bleq	ec2d3c <__CTOR_END__+0xebac28>
  50:	13490b39 	movtne	r0, #39737	; 0x9b39
  54:	00001802 	andeq	r1, r0, r2, lsl #16
  58:	0b002406 	bleq	9078 <__CTOR_END__+0xf64>
  5c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  60:	00000008 	andeq	r0, r0, r8
  64:	10001101 	andne	r1, r0, r1, lsl #2
  68:	03065506 	movweq	r5, #25862	; 0x6506
  6c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
  70:	0005130e 	andeq	r1, r5, lr, lsl #6
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	000080a4 	andeq	r8, r0, r4, lsr #1
  14:	00000054 	andeq	r0, r0, r4, asr r0
	...
  20:	00000024 	andeq	r0, r0, r4, lsr #32
  24:	006a0002 	rsbeq	r0, sl, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008000 	andeq	r8, r0, r0
  34:	000000a4 	andeq	r0, r0, r4, lsr #1
  38:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  3c:	00000014 	andeq	r0, r0, r4, lsl r0
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000000a1 	andeq	r0, r0, r1, lsr #1
   4:	006e0003 	rsbeq	r0, lr, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <N_FLAG+0x7ffffe94>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	302f7365 	eorcc	r7, pc, r5, ror #6
  44:	6f732d38 	svcvs	0x00732d38
  48:	61777466 	cmnvs	r7, r6, ror #8
  4c:	695f6572 	ldmdbvs	pc, {r1, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
  50:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
  54:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
  58:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  5c:	2f6c656e 	svccs	0x006c656e
  60:	00637273 	rsbeq	r7, r3, r3, ror r2
  64:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
  68:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
  6c:	2e737470 	mrccs	4, 3, r7, cr3, cr0, {3}
  70:	00707063 	rsbseq	r7, r0, r3, rrx
  74:	00000001 	andeq	r0, r0, r1
  78:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
  7c:	0080a402 	addeq	sl, r0, r2, lsl #8
  80:	09051300 	stmdbeq	r5, {r8, r9, ip}
  84:	4b0e0567 	blmi	381628 <__CTOR_END__+0x379514>
  88:	02001705 	andeq	r1, r0, #1310720	; 0x140000
  8c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
  90:	0402000e 	streq	r0, [r2], #-14
  94:	05056702 	streq	r6, [r5, #-1794]	; 0xfffff8fe
  98:	02040200 	andeq	r0, r4, #0, 4
  9c:	84010565 	strhi	r0, [r1], #-1381	; 0xfffffa9b
  a0:	01000802 	tsteq	r0, r2, lsl #16
  a4:	0000b101 	andeq	fp, r0, r1, lsl #2
  a8:	67000300 	strvs	r0, [r0, -r0, lsl #6]
  ac:	02000000 	andeq	r0, r0, #0
  b0:	0d0efb01 	vstreq	d15, [lr, #-4]
  b4:	01010100 	mrseq	r0, (UNDEF: 17)
  b8:	00000001 	andeq	r0, r0, r1
  bc:	01000001 	tsteq	r0, r1
  c0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; c <CPSR_MODE_USER-0x4>
  c4:	69732f65 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  c8:	7661686c 	strbtvc	r6, [r1], -ip, ror #16
  cc:	532f6a79 			; <UNDEFINED> instruction: 0x532f6a79
  d0:	6f6f6863 	svcvs	0x006f6863
  d4:	655a2f6c 	ldrbvs	r2, [sl, #-3948]	; 0xfffff094
  d8:	614d6f72 	hvcvs	55026	; 0xd6f2
  dc:	652f6574 	strvs	r6, [pc, #-1396]!	; fffffb70 <N_FLAG+0x7ffffb70>
  e0:	706d6178 	rsbvc	r6, sp, r8, ror r1
  e4:	2f73656c 	svccs	0x0073656c
  e8:	732d3830 			; <UNDEFINED> instruction: 0x732d3830
  ec:	7774666f 	ldrbvc	r6, [r4, -pc, ror #12]!
  f0:	5f657261 	svcpl	0x00657261
  f4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
  f8:	70757272 	rsbsvc	r7, r5, r2, ror r2
  fc:	656b2f74 	strbvs	r2, [fp, #-3956]!	; 0xfffff08c
 100:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 104:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 108:	74730000 	ldrbtvc	r0, [r3], #-0
 10c:	2e747261 	cdpcs	2, 7, cr7, cr4, cr1, {3}
 110:	00010073 	andeq	r0, r1, r3, ror r0
 114:	05000000 	streq	r0, [r0, #-0]
 118:	00800002 	addeq	r0, r0, r2
 11c:	2f2f1700 	svccs	0x002f1700
 120:	2f2f2f2f 	svccs	0x002f2f2f
 124:	0820032f 	stmdaeq	r0!, {r0, r1, r2, r3, r5, r8, r9}
 128:	302f3020 	eorcc	r3, pc, r0, lsr #32
 12c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 130:	2f2f2f2f 	svccs	0x002f2f2f
 134:	2f302f30 	svccs	0x00302f30
 138:	2f2f2f2f 	svccs	0x002f2f2f
 13c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 140:	00020231 	andeq	r0, r2, r1, lsr r2
 144:	05000101 	streq	r0, [r0, #-257]	; 0xfffffeff
 148:	0080f802 	addeq	pc, r0, r2, lsl #16
 14c:	00d10300 	sbcseq	r0, r1, r0, lsl #6
 150:	31313101 	teqcc	r1, r1, lsl #2
 154:	00020231 	andeq	r0, r2, r1, lsr r2
 158:	Address 0x0000000000000158 is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	74666f73 	strbtvc	r6, [r6], #-3955	; 0xfffff08d
   4:	65726177 	ldrbvs	r6, [r2, #-375]!	; 0xfffffe89
   8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
   c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
  10:	685f7470 	ldmdavs	pc, {r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
  14:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
  18:	2f007265 	svccs	0x00007265
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  24:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  28:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  2c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffe94 <N_FLAG+0x7ffffe94>
  30:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  34:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  38:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  3c:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  40:	302f7365 	eorcc	r7, pc, r5, ror #6
  44:	6f732d38 	svcvs	0x00732d38
  48:	61777466 	cmnvs	r7, r6, ror #8
  4c:	695f6572 	ldmdbvs	pc, {r1, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
  50:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
  54:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
  58:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
  5c:	2f6c656e 	svccs	0x006c656e
  60:	2f637273 	svccs	0x00637273
  64:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
  68:	70757272 	rsbsvc	r7, r5, r2, ror r2
  6c:	632e7374 			; <UNDEFINED> instruction: 0x632e7374
  70:	2f007070 	svccs	0x00007070
  74:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  78:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
  7c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
  80:	63532f6a 	cmpvs	r3, #424	; 0x1a8
  84:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; fffffeec <N_FLAG+0x7ffffeec>
  88:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
  8c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
  90:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
  94:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
  98:	302f7365 	eorcc	r7, pc, r5, ror #6
  9c:	6f732d38 	svcvs	0x00732d38
  a0:	61777466 	cmnvs	r7, r6, ror #8
  a4:	695f6572 	ldmdbvs	pc, {r1, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
  a8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
  ac:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
  b0:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
  b4:	4700646c 	strmi	r6, [r0, -ip, ror #8]
  b8:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
  bc:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
  c0:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
  c4:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
  c8:	31393130 	teqcc	r9, r0, lsr r1
  cc:	20353230 	eorscs	r3, r5, r0, lsr r2
  d0:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
  d4:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
  d8:	415b2029 	cmpmi	fp, r9, lsr #32
  dc:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
  e0:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
  e4:	6172622d 	cmnvs	r2, sp, lsr #4
  e8:	2068636e 	rsbcs	r6, r8, lr, ror #6
  ec:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
  f0:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
  f4:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
  f8:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
  fc:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 100:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 104:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
 108:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
 10c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
 110:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
 114:	20706676 	rsbscs	r6, r0, r6, ror r6
 118:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
 11c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 120:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
 124:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
 128:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 12c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
 130:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 134:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
 138:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
 13c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
 140:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
 144:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
 148:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
 14c:	616d2d20 	cmnvs	sp, r0, lsr #26
 150:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
 154:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
 158:	2b6b7a36 	blcs	1adea38 <__CTOR_END__+0x1ad6924>
 15c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
 160:	672d2067 	strvs	r2, [sp, -r7, rrx]!
 164:	304f2d20 	subcc	r2, pc, r0, lsr #26
 168:	304f2d20 	subcc	r2, pc, r0, lsr #26
 16c:	756f6300 	strbvc	r6, [pc, #-768]!	; fffffe74 <N_FLAG+0x7ffffe74>
 170:	2f00746e 	svccs	0x0000746e
 174:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 178:	6c69732f 	stclvs	3, cr7, [r9], #-188	; 0xffffff44
 17c:	79766168 	ldmdbvc	r6!, {r3, r5, r6, r8, sp, lr}^
 180:	63532f6a 	cmpvs	r3, #424	; 0x1a8
 184:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffffec <N_FLAG+0x7fffffec>
 188:	72655a2f 	rsbvc	r5, r5, #192512	; 0x2f000
 18c:	74614d6f 	strbtvc	r4, [r1], #-3439	; 0xfffff291
 190:	78652f65 	stmdavc	r5!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 194:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
 198:	302f7365 	eorcc	r7, pc, r5, ror #6
 19c:	6f732d38 	svcvs	0x00732d38
 1a0:	61777466 	cmnvs	r7, r6, ror #8
 1a4:	695f6572 	ldmdbvs	pc, {r1, r4, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
 1a8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 1ac:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
 1b0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 1b4:	2f6c656e 	svccs	0x006c656e
 1b8:	2f637273 	svccs	0x00637273
 1bc:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
 1c0:	00732e74 	rsbseq	r2, r3, r4, ror lr
 1c4:	20554e47 	subscs	r4, r5, r7, asr #28
 1c8:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
 1cc:	0034332e 	eorseq	r3, r4, lr, lsr #6

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__CTOR_END__+0x10c8c10>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	322d393a 	eorcc	r3, sp, #950272	; 0xe8000
   c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
  10:	302d3471 	eorcc	r3, sp, r1, ror r4
  14:	6e756275 	mrcvs	2, 3, r6, cr5, cr5, {3}
  18:	29317574 	ldmdbcs	r1!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}
  1c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
  20:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
  24:	31393130 	teqcc	r9, r0, lsr r1
  28:	20353230 	eorscs	r3, r5, r0, lsr r2
  2c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
  30:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
  34:	415b2029 	cmpmi	fp, r9, lsr #32
  38:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
  3c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
  40:	6172622d 	cmnvs	r2, sp, lsr #4
  44:	2068636e 	rsbcs	r6, r8, lr, ror #6
  48:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
  4c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
  50:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
  54:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00003041 	andeq	r3, r0, r1, asr #32
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000026 	andeq	r0, r0, r6, lsr #32
  10:	4b5a3605 	blmi	168d82c <__CTOR_END__+0x1685718>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__CTOR_END__+0x3a310>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__CTOR_END__+0x3df24>
  28:	1e011c01 	cdpne	12, 0, cr1, cr1, cr1, {0}
  2c:	44012206 	strmi	r2, [r1], #-518	; 0xfffffdfa
  30:	Address 0x0000000000000030 is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	00000020 	andeq	r0, r0, r0, lsr #32
  14:	00000000 	andeq	r0, r0, r0
  18:	000080a4 	andeq	r8, r0, r4, lsr #1
  1c:	00000054 	andeq	r0, r0, r4, asr r0
  20:	83080e42 	movwhi	r0, #36418	; 0x8e42
  24:	42018b02 	andmi	r8, r1, #2048	; 0x800
  28:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
  2c:	42080d0c 	andmi	r0, r8, #12, 26	; 0x300
  30:	000ec3cb 	andeq	ip, lr, fp, asr #7

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   4:	00000000 	andeq	r0, r0, r0
   8:	00008000 	andeq	r8, r0, r0
   c:	000080a4 	andeq	r8, r0, r4, lsr #1
  10:	000080f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  14:	0000810c 	andeq	r8, r0, ip, lsl #2
	...
