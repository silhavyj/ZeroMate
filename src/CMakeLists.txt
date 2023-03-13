# Build ImGUI sources separately as a static library.
# Otherwise they would break the build as they do not pass
# strict compiler warnings set up in the project
add_library(
    imgui_glfw
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/imgui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/imgui_tables.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/imgui_widgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/imgui_draw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/imgui_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/backends/imgui_impl_glfw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/backends/imgui_impl_opengl3.cpp)

target_include_directories(
    imgui_glfw
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/backends)

target_link_libraries(
    imgui_glfw
    PRIVATE libglew_static
    PRIVATE glfw)

# Build ImGuiFileDialog sources separately as a static library.
# Otherwise they would break the build as they do not pass
# strict compiler warnings set up in the project
add_library(
    imgui_file_dialog
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog/ImGuiFileDialog.cpp)

target_include_directories(
    imgui_file_dialog
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog)

# Define the name of the executable
set(EXECUTABLE_NAME ZeroMate)

# List out source files making up the executable
add_executable(
    ${EXECUTABLE_NAME}
    main.cpp
    core/utils/math.hpp
    core/arm1176jzf_s/registers/cspr.hpp
    core/arm1176jzf_s/registers/cspr.cpp
    core/arm1176jzf_s/isa/instruction.hpp
    core/arm1176jzf_s/isa/instruction.cpp
    core/arm1176jzf_s/isa/data_processing.hpp
    core/arm1176jzf_s/isa/data_processing.cpp
    core/arm1176jzf_s/isa/multiply.hpp
    core/arm1176jzf_s/isa/multiply.cpp
    core/arm1176jzf_s/isa/multiply_long.hpp
    core/arm1176jzf_s/isa/multiply_long.cpp
    core/arm1176jzf_s/isa/branch_and_exchange.hpp
    core/arm1176jzf_s/isa/branch_and_exchange.cpp
    core/arm1176jzf_s/isa/branch.hpp
    core/arm1176jzf_s/isa/branch.cpp
    core/arm1176jzf_s/isa/single_data_transfer.hpp
    core/arm1176jzf_s/isa/single_data_transfer.cpp
    core/arm1176jzf_s/isa/block_data_transfer.hpp
    core/arm1176jzf_s/isa/block_data_transfer.cpp
    core/arm1176jzf_s/isa/halfword_data_transfer.hpp
    core/arm1176jzf_s/isa/halfword_data_transfer.cpp
    core/arm1176jzf_s/isa/sw_interrupt.hpp
    core/arm1176jzf_s/isa/sw_interrupt.cpp
    core/arm1176jzf_s/isa/isa_decoder.hpp
    core/arm1176jzf_s/isa/isa_decoder.cpp
    core/arm1176jzf_s/cpu_core.hpp
    core/arm1176jzf_s/cpu_core.cpp
    core/arm1176jzf_s/alu.hpp
    core/arm1176jzf_s/alu.cpp
    core/arm1176jzf_s/mac.hpp
    core/arm1176jzf_s/mac.cpp
    core/arm1176jzf_s/exceptions.hpp
    core/peripherals/peripheral.hpp
    core/peripherals/ram.hpp
    core/peripherals/bus.hpp
    core/peripherals/bus.cpp
    core/utils/elf_loader.hpp
    core/utils/elf_loader.cpp
    core/utils/list_parser.hpp
    core/utils/list_parser.cpp
    gui/gui.hpp
    gui/gui.cpp
    gui/object.hpp
    gui/registers_window.hpp
    gui/registers_window.cpp
    gui/ram_window.hpp
    gui/ram_window.cpp
    gui/control_window.hpp
    gui/control_window.cpp
    gui/source_code_window.hpp
    gui/source_code_window.cpp
    gui/file_window.hpp
    gui/file_window.cpp)

target_include_directories(
    ${EXECUTABLE_NAME}
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/elfio
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/IconFontCppHeaders
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui_club
    SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog)

# Link project_warnings, project_options, and libraries
target_link_libraries(
    ${EXECUTABLE_NAME}
    PRIVATE project_warnings
    PRIVATE project_options
    PRIVATE fmt
    PRIVATE spdlog
    PRIVATE elfio
    PRIVATE libglew_static
    PRIVATE glfw
    PRIVATE imgui_glfw
    PRIVATE imgui_file_dialog)

if(WIN32)
    target_link_libraries(
        ${EXECUTABLE_NAME}
        PRIVATE $<$<CXX_COMPILER_ID:GNU>:opengl32.a>
        PRIVATE $<$<CXX_COMPILER_ID:MSVC>:opengl32.lib>)
endif()

# EOF
