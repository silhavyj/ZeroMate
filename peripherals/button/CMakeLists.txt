cmake_minimum_required(VERSION 3.21)

add_library(button SHARED)

target_include_directories(
    button
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui)

set_target_properties(
    button 
    PROPERTIES
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/button.lib)

target_sources(
    button
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.cpp)

target_link_libraries(
    button
    PRIVATE
        imgui_glfw)

set(output_directory ${PROJECT_SOURCE_DIR}/output/peripherals)
add_custom_command(
    TARGET button POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:button> ${output_directory})