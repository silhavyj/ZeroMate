# External peripherals

Here is a list of external peripherals that come with the emulator. They are all compiled separately as dynamic libraries (`.dll` on Windows and `.so` on Linux). These libraries are loaded at runtime and have access to GPIO pins, as specified in [peripherals.json](../peripherals.json).

- [button](button/README.md)
- [dip switch](dip_switch/README.md)
- [LED](led/README.md)
- [logic analyzer](logic_analyzer/README.md)
- [serial terminal](serial_terminal/README.md)
- [7-segment display](seven_seg_display/README.md)