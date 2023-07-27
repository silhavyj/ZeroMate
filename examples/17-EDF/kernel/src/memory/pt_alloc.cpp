#include <memory/pt_alloc.h>
#include <memory/pages.h>

CPage_Table_Allocator sPT_Alloc;

CPage_Table_Allocator::CPage_Table_Allocator()
: PT_Page(nullptr)
{
    //
}

uint32_t* CPage_Table_Allocator::Alloc()
{
    // alokovat stranku pro tabulky, pokud to jeste nikdo neudelal
    if (!PT_Page)
    {
        PT_Page = reinterpret_cast<uint8_t*>(sPage_Manager.Alloc_Page());
        if (!PT_Page)
            return nullptr;

        // vynulujeme - jeste nic neni alokovano
        for (unsigned int i = 0; i < sizeof(PT_Bitmap); i++)
            PT_Bitmap[i] = 0;
    }

    // najdeme first-fit
    for (unsigned int i = 0; i < sizeof(PT_Bitmap); i++)
    {
        if (PT_Bitmap[i] != 0xFF)
        {
            for (unsigned int j = 0; j < 8; j++)
            {
                if ((PT_Bitmap[i] & (1 << j)) == 0)
                {
                    uint32_t pt_idx = (i * 8 + j);

                    PT_Bitmap[pt_idx / 8] |= (1 << (pt_idx % 8));

                    return reinterpret_cast<uint32_t*>(PT_Page + pt_idx * PT_Size_Bytes);
                }
            }
        }
    }

    return nullptr;
}

void CPage_Table_Allocator::Free(uint32_t* pt)
{
    uint32_t pt_idx = (reinterpret_cast<uint32_t>(pt) - reinterpret_cast<uint32_t>(PT_Page)) / PT_Size_Bytes;

    PT_Bitmap[pt_idx / 8] &= ~(1 << (pt_idx % 8));
}
