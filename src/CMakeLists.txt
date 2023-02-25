# Define the name of the executable
set(EXECUTABLE_NAME ZeroMate)

# List out source files making up the executable
add_executable(
    ${EXECUTABLE_NAME}
    main.cpp
    utils/math.hpp
    cpu/registers/cspr.hpp
    cpu/registers/cspr.cpp
    cpu/isa/instruction.hpp
    cpu/isa/instruction.cpp
    cpu/isa/data_processing.hpp
    cpu/isa/data_processing.cpp
    cpu/isa/multiply.hpp
    cpu/isa/multiply.cpp
    cpu/isa/multiply_long.hpp
    cpu/isa/multiply_long.cpp
    cpu/isa/branch_and_exchange.hpp
    cpu/isa/branch_and_exchange.cpp
    cpu/isa/branch.hpp
    cpu/isa/branch.cpp
    cpu/isa/single_data_transfer.hpp
    cpu/isa/single_data_transfer.cpp
    cpu/instruction_decoder.hpp
    cpu/instruction_decoder.cpp
    cpu/arm1176jzf_s.hpp
    cpu/arm1176jzf_s.cpp
    cpu/alu.hpp
    cpu/alu.cpp
    cpu/mac.hpp
    cpu/mac.cpp
    cpu/mocks/ram.hpp)

# Link project_warnings, project_options, and libraries
target_link_libraries(
    ${EXECUTABLE_NAME}
    PRIVATE project_warnings
    PRIVATE project_options
    PRIVATE fmt
    PRIVATE spdlog)

# EOF
