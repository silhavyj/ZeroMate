# So we have access to all files in the src folder
include_directories(../src)

# List of src files to be compiler with the unit tests
set(SRC_FILES
    ../src/core/arm1176jzf_s/registers/cspr.cpp
    ../src/core/arm1176jzf_s/cpu_core.cpp
    ../src/core/arm1176jzf_s/alu.cpp
    ../src/core/arm1176jzf_s/mac.cpp
    ../src/core/arm1176jzf_s/isa/instruction.cpp
    ../src/core/arm1176jzf_s/isa/data_processing.cpp
    ../src/core/arm1176jzf_s/isa/multiply.cpp
    ../src/core/arm1176jzf_s/isa/multiply_long.cpp
    ../src/core/arm1176jzf_s/isa/branch_and_exchange.cpp
    ../src/core/arm1176jzf_s/isa/branch.cpp
    ../src/core/arm1176jzf_s/isa/single_data_transfer.cpp
    ../src/core/arm1176jzf_s/isa/block_data_transfer.cpp
    ../src/core/arm1176jzf_s/isa/halfword_data_transfer.cpp
    ../src/core/arm1176jzf_s/isa/sw_interrupt.cpp
    ../src/core/arm1176jzf_s/isa/isa_decoder.cpp
    ../src/core/peripherals/bus.cpp
    ../src/core/utils/elf_loader.cpp
    ../src/core/utils/logger/logger.cpp)

# Build unit tests
add_executable(
    unit_tests
    ${SRC_FILES}
    tests_main.cpp
    core/utils/math/is_bit_set_test.cpp
    core/utils/math/set_bit_test.cpp
    core/utils/math/lsl_test.cpp
    core/utils/math/lsr_test.cpp
    core/utils/math/asr_test.cpp
    core/utils/math/ror_test.cpp
    core/utils/math/is_negative_test.cpp
    core/arm1176jzf_s/registers/cspr/is_flag_set_test.cpp
    core/arm1176jzf_s/registers/cspr/set_flag_test.cpp
    core/arm1176jzf_s/isa/data_processing/register_state_checker.hpp
    core/arm1176jzf_s/isa/data_processing/mov_test.cpp
    core/arm1176jzf_s/isa/data_processing/mvn_test.cpp
    core/arm1176jzf_s/isa/data_processing/and_test.cpp
    core/arm1176jzf_s/isa/data_processing/eor_test.cpp
    core/arm1176jzf_s/isa/data_processing/tst_test.cpp
    core/arm1176jzf_s/isa/data_processing/teq_test.cpp
    core/arm1176jzf_s/isa/data_processing/orr_test.cpp
    core/arm1176jzf_s/isa/data_processing/bic_test.cpp
    core/arm1176jzf_s/isa/data_processing/sub_test.cpp
    core/arm1176jzf_s/isa/data_processing/rsb_test.cpp
    core/arm1176jzf_s/isa/data_processing/add_test.cpp
    core/arm1176jzf_s/isa/data_processing/adc_test.cpp
    core/arm1176jzf_s/isa/data_processing/sbc_test.cpp
    core/arm1176jzf_s/isa/data_processing/rsc_test.cpp
    core/arm1176jzf_s/isa/data_processing/cmp_test.cpp
    core/arm1176jzf_s/isa/data_processing/cmn_test.cpp
    core/arm1176jzf_s/isa/multiply/mul_test.cpp
    core/arm1176jzf_s/isa/multiply/mla_test.cpp
    core/arm1176jzf_s/isa/multiply_long/umull_test.cpp
    core/arm1176jzf_s/isa/multiply_long/smull_test.cpp
    core/arm1176jzf_s/isa/multiply_long/umlal_test.cpp
    core/arm1176jzf_s/isa/multiply_long/smlal_test.cpp
    core/arm1176jzf_s/isa/branch_and_exchange/bx_test.cpp
    core/arm1176jzf_s/isa/branch_and_exchange/blx_test.cpp
    core/arm1176jzf_s/isa/branch/b_test.cpp
    core/arm1176jzf_s/isa/branch/bl_test.cpp
    core/arm1176jzf_s/isa/single_data_transfer/str_test.cpp
    core/arm1176jzf_s/isa/single_data_transfer/ldr_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/stmia_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/stmib_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/stmdb_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/stmda_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/ldmib_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/ldmia_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/ldmda_test.cpp
    core/arm1176jzf_s/isa/block_data_transfer/ldmdb_test.cpp
    core/arm1176jzf_s/isa/halfword_data_transfer/ldrsb_test.cpp
    core/arm1176jzf_s/isa/halfword_data_transfer/ldrh_test.cpp
    core/arm1176jzf_s/isa/halfword_data_transfer/ldrsh_test.cpp
    core/arm1176jzf_s/isa/halfword_data_transfer/strh_test.cpp
    simple_programs/fibonacci/fibonacci_test.cpp
    simple_programs/factorial/factorial_test.cpp
    core/utils/elf/elf_loader.cpp)

target_include_directories(
    unit_tests
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/elfio/)

# Link libraries to the executable
target_link_libraries(
    unit_tests
    PRIVATE project_warnings project_options
    PRIVATE fmt
    PRIVATE gtest
    PRIVATE elfio)

# Include the download CMake file
include(GoogleTest)

# Discover all tests
gtest_discover_tests(unit_tests)

# EOF