# User manual

The purpose of this manual is to demonstrate the use of the ZeroMate emulator. 

The user is assumed to have a built executable of the emulator on their machine (see also the [build](build.md) document which is a walkthrough of building the emulator from the source code).

## External peripherals

Prior to launching the application, the user can define what external peripherals should be connected to the system in [peripherals.json](../peripherals.json). They need to keep in mind that while there can be multiple instance of the same peripheral loaded at the same time, they all need to have a unique name.

## First launch

When the user opens up the application for the first time, they may need to move aside all external peripherals that are connected to the emulator as shown blow. On the next start of the applications, all windows will be placed to where they were when the application was closed.

<img src="../misc/screenshots/gifs/first_launch.gif">

The layout of the windows making up the emulator is pre-defined. However, they can customize it as they wish.

## Loading a kernel ELF file

*File -> Load -> Kernel*

There is only one kernel that can be loaded at a time. If another kernel is loaded, the previous one is erased from the RAM.

<img src="../misc/screenshots/gifs/kernel_loading.gif">

## Loading user processes

*File -> Load -> Processes*

The user can also load user processes. However, these processes are not mapped into the RAM in any way. They only serve as a visualization of the program execution. They can be used to set breakpoint but it is up to user (the author of the kernel) to distinguish what address space is currently active.

<img src="../misc/screenshots/gifs/process_loading.gif">

## Examples

For more examples of how the emulator can be used, please see the [full list of examples](../examples/README.md) .