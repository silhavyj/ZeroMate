# External peripherals

Here is a list of external peripherals that come with the emulator. They are all compiled separately as dynamic libraries (`.dll` on Windows and `.so` on Linux). These libraries are loaded at runtime and have access to GPIO pins, as specified in [peripherals.json](../peripherals.json).

- [Button](button/README.md)
- [DIP switch](dip_switch/README.md)
- [LED](led/README.md)
- [Logic analyzer](logic_analyzer/README.md)
- [Serial terminal](serial_terminal/README.md)
- [7-segment display](seven_seg_display/README.md)
- [SSD1306 OLED](ssd1306_oled/README.md)