# 10 - GPIO interrupt

## Description

This example demonstrates the use of external GPIO interrupts. The kernel sets two types interrupts on GPIO pin 5 - rising edge and falling edge. When an external button is held down or released, it changes the state of  GPIO pin 5, which is detected by the kernel, which ten changes the state of the LED connected to pin 47. 

## External peripherals

A dip switch can also be used instead of a regular button. The difference is that a button needs to be held down for its output to be active, whereas a dip switch remains in its last position all by itself.

Here is the content of [peripherals.json](../../peripherals.json) used in this example. It connects a button and a dip switch to the same GPIO pin (pin 5). It also connects an LED to GPIO pin 47.

```json
{
  "peripherals": [
    {
      "name" : "Button",
      "connection" : [ 5 ],
      "lib_dir" : "peripherals",
      "lib_name" : "button"
    },
    {
      "name" : "DIP switch",
      "connection" : [ 5 ],
      "lib_dir" : "peripherals",
      "lib_name" : "dip_switch"
    },
    {
      "name" : "LED",
      "connection" : [ 47 ],
      "lib_dir" : "peripherals",
      "lib_name" : "led"
    }
  ]
}
```

## Demo

<img src="../../misc/screenshots/examples/10-GPIO_interrupt.gif">