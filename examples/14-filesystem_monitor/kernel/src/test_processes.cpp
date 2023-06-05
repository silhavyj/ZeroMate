#include <stdstring.h>
#include <stdfile.h>

#include <../../kernel/include/drivers/monitor.h>

extern "C" void enable_irq();
extern "C" void disable_irq();

void Process_1()
{
	volatile int i;

	uint32_t f = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);

	disable_irq();
	sMonitor << "process 1 file descriptor = " << f << "\n";
	enable_irq();

	while (true)
	{
		write(f, "1", 1);

		for (i = 0; i < 0x400; i++)
			;

		write(f, "0", 1);

		for (i = 0; i < 0x400; i++)
			;
	}

	close(f);
}

void Process_2()
{
	volatile int i;

	const char* msg = "Hello!\n";

	uint32_t f = open("DEV:uart/0", NFile_Open_Mode::Read_Write);

	disable_irq();
	sMonitor << "process 2 file descriptor = " << f << "\n";
	enable_irq();

	while (true)
	{
		write(f, msg, strlen(msg));

		for (i = 0; i < 0x800; i++)
			;
	}

	close(f);
}

void Process_3()
{
	volatile int i;

	uint32_t f = open("DEV:gpio/19", NFile_Open_Mode::Write_Only);

	disable_irq();
	sMonitor << "process 3 file descriptor = " << f << "\n";
	enable_irq();

	while (true)
	{
		write(f, "1", 1);

		for (i = 0; i < 0x800; i++)
			;

		write(f, "0", 1);

		for (i = 0; i < 0x800; i++)
			;
	}

	close(f);
}

void Process_4()
{
	volatile int i;

	uint32_t f = open("DEV:gpio/20", NFile_Open_Mode::Write_Only);

	disable_irq();
	sMonitor << "process 4 file descriptor = " << f << "\n";
	enable_irq();

	while (true)
	{
		write(f, "1", 1);

		for (i = 0; i < 0x1600; i++)
			;

		write(f, "0", 1);

		for (i = 0; i < 0x1600; i++)
			;
	}

	close(f);
}