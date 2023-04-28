
namespace __cxxabiv1
{
	__extension__ typedef int __guard __attribute__((mode(__DI__)));

	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
		return !*(char *)(g);
	}

	extern "C" void __cxa_guard_release (__guard *g)
	{
		*(char *)g = 1;
	}

	extern "C" void __cxa_guard_abort (__guard *)
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
