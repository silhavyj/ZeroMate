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

	uint32_t f = open("DEV:monitor/0", NFile_Open_Mode::Read_Write);
	uint32_t rndf = open("DEV:trng", NFile_Open_Mode::Read_Only);

	disable_irq();
	sMonitor << "process 2 file descriptor (f) = " << f << "\n";
	sMonitor << "process 2 file descriptor (rndf)= " << rndf << "\n";
	enable_irq();

	uint32_t rdbuf;
    char numbuf[16];

	while (true)
	{
		read(rndf, reinterpret_cast<char*>(&rdbuf), 4);

		bzero(numbuf, 16);
        itoa(rdbuf, numbuf, 10);

        write(f, numbuf, strlen(numbuf));

		for (i = 0; i < 0x800; i++)
			;
	}

	close(f);
	close(rndf);
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

void Process_5()
{
	volatile int i;

	uint32_t f = open("DEV:segd", NFile_Open_Mode::Write_Only);
    write(f, "4", 1);

	disable_irq();
	sMonitor << "process 5 file descriptor = " << f << "\n";
	enable_irq();

	char message[] = "0";

	while (true)
	{
		if (message[0] == '9')
		{
			message[0] = '0';
		}
		else
		{
			++message[0];
		}

		write(f, message, 1);
		
		for (i = 0; i < 0x1600; i++)
			;
	}

	close(f);
}