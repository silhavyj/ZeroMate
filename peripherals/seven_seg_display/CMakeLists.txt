include_guard()

# Specify the minimum required version of CMake
cmake_minimum_required(VERSION 3.21)

# Add the seven_seg_display peripheral as a shared library
add_library(seven_seg_display SHARED)

# Define the ZM_EXTERNAL_PERIPHERAL_EXPORT macro
target_compile_definitions(seven_seg_display
    PRIVATE 
        ZM_EXTERNAL_PERIPHERAL_EXPORT
)

# Specify the public and private include directories
target_include_directories(seven_seg_display
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui
)

# Specify the source file making up the seven_seg_display peripheral
target_sources(seven_seg_display
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/seven_seg_display.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/seven_seg_display.cpp
)

# Link imgui_glfw and logging_system to the seven_seg_display library so the peripheral can
# render itself and log messages to the logging system
target_link_libraries(seven_seg_display
    PRIVATE
        imgui_glfw
        logging_system
)

# Copy the shared library into the output/peripherals directory
set(output_directory ${PROJECT_SOURCE_DIR}/output/peripherals)

add_custom_command(TARGET seven_seg_display 
    POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:seven_seg_display> ${output_directory}
)