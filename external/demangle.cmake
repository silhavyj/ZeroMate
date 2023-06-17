# Define the list of all source files
file(
    GLOB_RECURSE demangle_source_files
    "${CMAKE_CURRENT_SOURCE_DIR}/demumble/third_party/llvm/lib/Demangle/*.cpp")

# Build demangle as a static library
add_library(
    demangle STATIC
    ${demangle_source_files})

# Specify the system include directories
target_include_directories(
    demangle
    SYSTEM PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/demumble/third_party/llvm/include)