CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

PROJECT(kiv_os_rpios_userspace CXX C ASM)

SET(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/link.ld")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${LINKER_SCRIPT}")

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/../kernel/include/")

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/../stdlib/include/")

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/../stdutils/include/")

INCLUDE_DIRECTORIES("${CMAKE_CURRENT_SOURCE_DIR}/../kernel/include/board/rpi0/")
ADD_DEFINITIONS(-DRPI0)

SET(ABI_FILES cxxabi.cpp)
SET(CRT_FILES crt0.s crt0.c)
SET(STDLIB_FILES ${CMAKE_CURRENT_SOURCE_DIR}/../build/libkivrtos_stdlib.a)

FUNCTION(ADD_USERSPACE_EXECUTABLE target_name file_list)
	SET(file_list ${ARGV})
	LIST(REMOVE_AT file_list 0)

	ADD_EXECUTABLE(${target_name} ${CRT_FILES} ${ABI_FILES} ${file_list})
	TARGET_LINK_LIBRARIES(${target_name} ${STDLIB_FILES})
	
	ADD_CUSTOM_COMMAND(
		TARGET ${target_name} POST_BUILD
		COMMAND ${CMAKE_OBJCOPY} ./${target_name}${CMAKE_EXECUTABLE_SUFFIX} -O binary ./${target_name}.bin
		COMMAND ${CMAKE_OBJDUMP} -l -S -D ./${target_name}${CMAKE_EXECUTABLE_SUFFIX} > ./${target_name}.asm
		COMMAND xxd -i ./${target_name}${CMAKE_EXECUTABLE_SUFFIX} > ./src_${target_name}.h
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
ENDFUNCTION(ADD_USERSPACE_EXECUTABLE)

# init task - systemovy task, musi byt pritomen
ADD_USERSPACE_EXECUTABLE(init_task init_task/main.cpp)

# volitelne tasky pro ruzne ulohy
ADD_USERSPACE_EXECUTABLE(sos_task sos_task/main.cpp)
ADD_USERSPACE_EXECUTABLE(oled_task oled_task/main.cpp)
ADD_USERSPACE_EXECUTABLE(logger_task logger_task/main.cpp)
ADD_USERSPACE_EXECUTABLE(counter_task counter_task/main.cpp)
ADD_USERSPACE_EXECUTABLE(tilt_task tilt_task/main.cpp)
