cmake_minimum_required(VERSION 3.21)

# General info about the project
project(
    ZeroMate
    VERSION 0.0.1
    DESCRIPTION "Raspberry Pi Zero emulator"
    HOMEPAGE_URL "https://github.com/silhavyj/ZeroMate"
    LANGUAGES C CXX)

# Enable parallel build
set(CMAKE_BUILD_PARALLEL_LEVEL 4)

# Default version of C++ is set to 20 unless the user has defined it otherwise
if(NOT DEFINED CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
else()
    set(CMAKE_CXX_STANDARD ${CXX_STANDARD})
endif()
message("Using C++ standard ${CMAKE_CXX_STANDARD}")

# Standard project settings
include(cmake/standard_project_settings.cmake)

# Install conan using PyPI
find_package(Python COMPONENTS Interpreter REQUIRED)
execute_process(COMMAND ${Python_EXECUTABLE} -m pip install --upgrade pip setuptools conan)

add_library(project_warnings INTERFACE)
add_library(project_options INTERFACE)

target_compile_features(project_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

# Standard compiler warnings
include(cmake/compiler_warnings.cmake)
set_project_warnings(project_warnings)

# Add sanitizer options if supported by the compiler
include(cmake/sanitizers.cmake)
enable_sanitizers(project_options)

# Allow for static analysis option
include(cmake/static_analyzers.cmake)

# Set up some extra Conan dependencies based on our needs before loading Conan
set(CONAN_EXTRA_REQUIRES
    "gtest/1.11.0"
    "spdlog/1.11.0"
    "fmt/9.1.0"
    "imgui/cci.20220621+1.88.docking"
    "glfw/3.3.6"
    "glew/2.2.0")

set(CONAN_EXTRA_IMPORTS "")

set(CONAN_EXTRA_OPTIONS "")

# Enable conan package manager
include(cmake/conan.cmake)
run_conan()

# Add the imgui_glfw folder 
add_subdirectory(external/imgui_glfw)

# Add the src folder
add_subdirectory(src)

# Add an option to enable testing
option(ENABLE_TESTING "Enable Test Builds" ON)

# Add tests
if(ENABLE_TESTING)
    enable_testing()
    add_subdirectory(test)
endif()

# EOF
