long long factorial(long long x)
{
    if (x == 1)
    {
        return 1;
    }

    return x * factorial(x - 1);
}

int kernel_main()
{
    return factorial(7);
}
