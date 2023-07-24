.section .text

.global mmu_invalidate_cache
mmu_invalidate_cache:
    mov r1, #0
    mcr p15, 0, r1, c7, c7, 0
    bx lr

.global mmu_data_sync_barrier
mmu_data_sync_barrier:
    mov r1, #0
    mcr p15, 0, r1, c7, c10, 4          ;@ data synchronization barrier
    bx lr

.global mmu_invalidate_tlb
mmu_invalidate_tlb:
    push {lr}
    mov r1, #0
    mcr p15, 0, r1, c8, c7, 0           ;@ invalidovani zaznamu v TLB
    bl mmu_data_sync_barrier
    pop {pc}
