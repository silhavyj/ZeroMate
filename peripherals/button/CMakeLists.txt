# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the button peripheral as a shared library
add_library(button SHARED)

# Specify the public and private include directories
target_include_directories(
    button
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui)

# Export all symbols on Windows and create a button.lib file
set_target_properties(
    button 
    PROPERTIES
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/button.lib)

# Specify the source file making up the button peripheral
target_sources(
    button
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.cpp)

# Link imgui_glfw and logger to the button library so the peripheral can
# render itself and log messages to the logging system
target_link_libraries(
    button
    PRIVATE
        imgui_glfw
        logger)

# Copy the shared library into the output/peripherals directory
set(output_directory ${PROJECT_SOURCE_DIR}/output/peripherals)
add_custom_command(
    TARGET button POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:button> ${output_directory})