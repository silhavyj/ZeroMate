long long factorial(long long x)
{
    long long result = 1;
    
    for (long long i = 2; i < x; ++i)
    {
        result *= i;
    }
    
    return result;
}


int kernel_main()
{
    return factorial(25);
}
