# 11 - ARM timer & GPIO interrupt

## Description

This examples demonstrates the use of interrupts coming 
simultaneously from multiple different peripherals. One interrupt comes periodically from the ARM timer and the second one comes from a GPIO pin (e.g. a button). The timer interrupt toggles an LED connected to pin 47 and the GPIO interrupt toggles an LED connected to pin 48.

## External peripherals

Here is the content of [peripherals.json](../../peripherals.json) used in this example. It connects two LEDs to GPIO pins 47 and 48. It also connects a button to GPIO pin 46.

```json
{
  "peripherals": [
    {
      "name" : "Button",
      "pins" : [ 46 ],
      "lib_dir" : "peripherals",
      "lib_name" : "button"
    },
    {
      "name" : "LED (timer)",
      "pins" : [ 47 ],
      "lib_dir" : "peripherals",
      "lib_name" : "led"
    },
    {
      "name" : "LED (GPIO)",
      "pins" : [ 48 ],
      "lib_dir" : "peripherals",
      "lib_name" : "led"
    }
  ]
}
```