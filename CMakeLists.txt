cmake_minimum_required(VERSION 3.10)
project(MyFirmware C)

set(CMAKE_C_STANDARD 11)

# Find objcopy tool
find_program(CMAKE_OBJCOPY NAMES arm-none-eabi-objcopy objcopy)

add_executable(myfirmware.elf
    src/main.c
)

# Add custom command to generate .bin from .elf
add_custom_command(TARGET myfirmware.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary myfirmware.elf myfirmware.bin
    COMMENT "Generating .bin from .elf"
)

