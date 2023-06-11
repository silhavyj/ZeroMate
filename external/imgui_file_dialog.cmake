add_library(
    imgui_file_dialog SHARED
    ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog/ImGuiFileDialog.cpp)

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
