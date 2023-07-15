// ---------------------------------------------------------------------------------------------------------------------
/// \file core.hpp
/// \date 15. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a class that represents a CPU core (arm1176jzf_s).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
#include <limits>
#include <vector>
#include <memory>
#include <cstdint>
#include <cassert>
#include <optional>
#include <unordered_set>
#include <unordered_map>
#include <initializer_list>
/// \endcond

// Project file imports

#include "context.hpp"
#include "exceptions.hpp"

#include "isa/isa.hpp"
#include "isa/isa_decoder.hpp"

#include "../bus.hpp"
#include "mmu/mmu.hpp"

#include "zero_mate/utils/math.hpp"
#include "zero_mate/utils/logger.hpp"

#include "../peripherals/interrupt_controller.hpp"
#include "../peripherals/system_clock_listener.hpp"

namespace zero_mate::arm1176jzf_s
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCPU_Core
    /// \brief Raspberry Pi Zero CPU core (arm1176jzf_s).
    // -----------------------------------------------------------------------------------------------------------------
    class CCPU_Core final
    {
    public:
        /// Alias for a system clock listener (just to make the code less wordy)
        using System_Clock_Listener_t = std::shared_ptr<peripheral::ISystem_Clock_Listener>;

        /// Alias for a collection of coprocessors (just to make the code less wordy)
        using Coprocessors_t = std::unordered_map<std::uint32_t, std::shared_ptr<coprocessor::ICoprocessor>>;

        /// Alias for an interrupt controller (just to make the code less wordy)
        using IC_t = std::shared_ptr<peripheral::CInterrupt_Controller>;

        /// Default execution start address (address of the first instruction)
        static constexpr std::uint32_t Default_Entry_Point_Addr = 0x8000;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        // -------------------------------------------------------------------------------------------------------------
        CCPU_Core() noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param pc Default value of the PC register (r15)
        /// \param bus Reference to the system bus, so the CPU can access different memory-mapped peripherals
        // -------------------------------------------------------------------------------------------------------------
        CCPU_Core(std::uint32_t pc, std::shared_ptr<CBus> bus) noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets an interrupt controller.
        ///
        /// When an interrupt controller is set, the CPU will use it check for any pending interrupts. If an interrupt
        /// controller is not preset, the CPU will not account for any interrupts, except for SWI.
        ///
        /// \param interrupt_controller Interrupt controller
        // -------------------------------------------------------------------------------------------------------------
        void Set_Interrupt_Controller(std::shared_ptr<peripheral::CInterrupt_Controller> interrupt_controller);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets an MMU (memory management unit)
        /// \param mmu MMU to be hooked up to the CPU.
        // -------------------------------------------------------------------------------------------------------------
        void Set_MMU(std::shared_ptr<mmu::CMMU> mmu);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Registers a system clock listener.
        ///
        /// After every instruction, the CPU updates all its registered listeners and notifies them about how many
        /// clock cycles have passed since the last update, so they can update their states.
        ///
        /// \param listener System clock listener to be registered
        // -------------------------------------------------------------------------------------------------------------
        void Register_System_Clock_Listener(const System_Clock_Listener_t& listener);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets a coprocessor.
        /// \param id Coprocessor ID
        /// \param coprocessor Coprocessor itself
        // -------------------------------------------------------------------------------------------------------------
        void Add_Coprocessor(std::uint32_t id, const std::shared_ptr<coprocessor::ICoprocessor>& coprocessor);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the CPU context.
        /// \return reference to the CPU context
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CCPU_Context& Get_CPU_Context();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the CPU context.
        /// \return const reference to the CPU context
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const CCPU_Context& Get_CPU_Context() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the CPU context.
        // -------------------------------------------------------------------------------------------------------------
        void Reset_Context();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets the PC register (r15).
        /// \param pc New value of the PC register
        // -------------------------------------------------------------------------------------------------------------
        void Set_PC(std::uint32_t pc);

        // -------------------------------------------------------------------------------------------------------------
        /// Sets a breakpoint to the given address.
        /// \param addr Address where CPU execution should stop
        // -------------------------------------------------------------------------------------------------------------
        void Add_Breakpoint(std::uint32_t addr);

        // -------------------------------------------------------------------------------------------------------------
        /// Removes a breakpoint from the given address.
        /// \param addr Address from which a breakpoint should be removed
        // -------------------------------------------------------------------------------------------------------------
        void Remove_Breakpoint(std::uint32_t addr);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Starts the execution.
        ///
        /// The CPU keeps on executing instructions until it hits a breakpoint.
        ///
        /// \note Bus shall not be NULL for this function to work correctly (assert(m_bus != nullptr))
        // -------------------------------------------------------------------------------------------------------------
        void Run();

        // -------------------------------------------------------------------------------------------------------------
        /// Performs a given number of steps (e.g. execute 5 instructions and stop).
        /// \note Bus shall not be NULL for this function to work correctly (assert(m_bus != nullptr))
        /// \param count Number of instructions (steps) to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Steps(std::size_t count);

        // -------------------------------------------------------------------------------------------------------------
        /// Performs a single step (executes a single instruction)
        /// \param ignore_breakpoint flag indicating whether set breakpoints should be ignored
        /// \note Bus shall not be NULL for this function to work correctly (assert(m_bus != nullptr))
        /// \return true if the next instruction was successfully executed. false, if a breakpoint was hit or the CPU
        ///         failed to fetch the next instruction.
        // -------------------------------------------------------------------------------------------------------------
        bool Step(bool ignore_breakpoint = false);

        // -------------------------------------------------------------------------------------------------------------
        /// Executes a given list of instructions.
        ///
        /// This function is mainly used for testing purposes.
        ///
        /// \param instructions List of instructions (binary codes) to be executed by the CPU
        // -------------------------------------------------------------------------------------------------------------
        void Execute(std::initializer_list<isa::CInstruction> instructions);

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the PC register (r15)
        /// \return reference to the PC register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& PC() noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the PC register (r15)
        /// \return const reference to the PC register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& PC() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the LR register (r14 = link register)
        /// \return reference to the LR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t& LR() noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the LR register (r14 = link register)
        /// \return const reference to the LR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::uint32_t& LR() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Fetches the next instruction.
        ///
        /// It attempts to read 4B (one word) from the address stored in the PC register. If it fails to do so, it
        /// will throw a prefetch abort exception which sets the value of the PC register to 0xC. If the next
        /// instruction is successfully fetched, the value of the PC register is incremented by 4B.
        ///
        /// \return std::nullopt, if the fetching process failed (PC = 0xC). isa::CInstruction, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::optional<isa::CInstruction> Fetch_Instruction();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether a given instruction should be executed or skipped based on its condition field.
        ///
        /// A detailed explanation of all the condition fields can be found here:
        /// https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf (chapter 4.2 The Condition Field)
        ///
        /// \param instruction Instruction whose condition field is to be checked
        /// \return true, if the instruction should be executed. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_Instruction_Condition_Met(isa::CInstruction instruction) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the shift amount of a data processing instruction.
        /// \param instruction Data processing instruction
        /// \return Calculated shift amount
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Shift_Amount(isa::CData_Processing instruction) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the second operand of a data processing instruction.
        /// \param instruction Data processing instruction
        /// \return Second operand involved in the operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t>
        Get_Second_Operand(isa::CData_Processing instruction) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a shift on the given value.
        /// \param shift_type Type of the shift (LSL, LSR, ASR, ROR)
        /// \param shift_amount Amount by which the value will be shifted (number of positions)
        /// \param value Value to be shifted
        /// \return Result of the shift operation
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t> Perform_Shift(isa::CInstruction::NShift_Type shift_type,
                                                                              std::uint32_t shift_amount,
                                                                              std::uint32_t value) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the offset from the base address in a single data transfer instruction.
        /// \param instruction Single data transfer instruction
        /// \return Offset that will be added to the base address be the data transfer is performed
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::int64_t Get_Offset(isa::CSingle_Data_Transfer instruction) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the offset from the base address in a halfword data transfer instruction.
        ///
        /// This offset will be added to the base address if the pre-index bit (P bit) is set to a 1.
        ///
        /// \param instruction Halfword data transfer instruction
        /// \return Offset that will be added to the base address in case pre-indexing is enabled (P bit = 1)
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Get_Offset(isa::CHalfword_Data_Transfer instruction) const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a halfword data read from a given address.
        /// \param type Type of the read
        /// \param addr Address from which data will be read
        /// \param dest_reg_idx Index of the destination register (data itself)
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Halfword_Data_Transfer_Read(isa::CHalfword_Data_Transfer::NType type,
                                                 std::uint32_t addr,
                                                 std::uint32_t dest_reg_idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a halfword data write to a given address.
        /// \param type Type of the write
        /// \param addr Address to which data will be written
        /// \param src_reg_idx Index of the source register (data itself)
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Halfword_Data_Transfer_Write(isa::CHalfword_Data_Transfer::NType type,
                                                  std::uint32_t addr,
                                                  std::uint32_t src_reg_idx);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes an MSR instruction (move data to CPSR/SPSR from an ARM register).
        /// \param instruction CPSR (SPSR) transfer instruction
        // -------------------------------------------------------------------------------------------------------------
        void Execute_MSR(isa::CPSR_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes an MRS instruction (move data from CPSR/SPSR to an ARM register).
        /// \param instruction CPSR (SPSR) transfer instruction
        // -------------------------------------------------------------------------------------------------------------
        void Execute_MRS(isa::CPSR_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a CPU exception.
        ///
        /// A more detailed explanation about ARMv6 exception can be found over at:
        /// https://cs107e.github.io/readings/armv6.pdf (Table A2-4 Exception processing modes)
        ///
        /// \param exception Type of exception that has been thrown
        // -------------------------------------------------------------------------------------------------------------
        void Execute_Exception(const exceptions::CCPU_Exception& exception);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Sets interrupt mask bits (A, I, and F) in the given value that is treated as the new value of the
        /// CPSR register.
        ///
        /// This function is a helper function called from void Execute(isa::CCPS instruction).
        ///
        /// \param cpsr New value of the CPSR register
        /// \param instruction CPS instruction
        /// \param set Indication of whether the bits should be set to a 1 or 0
        /// \return Modified value which is passed as a parameter
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static inline std::uint32_t
        Set_Interrupt_Mask_Bits(std::uint32_t cpsr, isa::CCPS instruction, bool set);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Determines the mode of the CPU that should be used in a block data transfer instruction.
        ///
        /// The CPU mode used when executing the instruction is either the current CPU mode or the USER mode as
        /// described in the documentation: https://iitd-plos.github.io/col718/ref/arm-instructionset.pdf
        /// (section 4.11.4 Use of the S bit)
        ///
        /// \param instruction Block data transfer instruction
        /// \return CPU mode that will be used in the instruction execution
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] CCPU_Context::NCPU_Mode Determine_CPU_Mode(isa::CBlock_Data_Transfer instruction) const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Updates all CPU cycle listeners.
        ///
        /// This function is be called after every instruction, so the listeners get updated about how many clock
        /// cycles have just passed by (time emulation).
        // -------------------------------------------------------------------------------------------------------------
        inline void Update_Cycle_Listeners();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief If there are any pending interrupts, it throws the exceptions::CIRQ exception.
        ///
        /// It is done by checking whether there is a pending interrupt in #m_interrupt_controller.
        // -------------------------------------------------------------------------------------------------------------
        inline void Check_For_Pending_IRQ();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if a coprocessor of a given id is present of not.
        /// \param coprocessor_id ID of the coprocessor
        /// \throws exceptions::CUndefined_Instruction if the coprocessor is not present
        // -------------------------------------------------------------------------------------------------------------
        inline void Check_Coprocessor_Existence(std::uint32_t coprocessor_id);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a single instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CInstruction instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a branch and exchange instruction.
        /// \param instruction Branch and exchange instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CBranch_And_Exchange instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a branch instruction.
        /// \param instruction Branch instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CBranch instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a data processing instruction.
        /// \param instruction Data processing instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a multiply instruction.
        /// \param instruction Multiply instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CMultiply instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a multiply long instruction.
        /// \param instruction Multiple long instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CMultiply_Long instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a single data transfer instruction.
        /// \param instruction Single data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CSingle_Data_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a block data transfer instruction.
        /// \param instruction Block data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CBlock_Data_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a halfword data transfer instruction.
        /// \param instruction Halfword data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CHalfword_Data_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes an extend instruction.
        /// \param instruction Extend instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CExtend instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a PSR transfer instruction.
        /// \param instruction PSR transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CPSR_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a CPS instruction.
        /// \param instruction CPS instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CCPS instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a coprocessor register transfer instruction (coprocessor instruction (1)).
        /// \param instruction Coprocessor register transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CCoprocessor_Reg_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a coprocessor data transfer instruction (coprocessor instruction (2)).
        /// \param instruction Coprocessor data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CCoprocessor_Data_Transfer instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a coprocessor data operation instruction (coprocessor instruction (3)).
        /// \param instruction Coprocessor data operation instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CCoprocessor_Data_Operation instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes an SRS instruction.
        /// \param instruction SRS instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CSRS instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes an RFE instruction.
        /// \param instruction RFE instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CRFE instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a CLZ instruction.
        /// \param instruction CLZ instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CCLZ instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the base address of a data transfer instruction.
        /// \tparam Instruction Type of the instruction that is being executed (block data transfer, RFE, or SRS)
        /// \param instruction Instruction itself
        /// \param base_reg_idx Index of the base register (Rd = base address)
        /// \param cpu_mode CPU mode used for the instruction
        /// \param number_of_regs Number of registers to be transferred
        /// \return Base address of the data transfer instruction
        // -------------------------------------------------------------------------------------------------------------
        template<typename Instruction>
        [[nodiscard]] std::uint32_t Calculate_Base_Address(Instruction instruction,
                                                           std::uint32_t base_reg_idx,
                                                           CCPU_Context::NCPU_Mode cpu_mode,
                                                           std::uint32_t number_of_regs) const
        {
            switch (instruction.Get_Addressing_Mode())
            {
                // Increment before
                case Instruction::NAddressing_Mode::IB:
                    return m_context.Get_Register(base_reg_idx, cpu_mode) + CCPU_Context::Reg_Size;

                // Increment after
                case Instruction::NAddressing_Mode::IA:
                    return m_context.Get_Register(base_reg_idx, cpu_mode);

                // Decrement before
                case Instruction::NAddressing_Mode::DB:
                    return m_context.Get_Register(base_reg_idx, cpu_mode) - (number_of_regs * CCPU_Context::Reg_Size);

                // Decrement after
                case Instruction::NAddressing_Mode::DA:
                    return m_context.Get_Register(base_reg_idx, cpu_mode) - (number_of_regs * CCPU_Context::Reg_Size) +
                           CCPU_Context::Reg_Size;
            }

            return {}; // Just so the compiler does not gripe about a missing return value.
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Calculates the second immediate operand of a given instruction.
        /// \tparam Instruction Type of the instruction that is being executed (data processing, MSR)
        /// \param instruction Instruction itself
        /// \return Second immediate operand of the instruction
        // -------------------------------------------------------------------------------------------------------------
        template<typename Instruction>
        [[nodiscard]] utils::math::TShift_Result<std::uint32_t>
        Get_Second_Operand_Imm(Instruction instruction) const noexcept
        {
            // Retrieve the immediate value and the shift amount.
            // The shift amount is always multiplied by 2 - see the documentation.
            const std::uint32_t immediate = instruction.Get_Immediate();
            const std::uint32_t shift_amount = instruction.Get_Rotate() * 2;

            // Create the result.
            utils::math::TShift_Result<std::uint32_t> second_operand{ m_context.Is_Flag_Set(CCPU_Context::NFlag::C),
                                                                      immediate };

            // Perform ROR if possible.
            if (shift_amount != 0 && shift_amount != std::numeric_limits<std::uint32_t>::digits)
            {
                second_operand = utils::math::ROR(immediate, shift_amount, false);
            }

            return second_operand;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Converts a given virtual address into a physical address using the MMU.
        /// \param virtual_addr Virtual address to be converted into a physical address
        /// \param write_access Indication of whether write or read access is intended to be performed
        /// \return Physical address
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::uint32_t Convert_Virtual_Addr_To_Physical_Addr(std::uint32_t virtual_addr, bool write_access)
        {
            // If the MMU is not preset, or it is not enabled, then virtual addr = physical addr.
            if (m_mmu != nullptr && m_mmu->Is_Enabled())
            {
                return m_mmu->Get_Physical_Addr(virtual_addr, m_context, write_access);
            }

            return virtual_addr;
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Writes data to the bus.
        /// \tparam Type Data type to be written to the bus
        /// \param virtual_addr Virtual address where the data will be written
        /// \param value Value (data) to be written to the bus
        // -------------------------------------------------------------------------------------------------------------
        template<typename Type>
        void Write(std::uint32_t virtual_addr, Type value)
        {
            // Make sure the CPU is connected to the bus.
            assert(m_bus != nullptr);

            // Convert the virtual address into a physical address.
            const std::uint32_t physical_addr = Convert_Virtual_Addr_To_Physical_Addr(virtual_addr, true);

            // Write data to the bus.
            m_bus->Write<Type>(physical_addr, value);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads data from the bus.
        /// \tparam Type Type of data to be read the bus
        /// \param virtual_addr Virtual address where the data will be read from
        /// \return Data read from the bus
        // -------------------------------------------------------------------------------------------------------------
        template<typename Type>
        [[nodiscard]] Type Read(std::uint32_t virtual_addr)
        {
            // Make sure the CPU is connected to the bus.
            assert(m_bus != nullptr);

            // Convert the virtual address into a physical address.
            const std::uint32_t physical_addr = Convert_Virtual_Addr_To_Physical_Addr(virtual_addr, false);

            // Write data to the bus.
            return m_bus->Read<Type>(physical_addr);
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Reads/writes data to the bus.
        /// \note The bus width is usually a fixed size. The generic type is supported only for emulation purposes
        /// \tparam Type Data type to be read/written to the bus
        /// \param instruction Instruction that is being executed
        /// \param virtual_addr Virtual address to read or written to
        /// \param reg_idx Index of the register used in the instruction
        // -------------------------------------------------------------------------------------------------------------
        template<std::unsigned_integral Type>
        void Read_Write_Value(isa::CSingle_Data_Transfer instruction, std::uint32_t virtual_addr, std::uint32_t reg_idx)
        {
            if (instruction.Is_L_Bit_Set())
            {
                m_context[reg_idx] = Read<Type>(virtual_addr);
            }
            else
            {
                Write<Type>(virtual_addr, static_cast<Type>(m_context[reg_idx]));
            }
        }

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks if the IVT (interrupt vector table) has been reallocated to the higher address (0xFFFF0000).
        /// \return true, if the base address of the IVT is 0xFFFF0000. false, otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] bool Is_IVT_Reallocated_To_High_Addr();

    private:
        CCPU_Context m_context;                                        ///< Context of the CPU (registers, mode, ...)
        isa::CISA_Decoder m_instruction_decoder;                       ///< Instruction (machine code) decoder
        std::shared_ptr<CBus> m_bus;                                   ///< Bus to access different peripherals
        std::shared_ptr<mmu::CMMU> m_mmu;                              ///< MMU used to convert virtual addresses
        std::unordered_set<std::uint32_t> m_breakpoints;               ///< Collection of set breakpoints
        utils::CLogging_System& m_logging_system;                      ///< Logging system
        std::uint32_t m_entry_point;                                   ///< Starting address of execution
        IC_t m_interrupt_controller;                                   ///< Interrupt controller
        std::vector<System_Clock_Listener_t> m_system_clock_listeners; ///< Collection of system clock listeners
        Coprocessors_t m_coprocessors;                                 ///< Collection of different coprocessors
    };

} // namespace zero_mate::arm1176jzf_s
