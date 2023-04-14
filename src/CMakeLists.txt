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
    SYSTEM PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui/backends)

target_link_libraries(
    imgui_glfw
    PRIVATE 
        libglew_static
        glfw)

# Build ImGuiFileDialog sources separately as a static library.
# Otherwise they would break the build as they do not pass
# strict compiler warnings set up in the project
add_library(
    imgui_file_dialog
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog/ImGuiFileDialog.cpp)

target_include_directories(
    imgui_file_dialog
    SYSTEM PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog)

# Build the inih library
add_library(
    ini
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/inih/ini.c
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/inih/cpp/INIReader.cpp)

target_include_directories(
    ini
    SYSTEM PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/ini)

# Find all source files making up the core of emulator
file(GLOB_RECURSE core_source_files "core/*.cpp" "core/*.hpp")

# Find all source files making up the GUI of emulator
file(GLOB_RECURSE gui_source_files "gui/*.cpp" "gui/*.hpp")

# Define the executable
add_executable(
    zero_mate
    main.cpp
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
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/magic_enum/include)

# Link project_warnings, project_options, and libraries
target_link_libraries(
    zero_mate
    PRIVATE 
        project_warnings
        project_options
        fmt
        elfio
        libglew_static
        glfw
        imgui_glfw
        imgui_file_dialog
        magic_enum
        capstone
        ini)

if(WIN32)
    target_link_libraries(
        zero_mate
        PRIVATE 
            $<$<CXX_COMPILER_ID:GNU>:opengl32.a>
            $<$<CXX_COMPILER_ID:MSVC>:opengl32.lib>)
endif()

# Copy the fonts, imgui.ini, and rpi_zero_config.ini to the location of the executable
add_custom_command(
    TARGET zero_mate POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/fonts $<TARGET_FILE_DIR:zero_mate>/fonts
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/imgui.ini $<TARGET_FILE_DIR:zero_mate>
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/rpi_zero_config.ini $<TARGET_FILE_DIR:zero_mate>)

# EOF
