#include <stdstring.h>

namespace
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    int i = 0;

    while (input > 0)
    {
        output[i] = CharConvArr[input % base];
        input /= base;
        i++;
    }

    if (i == 0)
    {
        output[i] = CharConvArr[0];
        i++;
    }

    output[i] = '\0';
    i--;

    for (int j = 0; j <= i / 2; j++)
    {
        char c = output[i - j];
        output[i - j] = output[j];
        output[j] = c;
    }
}

int atoi(const char* input)
{
    int output = 0;

    while (*input != '\0')
    {
        output *= 10;
        if (*input > '9' || *input < '0')
            break;

        output += *input - '0';

        input++;
    }

    return output;
}

char* strncpy(char* dest, const char* src, int num)
{
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
        dest[i] = src[i];
    for (; i < num; i++)
        dest[i] = '\0';

    return dest;
}

int strncmp(const char* s1, const char* s2, int num)
{
    unsigned char u1, u2;
    while (num-- > 0)
    {
        u1 = (unsigned char)*s1++;
        u2 = (unsigned char)*s2++;
        if (u1 != u2)
            return u1 - u2;
        if (u1 == '\0')
            return 0;
    }

    return 0;
}

int strlen(const char* s)
{
    int i = 0;

    while (s[i] != '\0')
        i++;

    return i;
}

void bzero(void* memory, int length)
{
    char* mem = reinterpret_cast<char*>(memory);

    for (int i = 0; i < length; i++)
        mem[i] = 0;
}

void memcpy(const void* src, void* dst, int num)
{
    const char* memsrc = reinterpret_cast<const char*>(src);
    char* memdst = reinterpret_cast<char*>(dst);

    for (int i = 0; i < num; i++)
        memdst[i] = memsrc[i];
}
