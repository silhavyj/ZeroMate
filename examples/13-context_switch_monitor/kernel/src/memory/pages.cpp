#include <memory/pages.h>
#include <drivers/monitor.h>

CPage_Manager sPage_Manager;

static unsigned fast_divide(unsigned dividend, unsigned divisor) {
    unsigned quotient = 0;
    unsigned temp = divisor;

    // Shift the divisor left until it's greater than or equal to the dividend
    while (temp <= dividend) {
        temp <<= 1;
    }

    // Shift the result right and subtract the divisor repeatedly
    while (divisor <= temp) {
        quotient <<= 1;
        if (dividend >= temp) {
            dividend -= temp;
            quotient |= 1;
        }
        temp >>= 1;
    }

    return quotient;
}

unsigned fast_modulus(unsigned dividend, unsigned divisor) {
    unsigned temp = divisor;

    // Shift the divisor left until it's greater than or equal to the dividend
    while (temp <= dividend) {
        temp <<= 1;
    }

    // Subtract the divisor repeatedly and shift it right until it's less than the original divisor
    while (divisor <= temp) {
        if (dividend >= temp) {
            dividend -= temp;
        }
        temp >>= 1;
    }

    return dividend;
}

CPage_Manager::CPage_Manager()
{
    // zadna stranka neni alokovana
    for (int i = 0; i < sizeof(mPage_Bitmap); i++)
        mPage_Bitmap[i] = 0;

    // nutno dodat, ze strankovatelna pamet implicitne nezahrnuje pamet, kam se nahralo jadro
}

void CPage_Manager::Mark(uint32_t page_idx, bool used)
{
    if (used)
        mPage_Bitmap[fast_divide(page_idx, 8)] |= 1 << fast_modulus(page_idx, 8);
    else
        mPage_Bitmap[fast_divide(page_idx, 8)] &= ~(1 << fast_modulus(page_idx, 8));
}

uint32_t CPage_Manager::Alloc_Page()
{
    // VELMI jednoduchy alokator stranek, prochazi bitmapu a hleda prvni volne misto
    // to je samozrejme O(n) a pro prakticke pouziti ne uplne dobre, ale k tomuto problemu az jindy

    uint32_t i, j;
    
    sMonitor << "mem::PageCount = \0" << mem::PageCount << '\n';

    // projdeme vsechny stranky
    for (i = 0; i < mem::PageCount; i++)
    {
        // je v dane osmici volna nejaka stranka? (0xFF = vse obsazeno)
        if (mPage_Bitmap[i] != 0xFF)
        {
            // projdeme vsechny bity a najdeme ten co je volny
            for (j = 0; j < 8; j++)
            {
                const uint32_t slot = mPage_Bitmap[i];
                const uint32_t mask = 1 << j; 
                
                if ((slot & mask) == 0)
                {
                    // oznacime 
                    const uint32_t page_idx = i*8 + j;
                    sMonitor << "j = \0" << j << '\n';
                    sMonitor << "mPage_Bitmap[i] = \0" << (unsigned int)mPage_Bitmap[i] << '\n';
                    sMonitor << (unsigned int)mPage_Bitmap[fast_divide(page_idx, 8)] << '\n';
                    Mark(page_idx, true);
                    sMonitor << (unsigned int)mPage_Bitmap[fast_divide(page_idx, 8)] << '\n';
                    
                    return mem::LowMemory + page_idx * mem::PageSize;
                }
            }
        }
    }

    return 0;
}

void CPage_Manager::Free_Page(uint32_t fa)
{
    // pro vyssi bezpecnost v nejakych safe systemech lze tady data stranky premazavat napr. nulami po dealokaci

    Mark(fa / mem::PageSize, false);
}
