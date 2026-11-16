#include "lynx/drivers/serial.h"

#include <stdint.h>

void outb(uint16_t port, uint8_t value) {
    __asm__ volatile ("outb %b0, %w1" : : "a"(value), "Nd"(port));
}

uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

int serial_is_transmit_empty(void) {
    uint8_t a = inb(0x3FD);
    int ret = a & 0x20;
    return ret;
}

void serial_write_char(char c) {
    while (serial_is_transmit_empty() == 0) {}

    outb(0x3F8, c);
}

void serial_write_string(const char *str) {
    if (str == 0) {
        return;
    }

    while (*str != '\0') {
        serial_write_char(*str);
        str++;
    }
}

void serial_write_line(const char *str) {
    if (str == 0) {
        return;
    }

    while (*str != '\0') {
        serial_write_char(*str);
        str++;
    }

    serial_write_char('\r');
    serial_write_char('\n');
}

void serial_init(void) {
    outb(0x3F9, 0x00);
    outb(0x3FB, 0x80);
    outb(0x3F8, 0x03);
    outb(0x3F9, 0x00);
    outb(0x3FB, 0x03);
    outb(0x3FA, 0xC7);
}
