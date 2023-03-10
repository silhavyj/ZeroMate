# Define the name of the executable
set(EXECUTABLE_NAME ZeroMate)

# List out source files making up the executable
add_executable(
    ${EXECUTABLE_NAME}
    main.cpp
    utils/math.hpp
    arm1176jzf_s/registers/cspr.hpp
    arm1176jzf_s/registers/cspr.cpp
    arm1176jzf_s/isa/instruction.hpp
    arm1176jzf_s/isa/instruction.cpp
    arm1176jzf_s/isa/data_processing.hpp
    arm1176jzf_s/isa/data_processing.cpp
    arm1176jzf_s/isa/multiply.hpp
    arm1176jzf_s/isa/multiply.cpp
    arm1176jzf_s/isa/multiply_long.hpp
    arm1176jzf_s/isa/multiply_long.cpp
    arm1176jzf_s/isa/branch_and_exchange.hpp
    arm1176jzf_s/isa/branch_and_exchange.cpp
    arm1176jzf_s/isa/branch.hpp
    arm1176jzf_s/isa/branch.cpp
    arm1176jzf_s/isa/single_data_transfer.hpp
    arm1176jzf_s/isa/single_data_transfer.cpp
    arm1176jzf_s/isa/block_data_transfer.hpp
    arm1176jzf_s/isa/block_data_transfer.cpp
    arm1176jzf_s/isa/halfword_data_transfer.hpp
    arm1176jzf_s/isa/halfword_data_transfer.cpp
    arm1176jzf_s/isa/sw_interrupt.hpp
    arm1176jzf_s/isa/sw_interrupt.cpp
    arm1176jzf_s/isa/isa_decoder.hpp
    arm1176jzf_s/isa/isa_decoder.cpp
    arm1176jzf_s/core.hpp
    arm1176jzf_s/core.cpp
    arm1176jzf_s/alu.hpp
    arm1176jzf_s/alu.cpp
    arm1176jzf_s/mac.hpp
    arm1176jzf_s/mac.cpp
    arm1176jzf_s/exceptions.hpp
    peripherals/peripheral.hpp
    peripherals/ram.hpp
    bus/bus.hpp
    bus/bus.cpp
    utils/elf_loader.hpp
    utils/elf_loader.cpp
    utils/list_parser.hpp
    utils/list_parser.cpp)

target_include_directories(
    ${EXECUTABLE_NAME}
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/elfio/)

# Link project_warnings, project_options, and libraries
target_link_libraries(
    ${EXECUTABLE_NAME}
    PRIVATE project_warnings
    PRIVATE project_options
    PRIVATE fmt
    PRIVATE spdlog
    PRIVATE elfio)

# EOF
