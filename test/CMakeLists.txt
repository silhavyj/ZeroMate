# So we have access to all files in the src folder
include_directories(../src)

# List of src files to be compiler with the unit tests
set(SRC_FILES
    ../src/cpu/registers/cspr.cpp
    ../src/cpu/arm1176jzf_s.cpp
    ../src/cpu/alu.cpp
    ../src/cpu/mac.cpp
    ../src/cpu/isa/instruction.cpp
    ../src/cpu/isa/data_processing.cpp
    ../src/cpu/isa/multiply.cpp
    ../src/cpu/isa/multiply_long.cpp
    ../src/cpu/isa/branch_and_exchange.cpp
    ../src/cpu/isa/branch.cpp
    ../src/cpu/instruction_decoder.cpp)

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
    cpu/isa/data_processing/register_state_checker.hpp
    cpu/isa/data_processing/mov_test.cpp
    cpu/isa/data_processing/mvn_test.cpp
    cpu/isa/data_processing/and_test.cpp
    cpu/isa/data_processing/eor_test.cpp
    cpu/isa/data_processing/tst_test.cpp
    cpu/isa/data_processing/teq_test.cpp
    cpu/isa/data_processing/orr_test.cpp
    cpu/isa/data_processing/bic_test.cpp
    cpu/isa/data_processing/sub_test.cpp
    cpu/isa/data_processing/rsb_test.cpp
    cpu/isa/data_processing/add_test.cpp
    cpu/isa/data_processing/adc_test.cpp
    cpu/isa/data_processing/sbc_test.cpp
    cpu/isa/data_processing/rsc_test.cpp
    cpu/isa/data_processing/cmp_test.cpp
    cpu/isa/data_processing/cmn_test.cpp
    cpu/isa/multiply/mul_test.cpp
    cpu/isa/multiply/mla_test.cpp
    cpu/isa/multiply_long/umull_test.cpp
    cpu/isa/multiply_long/smull_test.cpp
    cpu/isa/multiply_long/umlal_test.cpp
    cpu/isa/multiply_long/smlal_test.cpp)

# Link libraries to the executable
target_link_libraries(
    unit_tests
    PRIVATE project_warnings project_options
    PRIVATE gtest)

# Include the download CMake file
include(GoogleTest)

# Discover all tests
gtest_discover_tests(unit_tests)

# EOF