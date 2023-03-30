;@ _start is a label which identifies the entry point (conventional)
;@ this gets "called" when the Raspberry Pi boots
_start:
    mov sp, #0x8000       ;@ initialize the stack to some "safe" value
    bl kernel_main        ;@ and call the kernel main code
hang:                     ;@ just conventionally - loop indefinitelly here, even if this should not happen at all
    b hang
