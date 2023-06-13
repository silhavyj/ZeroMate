find_package(OpenGL REQUIRED)

add_library(
    imgui_glfw SHARED
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_tables.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_widgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_draw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_glfw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_opengl3.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog/ImGuiFileDialog.cpp)

set_target_properties(imgui_glfw PROPERTIES
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/imgui_glfw.lib)

target_include_directories(
    imgui_glfw
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends
        ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog)

target_link_libraries(
    imgui_glfw
    PUBLIC 
        libglew_static
        glfw
	    OpenGL::GL)

set(output_directory ${PROJECT_SOURCE_DIR}/output)

file(MAKE_DIRECTORY ${output_directory})

add_custom_command(
    TARGET imgui_glfw POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:imgui_glfw> ${output_directory})
