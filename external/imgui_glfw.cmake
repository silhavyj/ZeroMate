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
add_library(imgui_glfw ${LIB_TYPE})

target_sources(imgui_glfw
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_tables.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_widgets.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_draw.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_demo.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_glfw.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends/imgui_impl_opengl3.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/implot/implot.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/implot/implot_items.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/implot/implot_demo.cpp
)

# Specify the public include directories
target_include_directories(imgui_glfw
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui/backends
        ${CMAKE_CURRENT_SOURCE_DIR}/imgui-filebrowser
        ${CMAKE_CURRENT_SOURCE_DIR}/implot
)

# Link OpenGL, GLFW and GLEW to the library
target_link_libraries(imgui_glfw
    PUBLIC
        libglew_static
        glfw
        OpenGL::GL
)

# Copy the library to the output directory
if(NOT WIN32)
    set(output_directory ${PROJECT_SOURCE_DIR}/output)

    add_custom_command(TARGET imgui_glfw
        POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory ${output_directory}
            COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:imgui_glfw> ${output_directory}
    )
endif()