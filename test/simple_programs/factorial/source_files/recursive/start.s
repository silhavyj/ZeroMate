_start:
    mov sp, #1024
    bl kernel_main

hang:
    b hang
