
namespace __cxxabiv1
{
    __extension__ typedef int __guard __attribute__((mode(__DI__)));

    extern "C" int __cxa_guard_acquire(__guard*);
    extern "C" void __cxa_guard_release(__guard*);
    extern "C" void __cxa_guard_abort(__guard*);

    extern "C" int __cxa_guard_acquire(__guard* g)
    {
        return !*(char*)(g);
    }

    extern "C" void __cxa_guard_release(__guard* g)
    {
        *(char*)g = 1;
    }

    extern "C" void __cxa_guard_abort(__guard*)
    {
    }
}

extern "C" void __dso_handle()
{
    // ignore dtors for now
}

extern "C" void __cxa_atexit()
{
    // ignore dtors for now
}

extern "C" void __cxa_pure_virtual()
{
    // pure virtual method called
}

extern "C" void __aeabi_unwind_cpp_pr1()
{
    while (true)
        ;
}

using ctor_ptr = void (*)(void);
using dtor_ptr = void (*)(void);

// zacatek pole konstruktoru
extern "C" ctor_ptr __CTOR_LIST__[0];
// konec pole konstruktoru
extern "C" ctor_ptr __CTOR_END__[0];

// zacatek pole destruktoru
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    ctor_ptr* fnptr;

    // zavolame konstruktory globalnich C++ trid
    // v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
    for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
        (*fnptr)();

    return 0;
}

extern "C" int _cpp_shutdown(void)
{
    dtor_ptr* fnptr;

    // zavolame destruktory globalnich C++ trid
    for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
        (*fnptr)();

    return 0;
}
