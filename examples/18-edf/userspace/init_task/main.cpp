#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    // systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen
    // tehdy, kdy nic jineho nikdo nema na praci

    // nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
    set_task_deadline(Indefinite);

    // TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty

    while (true)
    {
        // kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
        // if (get_active_process_count() == 1)
        //	asm volatile("wfe");

        // predame zbytek casoveho kvanta dalsimu procesu
        // sched_yield();
    }

    return 0;
}