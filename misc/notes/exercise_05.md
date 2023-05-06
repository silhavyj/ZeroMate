- Why is there `push {r13}` in `context_switch` in the `switch.s` file? Should not it be `push {r0}` as suggested by the comments?
- In `start.s` why are the stacks moved up to `#0x80000000`. Is that just a cip select? How do I go about distinguishing in the emulator? Do I just mask it out or something?
- In the `uint32_t CPage_Manager::Alloc_Page()` method, should not be `mPage_Bitmap[i]` cast into `uint32_t`? 

    The following piece of code returns `1`, even though it should return `0`.

    ```c++
    typedef unsigned int uint32_t;
    typedef unsigned char uint8_t;

    int kernel_main()
    {
        uint8_t mPage_Bitmap = 1U;
            
        uint32_t j = 0;
        
        if ((mPage_Bitmap & (1 << j)) == 0)
        {
            return 1;
        }
        
        return 0;
    }
    ```

    When using a cast however, it does work as expected.

    ```c++
    typedef unsigned int uint32_t;
    typedef unsigned char uint8_t;

    int kernel_main()
    {
        uint8_t mPage_Bitmap = 1U;
            
        uint32_t j = 0;
        
        if (((uint32_t)mPage_Bitmap & (1 << j)) == 0)
        {
            return 1;
        }
        
        return 0;
    }
    ```

    Here is the corresponding assembly for the NOT working version of the piece of code above. It can be tested over at `https://cpulator.01xz.net/?sys=arm`

    ```as
    .global _start
    _start:
    mov	sp, #1024
    bl	0xc
    b	0x8

    push	{fp}
    add	fp, sp, #0
    sub	sp, sp, #12
    mov	r3, #1
    strb	r3, [fp, #-5]
    mov	r3, #0
    str	r3, [fp, #-12]
    ldrb	r2, [fp, #-5]
    ldr	r3, [fp, #-12]
    asr	r3, r2, r3
    and	r3, r3, #1
    cmp	r3, #0
    bne	48
    mov	r3, #1
    b	0x4c
    mov	r3, #0
    mov	r0, r3
    add	sp, fp, #0
    pop	{fp}
    bx	lr
    ```