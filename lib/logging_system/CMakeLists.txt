include_guard()

# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the logging_system as a shared library
add_library(logging_system SHARED)

# Define the ZM_EXTERNAL_PERIPHERAL_EXPORT macro
target_compile_definitions(logging_system
    PRIVATE
        ZM_LOGGING_SYSTEM_EXPORT
)

# Specify the public include directories
target_include_directories(logging_system
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

# Specify the source file making up the logging_system library
target_sources(logging_system
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/logging_system.cpp
)

# Copy the library (.dll) to the output directory
set(output_directory ${PROJECT_SOURCE_DIR}/output)

add_custom_command(TARGET logging_system
    POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:logging_system> ${output_directory}
)