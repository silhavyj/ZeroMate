cmake_minimum_required(VERSION 3.21)

# General info about the project
project(
    ZeroMate
    VERSION 0.3.0
    DESCRIPTION "Raspberry Pi Zero emulator"
    HOMEPAGE_URL "https://github.com/silhavyj/ZeroMate"
    LANGUAGES C CXX)

# Enable parallel build
set(CMAKE_BUILD_PARALLEL_LEVEL 4)

# Default version of C++ is set to 20
set(CMAKE_CXX_STANDARD 20)

# Standard project settings
include(cmake/standard_project_settings.cmake)

add_library(project_warnings INTERFACE)
add_library(project_options INTERFACE)

target_compile_features(project_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

# Standard compiler warnings
include(cmake/compiler_warnings.cmake)
set_project_warnings(project_warnings)

# Add sanitizer options if supported by the compiler
include(cmake/sanitizers.cmake)
enable_sanitizers(project_options)

# Turn on compiler optimizations for the Release build
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    include(cmake/compiler_optimizations.cmake)
    set_project_optimizations(project_warnings)
endif()

# Allow for static analysis option
include(cmake/static_analyzers.cmake)

# Add submodules (libraries)
add_subdirectory(external/fmt)
add_subdirectory(external/googletest)
add_subdirectory(external/elfio)
add_subdirectory(external/glew)
add_subdirectory(external/glfw)
add_subdirectory(external/magic_enum)
add_subdirectory(external/capstone)

# Add the src folder
add_subdirectory(src)

# Add tests
option(ENABLE_TESTING "Enable Test Builds" ON)
if(ENABLE_TESTING)
    enable_testing()
    add_subdirectory(test)
endif()

# Generate docs
option(BUILD_DOC "Build Documentation" ON)
if (BUILD_DOC)
    include(cmake/doxygen.cmake)
endif()

# EOF
