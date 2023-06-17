# Find OpenGL on the host system (required)
find_package(OpenGL REQUIRED)

# Build ImGUI GLFW as a static library on Windows and as a shared
# library on any other system
if (WIN32)
    set(LIB_TYPE STATIC)
else()
    set(LIB_TYPE SHARED)
endif()

# Add the library along with its source files
add_library(
    imgui_glfw ${LIB_TYPE}
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_tables.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_widgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_draw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_glfw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_opengl3.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog/ImGuiFileDialog.cpp)

# Specify the public include directories
target_include_directories(
    imgui_glfw
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends
        ${CMAKE_CURRENT_SOURCE_DIR}/ImGuiFileDialog)

# Link OpenGL, GLFW and GLEW to the library
target_link_libraries(
    imgui_glfw
    PUBLIC 
        libglew_static
        glfw
        OpenGL::GL)
