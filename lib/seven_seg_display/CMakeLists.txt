cmake_minimum_required(VERSION 3.21)

add_library(seven_seg_display SHARED)

target_include_directories(
    seven_seg_display
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../../external/imgui)

target_sources(
    seven_seg_display
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/seven_seg_display.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/seven_seg_display.cpp)

target_link_libraries(
    seven_seg_display
    PRIVATE
        glfw
        imgui_glfw)