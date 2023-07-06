#  <img src="misc/logos/title.svg" width="25%">

Raspberry Pi Zero Emulator

![version](https://img.shields.io/badge/version-1.0.1-green)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Doxygen Documentation](https://img.shields.io/badge/docs-doxygen-green.svg)](https://silhavyj.github.io/ZeroMate/)

[![Ubuntu](https://github.com/silhavyj/ZeroMate/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/silhavyj/ZeroMate/actions/workflows/ubuntu.yml)
[![Windows](https://github.com/silhavyj/ZeroMate/actions/workflows/windows.yml/badge.svg)](https://github.com/silhavyj/ZeroMate/actions/workflows/windows.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ecdf90cb11424b19a184ad5a34c7c820)](https://www.codacy.com/gh/silhavyj/ZeroMate/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=silhavyj/ZeroMate&amp;utm_campaign=Badge_Grade)

---

## Description

ZeroMate is an educational Raspberry Pi Zero emulator designed specifically as a **debugging tool for operating system development**. Its ultimate goal is to emulate [KIV-RTOS](https://github.com/MartinUbl/KIV-RTOS). For more information about the operating system itself, you can visit https://home.zcu.cz/~ublm/?page=vyuka&sub=os. Please keep in mind that while using the emulator, certain features may be missing or limited as it is still under active development.

## Installation

The emulator was tested on both Windows and Linux using the MSVC and gcc compiler respectively. You can download a ready-to-use executable for both platforms from the latest [release](https://github.com/silhavyj/ZeroMate/releases). Alternatively, if you are brave enough, you can attempt to [build](docs/build.md) it yourself from the source code.

## Examples 

The emulator comes with a couple of prebuilt [examples](examples/README.md) that you are encouraged to try out.

## Some of the key features

- [x] Majority of ARMv6 instructions
- [x] Stepping through the source code
- [x] RAM
- [x] GPIO
- [x] Interrupt controller
- [x] ARM timer
- [x] Memory-mapped debug monitor
- [x] TRNG (random number generator)
- [x] Exceptions
- [x] CPU modes (+ view of all banked CPU registers)
- [x] Paging
- [x] Support for external peripherals (shared libraries such as a button, LED, 7-segment display, etc.)
- [x] Loading of multiple ELF filer (kernel + separately compiled processes)
- [ ] I2C
- [ ] SPI
- [ ] UART 


<img src="misc/screenshots/screenshot-01.png">
