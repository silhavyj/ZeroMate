#include <memory/kernel_heap.h>
#include <memory/pages.h>

CKernel_Heap_Manager sKernelMem;

CKernel_Heap_Manager::CKernel_Heap_Manager()
: mFirst{ nullptr }
{
    //
}

TKernel_Heap_Chunk_Header* CKernel_Heap_Manager::Alloc_Next_Page()
{
    TKernel_Heap_Chunk_Header* chunk = reinterpret_cast<TKernel_Heap_Chunk_Header*>(sPage_Manager.Alloc_Page());
    chunk->prev = nullptr;
    chunk->next = nullptr;
    chunk->size =
    mem::PageSize - sizeof(TKernel_Heap_Chunk_Header); // z alokovane stranky musime ubrat velikost hlavicky
    chunk->is_free = true;

    return chunk;
}

void* CKernel_Heap_Manager::Alloc(uint32_t size)
{
    // zatim neumime alokovat >4kB, protoze zatim nemame virtualni pamet a tedy negarantujeme souvisly kus pameti
    // (mozne, ale zbytecne nakladne)
    if (size > mem::PageSize - sizeof(TKernel_Heap_Chunk_Header))
        return nullptr;

    if (!mFirst)
        mFirst = Alloc_Next_Page();

    TKernel_Heap_Chunk_Header* chunk = mFirst;
    TKernel_Heap_Chunk_Header* last = mFirst;

    // potrebujeme najit prvni blok, ktery je volny a zaroven alespon tak velky, jak potrebujeme (pro ted pouzivame
    // proste first-fit)
    while (chunk != nullptr && (!chunk->is_free || chunk->size < size))
    {
        last = chunk;
        chunk = chunk->next;
    }

    // jiz nemame volnou diru - alokujeme dalsi stranku o 4kB
    if (!chunk)
    {
        last->next = Alloc_Next_Page();
        chunk = last->next;
    }

    // pokud je pozadovane misto uz tak velke, jak potrebujeme, tak je to snadne - jen ho oznacime za alokovane a
    // vratime vzdy zarovname tak, aby se do dalsiho potencialniho bloku vesla alespon hlavicka dalsiho bloku a nejaky
    // overlap (alespon jeden bajt)
    if (chunk->size >= size && chunk->size <= size + sizeof(TKernel_Heap_Chunk_Header) + 1)
    {
        chunk->is_free = false;
        return reinterpret_cast<uint8_t*>(chunk) +
               sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
    }

    // pokud je vetsi, musime blok rozdelit
    // to, ze se tam vejde dalsi hlavicka jsme garantovali prekryvem, viz vyse

    TKernel_Heap_Chunk_Header* hdr2 = reinterpret_cast<TKernel_Heap_Chunk_Header*>(
    reinterpret_cast<uint8_t*>(chunk) + sizeof(TKernel_Heap_Chunk_Header) + size);

    hdr2->size = chunk->size - size - sizeof(TKernel_Heap_Chunk_Header);

    hdr2->prev = chunk;
    hdr2->next = chunk->next;
    hdr2->is_free = true;
    chunk->next = hdr2;

    chunk->size = size;
    chunk->is_free = false;

    return reinterpret_cast<uint8_t*>(chunk) +
           sizeof(TKernel_Heap_Chunk_Header); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce
}

void CKernel_Heap_Manager::Free(void* mem)
{
    TKernel_Heap_Chunk_Header* chunk =
    reinterpret_cast<TKernel_Heap_Chunk_Header*>(reinterpret_cast<uint8_t*>(mem) - sizeof(TKernel_Heap_Chunk_Header));

    chunk->is_free = true;

    // pokud je dalsi blok volny, spojme tento a dalsi blok do jednoho
    if (chunk->next && chunk->next->is_free)
    {
        chunk->size += chunk->next->size + sizeof(TKernel_Heap_Chunk_Header); // zvetsit soucasny
        chunk->next = chunk->next->next; // navazat nasledujici nasledujiciho jako dalsi
        chunk->next->prev = chunk;       // nasledujicimu nastavit predchozi na sebe
    }

    // pokud je predchozi blok volny, spojme predchozi a tento blok do jednoho
    if (chunk->prev && chunk->prev->is_free)
    {
        chunk->prev->size += chunk->size + sizeof(TKernel_Heap_Chunk_Header);
        chunk->prev->next = chunk->next;
        chunk->next->prev = chunk->prev;
    }
}