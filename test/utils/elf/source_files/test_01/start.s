_start:
    mov sp, #0x8000
    bl kernel_main

hang:
    b hang
