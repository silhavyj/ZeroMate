int fib(int n)
{
    int a = 0;
    int b = 1;
    int c;
    int i;
    
    if (n == 0)
    {
        return a;
    }
    
    for (i = 2; i <= n; ++i)
    {
       c = a + b;
       a = b;
       b = c;
    }
    
    return b;
}

int kernel_main()
{
    return fib(100);
}
