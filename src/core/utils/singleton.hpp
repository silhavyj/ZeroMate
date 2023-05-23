// =====================================================================================================================
/// \file singleton.hpp
/// \date 14. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines and implements a generic class that is used to treat other classes as singletons.
// =====================================================================================================================

#pragma once

// STL imports (excluded from Doxygen)
/// \cond
#include <mutex>
#include <memory>
/// \endcond

namespace zero_mate::utils
{
    // =================================================================================================================
    /// \class CSingleton
    /// \brief A generic class that allows for treating other classes as singletons.
    ///
    /// If a class is meant to be treated as a singleton using CSingleton, it needs to implement and empty
    /// constructor, so CSingleton can instantiate it. CSingleton works as a proxy that provides access to
    /// the instance of the class.
    ///
    /// \tparam Type class to be treated as a singleton
    // =================================================================================================================
    template<typename Type>
    class CSingleton
    {
    public:
        // =============================================================================================================
        /// \brief Returns the instance of the class
        ///
        /// The class gets instantiated only once.
        ///
        /// \return the instance of the class
        // =============================================================================================================
        static Type* Get_Instance()
        {
            // Make sure the class gets instantiated only once.
            std::call_once(s_init_flag, [=]() -> void { CSingleton<Type>::s_instance = std::make_unique<Type>(); });

            return s_instance.get();
        }

    private:
        static std::unique_ptr<Type> s_instance; ///< Single instance of the Type class within the project
        static std::once_flag s_init_flag;       ///< Flag indicating whether #Get_Instance has already been called
    };

    template<typename Type>
    std::unique_ptr<Type> CSingleton<Type>::s_instance{ nullptr };

    template<typename Type>
    std::once_flag CSingleton<Type>::s_init_flag{};

} // namespace zero_mate::utils
