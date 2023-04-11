#define N 24

int fib(int n, int* dp)
{
    if (n <= 1)
    {
        dp[n] = n;
        return n;
    }
    
    if (dp[n] != -1)
    {
        return dp[n];
    }

    dp[n] = fib(n - 1, dp) + fib(n - 2, dp);
    
    return dp[n];
}

int kernel_main()
{
    int arr[N];
    
    for (int i = 0; i < N; ++i)
    {
        arr[i] = -1;
    }

    return fib(10, arr) + fib(15, arr) + fib(5, arr);
}
