#pragma once

using spinlock_t = int;

constexpr uint32_t Lock_Unlocked = 0;
constexpr uint32_t Lock_Locked = 1;

extern "C" void spinlock_init(spinlock_t* lock);
extern "C" uint32_t spinlock_try_lock(spinlock_t* lock);
extern "C" void spinlock_unlock(spinlock_t* lock);

inline void spinlock_lock(spinlock_t* lock)
{
    while (!spinlock_try_lock(lock))
        ;
}
