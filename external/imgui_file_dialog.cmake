add_library(
    imgui_file_dialog SHARED
    ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog/ImGuiFileDialog.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_tables.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_widgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_draw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_glfw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_opengl3.cpp)

set_target_properties(
    imgui_file_dialog PROPERTIES
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/imgui_file_dialog.lib)

target_include_directories(
    imgui_file_dialog
    SYSTEM PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui
	${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends
        ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog)

target_link_libraries(
    imgui_file_dialog
    PRIVATE 
        glfw
        imgui_glfw)

set(output_directory ${PROJECT_SOURCE_DIR}/output)

file(MAKE_DIRECTORY ${output_directory})

add_custom_command(
    TARGET imgui_file_dialog POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:imgui_file_dialog> ${output_directory})