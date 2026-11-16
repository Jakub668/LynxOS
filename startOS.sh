#!/usr/bin/env bash

set -e

# Katalog główny projektu
cd "$(dirname "$0")"

echo "================================"
echo "        LYNX OS BUILDER"
echo "================================"

# 1. Konfiguracja środowiska
source env.sh

# 2. Konfiguracja CMake
echo "[1/5] Konfiguracja..."
cmake -S . -B build-cross \
    -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-x86_64-elf.cmake \
    -G Ninja

# 3. Budowanie kernela
echo "[2/5] Budowanie kernela..."
cmake --build build-cross

# 4. Przygotowanie ISO
echo "[3/5] Przygotowanie plików ISO..."
mkdir -p iso/boot/grub

cp build-cross/lynx_kernel.elf iso/boot/lynx_kernel.elf
cp boot/grub/grub.cfg iso/boot/grub/grub.cfg

# 5. Tworzenie obrazu ISO
echo "[4/5] Tworzenie ISO..."
grub2-mkrescue -o lynxos.iso iso

echo "[5/5] Uruchamianie LynxOS..."

# Uruchomienie QEMU
qemu-system-x86_64 \
    -cdrom lynxos.iso \
    -m 512M \
    -boot d \
    -no-reboot \
    -no-shutdown \
    -serial stdio \
    -monitor none

echo "LynxOS zakończył działanie."
