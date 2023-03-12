#include <memory>

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <imgui/imgui.h>
#include <imgui/backends/imgui_impl_glfw.h>
#include <imgui/backends/imgui_impl_opengl3.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include "gui.hpp"
#include "object.hpp"
#include "registers_window.hpp"
#include "ram_window.hpp"
#include "control_window.hpp"
#include "source_code_window.hpp"
#include "file_window.hpp"

namespace zero_mate::gui
{
    static inline constexpr const char* const WINDOW_TITLE = "ZeroMate - Rpi Zero emulator";
    static inline constexpr uint32_t WINDOW_WIDTH = 1240;
    static inline constexpr uint32_t WINDOW_WEIGHT = 720;

    static auto s_ram = std::make_shared<peripheral::CRAM<>>();
    static auto s_bus = std::make_shared<CBus>();
    static auto s_cpu = std::make_shared<arm1176jzf_s::CCPU_Core>(0, s_bus);

    static std::vector<utils::TText_Section_Record> s_source_code{};

    static const std::vector<std::shared_ptr<CGUI_Object>> s_windows = {
        std::make_shared<CRegisters_Window>(s_cpu),
        std::make_shared<CRAM_Window>(s_ram),
        std::make_shared<CControl_Window>(s_cpu),
        std::make_shared<CSource_Code_Window>(s_cpu, s_source_code),
        std::make_shared<CFile_Window>(s_bus, s_cpu, s_source_code)
    };

    static void Initialize()
    {
        if (s_bus->Attach_Peripheral(0x0, s_ram) != 0)
        {
            // TODO
        }
    }

    static void Render_GUI()
    {
        for (auto& window : s_windows)
        {
            window->Render();
        }
    }

    int Main_GUI(int argc, const char* argv[])
    {
        glfwSetErrorCallback([]([[maybe_unused]] int error_code, [[maybe_unused]] const char* description) -> void {
            // TODO
        });

        if (GLFW_TRUE != glfwInit())
        {
            // TODO
            return 1;
        }

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

        GLFWwindow* window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_WEIGHT, WINDOW_TITLE, nullptr, nullptr);
        if (window == nullptr)
        {
            // TODO
            return 1;
        }

        glfwMakeContextCurrent(window);
        glfwSwapInterval(1);

        if (glewInit() != GLEW_OK)
        {
            // TODO
            return 1;
        }

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();

        ImGuiIO& imgui_io = ImGui::GetIO();

        imgui_io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
        imgui_io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
        imgui_io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;

        ImGui::StyleColorsDark();
        ImGuiStyle& style = ImGui::GetStyle();

        if (imgui_io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
        {
            style.WindowRounding = 0.0f;
            style.Colors[ImGuiCol_WindowBg].w = 1.0f;
        }

        ImGui_ImplGlfw_InitForOpenGL(window, true);
        ImGui_ImplOpenGL3_Init("#version 130");

        if (argc >= 2)
        {
            if (imgui_io.Fonts->AddFontFromFileTTF(argv[1], 15.0f) == nullptr)
            {
                // TODO
            }
        }
        else
        {
            imgui_io.Fonts->AddFontDefault();
        }

        if (argc >= 3)
        {
            const float baseFontSize = 13.0f;
            const float iconFontSize = baseFontSize * 2.0f / 3.0f;

            static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_16_FA, 0 };
            ImFontConfig icons_config;
            icons_config.MergeMode = true;
            icons_config.PixelSnapH = true;
            icons_config.GlyphMinAdvanceX = iconFontSize;
            imgui_io.Fonts->AddFontFromFileTTF(argv[2], iconFontSize, &icons_config, icons_ranges);
        }

        int display_w{};
        int display_h{};

        Initialize();

        while (!glfwWindowShouldClose(window))
        {
            glfwPollEvents();

            ImGui_ImplOpenGL3_NewFrame();
            ImGui_ImplGlfw_NewFrame();
            ImGui::NewFrame();

            static bool dockspace_open = true;
            static ImGuiDockNodeFlags dockspace_flags = ImGuiDockNodeFlags_None;

            ImGuiWindowFlags window_flags = ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoDocking;

            const ImGuiViewport* viewport = ImGui::GetMainViewport();
            ImGui::SetNextWindowPos(viewport->WorkPos);
            ImGui::SetNextWindowSize(viewport->WorkSize);
            ImGui::SetNextWindowViewport(viewport->ID);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
            window_flags |= ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove;
            window_flags |= ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoNavFocus;

            if (dockspace_flags & ImGuiDockNodeFlags_PassthruCentralNode)
            {
                window_flags |= ImGuiWindowFlags_NoBackground;
            }

            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
            ImGui::Begin("DockSpace Demo", &dockspace_open, window_flags);
            ImGui::PopStyleVar();
            ImGui::PopStyleVar(2);

            if (imgui_io.ConfigFlags & ImGuiConfigFlags_DockingEnable)
            {
                const ImGuiID dockspace_id = ImGui::GetID("MyDockSpace");
                ImGui::DockSpace(dockspace_id, ImVec2(0.0f, 0.0f), dockspace_flags);
            }

            zero_mate::gui::Render_GUI();
            ImGui::End();
            ImGui::Render();

            glfwGetFramebufferSize(window, &display_w, &display_h);
            glViewport(0, 0, display_w, display_h);
            glClear(GL_COLOR_BUFFER_BIT);
            ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

            if (imgui_io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
            {
                GLFWwindow* backup_current_context = glfwGetCurrentContext();
                ImGui::UpdatePlatformWindows();
                ImGui::RenderPlatformWindowsDefault();
                glfwMakeContextCurrent(backup_current_context);
            }

            glfwSwapBuffers(window);
        }

        ImGui_ImplOpenGL3_Shutdown();
        ImGui_ImplGlfw_Shutdown();
        ImGui::DestroyContext();

        glfwDestroyWindow(window);
        glfwTerminate();

        return 0;
    }
}