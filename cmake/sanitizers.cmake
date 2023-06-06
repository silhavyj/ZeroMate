function(enable_sanitizers project_name)

    # This is only set up for gcc and clang compilers
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")

        # Enable code coverage
        option(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" OFF)
        if(ENABLE_COVERAGE)
            target_compile_options(${project_name} INTERFACE --coverage -O0 -g)
            target_link_libraries(${project_name} INTERFACE --coverage)
        else()
            # -O3 is not enabled for debugging reasons (optimized out)
            # target_compile_options(${project_name} INTERFACE -O3)
        endif()

        # List out different sanitizer options
        option(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
        option(ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
        option(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR "Enable undefined behavior sanitizer" OFF)
        option(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
        option(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)

        # List of all selected sanitizers
        set(SANITIZERS "")

        # Append the address sanitizer
        if(ENABLE_SANITIZER_ADDRESS)
            list(APPEND SANITIZERS "address")
        endif()

        # Append the leak sanitizer
        if(ENABLE_SANITIZER_LEAK)
            list(APPEND SANITIZERS "leak")
        endif()

        # Append the UB sanitizer (undefined behavior)
        if(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR)
            list(APPEND SANITIZERS "undefined")
        endif()

        # Append the thread sanitizer
        if(ENABLE_SANITIZER_THREAD)
            if("address" IN_LIST SANITIZERS OR "leak" IN_LIST SANITIZERS)
                message(WARNING "Thread sanitizer does not work with Address and Leak sanitizer enabled")
            else()
                list(APPEND SANITIZERS "thread")
            endif()
        endif()

        # Append the memory sanitizer
        if(ENABLE_SANITIZER_MEMORY AND CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            if("address" IN_LIST SANITIZERS OR "thread" IN_LIST SANITIZERS OR "leak" IN_LIST SANITIZERS)
                message(WARNING "Memory sanitizer does not work with Address, Thread and Leak sanitizer enabled")
            else()
                list(APPEND SANITIZERS "memory")
            endif()
        endif()

        list(JOIN SANITIZERS "," LIST_OF_SANITIZERS)
    endif()

    if(LIST_OF_SANITIZERS)
        if(NOT "${LIST_OF_SANITIZERS}" STREQUAL "")
            target_compile_options(${project_name} INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
            target_link_options(${project_name} INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
        endif()
    endif()

endfunction()

# EOF