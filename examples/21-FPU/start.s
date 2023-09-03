_start:
    mov sp, #1024
    mrc p15, 0, r0, c1, c0, 2
    orr r0, r0, #0x300000
    orr r0, r0, #0xC00000
    mcr p15, 0, r0, c1, c0, 2
    mov r0, #0x40000000
    fmxr fpexc, r0
    bl kernel_main

hang:
    b hang
