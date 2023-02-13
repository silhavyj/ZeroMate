macro(run_conan)

    # Install conan using pip
    find_package(Python COMPONENTS Interpreter REQUIRED)
    execute_process(COMMAND ${Python_EXECUTABLE} -m pip install --user --upgrade pip conan)

    # Download automatically, you can also just copy the conan.cmake file
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
        message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
        file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/0.18.1/conan.cmake" "${CMAKE_BINARY_DIR}/conan.cmake" TLS_VERIFY ON)
    endif()

    # Include the downloaded file
    include(${CMAKE_BINARY_DIR}/conan.cmake)

    # Run conan
    CONAN_CMAKE_RUN(
        REQUIRES
        ${CONAN_EXTRA_REQUIRES}
        OPTIONS
        ${CONAN_EXTRA_OPTIONS}
        IMPORTS
        ${CONAN_EXTRA_IMPORTS}
        SETTINGS
        compiler.cppstd=${CMAKE_CXX_STANDARD}
        BASIC_SETUP
        CMAKE_TARGETS # individual targets to link to
        BUILD
        missing)

endmacro(run_conan)

# EOF