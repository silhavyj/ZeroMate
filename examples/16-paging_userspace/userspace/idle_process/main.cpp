#include <stdfile.h>

int main(int argc, char** argv)
{
    // tady budeme mozna v budoucnu chtit resit treba uspavani, aby nas system nezral vic elektricke energie, nez je
    // treba

    while (true)
    {
        // predame zbytek casoveho kvanta dalsimu procesu
        sched_yield();
    }

    return 0;
}