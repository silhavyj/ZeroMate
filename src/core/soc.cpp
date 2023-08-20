// ---------------------------------------------------------------------------------------------------------------------
/// \file spc.cpp
/// \date 16. 06. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file implements the entire system on chip (SoC).
///
/// It creates, hooks up, and provides access to individual peripherals used on the Raspberry Pi Zero board.
/// Any file includes his header file can access all Raspberry Pi Zero components (CPU, RAM, ...)
// ---------------------------------------------------------------------------------------------------------------------

// STL imports (excluded from Doxygen)
/// \cond
#include <map>
#include <fstream>
#include <utility>
#include <unordered_set>
/// \endcond

// 3rd party library includes

#include "dylib.hpp"
#include "fmt/format.h"
#include "magic_enum.hpp"
#include "nlohmann/json.hpp"

// Project file imports

#include "soc.hpp"
#include "zero_mate/utils/singleton.hpp"
#include "../utils/logger/logger_stdo.hpp"

namespace zero_mate::soc
{
    // Initialize the logging system.
    utils::CLogging_System& g_logging_system = *utils::CSingleton<utils::CLogging_System>::Get_Instance();

    // RAM
    std::shared_ptr<peripheral::CRAM> g_ram{ nullptr };

    // Bus
    std::shared_ptr<CBus> g_bus = std::make_shared<CBus>();

    // CPU
    std::shared_ptr<arm1176jzf_s::CCPU_Core> g_cpu = std::make_shared<arm1176jzf_s::CCPU_Core>(0, g_bus);

    // CP15
    std::shared_ptr<coprocessor::cp15::CCP15> g_cp15 =
    std::make_shared<coprocessor::cp15::CCP15>(g_cpu->Get_CPU_Context());

    // FPU
    std::shared_ptr<coprocessor::cp10::CFPU> g_fpu =
    std::make_shared<coprocessor::cp10::CFPU>(g_cpu->Get_CPU_Context());

    // MMU
    std::shared_ptr<arm1176jzf_s::mmu::CMMU> g_mmu = std::make_shared<arm1176jzf_s::mmu::CMMU>(g_bus, g_cp15);

    // IC (interrupt controller)
    std::shared_ptr<peripheral::CInterrupt_Controller> g_ic =
    std::make_shared<peripheral::CInterrupt_Controller>(g_cpu->Get_CPU_Context());

    // ARM timer
    std::shared_ptr<peripheral::CARM_Timer> g_arm_timer = std::make_shared<peripheral::CARM_Timer>(g_ic);

    // GPIO
    std::shared_ptr<peripheral::CGPIO_Manager> g_gpio = std::make_shared<peripheral::CGPIO_Manager>(g_ic);

    // Monitor
    std::shared_ptr<peripheral::CMonitor> g_monitor = std::make_shared<peripheral::CMonitor>();

    // TRNG (random number generator)
    std::shared_ptr<peripheral::CTRNG> g_trng = std::make_shared<peripheral::CTRNG>();

    // AUX
    std::shared_ptr<peripheral::CAUX> g_aux = std::make_shared<peripheral::CAUX>(g_gpio, g_ic);

    // BSC 1
    std::shared_ptr<peripheral::CBSC> g_bsc_1 = std::make_shared<peripheral::CBSC>(g_gpio);

    // BSC 2
    std::shared_ptr<peripheral::CBSC> g_bsc_2 = std::make_shared<peripheral::CBSC>(g_gpio);

    // BSC 3
    std::shared_ptr<peripheral::CBSC> g_bsc_3 = std::make_shared<peripheral::CBSC>(g_gpio);

    // Initialize the collection of all internal peripherals as well as a collection of all external
    // peripherals that are connected to the board via GPIO.
    std::vector<std::shared_ptr<peripheral::IPeripheral>> g_peripherals{};
    std::vector<IExternal_Peripheral*> g_external_peripherals{};

    // Anonymous namespace to make its content visible only to this translation unit.
    namespace
    {
        // Instance of an STDO logger
        auto s_logger_stdo = std::make_shared<utils::CLogger_STDO>();

        // Collection of open shared libraries (key: {dir, name}, value: lib)
        std::map<std::pair<std::string, std::string>, std::shared_ptr<dylib>> s_shared_libs;

        // Collection of unique names of external peripherals connected to the system
        std::unordered_set<std::string> s_external_peripheral_names;

        // -------------------------------------------------------------------------------------------------------------
        /// \struct TPeripheral_Config
        /// \brief This structure contains a configuration of an external peripheral
        // -------------------------------------------------------------------------------------------------------------
        struct TPeripheral_Config
        {
            std::string name;                      ///< Name of the external peripherals
            std::vector<std::uint32_t> connection; ///< Connection of the external peripheral (GPIO pins, I2C addr, ...)
            std::string lib_dir;                   ///< Path to the directory where the shared library is located
            std::string lib_name;                  ///< Name of the shared library
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads the state of a GPIO pin.
        ///
        /// Every external peripheral is provided with this function upon its construction so it can interact
        /// with the rest of the system.
        ///
        /// \param pin_idx Index of the GPIO pin whose state is going to be returned
        /// \return true, if the pin is set to high. false, otherwise
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Read_GPIO_Pin(std::uint32_t pin_idx)
        {
            // Use to the GPIO manager to retrieve the state of the given pin.
            return g_gpio->Read_GPIO_Pin(pin_idx) == peripheral::CGPIO_Manager::CPin::NState::High;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the state of a GPIO pin.
        ///
        /// Every external peripheral is provided with this function upon its construction so it can interact
        /// with the rest of the system.
        ///
        /// \param pin_idx Index of the GPIO pin whose state is going to be set
        /// \param set Sta to which the GPIO is going to be set
        /// \return Returns status of the action (see peripheral::CGPIO_Manager::CPin::NState)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] int Set_GPIO_Pin(std::uint32_t pin_idx, bool set)
        {
            const auto status =
            g_gpio->Set_Pin_State(pin_idx, static_cast<peripheral::CGPIO_Manager::CPin::NState>(set));
            return static_cast<int>(status);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the logging system.
        // -------------------------------------------------------------------------------------------------------------
        void Initialize_Logging_System()
        {
            // Set the default logging level of the STDO debugger to Debug.
            s_logger_stdo->Set_Logging_Level(utils::ILogger::NLogging_Level::Debug);

            // Add the logger to the logging system.
            g_logging_system.Add_Logger(s_logger_stdo);
        }

        // clang-format off
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Attaches a peripherals to a given address on the bus.
        /// \tparam Peripheral Type of the peripheral to be mapped to the address space
        /// \param name Name of the peripheral
        /// \param addr Address where the peripheral is going to be mapped
        /// \param peripheral Reference to the peripherals itself
        // -------------------------------------------------------------------------------------------------------------
        template<typename Peripheral>
        inline void Attach_Peripheral_To_Bus(const char* name,
                                             std::uint32_t addr,
                                             std::shared_ptr<Peripheral> peripheral)
        {
            // Log a message saying that a peripheral is being mapped.
            g_logging_system.Info(fmt::format("Mapping the {} ({} [B]) to the bus address 0x{:08X}",
                                              name, peripheral->Get_Size(), addr).c_str());

            // Map the peripheral to the bus.
            const auto status = g_bus->Attach_Peripheral(addr, peripheral);

            // Make sure all went where (there were no collisions on the bus, ...).
            if (status != CBus::NStatus::OK)
            {
                g_logging_system.Error(fmt::format("Failed to attach the {} to the bus address (error value = {})",
                                                   name, magic_enum::enum_name(status)) .c_str());
            }
            else
            {
                // If mapped successfully, add the peripheral to the global collection of all peripherals.
                g_peripherals.emplace_back(peripheral);
            }
        }
        // clang-format on

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes all peripherals (internal).
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize_Peripherals()
        {
            // Initialize the RAM.
            g_ram = std::make_shared<peripheral::CRAM>(config::RAM_Size);

            // Map the peripherals to the bus.
            Attach_Peripheral_To_Bus<peripheral::CRAM>("RAM memory", config::RAM_Address, g_ram);
            Attach_Peripheral_To_Bus<peripheral::CInterrupt_Controller>("interrupt controller",
                                                                        config::IC_Address,
                                                                        g_ic);
            Attach_Peripheral_To_Bus<peripheral::CGPIO_Manager>("GPIO", config::GPIO_Address, g_gpio);
            Attach_Peripheral_To_Bus<peripheral::CARM_Timer>("ARM timer", config::ARM_Timer_Address, g_arm_timer);
            Attach_Peripheral_To_Bus<peripheral::CMonitor>("monitor", config::Monitor_Address, g_monitor);
            Attach_Peripheral_To_Bus<peripheral::CTRNG>("TRNG", config::TRNG_Address, g_trng);
            Attach_Peripheral_To_Bus<peripheral::CAUX>("AUX", config::AUX_Address, g_aux);
            Attach_Peripheral_To_Bus<peripheral::CBSC>("BSC_1", config::BSC_1_Address, g_bsc_1);
            Attach_Peripheral_To_Bus<peripheral::CBSC>("BSC_2", config::BSC_2_Address, g_bsc_2);
            Attach_Peripheral_To_Bus<peripheral::CBSC>("BSC_3", config::BSC_3_Address, g_bsc_3);

            // Attach the interrupt controller, MMU, external peripherals, and CP15 to the CPU.
            g_cpu->Set_Interrupt_Controller(g_ic);
            g_cpu->Add_Coprocessor(coprocessor::cp15::CCP15::ID, g_cp15);
            g_cpu->Add_Coprocessor(coprocessor::cp10::CFPU::ID, g_fpu);
            g_cpu->Set_MMU(g_mmu);
            g_cpu->Set_External_Peripherals(&g_external_peripherals);

            // Register system clock listeners.
            g_cpu->Register_System_Clock_Listener(g_arm_timer);
            g_cpu->Register_System_Clock_Listener(g_aux);
            g_cpu->Register_System_Clock_Listener(g_bsc_1);
            g_cpu->Register_System_Clock_Listener(g_bsc_2);
            g_cpu->Register_System_Clock_Listener(g_bsc_3);

            // Add a reference to CP15 to the bus, so it knows whether to check for unaligned memory access.
            g_bus->Set_CP15(g_cp15);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads and parses a given JSON config file
        /// \param path Path to the configuration file
        /// \return JSON object (contents of the file). If the input file is not a JSON file,
        /// and empty object is returned).
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline nlohmann::json Parse_JSON_File(const std::string& path)
        {
            // Open the config file in a read-only mode.
            std::ifstream config_file{ path, std::fstream::in };

            // Make sure the file has been opened successfully.
            if (!config_file)
            {
                g_logging_system.Error(fmt::format("Cannot load {}", config::External_Peripherals_Config_File).c_str());

                // Return an empty JSON object.
                return {};
            }

            try
            {
                // Attempt to parse the file's contents.
                return nlohmann::json::parse(config_file);
            }
            catch ([[maybe_unused]] const std::exception& e)
            {
                // clang-format off
                g_logging_system.Error(fmt::format("Failed to parse the config file ({})",
                                       config::External_Peripherals_Config_File).c_str());
                // clang-format on

                // Return an empty JSON object.
                return {};
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Verifies that all necessary sections are present in a given JSON peripheral configuration.
        /// \param peripheral Configuration of an external peripheral
        /// \return true, if all required sections are preset. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool All_Sections_Presents(const nlohmann::json& peripheral)
        {
            // clang-format off
            if (!peripheral.contains(config::sections::Name) ||
                !peripheral.contains(config::sections::Connection) ||
                !peripheral.contains(config::sections::Lib_Name) ||
                !peripheral.contains(config::sections::Lib_Dir))
            {
                g_logging_system.Error(fmt::format("At least one of the following sections is missing in the {} "
                                                   "file: {}, {}, {}, or {}",
                                                   config::sections::Name,
                                                   config::sections::Connection,
                                                   config::sections::Lib_Name,
                                                   config::sections::Lib_Dir,
                                                   config::External_Peripherals_Config_File).c_str());
                return false;
            }
            // clang-format on

            return true;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Extracts data from config sections of a given peripheral (settings).
        /// \note To make sure the sections exist (#All_Sections_Presents must be called prior to calling this function)
        /// \param peripheral Peripheral (JSON object)
        /// \return Structure holding retrieved values
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline TPeripheral_Config Get_Peripheral_Config(const nlohmann::json& peripheral)
        {
            TPeripheral_Config config{};

            // Read data from the config sections.
            config.name = peripheral[config::sections::Name].template get<std::string>();
            config.connection = peripheral[config::sections::Connection].template get<std::vector<std::uint32_t>>();
            config.lib_name = peripheral[config::sections::Lib_Name].template get<std::string>();
            config.lib_dir = peripheral[config::sections::Lib_Dir].template get<std::string>();

            return config;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of an external peripheral and connects it to the system.
        /// \param config Configuration of the external peripheral (dll path, name, etc.)
        // -------------------------------------------------------------------------------------------------------------
        inline void Create_External_Peripheral(const TPeripheral_Config& config)
        {
            // Create a unique ID of a shared library.
            const std::pair<std::string, std::string> lib_id{ config.lib_dir, config.lib_name };

            try
            {
                // Check if this shared library has been loaded yet.
                if (!s_shared_libs.contains(lib_id))
                {
                    // If not, load it using the dylib library.
                    s_shared_libs[lib_id] = std::make_shared<dylib>(config.lib_dir, config.lib_name);
                }

                // Retrieve the shared library.
                const auto& lib = s_shared_libs.at(lib_id);

                // Get the address of the "Create_Peripheral" function located in the shared library.
                auto create_peripheral = lib->get_function<int(IExternal_Peripheral**,
                                                               const char* const,
                                                               const std::uint32_t* const,
                                                               std::size_t,
                                                               IExternal_Peripheral::Set_GPIO_Pin_t,
                                                               IExternal_Peripheral::Read_GPIO_Pin_t,
                                                               utils::CLogging_System*)>("Create_Peripheral");

                // Create room for the new external peripheral in the collection of all external peripherals
                g_external_peripherals.emplace_back();

                // Call the extern "Create_Peripheral" function to create the peripheral.
                const auto status = static_cast<IExternal_Peripheral::NInit_Status>(
                create_peripheral(&g_external_peripherals.back(),
                                  config.name.c_str(),
                                  config.connection.data(),
                                  config.connection.size(),
                                  &Set_GPIO_Pin,
                                  &Read_GPIO_Pin,
                                  utils::CSingleton<utils::CLogging_System>::Get_Instance()));

                switch (status)
                {
                    case IExternal_Peripheral::NInit_Status::OK:
                        // Add the peripheral to the GPIO manager, so it can notify it
                        // whenever the state of its pins changes.
                        g_gpio->Add_External_Peripheral(g_external_peripherals.back());

                        // No other external peripheral with the same name can be connected to the system again.
                        s_external_peripheral_names.insert(config.name);
                        break;

                    case IExternal_Peripheral::NInit_Status::GPIO_Mismatch:
                        // clang-format off
                        g_logging_system.Error(fmt::format("Failed to initialize an external peripheral: path = {}; "
                                                           "name = {} - number of expected GPIO pins does not match "
                                                           "the expected value",
                                                           config.lib_dir, config.lib_name).c_str());
                        // clang-format on
                        break;

                    case IExternal_Peripheral::NInit_Status::Allocation_Error:
                        // clang-format off
                        g_logging_system.Error(fmt::format("Failed to initialize an external peripheral: path = {}; "
                                                           "name = {} - allocation failed",
                                                           config.lib_dir, config.lib_name).c_str());
                        // clang-format on
                        break;

                    default:
                        // clang-format off
                        g_logging_system.Error(fmt::format("Failed to initialize an external peripheral: path = {}; "
                                                           "name = {} - unknown error number: {}",
                                                           config.lib_dir, config.lib_name,
                                                           static_cast<int>(status)).c_str());
                        // clang-format on
                        break;
                }

                if (status != IExternal_Peripheral::NInit_Status::OK)
                {
                    // We do not need room for the peripheral as it has not been created successfully.
                    g_external_peripherals.pop_back();
                }
            }
            catch ([[maybe_unused]] const std::exception& e)
            {
                // clang-format off
                g_logging_system.Error(fmt::format("Failed to load a shared library: path = {}; name = {} ",
                                                   config.lib_dir, config.lib_name).c_str());
                // clang-format on
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes external peripherals as they are defined in the config file.
        // -------------------------------------------------------------------------------------------------------------
        inline void Init_External_Peripherals()
        {
            // Get the data from the input file.
            nlohmann::json data = Parse_JSON_File(config::External_Peripherals_Config_File);

            // Make sure a "peripherals" section exists in the input file.
            if (!data.contains("peripherals"))
            {
                // clang-format off
                g_logging_system.Error(fmt::format("No peripherals section found in {}",
                                                   config::External_Peripherals_Config_File).c_str());
                // clang-format on

                return;
            }

            // Retrieve the peripherals.
            const auto peripherals = data["peripherals"];

            for (const auto& peripheral : peripherals)
            {
                // Make sure all sections are present (otherwise skip this peripheral).
                if (!All_Sections_Presents(peripheral))
                {
                    continue;
                }

                // Retrieve the configuration for the current peripheral.
                const TPeripheral_Config config = Get_Peripheral_Config(peripheral);

                // Make sure no such peripheral has been connected to the system.
                // Every peripheral name must be unique.
                if (s_external_peripheral_names.contains(config.name))
                {
                    // clang-format off
                    g_logging_system.Error(fmt::format("External peripheral named {} already exists",
                                                       config.name).c_str());
                    // clang-format on
                    continue;
                }

                // Create the peripheral.
                Create_External_Peripheral(config);
            }
        }
    }

    void Init()
    {
        Initialize_Logging_System();
        Initialize_Peripherals();
        Init_External_Peripherals();
    }

} // namespace zero_mate::soc