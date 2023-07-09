// ---------------------------------------------------------------------------------------------------------------------
/// \file gui.cpp
/// \date 09. 07. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the main GUI entry function that takes care of creating and rendering all windows.
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <filesystem>
#include <unordered_map>
/// \endcond

// 3rd party library includes

#include "GL/glew.h"
#include "GLFW/glfw3.h"
#include "imgui/imgui.h"
#include "imgui/backends/imgui_impl_glfw.h"
#include "imgui/backends/imgui_impl_opengl3.h"
#include "IconFontCppHeaders/IconsFontAwesome5.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"

// Project file imports

#include "../core/soc.hpp"
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

namespace zero_mate::gui
{
    /// Main window title
    static inline constexpr const char* const Window_Title = "ZeroMate - Rpi Zero emulator";

    /// Default width of the main window
    static inline constexpr std::uint32_t Window_Width = 1240;

    /// Default height of the main window
    static inline constexpr std::uint32_t Window_Height = 720;

    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        /// Logging window.
        auto s_log_window = std::make_shared<CLog_Window>();

        /// Collection of loaded ELF files.
        utils::elf::Source_Codes_t s_source_codes;

        /// Collection of all windows that will be rendered.
        std::vector<std::shared_ptr<IGUI_Window>> s_windows;

        // Variables shared among multiple windows.

        bool s_scroll_to_curr_line{ false };      ///< Should the source code window scroll to the current line of exec.
        bool s_kernel_has_been_loaded{ false };   ///< Has the kernel been loaded?
        bool s_cpu_running{ false };              ///< Is the CPU running?

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the logging window.
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize_Logging_Window()
        {
            // Register the logging windows as another type of logger.
            s_log_window->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);
            soc::g_logging_system.Add_Logger(s_log_window);

            // Logging window
            s_windows.emplace_back(s_log_window);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes all emulator windows (registers, source code, etc.).
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize_Emulator_Windows()
        {
            // Register window
            s_windows.emplace_back(std::make_shared<CRegisters_Window>(soc::g_cpu));

            // Control window
            s_windows.emplace_back(std::make_shared<CControl_Window>(soc::g_cpu,
                                                                     s_scroll_to_curr_line,
                                                                     s_kernel_has_been_loaded,
                                                                     s_cpu_running,
                                                                     soc::g_peripherals,
                                                                     soc::g_bus));

            // Source code window
            // clang-format off
            s_windows.emplace_back(std::make_shared<CSource_Code_Window>(soc::g_cpu,
                                                                         s_source_codes,
                                                                         s_scroll_to_curr_line,
                                                                         s_cpu_running));
            // clang-format on

            // File window
            s_windows.emplace_back(std::make_shared<CFile_Window>(soc::g_bus,
                                                                  soc::g_cpu,
                                                                  s_source_codes,
                                                                  s_kernel_has_been_loaded,
                                                                  soc::g_peripherals,
                                                                  s_cpu_running));
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes all peripheral windows.
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize_Peripheral_Windows()
        {
            // RAM
            s_windows.push_back(std::make_shared<CRAM_Window>(soc::g_ram));

            // GPIO
            s_windows.emplace_back(std::make_shared<CGPIO_Window>(soc::g_gpio));

            // Interrupt controller (IC)
            s_windows.emplace_back(std::make_shared<CInterrupt_Controller_Window>(soc::g_ic));

            // ARM timer
            s_windows.emplace_back(std::make_shared<CARM_Timer_Window>(soc::g_arm_timer));

            // Debug monitor
            s_windows.emplace_back(std::make_shared<CMonitor_Window>(soc::g_monitor));

            // Coprocessor CP15
            s_windows.emplace_back(std::make_shared<CCP15_Window>(soc::g_cp15));
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes all GUI windows.
        // -------------------------------------------------------------------------------------------------------------
        void Initialize_Windows()
        {
            Initialize_Logging_Window();
            Initialize_Emulator_Windows();
            Initialize_Peripheral_Windows();
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Renders all GUI windows.
        // -------------------------------------------------------------------------------------------------------------
        void Render_GUI()
        {
            // Render external peripherals.
            // clang-format off
            std::for_each(s_windows.begin(),
                          s_windows.end(),
                          [](const auto& window) -> void { window->Render(); });
            // clang-format on

            /// Render emulator windows and peripheral windows
            std::for_each(soc::g_external_peripherals.begin(),
                          soc::g_external_peripherals.end(),
                          [](const auto& window) -> void { window->Render(); });
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Passes ImGuiContext to all external peripherals, so they can render themselves as GUIs.
        /// \param context ImGuiContext
        // -------------------------------------------------------------------------------------------------------------
        void Init_External_GUIs(ImGuiContext* context)
        {
            std::for_each(soc::g_external_peripherals.begin(),
                          soc::g_external_peripherals.end(),
                          [&](const auto& window) -> void { window->Set_ImGui_Context(context); });
        }
    }

    int Main_GUI([[maybe_unused]] int argc, [[maybe_unused]] const char* argv[])
    {
        // Initialize all windows.
        Initialize_Windows();

        // Set up a GLFW error callback.
        glfwSetErrorCallback([](int error_code, const char* description) -> void {
            soc::g_logging_system.Error(
            fmt::format("Error {} occurred when initializing GLFW: {}", error_code, description).c_str());
            std::terminate();
        });

        // Init GLFW.
        if (glfwInit() != GLFW_TRUE)
        {
            soc::g_logging_system.Error("Failed to initialize GLFW");
            return 1;
        }

        // Set up GLFW window hints.
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

        // Create a GLFW window.
        GLFWwindow* window = glfwCreateWindow(Window_Width, Window_Height, Window_Title, nullptr, nullptr);

        // Make sure the window was created successfully.
        if (window == nullptr)
        {
            soc::g_logging_system.Error("Failed to create a GLFW window");
            return 1;
        }

        // Set up GLFW context and swap interval.
        glfwMakeContextCurrent(window);
        glfwSwapInterval(1);

        // Init GLEW.
        if (glewInit() != GLEW_OK)
        {
            soc::g_logging_system.Error("Failed to initialize GLEW");
            return 1;
        }

        // Create an ImGUI context.
        IMGUI_CHECKVERSION();
        ImGuiContext* context = ImGui::CreateContext();

        // Set up some config flags.
        ImGuiIO& imgui_io = ImGui::GetIO();
        imgui_io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
        imgui_io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
        imgui_io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;

        // Set up window style.
        ImGui::StyleColorsDark();
        ImGuiStyle& style = ImGui::GetStyle();
        style.FrameRounding = 4.0F;

        if ((imgui_io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable) != 0)
        {
            style.WindowRounding = 0.0F;
            style.Colors[ImGuiCol_WindowBg].w = 1.0F;
        }

        // Init ImGUI GLFW with OpenGL implementation.
        ImGui_ImplGlfw_InitForOpenGL(window, true);
        ImGui_ImplOpenGL3_Init("#version 130");

        // Attempt to load a custom font and icons.
        if (std::filesystem::exists(config::Font_Path) && std::filesystem::exists(config::Icons_Path))
        {
            // Load a custom font.
            imgui_io.Fonts->AddFontFromFileTTF(config::Font_Path, 15.0F);

            // Set up a base font size and calculate the appropriate icon size.
            const float baseFontSize = 13.0F;
            const float iconFontSize = baseFontSize * 2.0F / 3.0F;

            static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_16_FA, 0 };
            ImFontConfig icons_config;
            icons_config.MergeMode = true;
            icons_config.PixelSnapH = true;
            icons_config.GlyphMinAdvanceX = iconFontSize;

            // Load up icons.
            imgui_io.Fonts->AddFontFromFileTTF(config::Icons_Path, iconFontSize, &icons_config, icons_ranges);
        }
        else
        {
            // Use the default font.
            soc::g_logging_system.Warning("Failed to load the font and font (using the default one)");
            imgui_io.Fonts->AddFontDefault();
        }

        int display_w{};
        int display_h{};

        // Initialize external peripherals (provide them with the ImGuiContext)
        Init_External_GUIs(context);

        // Load the window logo.
        GLFWimage images[1];
        images[0].pixels = stbi_load(config::Window_Icon_Path, &images[0].width, &images[0].height, 0, 4);

        // Make sure the logo was loaded successfully.
        if (images[0].pixels != nullptr)
        {
            glfwSetWindowIcon(window, 1, images);
        }

        // Free the junk of allocated memory.
        stbi_image_free(images[0].pixels);

        // Main loop
        while (glfwWindowShouldClose(window) == 0)
        {
            // Poll events.
            glfwPollEvents();

            // Create a new frame
            ImGui_ImplOpenGL3_NewFrame();
            ImGui_ImplGlfw_NewFrame();
            ImGui::NewFrame();

            // Do not forge to set ImGuiContext.
            ImGui::SetCurrentContext(context);

            // Dockspace flags
            [[maybe_unused]] static bool dockspace_open = true;
            static ImGuiDockNodeFlags dockspace_flags = ImGuiDockNodeFlags_None;

            // Create viewport and set window flags.
            ImGuiWindowFlags window_flags = ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoDocking;
            const ImGuiViewport* viewport = ImGui::GetMainViewport();

            ImGui::SetNextWindowPos(viewport->WorkPos);
            ImGui::SetNextWindowSize(viewport->WorkSize);
            ImGui::SetNextWindowViewport(viewport->ID);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0F);
            ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0F);

            // clang-format off
            window_flags |= ImGuiWindowFlags_NoTitleBar |
                            ImGuiWindowFlags_NoCollapse |
                            ImGuiWindowFlags_NoResize |
                            ImGuiWindowFlags_NoMove |
                            ImGuiWindowFlags_NoBringToFrontOnFocus |
                            ImGuiWindowFlags_NoNavFocus;
            // clang-format on

            if ((dockspace_flags & ImGuiDockNodeFlags_PassthruCentralNode) != 0)
            {
                window_flags |= ImGuiWindowFlags_NoBackground;
            }

            // State a dockspace
            ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0F, 0.0F));
            ImGui::Begin("##ZeroMate Dockspace", &dockspace_open, window_flags);
            ImGui::PopStyleVar();
            ImGui::PopStyleVar(2);

            if ((imgui_io.ConfigFlags & ImGuiConfigFlags_DockingEnable) != 0)
            {
                const ImGuiID dockspace_id = ImGui::GetID("ZeroMateDockspace");
                ImGui::DockSpace(dockspace_id, ImVec2(0.0F, 0.0F), dockspace_flags);
            }

            // Render all GUI windows.
            zero_mate::gui::Render_GUI();

            // End of the dockspace.
            ImGui::End();

            // Render the frame.
            ImGui::Render();
            glfwGetFramebufferSize(window, &display_w, &display_h);
            glViewport(0, 0, display_w, display_h);
            glClear(GL_COLOR_BUFFER_BIT);
            ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

            if ((imgui_io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable) != 0)
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

} // namespace zero_mate::gui