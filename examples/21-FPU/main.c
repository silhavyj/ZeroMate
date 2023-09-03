float Foo()
{
    float f1 = 0.65F;
    float f2 = 0.15F;

    return f1 * f2;
}

int kernel_main()
{
    return Foo();
}
