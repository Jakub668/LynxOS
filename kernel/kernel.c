#include <stdint.h>
#include "lynx/drivers/serial.h"

void kernel_main(uint32_t magic, uintptr_t mbi_address) {
    serial_init();
    serial_write_line("LynxOS");
    serial_write_line("[BOOT] Long Mode initialized");
    serial_write_line("[BOOT] Kernel entry reached");
    serial_write_line("[DRIVER] Serial initialized");
}
