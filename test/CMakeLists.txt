# So we have access to all files in the src folder
include_directories(../src)

# Find all source files to be compiled with the unit tests
file(
    GLOB_RECURSE core_source_files
    "../src/core/*.cpp"
    "../src/core/*.hpp"
    "../src/utils/*.hpp"
    "../src/utils/*.cpp")

# Find all unit test source files
file(
    GLOB_RECURSE test_source_files
    "./*.cpp"
    "./*.hpp")

# Build unit tests
add_executable(
    unit_tests
    ${core_source_files}
    ${test_source_files})

# Add system headers, so they build passes all compiler warnings
target_include_directories(
    unit_tests
    SYSTEM PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/elfio/
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/magic_enum/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/demumble/third_party/llvm/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/dylib/include/
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/json/include/
        ${CMAKE_CURRENT_SOURCE_DIR}/../include)

# Link libraries to the executable
target_link_libraries(
    unit_tests
    PRIVATE 
        project_warnings project_options
        fmt
        gtest
        elfio
        magic_enum
        capstone
        demangle
        logger)

# Include the download CMake file
include(GoogleTest)

# Discover all tests
gtest_discover_tests(unit_tests)
