float Fahrenheit_To_Celsius(float fahrenheit)
{
    return (fahrenheit - 32) * 5.0f / 9.0f;
}

extern "C" int _kernel_main()
{
    int celsius = Fahrenheit_To_Celsius(100.0f);

    while (1)
    {
    }

    return 0;
}
