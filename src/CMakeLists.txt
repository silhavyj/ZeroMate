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
    cpu/ARM1176JZF_S.hpp
    cpu/ARM1176JZF_S.cpp)

# Link project_warnings, project_options, and libraries
target_link_libraries(
    ${EXECUTABLE_NAME}
    PRIVATE project_warnings
    PRIVATE project_options
    PRIVATE CONAN_PKG::fmt
    PRIVATE CONAN_PKG::spdlog
    PRIVATE CONAN_PKG::imgui
    PRIVATE CONAN_PKG::glew
    PRIVATE CONAN_PKG::glfw
    PRIVATE imgui_glfw)

# EOF
