extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
    int count = 0;
    for (int i = 0; i < 10; ++i)
        count++;
}
