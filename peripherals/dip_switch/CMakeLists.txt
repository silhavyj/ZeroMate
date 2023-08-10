# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the dip_switch peripheral as a shared library
add_library(dip_switch SHARED)

# Specify the public and private include directories
target_include_directories(
    dip_switch
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui)

# Specify the source file making up the dip_switch peripheral
target_sources(
    dip_switch
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/dip_switch.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/dip_switch.cpp)

# Link imgui_glfw and logger to the dip_switch library so the peripheral can
# render itself and log messages to the logging system
target_link_libraries(
    dip_switch
    PRIVATE
        imgui_glfw
        logger)

# Copy the shared library into the output/peripherals directory
set(output_directory ${PROJECT_SOURCE_DIR}/output/peripherals)
add_custom_command(
    TARGET dip_switch POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:dip_switch> ${output_directory})