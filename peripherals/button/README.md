# Button

A button has write-only access to the GPIO pin it is connected to. For the output to be high, the button needs to be actively held down. As soon as the button is let go of, the output drops down to low again.

## Configuration 

```json
{
  "peripherals": [
    {
      "name" : "Button",
      "pins" : [ 5 ],
      "lib_dir" : "peripherals",
      "lib_name" : "button"
    }
  ]
}
```