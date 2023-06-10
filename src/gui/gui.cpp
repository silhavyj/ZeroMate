#include <filesystem>

#include <dylib.hpp>
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <imgui/imgui.h>
#include <magic_enum.hpp>
#include <inih/cpp/INIReader.h>
#include <imgui/backends/imgui_impl_glfw.h>
#include <imgui/backends/imgui_impl_opengl3.h>
#include <IconFontCppHeaders/IconsFontAwesome5.h>

#include <zero_mate/external_peripheral.hpp>

#include "../config.hpp"

#include "gui.hpp"
#include <zero_mate/gui_window.hpp>
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

#include "windows/peripherals/external/button_window.hpp"
#include "windows/peripherals/external/seven_segment_display_window.hpp"

#include "../core/peripherals/trng.hpp"

#include "../core/utils/singleton.hpp"
#include "../core/utils/logger/logger_stdo.hpp"

namespace zero_mate::gui
{
    static inline constexpr const char* const WINDOW_TITLE = "ZeroMate - Rpi Zero emulator";

    static inline constexpr std::uint32_t WINDOW_WIDTH = 1240;
    static inline constexpr std::uint32_t WINDOW_WEIGHT = 720;

    namespace
    {
        IExternal_Peripheral *button_peripheral{ nullptr };
        const dylib button_dl{"/home/silhavyj/School/ZeroMate/build/unix_makefiles/debug/lib/button/", "button"};

        auto logger_stdo = std::make_shared<utils::CLogger_STDO>();
        auto& s_logging_system = *utils::CSingleton<utils::CLogging_System>::Get_Instance();

        std::shared_ptr<peripheral::CRAM> s_ram{ nullptr };
        auto s_bus = std::make_shared<CBus>();
        auto s_cpu = std::make_shared<arm1176jzf_s::CCPU_Core>(0, s_bus);
        auto s_cp15 = std::make_shared<coprocessor::CCP15>(s_cpu->Get_CPU_Context());
        auto s_interrupt_controller = std::make_shared<peripheral::CInterrupt_Controller>(s_cpu->Get_CPU_Context());
        auto s_arm_timer = std::make_shared<peripheral::CARM_Timer>(s_interrupt_controller);
        auto s_gpio = std::make_shared<peripheral::CGPIO_Manager>(s_interrupt_controller);
        auto s_monitor = std::make_shared<peripheral::CMonitor>();
        auto s_trng = std::make_shared<peripheral::CTRNG>();

        auto s_shift_register = std::make_shared<peripheral::external::CShift_Register<>>(s_gpio, 2, 3, 4);
        auto s_button = std::make_shared<peripheral::external::CButton>(s_gpio, 5);

        std::vector<utils::elf::TText_Section_Record> s_source_code{};
        auto s_log_window = std::make_shared<CLog_Window>();
        bool s_scroll_to_curr_line{ false };
        bool s_elf_file_has_been_loaded{ false };
        bool s_cpu_running{ false };

        std::vector<std::shared_ptr<peripheral::IPeripheral>> s_peripherals;
        std::vector<std::shared_ptr<IGUI_Window>> s_windows;
        std::vector<IGUI_Window *> s_external_windows;

        struct TINI_Config_Values
        {
            std::uint32_t ram_size;
            std::uint32_t ram_map_addr;
            std::uint32_t gpio_map_addr;
            std::uint32_t interrupt_controller_map_addr;
            std::uint32_t arm_timer_map_addr;
            std::uint32_t monitor_map_addr;
            std::uint32_t trng_map_addr;
        };

        [[nodiscard]] bool Read_Pin(std::uint32_t pin_idx)
        {
            return s_gpio->Read_GPIO_Pin(pin_idx) == peripheral::CGPIO_Manager::CPin::NState::High;
        }

        void Set_Pin(std::uint32_t pin_idx, bool set)
        {
            const auto status = s_gpio->Set_Pin_State(pin_idx, static_cast<peripheral::CGPIO_Manager::CPin::NState>(set));

            switch (status)
            {
                case peripheral::CGPIO_Manager::NPin_Set_Status::OK:
                    break;

                case peripheral::CGPIO_Manager::NPin_Set_Status::Not_Input_Pin:
                    s_logging_system.Debug("The pin has not been set as INPUT");
                    break;

                case peripheral::CGPIO_Manager::NPin_Set_Status::Invalid_Pin_Number:
                    s_logging_system.Debug("Invalid pin number");
                    break;

                case peripheral::CGPIO_Manager::NPin_Set_Status::State_Already_Set:
                    s_logging_system.Debug("Pin state is already set the desired value");
                    break;
            }
        }

        void Initialize_Logging_System()
        {
            logger_stdo->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);
            s_log_window->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);

            s_logging_system.Add_Logger(logger_stdo);
            s_logging_system.Add_Logger(s_log_window);
        }

        void Initialize_Windows()
        {
            s_windows.emplace_back(std::make_shared<CRegisters_Window>(s_cpu, s_cpu_running));
            s_windows.push_back(std::make_shared<CRAM_Window>(s_ram));
            s_windows.emplace_back(std::make_shared<CControl_Window>(s_cpu, s_scroll_to_curr_line, s_elf_file_has_been_loaded, s_cpu_running, s_peripherals, s_bus));
            s_windows.emplace_back(std::make_shared<CSource_Code_Window>(s_cpu, s_source_code, s_scroll_to_curr_line, s_cpu_running));
            s_windows.emplace_back(std::make_shared<CFile_Window>(s_bus, s_cpu, s_source_code, s_elf_file_has_been_loaded, s_peripherals));
            s_windows.emplace_back(std::make_shared<CGPIO_Window>(s_gpio));
            s_windows.emplace_back(s_log_window);
            s_windows.emplace_back(std::make_shared<CInterrupt_Controller_Window>(s_interrupt_controller));
            s_windows.emplace_back(std::make_shared<CARM_Timer_Window>(s_arm_timer));
            s_windows.emplace_back(std::make_shared<CMonitor_Window>(s_monitor));
            s_windows.emplace_back(std::make_shared<CCP15_Window>(s_cp15));

            s_windows.emplace_back(std::make_shared<external_peripheral::CButton_Window>(s_button));
            s_windows.emplace_back(std::make_shared<external_peripheral::CSeven_Segment_Display>(s_shift_register));

            // TODO
            // typedef int (*Create_Peripheral_Ptr)(IExternal_Peripheral**, const std::string&, const std::vector<std::uint32_t>&, std::function<void(int, bool)>, std::function<bool(int)>);

            const std::vector<std::uint32_t> pin{ 5 };
            auto create_peripheral = button_dl.get_function<int(IExternal_Peripheral**, const std::string&, const std::vector<std::uint32_t>&, std::function<void(int, bool)>, std::function<bool(int)>)>("Create_Peripheral");
            [[maybe_unused]] int status = create_peripheral(&button_peripheral, "My_Button", pin, Set_Pin, Read_Pin);

            if (button_peripheral != nullptr && button_peripheral->Implements_GUI())
            {
                //s_external_windows.push_back((IGUI_Window *)button_peripheral);
            }
        }

        template<typename Peripheral>
        inline void Attach_Peripheral_To_Bus(const char* name, std::uint32_t addr, std::shared_ptr<Peripheral> peripheral)
        {
            s_logging_system.Info(fmt::format("Mapping the {} ({} [B]) to the bus address 0x{:08X}", name, peripheral->Get_Size(), addr).c_str());
            const auto status = s_bus->Attach_Peripheral(addr, peripheral);

            if (status != CBus::NStatus::OK)
            {
                s_logging_system.Error(fmt::format("Failed to attach the {} to the bus address (error value = {})", name, magic_enum::enum_name(status)).c_str());
            }
            else
            {
                s_peripherals.emplace_back(peripheral);
            }
        }

        template<typename Type>
        [[nodiscard]] Type Get_Ini_Value(const INIReader& ini_reader, const std::string& section, const std::string& value, Type default_value)
        {
            if (ini_reader.HasSection(section))
            {
                if (ini_reader.HasValue(section, value))
                {
                    return static_cast<Type>(ini_reader.GetUnsigned(section, value, default_value));
                }
                else
                {
                    s_logging_system.Error(fmt::format("Value {} was not found in section {} of the config file ({}). Using default value 0x{:08X} for the {} value", value, section, config::CONFIG_FILE, default_value, value).c_str());
                    return default_value;
                }
            }
            else
            {
                s_logging_system.Error(fmt::format("Section {} was not found in {}. Using default value 0x{:08X} for the {} value", section, config::CONFIG_FILE, default_value, value).c_str());
                return default_value;
            }
        }

        [[nodiscard]] TINI_Config_Values Parse_INI_Config_File()
        {
            TINI_Config_Values config_values{
                .ram_size = config::DEFAULT_RAM_SIZE,
                .ram_map_addr = config::DEFAULT_RAM_MAP_ADDR,
                .gpio_map_addr = config::DEFAULT_GPIO_MAP_ADDR,
                .interrupt_controller_map_addr = config::DEFAULT_INTERRUPT_CONTROLLER_MAP_ADDR,
                .arm_timer_map_addr = config::DEFAULT_ARM_TIMER_MAP_ADDR,
                .monitor_map_addr = config::DEFAULT_MONITOR_MAP_ADDR,
                .trng_map_addr = config::DEFAULT_TRNG_MAP_ADDR
            };

            const INIReader ini_reader(config::CONFIG_FILE);

            if (ini_reader.ParseError() < 0)
            {
                s_logging_system.Error(fmt::format("Cannot load {}. Using the default mappings", config::CONFIG_FILE).c_str());
            }
            else
            {
                config_values.ram_size = Get_Ini_Value<std::uint32_t>(ini_reader, config::RAM_SECTION, "size", config::DEFAULT_RAM_SIZE);
                config_values.ram_map_addr = Get_Ini_Value<std::uint32_t>(ini_reader, config::RAM_SECTION, "addr", config::DEFAULT_RAM_MAP_ADDR);
                config_values.gpio_map_addr = Get_Ini_Value<std::uint32_t>(ini_reader, config::GPIO_SECTION, "addr", config::DEFAULT_GPIO_MAP_ADDR);
                config_values.interrupt_controller_map_addr = Get_Ini_Value<std::uint32_t>(ini_reader, config::INTERRUPT_CONTROLLER_SECTION, "addr", config::DEFAULT_INTERRUPT_CONTROLLER_MAP_ADDR);
                config_values.arm_timer_map_addr = Get_Ini_Value<std::uint32_t>(ini_reader, config::ARM_TIMER_SECTION, "addr", config::DEFAULT_ARM_TIMER_MAP_ADDR);
                config_values.monitor_map_addr = Get_Ini_Value<std::uint32_t>(ini_reader, config::MONITOR_SECTION, "addr", config::DEFAULT_MONITOR_MAP_ADDR);
                config_values.trng_map_addr = Get_Ini_Value<std::uint32_t>(ini_reader, config::TRNG_SECTION, "addr", config::DEFAULT_TRNG_MAP_ADDR);
            }

            return config_values;
        }

        void Init_CPU()
        {
            s_cpu->Set_Interrupt_Controller(s_interrupt_controller);
            s_cpu->Register_System_Clock_Listener(s_arm_timer);
            s_cpu->Add_Coprocessor(coprocessor::CCP15::ID, s_cp15);
        }

        void Init_BUS()
        {
            s_bus->Set_CP15(s_cp15);
        }

        void Initialize_Peripherals()
        {
            const auto config_values = Parse_INI_Config_File();

            s_ram = std::make_shared<peripheral::CRAM>(config_values.ram_size);

            Attach_Peripheral_To_Bus<peripheral::CRAM>("RAM memory", config_values.ram_map_addr, s_ram);
            Attach_Peripheral_To_Bus<peripheral::CInterrupt_Controller>("interrupt controller", config_values.interrupt_controller_map_addr, s_interrupt_controller);
            Attach_Peripheral_To_Bus<peripheral::CGPIO_Manager>("GPIO pin registers", config_values.gpio_map_addr, s_gpio);
            Attach_Peripheral_To_Bus<peripheral::CARM_Timer>("ARM timer", config_values.arm_timer_map_addr, s_arm_timer);
            Attach_Peripheral_To_Bus<peripheral::CMonitor>("monitor", config_values.monitor_map_addr, s_monitor);
            Attach_Peripheral_To_Bus<peripheral::CTRNG>("trng", config_values.trng_map_addr, s_trng);

            Init_CPU();
            Init_BUS();

            s_gpio->Add_External_Peripheral(s_shift_register);
        }

        void Initialize()
        {
            Initialize_Logging_System();
            Initialize_Peripherals();
            Initialize_Windows();
        }

        void Render_GUI()
        {
            std::for_each(s_windows.begin(), s_windows.end(), [](const auto& window) -> void { window->Render(); });
            std::for_each(s_external_windows.begin(), s_external_windows.end(), [](const auto& window) -> void { window->Render(); });
        }
    }

    int Main_GUI([[maybe_unused]] int argc, [[maybe_unused]] const char* argv[])
    {
        Initialize();

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

        if (std::filesystem::exists(config::FONT_PATH) && std::filesystem::exists(config::ICONS_PATH))
        {
            imgui_io.Fonts->AddFontFromFileTTF(config::FONT_PATH, 15.0f);

            const float baseFontSize = 13.0f;
            const float iconFontSize = baseFontSize * 2.0f / 3.0f;

            static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_16_FA, 0 };
            ImFontConfig icons_config;
            icons_config.MergeMode = true;
            icons_config.PixelSnapH = true;
            icons_config.GlyphMinAdvanceX = iconFontSize;
            imgui_io.Fonts->AddFontFromFileTTF(config::ICONS_PATH, iconFontSize, &icons_config, icons_ranges);
        }
        else
        {
            s_logging_system.Warning("Failed to load the font and font (using the default one)");
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