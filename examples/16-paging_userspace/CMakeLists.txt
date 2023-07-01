CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

PROJECT(kiv_os_rpios CXX C ASM)

# specifikujeme linker skript - potrebujeme vlastni definici pametoveho layoutu
SET(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/kernel/link.ld")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${LINKER_SCRIPT}")

ADD_DEFINITIONS(-g)

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/kernel/include/")

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/stdlib/include/")

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/stdutils/include/")

# budeme vyvijet jen pro RPi0, takze tady proste natvrdo napiseme cesty k hlavickam a pridame define
INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/kernel/include/board/rpi0/")
ADD_DEFINITIONS(-DRPI0)

# rekurzivne pridame vsechny zdrojaky z kernel podslozky
FILE(GLOB_RECURSE kernel_src "kernel/*.cpp" "kernel/*.c" "kernel/*.h" "kernel/*.hpp" "kernel/*.s")

# pridame standardni knihovnu (nas minimalni stub knihovny)
FILE(GLOB_RECURSE stdlib_src "stdlib/*.cpp" "stdlib/*.c" "stdlib/*.h" "stdlib/*.hpp" "stdlib/*.s")

# pridame knihovnu utilit (ovladani zarizeni z userspace, apod)
FILE(GLOB_RECURSE stdutils_src "stdutils/*.cpp" "stdutils/*.c" "stdutils/*.h" "stdutils/*.hpp" "stdutils/*.s")

# pridame cil - sestavujeme standardni knihovnu (minimalni)
ADD_LIBRARY(kivrtos_stdlib STATIC ${stdlib_src} ${stdutils_src})

# pridame cil - sestavujeme jen kernel
ADD_EXECUTABLE(kernel ${kernel_src})

# prilinkujeme standardni knihovnu do kernelu
TARGET_LINK_LIBRARIES(kernel kivrtos_stdlib)

# po dokonceni sestaveni musime jeste zkonvertovat vystupy
# 1) zkompilovany ELF soubor na surovou binarni mapu pro RPi bootloader (kernel.img)
# 2) pro pruzkumne ucely i disassembly vysledne binarky
# 3) SREC dump pro UART bootloader
ADD_CUSTOM_COMMAND(
    TARGET kernel POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} ./kernel${CMAKE_EXECUTABLE_SUFFIX} -O binary ./kernel.img
    COMMAND ${CMAKE_OBJDUMP} -l -S -D ./kernel${CMAKE_EXECUTABLE_SUFFIX} > ./kernel.asm
	COMMAND ${CMAKE_OBJCOPY} --srec-forceS3 ./kernel${CMAKE_EXECUTABLE_SUFFIX} -O srec kernel.srec
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
