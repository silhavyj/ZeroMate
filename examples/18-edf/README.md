# 18 - EDF

## Description

This example demonstrates multiple user processes being controlled by an EDF (Earliest Deadline First) scheduler.

The kernel creates 5 user processes:
1) [init task](userspace/init_task/main.cpp) that does nothing (infinite loop).
2) [counter task](userspace/counter_task/main.cpp) that displays digits 0 through 9 to a 7-segment display
    - the speed can be controlled via a dip switch connected to GPIO pin 17
    - the direction of the counter (ascending / descending) can be controlled via another dip switch connected to pin 23
3) [sos tak](userspace/sos_task/main.cpp) that upon a press of a button connected to pin 16 sends an SOS signal to an output LED connected to pin 18
4) [logger task](userspace/logger_task/main.cpp) that receives messages from other processes through a pipe (IPC) and prints them out to the memory-mapped debug monitor
5) [titl task](userspace/tilt_task/main.cpp) that reads data from a tilt sensor (mocked by a button) and sends its current state to the logger task through a shared pipe

## !! Limitations !!

There are a few limitations embedded in this example, which might need to be addressed in the future.

1) The init task is indeed just an infinite loop (no yielding is taking place)
2) The lilt task does not wait on GPIO pin 23 nor does it sleep to compensate for flapping
3) Some timing adjustments were made (real HW offers a faster execution compared to the emulator)

## External peripherals

Here is the content of [peripherals.json](../../peripherals.json) used in this example.

```json
{
  "peripherals": [
    {
      "name" : "7-segment display",
      "pins" : [ 22, 27, 10 ],
      "comment" : "pins: latch, data, clock",
      "lib_dir" : "peripherals",
      "lib_name" : "seven_seg_display"
    },
    {
      "name" : "Direction",
      "pins" : [ 4 ],
      "lib_dir" : "peripherals",
      "lib_name" : "dip_switch"
    },
    {
      "name" : "Speed",
      "pins" : [ 17 ],
      "lib_dir" : "peripherals",
      "lib_name" : "dip_switch"
    },
    {
      "name" : "SOS btn",
      "pins" : [ 16 ],
      "lib_dir" : "peripherals",
      "lib_name" : "button"
    },
    {
      "name" : "SOS LED",
      "pins" : [ 18 ],
      "lib_dir" : "peripherals",
      "lib_name" : "led"
    },
    {
      "name" : "titl btn",
      "pins" : [ 23 ],
      "lib_dir" : "peripherals",
      "lib_name" : "button"
    }
  ]
}
```

## Demo

<img src="../../misc/screenshots/gifs/examples/18-EDF.gif">