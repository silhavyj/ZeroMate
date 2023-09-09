// ---------------------------------------------------------------------------------------------------------------------
/// \file cp10.hpp
/// \date 09. 09. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines coprocessor CP10 (single-precision FPU).
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <array>
/// \endcond

// Project file imports

#include "fpexc.hpp"
#include "fpscr.hpp"
#include "register.hpp"
#include "isa/isa.hpp"
#include "isa/cp_data_processing_inst.hpp"
#include "isa/cp_data_transfer_inst.hpp"
#include "isa/cp_register_transfer_inst.hpp"
#include "zero_mate/utils/logging_system.hpp"
#include "../coprocessor.hpp"
#include "../../bus.hpp"

namespace zero_mate::coprocessor::cp10
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class CCP10
    /// \brief This class represents coprocessor 10 (single-precision FPU).
    // -----------------------------------------------------------------------------------------------------------------
    class CCP10 final : public ICoprocessor
    {
    public:
        /// Unique ID of the coprocessor
        static constexpr std::uint32_t ID = 10;

        /// Number of single-precision floating point registers
        static constexpr std::uint32_t Number_Of_S_Registers = 32;

    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu_context Reference to a CPU context (access to ARM registers)
        /// \param bus Reference to the system bus (reading/writing to the RAM)
        // -------------------------------------------------------------------------------------------------------------
        explicit CCP10(arm1176jzf_s::CCPU_Context& cpu_context, std::shared_ptr<CBus> bus);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Resets the coprocessor.
        // -------------------------------------------------------------------------------------------------------------
        void Reset() override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor register transfer instruction (ICoprocessor interface).
        /// \param instruction Coprocessor register transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor data transfer instruction (ICoprocessor interface).
        /// \param instruction Coprocessor data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor data operation instruction (ICoprocessor interface).
        /// \param instruction Coprocessor data operation instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction) override;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a reference to the coprocessor single-precision registers.
        /// \return Reference to the coprocessor single-precision registers
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] std::array<CRegister, Number_Of_S_Registers>& Get_Registers();

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the coprocessor single-precision registers.
        /// \return Const reference to the coprocessor single-precision registers
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const std::array<CRegister, Number_Of_S_Registers>& Get_Registers() const;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the FPSCR register.
        /// \return Const reference to the FPSCR register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const CFPSCR& Get_FPSCR() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Returns a const reference to the FPEXC register.
        /// \return Const reference to the FPEXC register
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] const CFPEXC& Get_FPEXC() const noexcept;

    private:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Checks whether the coprocessor is enabled or not.
        /// \return true, if CP10 is enabled. false otherwise.
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] inline bool Is_FPU_Enabled() const noexcept;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VMSR floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CVMSR instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VMRS floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CVMRS instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VMOV (from an ARM register to S{x} register) floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        void Execute(isa::CVMOV_ARM_Register_Single_Precision_Register instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VMUL floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VMUL(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VADD floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VADD(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VSUB floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VSUB(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VDIV floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VDIV(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VABS floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VABS(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VNEG floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VNEG(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VSQRT floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VSQRT(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes VMLA and VMLS floating point instructions.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VMLA_VMLS(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes VNMLA, VNMLS, and VNMUL floating point instructions.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VNMLA_VNMLS_VNMUL(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VMOV floating point instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VMOV(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VCMP and CMPE float point instructions.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VCMP_VCMPE(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VCVT (double-precision to single-precision) instruction.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VCVT_Double_Precision_Single_Precision(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VCVT and VCVTR floating point instructions.
        /// \param instruction Instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VCVT_VCVTR_Floating_Point_Integer(isa::CData_Processing instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VLDR and VSTR floating point instructions.
        /// \param instruction Instruction to be executed
        /// \param is_load_op Is the instruction a load (VLDR) instruction?
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VLDR_VSTR(isa::CData_Transfer instruction, bool is_load_op);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Executes a VSTM and VLDM floating point instructions.
        /// \param instruction Instruction to be executed
        /// \param is_load_instruction Is the instruction a load (VLDM) instruction?
        // -------------------------------------------------------------------------------------------------------------
        inline void Execute_VSTM_VLDM(isa::CData_Transfer instruction, bool is_load_instruction);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Converts (casts) a floating point value into an integer.
        /// \param value Float value to be converted into an integer
        /// \param is_signed Should the final result be a signed integer?
        /// \return Given floating point value cast into an integer
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static std::uint32_t Convert_Float_To_Int(float value, bool is_signed);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Converts (casts) an integer value into a floating point value
        /// \param value Integer value to be converted into a floating point value
        /// \param is_signed Is the integer value a signed integer?
        /// \return Given integer value cast into a float
        // -------------------------------------------------------------------------------------------------------------
        [[nodiscard]] static float Convert_Int_To_Float(std::uint32_t value, bool is_signed);

    private:
        std::shared_ptr<CBus> m_bus;                         ///< System bus
        CFPEXC m_fpexc;                                      ///< FPEXC register
        CFPSCR m_fpscr;                                      ///< FPSCR register
        utils::CLogging_System& m_logging_system;            ///< Logging system
        std::array<CRegister, Number_Of_S_Registers> m_regs; ///< Single-precision floating point registers
    };

} // namespace zero_mate::coprocessor::cp10