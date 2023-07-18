#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>

#include <drivers/gpio.h>
#include <process/process_manager.h>

/**
 * Tilt task
 *
 * Ceka na vstup ze senzoru naklonu, a prehraje neco na buzzeru (PWM) dle naklonu
 **/

int main(int argc, char** argv)
{
    char state = '0';
    char oldstate = '0';

    uint32_t tiltsensor_file = open("DEV:gpio/23", NFile_Open_Mode::Read_Only);
    // TODO: otevrit PWM

    NGPIO_Interrupt_Type irtype;

    // irtype = NGPIO_Interrupt_Type::Rising_Edge;
    // ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

    irtype = NGPIO_Interrupt_Type::Falling_Edge;
    ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

    uint32_t logpipe = pipe("log", 32);

    while (true)
    {
        // wait(tiltsensor_file, 1);

        // "debounce" - tilt senzor bude chvili flappovat mezi vysokou a nizkou urovni
        // sleep(2, Deadline_Unchanged);

        read(tiltsensor_file, &state, 1);

        // if (state != oldstate)
        {
            if (state == '0')
            {
                write(logpipe, "Tilt UP", 7);
            }
            else
            {
                write(logpipe, "Tilt DOWN", 10);
            }
            oldstate = state;
        }

        sleep(10, Indefinite /*0x100*/);
    }

    // TODO zavrit PWM
    close(tiltsensor_file);

    return 0;
}
