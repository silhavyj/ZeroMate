# 16 - Paging & userspace

## Description

This examples tests out the use of paging as well as switching between privileged and non-privileged CPU modes. When the kernel is executed, it first creates three user processes:

1) [IDLE process](userspace/idle_process/main.cpp) that does nothing but yields
2) [Process 1](userspace/test_process_1/main.cpp) that keeps writing digits 0 through 9 to the 7-segment display
3) [Process 2](userspace/test_process_2/main.cpp) that utilizes the random number generator as well as the debug monitor to print out random numbers

## External peripherals

Here is the content of [peripherals.json](../../peripherals.json) used in this example. It connects four 7-segment displays in parallel to the same GPIO pins, so they all display the same number. 


```json
{
  "peripherals": [
    {
      "name" : "Display (1)",
      "pins" : [ 2, 3, 4 ],
      "comment" : "pins: latch, data, clock",
      "lib_dir" : "peripherals",
      "lib_name" : "seven_seg_display"
    },
    {
      "name" : "Display (2)",
      "pins" : [ 2, 3, 4 ],
      "comment" : "pins: latch, data, clock",
      "lib_dir" : "peripherals",
      "lib_name" : "seven_seg_display"
    },
    {
      "name" : "Display (3)",
      "pins" : [ 2, 3, 4 ],
      "comment" : "pins: latch, data, clock",
      "lib_dir" : "peripherals",
      "lib_name" : "seven_seg_display"
    },
    {
      "name" : "Display (4)",
      "pins" : [ 2, 3, 4 ],
      "comment" : "pins: latch, data, clock",
      "lib_dir" : "peripherals",
      "lib_name" : "seven_seg_display"
    }
  ]
}
```
## Demo

<img src="../../misc/screenshots/examples/16-paging_userspace.gif">