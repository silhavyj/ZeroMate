
using ctor_ptr = void (*)(void);
using dtor_ptr = void (*)(void);

// zacatek .bss sekce
extern "C" int _bss_start;
// konec .bss sekce
extern "C" int _bss_end;

// zacatek pole konstruktoru
extern "C" ctor_ptr __CTOR_LIST__[0];
// konec pole konstruktoru
extern "C" ctor_ptr __CTOR_END__[0];

// zacatek pole destruktoru
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _c_startup(void)
{
	int* i;
	
	// vynulujeme .bss sekci
	for (i = (int*)_bss_start; i < (int*)_bss_end; i++)
		*i = 0;
	
	return 0;
}

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
