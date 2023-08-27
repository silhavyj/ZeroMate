# Prebuilt examples

Each example includes the source code, as well as an output folder containing ELF files that can be loaded into the emulator.

- [01 - factorial recursive](01-factorial_recursive/README.md)
- [02 - factorial non-recursive](02-factorial_non_recursive/README.md)
- [03 - fibonacci dynamic](03-fibonacci_dynamic/README.md)
- [04 - fibonacci recursive](04-fibonacci_recursive/README.md)
- [05 - fibonacci non-recursive](05-fibonacci_non_recursive/README.md)
- [06 - LED toggle](06-LED_toggle/README.md)
- [07 - LED toggle debug monitor](07-LED_toggle_debug_monitor/README.md)
- [08 - LED toggle SOS signal](08-LED_toggle_sos_signal/README.md)
- [09 - software interrupt](09-software_interrupt/README.md)
- [10 - GPIO interrupt](10-GPIO_interrupt/README.md)
- [11 - timer and GPIO interrupt](11-timer_and_GPIO_interrupt/README.md)
- [12 - timer no clear IRQ](12-timer_no_clear_IRQ/README.md)
- [13 - context switch monitor](13-context_switch_monitor/README.md)
- [14 - filesystem monitor](14-filesystem_monitor/README.md)
- [15 - DPP-01 external peripherals](15-DPP_01_external_peripherals/README.md)
- [16 - paging userspace](16-paging_userspace/README.md)
- [17 - EDF](17-EDF/README.md)
- [18 - UART](18-UART/README.md)
- [19 - I2C](19-I2C/README.md)
- [20 - UART game](20-UART_game/README.md)

If the user wants to modify or rebuild any of the examples, they are more than welcome to do so. However, they will need to have `gcc-arm-none-eabi` installed on their machine. On a Debian-based machine, it can be achieved by running the following command:

```
sudo apt install gcc-arm-none-eabi
```