#include <drivers/monitor.h>

float custom_sin(float x)
{
    float result = 0.0F;
    float term = x;
    float sign = 1.0F;
    float factorial = 1.0F;

    for (int i = 0; i < 10; i++)
    {
        result += sign * term;
        sign = -sign;
        term = term * x * x / ((2 * i + 2) * (2 * i + 3));
    }

    return result;
}

extern "C" int _kernel_main(void)
{
    sMonitor.Clear();

    float angle = 0.0F;
    float frequency = 1.0F;

    const float M_PI = 3.14159265358979323846F;

    while (1)
    {
        float value = custom_sin(angle);
        int numStars = (int)((value + 1.0F) * 40.F);

        for (int i = 0; i < numStars; i++)
        {
            sMonitor << '*';
        }

        sMonitor << '\n';

        angle += 0.1F * frequency;
        if (angle >= 2.0F * M_PI)
        {
            angle -= 2.0F * M_PI;
        }
    }

    return 0;
}
