cmake_minimum_required(VERSION 3.21)

add_library(logger SHARED)

target_include_directories(
    logger
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

set_target_properties(
    logger
    PROPERTIES
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/logger.lib)

target_sources(
    logger
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/logger.cpp)