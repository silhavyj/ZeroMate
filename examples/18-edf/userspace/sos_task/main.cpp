#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>

#include <drivers/gpio.h>
#include <process/process_manager.h>

#include <oled.h>

/**
 * SOS blinker task
 *
 * Ceka na stisk tlacitka, po stisku vyblika LEDkou "SOS" signal
 **/

constexpr uint32_t symbol_tick_delay = 8;
constexpr uint32_t char_tick_delay = 2;

uint32_t sos_led;
uint32_t button;

void blink(bool short_blink)
{
    write(sos_led, "1", 1);
    sleep(short_blink ? 8 : 10);
    write(sos_led, "0", 1);
}

int main(int argc, char** argv)
{
    sos_led = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);
    button = open("DEV:gpio/16", NFile_Open_Mode::Read_Only);

    NGPIO_Interrupt_Type irtype = NGPIO_Interrupt_Type::Rising_Edge;
    ioctl(button, NIOCtl_Operation::Enable_Event_Detection, &irtype);

    uint32_t logpipe = pipe("log", 32);

    while (true)
    {
        // pockame na stisk klavesy
        wait(button, 1, 30);

        // tady by se mohla hodit inverze priorit:
        // 1) pipe je plna
        // 2) my mame deadline 0x300
        // 3) log task ma deadline 0x1000
        // 4) jiny task ma deadline 0x500
        // jiny task dostane prednost pred log taskem, a pokud nesplni v kratkem case svou ulohu, tento task prekroci
        // deadline
        // TODO: inverzi priorit bychom docasne zvysili prioritu (zkratili deadline) log tasku, aby vyprazdnil pipe a my
        // se mohli odblokovat co nejdrive
        write(logpipe, "SOS!", 5);

        blink(true);
        sleep(symbol_tick_delay);
        blink(true);
        sleep(symbol_tick_delay);
        blink(true);

        sleep(char_tick_delay);

        blink(false);
        sleep(symbol_tick_delay);
        blink(false);
        sleep(symbol_tick_delay);
        blink(false);
        sleep(symbol_tick_delay);

        sleep(char_tick_delay);

        blink(true);
        sleep(symbol_tick_delay);
        blink(true);
        sleep(symbol_tick_delay);
        blink(true);
    }

    close(button);
    close(sos_led);

    return 0;
}
