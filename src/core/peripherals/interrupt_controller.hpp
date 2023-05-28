// ---------------------------------------------------------------------------------------------------------------------
/// \file interrupt_controller.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines the interrupt controller used BCM2835.
///
/// To find more information about this instruction, please visit
/// https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf (chapter 7)
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <unordered_map>
/// \endcond

// Project file imports

#include "peripheral.hpp"
#include "../arm1176jzf_s/context.hpp"
#include "../utils/logger/logger.hpp"

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CInterrupt_Controller
    /// \brief This class represents the interrupt controller used in BCM2835.
    // -----------------------------------------------------------------------------------------------------------------
    class CInterrupt_Controller final : public IPeripheral
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \enum NRegister
        /// \brief This enumeration lists out all interrupt control registers.
        // -------------------------------------------------------------------------------------------------------------
        enum class NRegister : std::uint32_t
        {
            IRQ_Basic_Pending = 0, ///< Bitmask of pending basic IRQs
            IRQ_Pending_1,         ///< Bitmask of pending shared IRQs 0-31
            IRQ_Pending_2,         ///< Bitmask of pending shared IRQs 32-63
            FIQ_Control,           ///< Fast interrupt control
            Enable_IRQs_1,         ///< Write 1 to the corresponding bit(s) to enable one or more IRQs (0-31)
            Enable_IRQs_2,         ///< Write 1 to the corresponding bit(s) to enable one or more IRQs (32-63)
            Enable_Basic_IRQs,     ///< Write 1 to the corresponding bit(s) to enable one or more ARM-specific IRQs
            Disable_IRQs_1,        ///< Write 1 to the corresponding bit(s) to disable one or more IRQs (0-31)
            Disable_IRQs_2,        ///< Write 1 to the corresponding bit(s) to disable one or more IRQs (32-63)
            Disable_Basic_IRQs,    ///< Write 1 to the corresponding bit(s) to disable one or more ARM-specific IRQs
            Count                  ///< Total number of register (helper enum record)
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NIRQ_Basic_Source
        /// \brief This enumeration defines different IRQ basic source that can trigger an interrupt.
        ///
        /// Each value represents a bit position in the corresponding enable/disable register.
        // -------------------------------------------------------------------------------------------------------------
        enum class NIRQ_Basic_Source : std::uint32_t
        {
            ARM_Timer = 0,             ///< ARM timer
            ARM_Mailbox = 1,           ///< Mailbox
            ARM_Doorbell_0 = 2,        ///< Doorbell 0
            ARM_Doorbell_1 = 3,        ///< Doorbell 0
            GPU_0_Halted = 4,          ///< GPU halted 0
            GPU_1_Halted = 5,          ///< GPU halted 0
            Illegal_Access_Type_1 = 6, ///< Illegal access type 1
            Illegal_Access_Type_0 = 7, ///< Illegal access type 0
        };

        // -------------------------------------------------------------------------------------------------------------
        /// \enum NIRQ_Source
        /// \brief This enumeration defines different IRQ source that can trigger an interrupt.
        ///
        /// Each value represents a bit position in the corresponding enable/disable register. If the position is
        /// greater than 31, register (2) is used.
        // -------------------------------------------------------------------------------------------------------------
        enum class NIRQ_Source
        {
            AUX = 29,         ///< Auxiliary interrupt
            I2C_SPI_SLV = 43, ///< I2C or SPI slave
            PWA_0 = 45,       ///< PWA 0
            PWA_1 = 45,       ///< PWA 1
            SMI = 48,         ///< SMI
            GPIO_0 = 49,      ///< BANK 0 GPIO pins 0-27
            GPIO_1 = 50,      ///< BANK 1 GPIO pins 28-45
            GPIO_2 = 51,      ///< BANK 2 GPIO pins 46-53
            GPIO_3 = 52,      ///< All GPIO pins
            I2C = 53,         ///< I2C (master?)
            SPI = 54,         ///< SPI (master?)
            PCM = 55,         ///< PCM
            UART = 57         ///< UART
        };

        /// Total number of registers associated with the peripheral
        static constexpr auto NUMBER_OF_REGISTERS = static_cast<std::uint32_t>(NRegister::Count);

        /// Size of a single register
        static constexpr auto REG_SIZE = static_cast<std::uint32_t>(sizeof(std::uint32_t));

        // -------------------------------------------------------------------------------------------------------------
        /// \struct TInterrupt_Info
        /// \brief This structure holds information about each IRQ/Basic IRQ source.
        // -------------------------------------------------------------------------------------------------------------
        struct TInterrupt_Info
        {
            bool enabled{ false }; ///< Is the source enabled or disabled?
            bool pending{ false }; ///< Is the source pending or not?
        };

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu_context CPU context (the IC needs to check if interrupts are globally enabled/disabled)
        // -------------------------------------------------------------------------------------------------------------
        explicit CInterrupt_Controller(const arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the size of the peripheral (IPeripheral interface).
        /// \return number of register * register size
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Size() const noexcept override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Writes data to the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) where the data will be written
        /// \param data Pointer to the data to be written to the peripheral
        /// \param size Size of the data to be written to the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Write(std::uint32_t addr, const char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads data from the peripheral (IPeripheral interface).
        /// \param addr Relative address (from the peripheral's perspective) from which the data will be read
        /// \param data Pointer to a buffer the data will be copied into
        /// \param size Size of the data to read from the peripheral [B]
        // -------------------------------------------------------------------------------------------------------------
        void Read(std::uint32_t addr, char* data, std::uint32_t size) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies the interrupt controller about a pending interrupt triggered by an IRQ source.
        ///
        /// The interrupt controller may ignore this notification if the source is not enabled or all interrupts
        /// have been globally disabled in the CPSR register.
        ///
        /// \param source IRQ source that has triggered the interrupt
        // -------------------------------------------------------------------------------------------------------------
        void Signalize_IRQ(NIRQ_Source source);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies the interrupt controller about a pending interrupt triggered by a basic IRQ source.
        ///
        /// The interrupt controller may ignore this notification if the source is not enabled or all interrupts
        /// have been globally disabled in the CPSR register.
        ///
        /// \param source Basic IRQ source that has triggered the interrupt
        // -------------------------------------------------------------------------------------------------------------
        void Signalize_Basic_IRQ(NIRQ_Basic_Source source);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns information about whether there is a pending IRQ.
        ///
        /// For this function to return true, all interrupts must be globally enabled in the CPSR register.
        /// Additionally, there must be a basic IRQ pending or an IRQ pending (see #Has_Pending_IRQ, and
        /// #Has_Pending_Basic_IRQ).
        ///
        /// \return true, if there is an pending interrupt. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Has_Pending_Interrupt() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears a pending basic IRQ.
        ///
        /// This function is called from the corresponding peripheral whenever it gets cleared of a pending interrupt
        /// by writing a 1 to its clear register.
        ///
        /// \param source Basic IRQ source that has a pending interrupt.
        // -------------------------------------------------------------------------------------------------------------
        void Clear_Pending_Basic_IRQ(NIRQ_Basic_Source source) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Clears a pending IRQ.
        ///
        /// This function is called from the corresponding peripheral whenever it gets cleared of a pending interrupt
        /// by writing a 1 to its clear register.
        ///
        /// \param source IRQ source that has a pending interrupt.
        // -------------------------------------------------------------------------------------------------------------
        void Clear_Pending_IRQ(NIRQ_Source source) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a collection of basic IRQs (visualization purposes).
        /// \return Collection of basic IRQs
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::unordered_map<NIRQ_Basic_Source, TInterrupt_Info>& Get_Basic_IRQs() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a collection of IRQs (visualization purposes).
        /// \return Collection of IRQs
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::unordered_map<NIRQ_Source, TInterrupt_Info>& Get_IRQs() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns the corresponding IRQ source for a given GPIO pin.
        ///
        /// - gpio_int[0] for BANK0 (pins 0-27)
        /// - gpio_int[1] for BANK1 (pins 28-45)
        /// - gpio_int[2] for BANK2 (pins 46-53)
        /// - gpio_int[3] for all the pins; visit
        /// https://raspberrypi.stackexchange.com/questions/51737/use-of-gpio-interrupt-2-rather-than-interrupt-3.
        ///
        /// \param pin_idx Index of the GPIO pin
        /// \return Corresponding IRQ source (GPIO_0-3)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static NIRQ_Source Get_IRQ_Source(std::size_t pin_idx) noexcept;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the interrupt controller.
        ///
        /// It calls #Initialize_Basic_IRQ_Sources and #Initialize_IRQ_Sources.
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the collection of basic IRQ sources.
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize_Basic_IRQ_Sources();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Initializes the collection of IRQ sources.
        // -------------------------------------------------------------------------------------------------------------
        inline void Initialize_IRQ_Sources();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether an IRQ source is enabled or not.
        /// \param source IRQ source to be examined
        /// \return true, if the IRQ source is enabled. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_IRQ_Source_Enabled(NIRQ_Source source) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether there is a pending interrupt triggered by an IRQ source.
        /// \return true, if there is a pending interrupt (IRQ source). false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Has_Pending_IRQ() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether there is a pending interrupt triggered by a basic IRQ source.
        /// \return true, if there is a pending interrupt (basic IRQ source). false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Has_Pending_Basic_IRQ() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Enables/disables interrupts from a basic IRQ source.
        /// \param reg Register containing information about what basic IRQ source are enabled/disabled
        /// \param enable Indication of whether the register is an enable or disable register
        // -------------------------------------------------------------------------------------------------------------
        void Enable_IRQ_Basic_Sources(NRegister reg, bool enable);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Enables/disables interrupts from an IRQ source.
        /// \param reg Register containing information about what IRQ source are enabled/disabled
        /// \param enable Indication of whether the register is an enable or disable register
        // -------------------------------------------------------------------------------------------------------------
        void Enable_IRQ_Sources(NRegister reg, bool enable);

    private:
        const arm1176jzf_s::CCPU_Context& m_cpu_context;                            ///< CPU context
        std::array<std::uint32_t, NUMBER_OF_REGISTERS> m_regs;                      ///< IC registers
        std::unordered_map<NIRQ_Basic_Source, TInterrupt_Info> m_irq_basic_sources; ///< Collection of IRQ basic sources
        std::unordered_map<NIRQ_Source, TInterrupt_Info> m_irq_sources;             ///< Collection of IRQ sources
        utils::CLogging_System& m_logging_system;                                   ///< Logging system
    };

} // namespace zero_mate::peripheral