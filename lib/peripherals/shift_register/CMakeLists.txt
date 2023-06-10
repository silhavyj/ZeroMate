cmake_minimum_required(VERSION 3.21)

add_library(shift_register SHARED)

target_include_directories(
    shift_register
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src)

target_sources(
    shift_register
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/shift_register.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/shift_register.cpp)