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
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/magic_enum/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/demumble/third_party/llvm/include)

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
        ini
        demangle)

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
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/icons $<TARGET_FILE_DIR:zero_mate>/icons
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/imgui.ini $<TARGET_FILE_DIR:zero_mate>
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/peripherals.ini $<TARGET_FILE_DIR:zero_mate>)

# EOF
