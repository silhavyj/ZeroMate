# Find all source files in the utils folder
file(
    GLOB_RECURSE utils_source_files
    "utils/*.cpp"
    "utils/*.hpp")

# Find all source files making up the core of the emulator
file(
    GLOB_RECURSE core_source_files
    "core/*.cpp"
    "core/*.hpp")

# Find all source files making up the GUI of the emulator
file(
    GLOB_RECURSE gui_source_files
    "gui/*.cpp"
    "gui/*.hpp")

# Define the main executable
add_executable(
    zero_mate
    main.cpp
    ${utils_source_files}
    ${core_source_files}
    ${gui_source_files})

# Add system headers, so the build passes all compiler warnings
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
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/stb
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

# Set the rpath to look for shared libraries relative to the executable
if(NOT WIN32)
    set_target_properties(
        zero_mate PROPERTIES
        INSTALL_RPATH "$ORIGIN"
        BUILD_WITH_INSTALL_RPATH TRUE)
endif()

# Set the output directory
set(output_directory ${PROJECT_SOURCE_DIR}/output)

# Copy the output file into the output directory
add_custom_command(
    TARGET zero_mate POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:zero_mate> ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/fonts ${output_directory}/fonts
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/icons ${output_directory}/icons
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/misc/logos ${output_directory}/logos
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/imgui.ini ${output_directory}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/peripherals.json ${output_directory})

# Windows specific: Embed the icon into the executable
if(WIN32)
    set(RESOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/resources.rc)
    file(WRITE ${RESOURCE_FILE} "IDI_ICON1 ICON \"${CMAKE_SOURCE_DIR}/misc/logos/logo.ico\"")
    target_sources(zero_mate PRIVATE ${RESOURCE_FILE})
    set_source_files_properties(${RESOURCE_FILE} PROPERTIES GENERATED TRUE)
    set_target_properties(
        zero_mate PROPERTIES
        LINK_FLAGS "/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")
endif()
