# Serial terminal

The serial terminal needs to connected to GPIO pins - RX, and TX. It communicates via the UART protocol. However, only from the terminal's perspective, only the RX channel is used, making the it a write-only external device.

## Configuration

```json
{
  "peripherals": [
    {
      "name" : "Serial terminal",
      "pins" : [ 14, 15 ],
      "comment" : "pins: [RX, TX]",
      "lib_dir" : "peripherals",
      "lib_name" : "serial_terminal"
    }
  ]
}
```