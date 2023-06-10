add_library(
    imgui_file_dialog
    ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog/ImGuiFileDialog.cpp)

target_include_directories(
    imgui_file_dialog
    SYSTEM PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/../external/ImGuiFileDialog)