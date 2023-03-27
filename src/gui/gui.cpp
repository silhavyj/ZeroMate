#include <memory>
#include <algorithm>

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <imgui/imgui.h>
#include <imgui/backends/imgui_impl_glfw.h>
#include <imgui/backends/imgui_impl_opengl3.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include "gui.hpp"
#include "window.hpp"
#include "windows/registers_window.hpp"
#include "windows/ram_window.hpp"
#include "windows/control_window.hpp"
#include "windows/source_code_window.hpp"
#include "windows/file_window.hpp"
#include "windows/log_window.hpp"

#include "../core/utils/singleton.hpp"
#include "../core/utils/logger/logger_stdo.hpp"

// #define SHOW_EXAMPLE_OF_LOG_MESSAGES

namespace zero_mate::gui
{
    static inline constexpr const char* const WINDOW_TITLE = "ZeroMate - Rpi Zero emulator";

    static inline constexpr std::uint32_t WINDOW_WIDTH = 1240;
    static inline constexpr std::uint32_t WINDOW_WEIGHT = 720;

    static auto& s_logging_system = *utils::CSingleton<utils::CLogging_System>::Get_Instance();

    static auto s_ram = std::make_shared<peripheral::CRAM<>>();
    static auto s_bus = std::make_shared<CBus>();
    static auto s_cpu = std::make_shared<arm1176jzf_s::CCPU_Core>(0, s_bus);

    static std::vector<utils::TText_Section_Record> s_source_code{};
    static auto s_log_window = std::make_shared<CLog_Window>();

    static const std::vector<std::shared_ptr<CGUI_Window>> s_windows = {
        std::make_shared<CRegisters_Window>(s_cpu),
        std::make_shared<CRAM_Window>(s_ram),
        std::make_shared<CControl_Window>(s_cpu),
        std::make_shared<CSource_Code_Window>(s_cpu, s_source_code),
        std::make_shared<CFile_Window>(s_bus, s_cpu, s_source_code),
        s_log_window
    };

    static void Initialize_Logging_System()
    {
        auto logger_stdo = std::make_shared<utils::CLogger_STDO>();
        logger_stdo->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);

        s_logging_system.Add_Logger(logger_stdo);
        s_logging_system.Add_Logger(s_log_window);

#ifdef SHOW_EXAMPLE_OF_LOG_MESSAGES
        s_logging_system.Print("This is just a message");
        s_logging_system.Debug("This is a debug message");
        s_logging_system.Info("This is an info message");
        s_logging_system.Warning("This is a warning message");
        s_logging_system.Error("This is an error message");
#endif
    }

    static void Initialize_Peripherals()
    {
        if (s_bus->Attach_Peripheral(0x0, s_ram) != 0)
        {
            s_logging_system.Error("Failed to attach RAM to the bus");
        }
    }

    static void Initialize()
    {
        Initialize_Logging_System();
        Initialize_Peripherals();
    }

    static void Render_GUI()
    {
        std::for_each(s_windows.begin(), s_windows.end(), [](const auto& window) -> void { window->Render(); });
    }

    int Main_GUI(int argc, const char* argv[])
    {
        glfwSetErrorCallback([](int error_code, const char* description) -> void {
            s_logging_system.Error(fmt::format("Error {} occurred when initializing GLFW: {}", error_code, description).c_str());
            std::terminate();
        });

        if (GLFW_TRUE != glfwInit())
        {
            s_logging_system.Error("Failed to initialize GLFW");
            return 1;
        }

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

        GLFWwindow* window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_WEIGHT, WINDOW_TITLE, nullptr, nullptr);
        if (window == nullptr)
        {
            s_logging_system.Error("Failed to create a GLFW window");
            return 1;
        }

        glfwMakeContextCurrent(window);
        glfwSwapInterval(1);

        if (glewInit() != GLEW_OK)
        {
            s_logging_system.Error("Failed to initialize GLEW");
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