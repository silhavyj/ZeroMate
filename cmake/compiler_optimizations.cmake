function(set_project_optimizations project_name)
    message("Enabling compiler optimizations")

    # MSVC optimization flags
    set(MSVC_OPTIMIZATIONS /O2)

    # GCC optimization flags
    set(GCC_OPTIMIZATION -O2)

    # Set compiler warnings based on the compiler
    if(MSVC)
        set(PROJECT_OPTIMIZATIONS ${MSVC_OPTIMIZATIONS})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(PROJECT_OPTIMIZATIONS ${GCC_OPTIMIZATION})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(PROJECT_OPTIMIZATIONS ${GCC_OPTIMIZATION})
    else()
        message(AUTHOR_WARNING "No compiler optimizations set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()

    # Add compile options to the interface
    target_compile_options(${project_name} INTERFACE ${PROJECT_OPTIMIZATIONS})

endfunction()

# EOF