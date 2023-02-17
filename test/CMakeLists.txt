# So we have access to all files in the src folder
include_directories(../src)

# List of src files to be compiler with the unit tests
set(SRC_FILES
    ../src/cpu/registers/cspr.cpp
    ../src/cpu/ARM1176JZF_S.cpp
    ../src/cpu/isa/instruction.cpp
    ../src/cpu/isa/data_processing.cpp
    ../src/cpu/isa/decoder.cpp)

# Build unit tests
add_executable(
    unit_tests
    ${SRC_FILES}
    tests_main.cpp
    utils/math/is_bit_set_test.cpp
    utils/math/set_bit_test.cpp
    utils/math/lsl_test.cpp
    utils/math/lsr_test.cpp
    utils/math/asr_test.cpp
    utils/math/ror_test.cpp
    utils/math/is_negative_test.cpp
    cpu/registers/cspr/is_flag_set_test.cpp
    cpu/registers/cspr/set_flag_test.cpp
    cpu/isa/mov_test.cpp
    cpu/isa/mvn_test.cpp
    cpu/isa/and_test.cpp
    cpu/isa/eor_test.cpp)

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