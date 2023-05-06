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
