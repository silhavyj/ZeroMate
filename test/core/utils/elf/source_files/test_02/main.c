int strlen(const char* const str)
{
    int len = 0;

    while (str[len] != '\0')
    {
        ++len;
    }

    return len;
}

int Count_Characters(const char* const str, int len, char c)
{
    int count = 0;

    for (unsigned int i = 0; i < len; ++i)
    {
        if (str[i] == c)
        {
            ++count;
        }
    }

    return count;
}

int kernel_main()
{
    int total_count = 0;

    const char* const s1 = "This is just a piece of text\0";
    const char* const s2 = "AaBbCcAaBbCcAaBbCc\0";

    total_count += Count_Characters(s1, strlen(s1), 'i');
    total_count += Count_Characters(s2, strlen(s2), 'C');

    return total_count;
}
