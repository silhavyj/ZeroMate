_start:
    mov sp, #1024
    mrc p15, 0, r6, c1, c0, 2
    orr r6, r6, #0x300000
    mcr p15, 0, r6, c1, c0, 2
    mov r6, #0x40000000
    fmxr fpexc, r6
    bl kernel_main

hang:
    b hang
