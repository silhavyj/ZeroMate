typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

int kernel_main()
{
    uint8_t mPage_Bitmap = 1U;
        
    uint32_t j = 0;
    
    if ((mPage_Bitmap & (1 << j)) == 0)
    {
        return 1;
    }
    
    return 0;
}
