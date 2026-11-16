#!/bin/bash

set -e
source env.sh

echo "budowanie LynxOS"
cmake --build build-cross

echo "testy:"
echo "format: "
file build-cross/lynx_kernel.elf

echo "naglowek ELF: "
x86_64-elf-readelf -h build-cross/lynx_kernel.elf

echo "segmenty: "
x86_64-elf-readelf -l build-cross/lynx_kernel.elf

echo "sekcje ELF: "
x86_64-elf-objdump -h build-cross/lynx_kernel.elf

echo "deasemblacja: "
x86_64-elf-objdump -d build-cross/lynx_kernel.elf

echo "adresy i sybole: "
x86_64-elf-nm build-cross/lynx_kernel.elf

echo "Multiboot2: "
grub2-file --is-x86-multiboot2 build-cross/lynx_kernel.elf
echo $?
echo "0 = OK 1 = NO_OK"

echo "zakaczono budowanie LynxOS"
