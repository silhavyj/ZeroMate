# Find all source files in the utils folder
file(GLOB_RECURSE utils_source_files "utils/*.cpp" "utils/*.hpp")

# Find all source files making up the core of emulator
file(GLOB_RECURSE core_source_files "core/*.cpp" "core/*.hpp")

# Find all source files making up the GUI of emulator
file(GLOB_RECURSE gui_source_files "gui/*.cpp" "gui/*.hpp")

# Define the main executable
add_executable(
    zero_mate
    main.cpp
    soc.hpp
    soc.cpp
    ${utils_source_files}
    ${core_source_files}
    ${gui_source_files})

# Add system headers, so they build passes all compiler warnings
target_include_directories(
    zero_mate
    SYSTEM PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/elfio
        ${CMAKE_CURRENT_SOURCE_DIR}/../external
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/IconFontCppHeaders
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui_club
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/magic_enum/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/demumble/third_party/llvm/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/dylib/include/
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/json/include/
        ${CMAKE_CURRENT_SOURCE_DIR}/../include)

# Link project_warnings, project_options, and libraries
target_link_libraries(
    zero_mate
    PRIVATE 
        project_warnings
        project_options
        fmt
        elfio
        imgui_glfw
        magic_enum
        capstone
        demangle
        logger)

# Set the output directory
set(output_directory ${PROJECT_SOURCE_DIR}/output)

# Create the output directory if it does not exist
file(MAKE_DIRECTORY ${output_directory})

# Copy the output file into the output directory
add_custom_command(
    TARGET zero_mate POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:zero_mate> ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/fonts ${output_directory}/fonts
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/icons ${output_directory}/icons
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/imgui.ini ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/peripherals.json ${output_directory})

# EOF
