
extern void _cpp_startup();
extern void _cpp_shutdown();
extern int main(int argc, char** argv);

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    unsigned int* begin = (unsigned int*)&__bss_start;
    for (; begin < (unsigned int*)&__bss_end; begin++)
        *begin = 0;
}

void __crt0_run()
{
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS
    // pushnout co chce)
    int result = main(0, 0);

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r"(result));
    asm volatile("svc #1");
}
