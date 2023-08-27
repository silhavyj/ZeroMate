#include <hal/intdef.h>
#include <hal/peripherals.h>
#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <interrupt_controller.h>

volatile int game_state = 0;
volatile int max_num = 100;
volatile int min_num = 0;
volatile int middle;

void Guessing_Game(char c)
{
    bool greater;

    switch (game_state)
    {
        case 0:
            if (c == 'y' || c == 'Y')
            {
                game_state = 1;
                sUART0.Write("Awesome! Let's get started then...\n\r");
            }
            else
            {
                sUART0.Write("Don't worry, we can always play the game next time! Have a good one :)");
                game_state = 0xFFFFFFFFU;
                break;
            }

        case 1:
            sUART0.Write("Is your number greater than ");
            middle = min_num + (max_num - min_num) / 2;
            sUART0.Write(middle);
            sUART0.Write("? [y/n]: ");
            game_state = 2;
            break;

        case 2:
            if (c == 'y' || c == 'Y')
            {
                min_num = middle + 1;
                greater = true;
            }
            else
            {
                max_num = middle - 1;
                greater = false;
            }

            if (min_num > max_num)
            {
                sUART0.Write("The number you're thinking of must be ");
                sUART0.Write(min_num);
                sUART0.Write("!\n\r");
                sUART0.Write("Do you wanna play again? [y/n]: ");
                game_state = 3;
                break;
            }

            middle = min_num + (max_num - min_num) / 2;
            sUART0.Write("Is your number greater than ");
            sUART0.Write(middle);
            sUART0.Write("? [y/n]: ");

            break;

        case 3:
            if (c == 'y' || c == 'Y')
            {
                min_num = 0;
                max_num = 100;

                sUART0.Write("Is your number greater than ");
                middle = min_num + (max_num - min_num) / 2;
                sUART0.Write(middle);
                sUART0.Write("? [y/n]: ");
                game_state = 2;
            }
            else
            {
                sUART0.Write("See you next time!\n\r");
                game_state = 0xFFFFFFFFU;
            }
            break;

        default:
            break;
    }
}

extern "C" void __attribute__((interrupt("SWI"))) software_interrupt_handler()
{
}

extern "C" void __attribute__((interrupt("IRQ"))) irq_handler()
{
    char c;

    sUART0.Read(&c);
    if (c == '\n' || c == '\r')
        return;

    Guessing_Game(c);
}

extern "C" void __attribute__((interrupt("FIQ"))) fast_interrupt_handler()
{
}

CInterrupt_Controller sInterruptCtl(hal::Interrupt_Controller_Base);

CInterrupt_Controller::CInterrupt_Controller(unsigned long base)
: mInterrupt_Regs(reinterpret_cast<unsigned int*>(base))
{
}

volatile unsigned int& CInterrupt_Controller::Regs(hal::Interrupt_Controller_Reg reg)
{
    return mInterrupt_Regs[static_cast<unsigned int>(reg)];
}

void CInterrupt_Controller::Enable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Enable) = (1 << static_cast<unsigned int>(source_idx));
}

void CInterrupt_Controller::Disable_Basic_IRQ(hal::IRQ_Basic_Source source_idx)
{
    Regs(hal::Interrupt_Controller_Reg::IRQ_Basic_Disable) = (1 << static_cast<unsigned int>(source_idx));
}

void CInterrupt_Controller::Enable_IRQ(hal::IRQ_Source source_idx)
{
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Enable_1 : hal::Interrupt_Controller_Reg::IRQ_Enable_2) =
    (1 << (idx_base % 32));
}

void CInterrupt_Controller::Disable_IRQ(hal::IRQ_Source source_idx)
{
    const unsigned int idx_base = static_cast<unsigned int>(source_idx);

    Regs(idx_base < 32 ? hal::Interrupt_Controller_Reg::IRQ_Disable_1 : hal::Interrupt_Controller_Reg::IRQ_Disable_2) =
    (1 << (idx_base % 32));
}
