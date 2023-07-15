# Building the emulator from the source code

## Requirements

To build the emulator from the source code, the user needs to have [CMake](https://cmake.org/), a C++ compiler, and a build system of their choice installed on their machine. However, it is recommended to use the following combinations to ensure a smooth build process:

- Windows: [Microsoft Visual Studio](https://visualstudio.microsoft.com/) + MSVC
- Linux: Makefiles + [GCC](https://gcc.gnu.org/)

Other build systems and compilers can also be used. These recommendations are based on the combinations used during the development of the emulator, increasing the likelihood of a successful build. The user can also use [CMakePresets.json](../CMakePresets.json) to automate the build process.

ZeroMate utilizes several external libraries. However, the user does not need to worry about them, as they are automatically downloaded, built, and linked via CMake.

The only essential dependency that must already be present on the user's machine is [OpenGL](https://www.opengl.org/), which is most likely already included by default.

## Cloning

First of all, the user needs to **recursively** clone the repository by running the following command:

```
git clone --recursive https://github.com/silhavyj/ZeroMate.git
```

The recursive version of the clone commands ensures that all submodules are cloned as well. 

## Build

### Windows

First, the user needs to navigate to the root folder of the project structure, where the root [CMakeLists.txt](../CMakeLists.txt) is located, and run the following command.

```
cmake --preset=msvc
```

Once the command has finished, the `.sln` file should be located in `build/msvc`. This file can be opened using Microsoft Visual Studio. The actual build can be then done from the IDE itself.

### Linux

The process of building the emulator on Linux is nearly identical. The user can choose whether they want to build for debugging or release. It is recommended to choose the release option as it incorporates various optimizations.

#### Debug

```
cmake --preset=unix_debug
```

```
cmake --build build/unix_makefiles/debug -j10
```
#### Release

```
cmake --preset=unix_release
```

```
cmake --build build/unix_makefiles/release -j10
```

## Output

After a successful build on either platform, you can find all the output files in the output folder, which is located in the root directory of the project structure.

```
.
├── fonts                      # custom fonts
├── icons                      # GUI icons
├── imgui.ini                  # window layout
├── logger.dll                 # logging library
├── logos                      # application logo
├── peripherals                # external peripherals
│   ├── button.dll
│   ├── dip_switch.dll
│   ├── led.dll
│   └── seven_seg_display.dll
├── peripherals.json           # config of external peripherals
└── zero_mate.exe              # main executable
```