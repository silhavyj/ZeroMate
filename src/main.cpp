#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <imgui/imgui.h>
#include <imgui/backends/imgui_impl_glfw.h>
#include <imgui/backends/imgui_impl_opengl3.h>

/// Window title
inline constexpr const char* Window_Title = "KIV/VSS - Covid 19 Simulation";

/// Default width of the window
inline constexpr uint32_t Window_Width = 1240;

/// Default height of the window
inline constexpr uint32_t Window_Height = 720;

int main([[maybe_unused]] int argc,
         [[maybe_unused]] const char* argv[])
{
    glfwSetErrorCallback([]([[maybe_unused]] int error_code, [[maybe_unused]] const char* description) -> void {
       // spdlog::error("GLFW Error {} : {}\n", error_code, description);
    });

    // Init GLFW.
    if (GLFW_TRUE != glfwInit())
    {
        //spdlog::error("Failed to initialize GLFW\n");
        return 1;
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

    // Crate a GLFW window
    GLFWwindow* window = glfwCreateWindow(Window_Width, Window_Height, Window_Title, nullptr, nullptr);
    if (nullptr == window)
    {
        //spdlog::error("Failed to create a window\n");
        return 1;
    }
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);

    // Init GLEW.
    if (GLEW_OK != glewInit())
    {
        //spdlog::error("Failed to initialize glew\n");
        return 1;
    }

    // Init ImGUI and ImPlot.
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    ImGuiIO& io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
    io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;

    ImGui::StyleColorsDark();

    ImGuiStyle& style = ImGui::GetStyle();
    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    {
        style.WindowRounding = 0.0f;
        style.Colors[ImGuiCol_WindowBg].w = 1.0f;
    }

    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init("#version 130");

    // Load up the font passed in as the 1st argument.
    if (argc >= 2)
    {
        const ImFont* font = io.Fonts->AddFontFromFileTTF(argv[1], 15.0f);
        if (nullptr == font)
        {
            //spdlog::warn("Failed to load the font '{}'", argv[1]);
        }
    }

    int display_w;
    int display_h;

    // Infinite loop (exits when the user closes the window).
    while (!glfwWindowShouldClose(window))
    {
        // Poll GUI events.
        glfwPollEvents();

        // Start a new frame to be rendered.
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        // Start an ImGUI dockspace
        static bool dockspace_open = true;
        static bool opt_fullscreen = true;
        static bool opt_padding = false;
        static ImGuiDockNodeFlags dockspace_flags = ImGuiDockNodeFlags_None;

        ImGuiWindowFlags window_flags = ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoDocking;
        if (opt_fullscreen)
        {
            const ImGuiViewport* viewport = ImGui::GetMainViewport();
            ImGui::SetNextWindowPos(viewport->WorkPos);
            ImGui::SetNextWindowSize(viewport->WorkSize);
            ImGui::SetNextWindowViewport(viewport->ID);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
            window_flags |= ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove;
            window_flags |= ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoNavFocus;
        }
        else
        {
            dockspace_flags &= ~ImGuiDockNodeFlags_PassthruCentralNode;
        }

        if (dockspace_flags & ImGuiDockNodeFlags_PassthruCentralNode)
        {
            window_flags |= ImGuiWindowFlags_NoBackground;
        }

        if (!opt_padding)
        {
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
        }
        ImGui::Begin("DockSpace Demo", &dockspace_open, window_flags);
        if (!opt_padding)
        {
            ImGui::PopStyleVar();
        }

        if (opt_fullscreen)
        {
            ImGui::PopStyleVar(2);
        }

        if (io.ConfigFlags & ImGuiConfigFlags_DockingEnable)
        {
            ImGuiID dockspace_id = ImGui::GetID("MyDockSpace");
            ImGui::DockSpace(dockspace_id, ImVec2(0.0f, 0.0f), dockspace_flags);
        }

        // Render the contents of the frame (actual GUI elements).

        ImGui::End();
        ImGui::Render();

        glfwGetFramebufferSize(window, &display_w, &display_h);
        glViewport(0, 0, display_w, display_h);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

        if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
        {
            GLFWwindow* backup_current_context = glfwGetCurrentContext();
            ImGui::UpdatePlatformWindows();
            ImGui::RenderPlatformWindowsDefault();
            glfwMakeContextCurrent(backup_current_context);
        }
        glfwSwapBuffers(window);
    }

    // Clean up.
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();

    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}