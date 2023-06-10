file(GLOB_RECURSE demangle_source_files
    "${CMAKE_CURRENT_SOURCE_DIR}/../external/demumble/third_party/llvm/lib/Demangle/*.cpp")

add_library(
    demangle
    ${demangle_source_files})

target_include_directories(
    demangle
    SYSTEM PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/demumble/third_party/llvm/include)