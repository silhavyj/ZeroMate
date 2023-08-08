# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the ssd1306_oled peripheral as a shared library
add_library(ssd1306_oled SHARED)

# Specify the public and private include directories
target_include_directories(
        ssd1306_oled
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui)

# Specify the source file making up the ssd1306_oled peripheral
target_sources(
        ssd1306_oled
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/ssd1306_oled.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/ssd1306_oled.cpp)

# Link imgui_glfw and logger to the ssd1306_oled library so the peripheral can
# render itself and log messages to the logging system
target_link_libraries(
        ssd1306_oled
        PRIVATE
        imgui_glfw
        logger)

# Copy the shared library into the output/peripherals directory
set(output_directory ${PROJECT_SOURCE_DIR}/output/peripherals)
add_custom_command(
        TARGET ssd1306_oled POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:ssd1306_oled> ${output_directory})