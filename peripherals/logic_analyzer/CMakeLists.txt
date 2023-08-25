# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the logic_analyzer peripheral as a shared library
add_library(logic_analyzer SHARED)

# Specify the public and private include directories
target_include_directories(
    logic_analyzer
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui)

# Specify the source file making up the logic_analyzer peripheral
target_sources(
    logic_analyzer
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/logic_analyzer.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/logic_analyzer.cpp)

# Link imgui_glfw and logging_system to the logic_analyzer library so the peripheral can
# render itself and log messages to the logging system
target_link_libraries(
    logic_analyzer
    PRIVATE
        imgui_glfw
        logging_system)

# Copy the shared library into the output/peripherals directory
set(output_directory ${PROJECT_SOURCE_DIR}/output/peripherals)
add_custom_command(
    TARGET logic_analyzer POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:logic_analyzer> ${output_directory})