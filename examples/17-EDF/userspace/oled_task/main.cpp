#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>

#include <oled.h>

#include <drivers/bridges/uart_defs.h>
#include <drivers/gpio.h>

#include <process/process_manager.h>

/**
 * Displejovy task
 *
 * Zobrazuje hlasky na OLED displeji, a pokud prijde udalost od jinych tasku, zobrazi neco relevantniho k nim
 **/

const char* messages[] = {
    "I blink, therefore I am.",        "I see dead pixels.",
    "One CPU rules them all.",         "My favourite sport is ARM wrestling",
    "Old MacDonald had a farm, EIGRP",
};

int main(int argc, char** argv)
{
    COLED_Display disp("DEV:oled");
    disp.Clear(false);
    disp.Put_String(10, 10, "KIV-RTOS init...");
    disp.Flip();

    uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    uint32_t num = 0;

    sleep(0x800, 0x800);

    while (true)
    {
        // ziskame si nahodne cislo a vybereme podle toho zpravu
        read(trng_file, reinterpret_cast<char*>(&num), sizeof(num));
        const char* msg = messages[num % (sizeof(messages) / sizeof(const char*))];

        disp.Clear(false);
        disp.Put_String(0, 0, msg);
        disp.Flip();

        sleep(0x4000, 0x800); // TODO: z tohohle bude casem cekani na podminkove promenne (na eventu) s timeoutem
    }

    return 0;
}
