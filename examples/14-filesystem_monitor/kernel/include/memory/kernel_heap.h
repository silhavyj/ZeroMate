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

// pomocne implementace pro kernel heap - tento soubor je includovat vyhradne z kernel-only implementaci, a tak proste jen presmerujeme
// vsechna volani new/delete na tyto implementace, ktere alokuji a uvolnuji pamet z haldy jadra

inline void* operator new(uint32_t size)
{
    return sKernelMem.Alloc(size);
}

inline void *operator new(uint32_t, void *p)
{
    return p;
}

inline void *operator new[](uint32_t, void *p)
{
    return p;
}

inline void operator delete(void* p)
{
    sKernelMem.Free(p);
}

inline void operator delete(void* p, uint32_t)
{
    sKernelMem.Free(p);
}

inline void  operator delete  (void *, void *)
{
}

inline void  operator delete[](void *, void *)
{
}
