# Building the emulator from the source code

## Requirements

To build the emulator from the source code, the user needs to have [CMake](https://cmake.org/), a C++ compiler, and a build system of their choice installed on their machine.

### 3rd party libraries

ZeroMate utilizes several external libraries. However, the user does not need to worry about them, as they are automatically downloaded, built, and linked via CMake.  The only essential dependency that must already be present on the user's machine is [OpenGL](https://www.opengl.org/), which is most likely already included by default.

## Cloning

First of all, the user needs to **recursively** clone the repository by running the following command:

```
git clone --recursive https://github.com/silhavyj/ZeroMate.git
```

The recursive version of the clone commands ensures that all submodules are cloned as well.

## Build

The user can use the predefined [CMakePresets.json](../CMakePresets.json) to run different builds according to their build system and compiler.

### List all CMake presets

The following command lists out all presets that are currently supported in the project.

```
cmake --list-presets
```

Here is an example of the output may look like:

```
c:\ZeroMate>cmake --list-presets
Available configure presets:

  "unix_makefiles_gcc_release"
  "unix_makefiles_gcc_debug"
  "unix_makefiles_clang_release"
  "unix_makefiles_clang_debug"
  "ninja_clang_release"
  "ninja_clang_debug"
  "ninja_gcc_release"
  "ninja_gcc_debug"
  "msvc"
```

### CMake preset

For instance, if the user wants to use the [Nina](https://ninja-build.org/) build system to build a release version using the Clang compiler, they can run the following CMake preset.


```
cmake --preset ninja_clang_release
```

### CMake build

After the previous command has finished successfully, they can build the application using the following command:

```
cmake --build --preset ninja_clang_release
```

| ⚠️ WARNING: The MinGW compiler (Windows version of GCC) currently does not work |
|--|

## Output

Upon a successful build of the application, the final executable along with all its dependencies can be found in the output folder located in the root folder of the project structure.