#include <filesystem>

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <imgui/imgui.h>
#include <magic_enum.hpp>
#include <imgui/backends/imgui_impl_glfw.h>
#include <imgui/backends/imgui_impl_opengl3.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include "../soc.hpp"

#include "gui.hpp"
#include "window.hpp"
#include "windows/registers_window.hpp"
#include "windows/control_window.hpp"
#include "windows/source_code_window.hpp"
#include "windows/file_window.hpp"
#include "windows/log_window.hpp"

#include "windows/cp15_window.hpp"
#include "windows/peripherals/ram_window.hpp"
#include "windows/peripherals/gpio_window.hpp"
#include "windows/peripherals/arm_timer_window.hpp"
#include "windows/peripherals/monitor_window.hpp"
#include "windows/peripherals/interrupt_controller_window.hpp"

#include "../core/utils/logger/logger_stdo.hpp"

namespace zero_mate::gui
{
    static inline constexpr const char* const WINDOW_TITLE = "ZeroMate - Rpi Zero emulator";

    static inline constexpr std::uint32_t WINDOW_WIDTH = 1240;
    static inline constexpr std::uint32_t WINDOW_WEIGHT = 720;

    namespace
    {
        auto s_log_window = std::make_shared<CLog_Window>();
        std::vector<std::shared_ptr<IGUI_Window>> s_windows;

        bool s_scroll_to_curr_line{ false };
        bool s_elf_file_has_been_loaded{ false };
        bool s_cpu_running{ false };

        void Initialize_Windows()
        {
            s_log_window->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);
            soc::g_logging_system.Add_Logger(s_log_window);

            s_windows.emplace_back(std::make_shared<CRegisters_Window>(soc::g_cpu, s_cpu_running));
            s_windows.push_back(std::make_shared<CRAM_Window>(soc::g_ram));
            s_windows.emplace_back(std::make_shared<CControl_Window>(soc::g_cpu, s_scroll_to_curr_line, s_elf_file_has_been_loaded, s_cpu_running, soc::g_peripherals, soc::g_bus));
            s_windows.emplace_back(std::make_shared<CSource_Code_Window>(soc::g_cpu, soc::g_source_code, s_scroll_to_curr_line, s_cpu_running));
            s_windows.emplace_back(std::make_shared<CFile_Window>(soc::g_bus, soc::g_cpu, soc::g_source_code, s_elf_file_has_been_loaded, soc::g_peripherals));
            s_windows.emplace_back(std::make_shared<CGPIO_Window>(soc::g_gpio));
            s_windows.emplace_back(s_log_window);
            s_windows.emplace_back(std::make_shared<CInterrupt_Controller_Window>(soc::g_ic));
            s_windows.emplace_back(std::make_shared<CARM_Timer_Window>(soc::g_arm_timer));
            s_windows.emplace_back(std::make_shared<CMonitor_Window>(soc::g_monitor));
            s_windows.emplace_back(std::make_shared<CCP15_Window>(soc::g_cp15));
        }
        
        void Render_GUI()
        {
            std::for_each(s_windows.begin(), s_windows.end(), [](const auto& window) -> void { window->Render(); });
            std::for_each(soc::g_external_peripherals.begin(), soc::g_external_peripherals.end(), [](const auto& window) -> void { window->Render(); });
        }
    }

    int Main_GUI([[maybe_unused]] int argc, [[maybe_unused]] const char* argv[])
    {
        Initialize_Windows();

        glfwSetErrorCallback([](int error_code, const char* description) -> void {
            soc::g_logging_system.Error(fmt::format("Error {} occurred when initializing GLFW: {}", error_code, description).c_str());
            std::terminate();
        });

        if (glfwInit() != GLFW_TRUE)
        {
            soc::g_logging_system.Error("Failed to initialize GLFW");
            return 1;
        }

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

        GLFWwindow* window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_WEIGHT, WINDOW_TITLE, nullptr, nullptr);

        if (window == nullptr)
        {
            soc::g_logging_system.Error("Failed to create a GLFW window");
            return 1;
        }

        glfwMakeContextCurrent(window);
        glfwSwapInterval(1);

        if (glewInit() != GLEW_OK)
        {
            soc::g_logging_system.Error("Failed to initialize GLEW");
            return 1;
        }

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();

        ImGuiIO& imgui_io = ImGui::GetIO();

        imgui_io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
        imgui_io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
        imgui_io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;

        ImGui::StyleColorsDark();
        ImGui::GetStyle().FrameRounding = 4.0f;
        ImGuiStyle& style = ImGui::GetStyle();

        if (imgui_io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
        {
            style.WindowRounding = 0.0f;
            style.Colors[ImGuiCol_WindowBg].w = 1.0f;
        }

        ImGui_ImplGlfw_InitForOpenGL(window, true);
        ImGui_ImplOpenGL3_Init("#version 130");

        if (std::filesystem::exists(config::Font_Path) && std::filesystem::exists(config::Icons_Path))
        {
            imgui_io.Fonts->AddFontFromFileTTF(config::Font_Path, 15.0f);

            const float baseFontSize = 13.0f;
            const float iconFontSize = baseFontSize * 2.0f / 3.0f;

            static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_16_FA, 0 };
            ImFontConfig icons_config;
            icons_config.MergeMode = true;
            icons_config.PixelSnapH = true;
            icons_config.GlyphMinAdvanceX = iconFontSize;
            imgui_io.Fonts->AddFontFromFileTTF(config::Icons_Path, iconFontSize, &icons_config, icons_ranges);
        }
        else
        {
            soc::g_logging_system.Warning("Failed to load the font and font (using the default one)");
            imgui_io.Fonts->AddFontDefault();
        }

        int display_w{};
        int display_h{};

        while (!glfwWindowShouldClose(window))
        {
            glfwPollEvents();

            ImGui_ImplOpenGL3_NewFrame();
            ImGui_ImplGlfw_NewFrame();
            ImGui::NewFrame();

            [[maybe_unused]] static bool dockspace_open = true;
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
            ImGui::Begin("##ZeroMate Dockspace", &dockspace_open, window_flags);
            ImGui::PopStyleVar();
            ImGui::PopStyleVar(2);

            if (imgui_io.ConfigFlags & ImGuiConfigFlags_DockingEnable)
            {
                const ImGuiID dockspace_id = ImGui::GetID("ZeroMateDockspace");
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