# Build ImGUI sources separately as a static library.
# Otherwise they would break the build as they do not pass 
# strict compiler warnings set up in the project

add_library(
    imgui_glfw STATIC
    imgui_impl_glfw.cpp
    imgui_impl_glfw.h
    imgui_impl_opengl3.cpp
    imgui_impl_opengl3.h
    imgui_impl_opengl3_loader.h)

target_link_libraries(
    imgui_glfw
    PRIVATE CONAN_PKG::imgui
    PRIVATE CONAN_PKG::glew
    PRIVATE CONAN_PKG::glfw)

# EOF