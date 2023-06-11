add_library(
    ini
    ${CMAKE_CURRENT_SOURCE_DIR}/inih/ini.c
    ${CMAKE_CURRENT_SOURCE_DIR}/inih/cpp/INIReader.cpp)

target_include_directories(
    ini
    SYSTEM PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/ini)