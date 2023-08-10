# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the logger as a shared library
add_library(logger SHARED)

# Specify the public include directories
target_include_directories(
    logger
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

# Specify the source file making up the logger library
target_sources(
    logger
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/logger.cpp)

# Copy the library (.dll) to the output directory
set(output_directory ${PROJECT_SOURCE_DIR}/output)
add_custom_command(
    TARGET logger POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:logger> ${output_directory})