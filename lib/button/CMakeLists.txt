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

target_sources(
    button
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.cpp)

target_link_libraries(
    button
    PRIVATE
        glfw
        imgui_glfw)