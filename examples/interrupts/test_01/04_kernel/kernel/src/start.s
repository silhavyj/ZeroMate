.global _start

.section .text.start

_start:
	ldr pc, _reset_ptr
	ldr pc, _undefined_instruction_ptr
	ldr pc, _software_interrupt_ptr
	ldr pc, _prefetch_abort_ptr
	ldr pc, _data_abort_ptr
	ldr pc, _unused_handler_ptr
	ldr pc, _irq_ptr
	ldr pc, _fast_interrupt_ptr

_reset_ptr:
	.word _reset
_undefined_instruction_ptr:
	.word undefined_instruction_handler
_software_interrupt_ptr:
	.word software_interrupt_handler
_prefetch_abort_ptr:
	.word prefetch_abort_handler
_data_abort_ptr:
	.word data_abort_handler
_unused_handler_ptr:
	.word _reset
_irq_ptr:
	.word irq_handler
_fast_interrupt_ptr:
	.word fast_interrupt_handler


.equ    CPSR_MODE_USER,         0x10
.equ    CPSR_MODE_SVR,          0x13
.equ    CPSR_IRQ_INHIBIT,       0x80
.equ    CPSR_FIQ_INHIBIT,       0x40

.equ    N_FLAG,  0x80000000
.equ    Z_FLAG,  0x40000000
.equ    C_FLAG,  0x20000000
.equ    V_FLAG,  0x10000000


_reset:
	mov sp, #0x8000

	mov r0, #0x8000
    mov r1, #0x0000

    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}
    ldmia r0!,{r2, r3, r4, r5, r6, r7, r8, r9}
    stmia r1!,{r2, r3, r4, r5, r6, r7, r8, r9}

    mov r0, #(CPSR_MODE_USER | CPSR_IRQ_INHIBIT | CPSR_FIQ_INHIBIT)
	orr r0, #N_FLAG
	orr r0, #Z_FLAG
	orr r0, #C_FLAG
	orr r0, #V_FLAG

    msr cpsr_cf, r0
    mov sp, #0x8000

	mov r0, #0x0
	mov r1, #0x1
	mov r2, #0x2
	mov r3, #0x3
	mov r4, #0x4
	mov r5, #0x5
	mov r6, #0x6
	mov r7, #0x7
	mov r8, #0x8
	
	svc 0

hang:
	b hang

.section .text

undefined_instruction_handler:
	b hang

prefetch_abort_handler:
	b hang

data_abort_handler:
	b hang

irq_handler:
	b hang

fast_interrupt_handler:
	b hang