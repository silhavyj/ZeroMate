# So we have access to all files in the src folder
include_directories(../src)

# Build unit tests
add_executable(
    unit_tests
    tests_main.cpp)

# Link libraries to the executable
target_link_libraries(
    unit_tests
    PRIVATE project_warnings project_options
    PRIVATE CONAN_PKG::gtest
    PRIVATE CONAN_PKG::spdlog)

# Download a CMake file for working with gtests
include(FetchContent)
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# Include the download CMake file
include(GoogleTest)

# Discover all tests
gtest_discover_tests(unit_tests)

# EOF