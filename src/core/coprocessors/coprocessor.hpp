// ---------------------------------------------------------------------------------------------------------------------
/// \file coprocessor.hpp
/// \date 29. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines a general interface of a coprocessor.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

// Project file imports

#include "../arm1176jzf_s/context.hpp"
#include "../arm1176jzf_s/isa/coprocessor_register_transfer.hpp"
#include "../arm1176jzf_s/isa/coprocessor_data_transfer.hpp"
#include "../arm1176jzf_s/isa/coprocessor_data_operation.hpp"

namespace zero_mate::coprocessor
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class ICoprocessor
    /// \brief This class represents an interface of a coprocessor.
    // -----------------------------------------------------------------------------------------------------------------
    class ICoprocessor
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class.
        /// \param cpu_context Reference to the CPU context (so it can perform register transfer operations)
        // -------------------------------------------------------------------------------------------------------------
        explicit ICoprocessor(arm1176jzf_s::CCPU_Context& cpu_context);

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~ICoprocessor() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        ICoprocessor(const ICoprocessor&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        ICoprocessor& operator=(const ICoprocessor&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        ICoprocessor(ICoprocessor&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        ICoprocessor& operator=(ICoprocessor&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor register transfer instruction.
        ///
        /// This is one of the three functions to interact with a coprocessor. Any class that implements the
        /// ICoprocessor interface must implement this function.
        ///
        /// \param instruction Coprocessor register transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        virtual void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor data transfer instruction.
        ///
        /// This is one of the three functions to interact with a coprocessor. Any class that implements the
        /// ICoprocessor interface must implement this function.
        ///
        /// \param instruction Coprocessor data transfer instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        virtual void Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction) = 0;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Performs a coprocessor data operation instruction.
        ///
        /// This is one of the three functions to interact with a coprocessor. Any class that implements the
        /// ICoprocessor interface must implement this function.
        ///
        /// \param instruction Coprocessor data operation instruction to be executed
        // -------------------------------------------------------------------------------------------------------------
        virtual void Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction) = 0;

    protected:
        arm1176jzf_s::CCPU_Context& m_cpu_context;
    };

} // namespace zero_mate::coprocessor