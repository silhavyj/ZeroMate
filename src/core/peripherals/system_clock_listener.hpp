// ---------------------------------------------------------------------------------------------------------------------
/// \file system_clock_listener.hpp
/// \date 27. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines an interface for a CPU clock listener.
///
/// This interface is usually implemented by time-related peripherals such as timers,
/// communication protocol drivers, etc.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <cstdint>
/// \endcond

namespace zero_mate::peripheral
{
    // -----------------------------------------------------------------------------------------------------------------
    /// \class ISystem_Clock_Listener
    /// \brief This class represents a general interface for a CPU clock listener.
    // -----------------------------------------------------------------------------------------------------------------
    class ISystem_Clock_Listener
    {
    public:
        // -------------------------------------------------------------------------------------------------------------
        /// \brief Creates an instance of the class (default non-parameterized constructor).
        // -------------------------------------------------------------------------------------------------------------
        ISystem_Clock_Listener() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Destroys (deletes) the object from the memory.
        // -------------------------------------------------------------------------------------------------------------
        virtual ~ISystem_Clock_Listener() = default;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted copy constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        ISystem_Clock_Listener(const ISystem_Clock_Listener&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        ISystem_Clock_Listener& operator=(const ISystem_Clock_Listener&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted move constructor (rule of five).
        // -------------------------------------------------------------------------------------------------------------
        ISystem_Clock_Listener(ISystem_Clock_Listener&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Deleted assignment operator with an r-value reference (rule of five).
        /// \return Instance of this class
        // -------------------------------------------------------------------------------------------------------------
        ISystem_Clock_Listener& operator=(ISystem_Clock_Listener&&) = delete;

        // -------------------------------------------------------------------------------------------------------------
        /// \brief Notifies the peripheral about how many CPU cycles have passed by.
        ///
        /// The CPU core calls this function after every instruction, so the peripheral can update itself.
        /// Every class/struct that inherits from the ISystem_Clock_Listener class must implement this function.
        ///
        /// \param count Number of CPU cycles
        // -------------------------------------------------------------------------------------------------------------
        virtual void Increment_Passed_Cycles(std::uint32_t count) = 0;
    };

} // namespace zero_mate::peripheral