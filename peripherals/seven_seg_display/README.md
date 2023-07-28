# 7-segment display

The 7-segment display is controlled via an 8-bit shift register and it is capable of displaying digits 0 through 9. The shift register can be controlled via its pins - latch, data, and clock.

## Configuration

```json
{
  "peripherals": [
    {
      "name" : "7-segment display",
      "pins" : [ 22, 27, 10 ],
      "comment" : "pins: latch, data, clock",
      "lib_dir" : "peripherals",
      "lib_name" : "seven_seg_display"
    }
  ]
}
```