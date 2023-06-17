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

if (WIN32)
    set(output_directory ${PROJECT_SOURCE_DIR}/output)
    add_custom_command(
        TARGET logger POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:logger> ${output_directory})
endif()