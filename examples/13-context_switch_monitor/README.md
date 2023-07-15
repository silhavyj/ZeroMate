# 13 - context switch & monitor

## Description

This examples showcases the use of context switching, which an essential part in any operating system. The kernel creates four processes that share their time on the CPU. Whenever its is time to switch to another process (determined by the ARM timer), the CPU stores the context of the current process and loads the context of the next one.

### Process

Onces a process is bootstrapped, it starts printing the its index number (e. g. 1) into the debug monitor.

```c++
extern "C" void Process_1()
{
    volatile int i;

    sMonitor << "Process <number>\n";

    while (true)
    {
        for (i = 0; i < 0x200; i++)
            ;

        disable_irq();
        sMonitor << '<number>';
        enable_irq();
    }
}
```

## Demo

<img src="../../misc/screenshots/gifs/examples/13-context_switch_monitor.gif">