#include <map>
#include <fstream>
#include <utility>

#include <dylib.hpp>
#include <fmt/format.h>
#include <magic_enum.hpp>
#include <nlohmann/json.hpp>

#include "soc.hpp"
#include "core/utils/singleton.hpp"
#include "core/utils/logger/logger_stdo.hpp"

namespace zero_mate::soc
{
    utils::CLogging_System& g_logging_system = *utils::CSingleton<utils::CLogging_System>::Get_Instance();

    std::shared_ptr<peripheral::CRAM> g_ram{ nullptr };
    std::shared_ptr<zero_mate::CBus> g_bus = std::make_shared<CBus>();
    std::shared_ptr<arm1176jzf_s::CCPU_Core> g_cpu = std::make_shared<arm1176jzf_s::CCPU_Core>(0, g_bus);
    std::shared_ptr<coprocessor::CCP15> g_cp15 = std::make_shared<coprocessor::CCP15>(g_cpu->Get_CPU_Context());
    std::shared_ptr<peripheral::CInterrupt_Controller> g_ic = std::make_shared<peripheral::CInterrupt_Controller>(g_cpu->Get_CPU_Context());;
    std::shared_ptr<peripheral::CARM_Timer> g_arm_timer = std::make_shared<peripheral::CARM_Timer>(g_ic);
    std::shared_ptr<peripheral::CGPIO_Manager> g_gpio = std::make_shared<peripheral::CGPIO_Manager>(g_ic);
    std::shared_ptr<peripheral::CMonitor> g_monitor = std::make_shared<peripheral::CMonitor>();
    std::shared_ptr<peripheral::CTRNG> g_trng = std::make_shared<peripheral::CTRNG>();

    std::vector<std::shared_ptr<peripheral::IPeripheral>> g_peripherals{};
    std::vector<IExternal_Peripheral *> g_external_peripherals{};

    std::vector<utils::elf::TText_Section_Record> g_source_code{};

    bool g_scroll_to_curr_line{ false };
    bool g_elf_file_has_been_loaded{ false };
    bool g_cpu_running{ false };

    namespace
    {
        auto s_logger_stdo = std::make_shared<utils::CLogger_STDO>();
        std::map<std::pair<std::string, std::string>, std::shared_ptr<dylib>> s_shared_libs;

        void Initialize_Logging_System()
        {
            s_logger_stdo->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);
            g_logging_system.Add_Logger(s_logger_stdo);
        }

        template<typename Peripheral>
        inline void Attach_Peripheral_To_Bus(const char* name, std::uint32_t addr, std::shared_ptr<Peripheral> peripheral)
        {
            g_logging_system.Info(fmt::format("Mapping the {} ({} [B]) to the bus address 0x{:08X}", name, peripheral->Get_Size(), addr).c_str());
            const auto status = g_bus->Attach_Peripheral(addr, peripheral);

            if (status != CBus::NStatus::OK)
            {
                g_logging_system.Error(fmt::format("Failed to attach the {} to the bus address (error value = {})", name, magic_enum::enum_name(status)).c_str());
            }
            else
            {
                g_peripherals.emplace_back(peripheral);
            }
        }

        inline void Initialize_Peripherals()
        {
            g_ram = std::make_shared<peripheral::CRAM>(config::RAM_Size);

            Attach_Peripheral_To_Bus<peripheral::CRAM>("RAM memory", config::RAM_Address, g_ram);
            Attach_Peripheral_To_Bus<peripheral::CInterrupt_Controller>("nterrupt controller", config::IC_Address, g_ic);
            Attach_Peripheral_To_Bus<peripheral::CGPIO_Manager>("GPIO pin registers", config::GPIO_Address, g_gpio);
            Attach_Peripheral_To_Bus<peripheral::CARM_Timer>("ARM timer", config::ARM_Timer_Address, g_arm_timer);
            Attach_Peripheral_To_Bus<peripheral::CMonitor>("monitor", config::Monitor_Address, g_monitor);
            Attach_Peripheral_To_Bus<peripheral::CTRNG>("trng", config::TRNG_Address, g_trng);

            g_cpu->Set_Interrupt_Controller(g_ic);
            g_cpu->Register_System_Clock_Listener(g_arm_timer);
            g_cpu->Add_Coprocessor(coprocessor::CCP15::ID, g_cp15);

            g_bus->Set_CP15(g_cp15);
        }
    }

    inline void Init_External_Peripherals()
    {
        std::ifstream config_file(config::External_Peripherals_Config_File);

        if (!config_file)
        {
            g_logging_system.Error(fmt::format("Cannot load {}", config::External_Peripherals_Config_File).c_str());
            return;
        }

        nlohmann::json data = nlohmann::json::parse(config_file);

        if (!data.contains("peripherals"))
        {
            g_logging_system.Error(fmt::format("No peripherals section found in {}", config::External_Peripherals_Config_File).c_str());
            return;
        }

        const auto peripherals = data["peripherals"];

        for (const auto& peripheral : peripherals)
        {
            if (!peripheral.contains("name") || !peripheral.contains("pins") || !peripheral.contains("lib_name") || !peripheral.contains("lib_path"))
            {
                g_logging_system.Error(fmt::format("At least one of the following sections is missing in the {} file: name, pins, lib_name, or lib_path", config::External_Peripherals_Config_File).c_str());
                return;
            }

            // TODO catch a possible exception

            const auto name = peripheral["name"].template get<std::string>();
            const std::vector<std::uint32_t> pins = peripheral["pins"].template get<std::vector<std::uint32_t>>();
            const auto lib_name = peripheral["lib_name"].template get<std::string>();
            const auto lib_path = peripheral["lib_path"].template get<std::string>();

            try
            {
                const std::pair<std::string, std::string> lib_id{ lib_path, lib_name };

                if (!s_shared_libs.contains(lib_id))
                {
                    s_shared_libs[lib_id] = std::make_shared<dylib>(lib_path, lib_name);
                }

                const auto& lib = s_shared_libs.at(lib_id);

                auto create_peripheral = lib->get_function<int(IExternal_Peripheral**, const std::string&, const std::vector<std::uint32_t>&, std::function<void(int, bool)>, std::function<bool(int)>)>("Create_Peripheral");

                g_external_peripherals.emplace_back();

                // TODO
                [[maybe_unused]] const int status = create_peripheral(&g_external_peripherals.back(), name, pins, Set_GPIO_Pin, Read_GPIO_Pin);
                g_gpio->Add_External_Peripheral(g_external_peripherals.back());

            } catch (const std::exception &)
            {
                g_logging_system.Error(fmt::format("Failed to {} ", lib_name).c_str());
            }
        }
    }

    [[nodiscard]] bool Read_GPIO_Pin(std::uint32_t pin_idx)
    {
        return g_gpio->Read_GPIO_Pin(pin_idx) == peripheral::CGPIO_Manager::CPin::NState::High;
    }

    [[nodiscard]] int Set_GPIO_Pin(std::uint32_t pin_idx, bool set)
    {
        const auto status = g_gpio->Set_Pin_State(pin_idx, static_cast<peripheral::CGPIO_Manager::CPin::NState>(set));
        return static_cast<int>(status);
    }

    void Init()
    {
        Initialize_Logging_System();
        Initialize_Peripherals();
        Init_External_Peripherals();
    }
}