#define GPFSEL4 0x20200010
#define GPSET1  0x20200020
#define GPCLR1  0x2020002C

void write32(unsigned int address, unsigned int val)
{
    *((volatile unsigned int*)address) = val;
}

unsigned int read32(unsigned int address)
{
    return *((volatile unsigned int*)address);
}

void active_sleep(unsigned int ticks)
{
    volatile int ra;
    for (ra = 0; ra < ticks; ra++)
        ;
}

void toggle_LED(int count, int delay)
{
    for (int i = 0; i < count; ++i)
    {
        write32(GPSET1, 1 << (47 - 32));
        active_sleep(delay);
        write32(GPCLR1, 1 << (47 - 32));
        active_sleep(delay);
    }
}

void kernel_main()
{
    unsigned int reg;

    reg = read32(GPFSEL4);
    reg &= ~(7 << 21);
    reg |= 1 << 21;
    write32(GPFSEL4, reg);

    while(1)
    {
        toggle_LED(3, 1);
        toggle_LED(3, 7);
        toggle_LED(3, 1);
        
        active_sleep(30);
    }
}
