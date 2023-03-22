const char* txt = "Hello word\0";
const unsigned int len = 10;

int kernel_main()
{
    int count = 0;

    for (unsigned int i = 0; i < len; ++i)
    {
        if (txt[i] == 'o')
        {
            ++count;
        }
    }

    return count;
}
