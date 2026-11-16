#ifndef LYNX_SERIAL_H
#define LYNX_SERIAL_H

#include <stdint.h>

void outb(uint16_t port, uint8_t value);
uint8_t inb(uint16_t port);
int serial_is_transmit_empty(void);
void serial_write_char(char c);
void serial_write_string(const char *str);
void serial_init(void);
void serial_write_line(const char *str);

#endif
