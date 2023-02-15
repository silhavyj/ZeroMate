# Build of the application

<p float="left">
    <img src="../misc/img/logo/conan.png" width=50>
    <img src="../misc/img/logo/cmake.png" width=100>
</p>

## Dependencies

In order to successfully build the project, the user is required to have the following dependencies installed on their system.

* [CMake](https://cmake.org/) version 3.21 or later
* [Python3](https://www.python.org/downloads/) & [PyPI](https://pypi.org/)
* `C/C++` compiler (the application was developed using `gcc 11.2.0`)

The first two dependencies are required regardless of the `C/C++` compiler or the build system. The application was written with two main build systems in mind - **Microsoft Visual Studio** and **Unix-like** systems which use traditional Makefiles.

### Linux
Installing dependencies on a Linux system is straightforward. The user can install both `CMake` and `Python3` using the `apt` package manager. The majority of Linux distributions come with `gcc` and `g++` compilers out of the box.

### Windows

If the user uses Windows, they can build the application using either option. However, if they decide to go with Makefiles, they also need to have `make` and a `C/C++` compiler of choice installed on their system (preferably `gcc`). Perhaps the simplest way to install `make` on Windows is by using `Chocolatey`.  An alternative way is to install `make` directly from https://gnuwin32.sourceforge.net/install.html. All executables must be added to the environment `PATH` variable. Otherwise, they will not be visible for `CMake` and the build will most likely not complete successfully.

## Third-party libraries

The application uses several third-party libraries. Nevertheless, the user is not required to do anything as they are all downloaded, built, and linked automatically using `CMake` with the help of the `conan` extension. [Conan](https://conan.io/) itself is installed automatically by `CMake`, assuming `PyPI` is found on the system. The list of all libraries used in the project can be found in `CMakeLists.txt` located in the root folder of the project structure (search for `CONAN_EXTRA_REQUIRES`). On a Windows machine, the user may also need to add the path to the `conan` executable file to their environment `PATH` variable as it is not done automatically. For most users, the executable will be installed to `C:\Users\<user>\AppData\Local\Programs\Python\<python_version>\Scripts\conan.exe`. After they have done so, they will need to log-out and log-in again for the change to take effect. 

## Build

### Visual Studio

```
cmake --preset=msvc
```

This command will generate a `.sln` file in `build/msvc/` which can be then opened using Microsoft Visual Studio. They may also need to change the startup project in Visual Studio from `ALL_BUILD` to `ZeroMate`. 

### Linux

#### Debug

```
cmake --preset=unix_debug
cmake --build build/unix_makefiles/debug
```

#### Release

```
cmake --preset=unix_release
cmake --build build/unix_makefiles/release
```

All the different options can be seen in the `CMakePresets.json` file located in the root folder of the project structure. Alternatively, the user can also build the application using, for example, the `CMake GUI` application, where they can specify their build system (IDE) as well as different `CMake` options, such as their preferable compiler. 