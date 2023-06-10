add_library(button SHARED)

target_include_directories(
    button
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../../include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src)

target_sources(
    button
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/button.cpp)