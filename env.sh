
#!/usr/bin/env bash

# LynxOS development environment

export LYNXOS_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

export TARGET="x86_64-elf"
export CROSS_PREFIX="$HOME/opt/cross"
export PATH="$CROSS_PREFIX/bin:$PATH"

# Cross-toolchain
export CROSS_COMPILE="${TARGET}-"
export CC="${TARGET}-gcc"
export AS="${TARGET}-as"
export LD="${TARGET}-ld"
export AR="${TARGET}-ar"
export OBJCOPY="${TARGET}-objcopy"
export OBJDUMP="${TARGET}-objdump"
