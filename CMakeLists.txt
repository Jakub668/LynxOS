
cmake_minimum_required(VERSION 3.25)

project(LynxOS
    VERSION 0.1.0
    LANGUAGES C ASM
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(lynx_kernel
    kernel/arch/x86_64/boot.s
    kernel/kernel.c
    kernel/memory/paging.c
    kernel/drivers/serial.c
)

target_include_directories(lynx_kernel PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

target_compile_options(lynx_kernel PRIVATE
    $<$<COMPILE_LANGUAGE:C>:-ffreestanding>
    $<$<COMPILE_LANGUAGE:C>:-fno-stack-protector>
    $<$<COMPILE_LANGUAGE:C>:-mno-red-zone>
    -fno-unwind-tables
    -fno-asynchronous-unwind-tables
)

target_link_options(lynx_kernel PRIVATE
    -nostdlib
    -static
    -T${CMAKE_SOURCE_DIR}/linker/linker.ld
)

set_target_properties(lynx_kernel PROPERTIES
    OUTPUT_NAME "lynx_kernel"
    SUFFIX ".elf"
)
