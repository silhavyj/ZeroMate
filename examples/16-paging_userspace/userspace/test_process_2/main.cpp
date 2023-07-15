#include <stdstring.h>
#include <stdfile.h>

int main(int argc, char** argv)
{
    volatile int i;

    const char* msg = "Hello!\n";

    uint32_t f = open("DEV:monitor/0", NFile_Open_Mode::Read_Write);
    uint32_t rndf = open("DEV:trng", NFile_Open_Mode::Read_Only);

    uint32_t rdbuf;
    char numbuf[16];

    while (true)
    {
        read(rndf, reinterpret_cast<char*>(&rdbuf), 4);

        bzero(numbuf, 16);
        itoa(rdbuf, numbuf, 10);

        write(f, numbuf, strlen(numbuf));

        for (i = 0; i < 0x800; i++)
            ;
    }

    close(f);
    close(rndf);

    return 0;
}
