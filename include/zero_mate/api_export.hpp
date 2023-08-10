// ---------------------------------------------------------------------------------------------------------------------
/// \file api_export.hpp
/// \date 06. 08. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines macros for exporting symbols out of a shared library.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#ifdef _WIN32
    #ifdef ZERO_MATE_EXPORT
        #define ZERO_MATE_API __declspec(dllexport)
    #else
        #define ZERO_MATE_API __declspec(dllimport)
    #endif
#else
    #define ZERO_MATE_API
#endif