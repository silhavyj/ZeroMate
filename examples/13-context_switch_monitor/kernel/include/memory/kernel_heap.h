#pragma once

#include <hal/intdef.h>

// jednoduchy first-fit alokator kernelove pameti

// struktura, ktera bude predchazet kazdemu alokovanemu bloku na kernelove halde
struct TKernel_Heap_Chunk_Header
{
    TKernel_Heap_Chunk_Header* prev;
    TKernel_Heap_Chunk_Header* next;
    uint32_t size;
    bool is_free;
};

class CKernel_Heap_Manager
{
    private:
        TKernel_Heap_Chunk_Header* mFirst;

        TKernel_Heap_Chunk_Header* Alloc_Next_Page();

    public:
        CKernel_Heap_Manager();

        void* Alloc(uint32_t size);
        void Free(void* mem);

        template<class T>
        T* Alloc()
        {
            return reinterpret_cast<T*>(Alloc(sizeof(T)));
        }
};

extern CKernel_Heap_Manager sKernelMem;
