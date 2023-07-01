#include <stdstring.h>
#include <stdfile.h>

#include <drivers/bridges/uart_defs.h>

int main(int argc, char** argv)
{
    volatile int i;

    uint32_t f = open("DEV:segd", NFile_Open_Mode::Write_Only);
    write(f, "4", 1);

    char message[] = "0";

    while (true)
    {
        if (message[0] == '9')
        {
            message[0] = '0';
        }
        else
        {
            ++message[0];
        }

        write(f, message, 1);

        for (i = 0; i < 0x1600; i++)
            ;
    }

    close(f);

    return 0;
}
