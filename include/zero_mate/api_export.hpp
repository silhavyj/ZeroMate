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