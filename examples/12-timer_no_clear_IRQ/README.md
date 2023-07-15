# 12 - timer no clear IRQ

## Description

An ARM timer interrupt should be cleared once it has been handled. In this example, it is intentionally not clear in order to demonstrate what happens if it is forgotten to do so. 

```c++
void CTimer::IRQ_Callback()
{
    // Uncomment this to clear the interrupt
    //
    // Regs(hal::Timer_Reg::IRQ_Clear) = 1;

    if (mCallback)
        mCallback();
}
```

After an interrupt has been handled, it checks whether there is another pending interrupt or not, and since the interrupt is not cleared, the CPU jumps back into the exception handler, effectively doing nothing but executing the same routine over and over again.

## Demo

This can be demonstrating by setting a breakpoint at the very last instruction of the `kernel_main` function (infinite loop). If the interrupt is not cleared, once the first interrupt is triggered, the execution will never return back to the `kernel_main` function.

### Interrupt is NOT cleared

<img src="../../misc/screenshots/gifs/examples/12-timer_no_clear_IRQ_2.gif">

### Interrupt is cleared

<img src="../../misc/screenshots/gifs/examples/12-timer_no_clear_IRQ_1.gif">