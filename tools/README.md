# Debug monitor

## Description

This tool can be seamlessly integrated into any C++ project as it does not rely on any third-party libraries. It serves as a driver for a fictional memory-mapped 80x25 display, which was temporarily implemented in the emulator as a substitute for UART.

## Instantiation

In `monitor.cpp`, a global instance of the driver is created as follows:

```c++
CMonitor sMonitor{ 0x30000000, 80, 25 };
```

The first parameter represents the address where the peripheral will be mapped and last two parameters represent the width and height in respectively.

## Usage

```c++
#include "monitor.h"

int main()
{
    unsigned int my_var = 155;
    bool flag = false;

    sMonitor << "dec = " << my_var << '\n';
    sMonitor << "hex = " << CMonitor::NNumber_Base::HEX << my_var << '\n';
    sMonitor << "flag = " << flag << '\n';

    return 0;
}
```

You can also find the monitor being used in some of the [examples](../examples/README.md).