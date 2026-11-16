#ifndef LYNX_PAGING_H
#define LYNX_PAGING_H

#include <stdint.h>
#define PAGE_PRESENT (1ULL << 0)
#define PAGE_WRITABLE (1ULL << 1)
#define PAGE_USER (1ULL << 2)
#define PAGE_NO_EXECUTE (1ULL << 63)
#define PAGE_TABLE_ENTRIES (512ULL)
#define PAGE_ADDRESS_MASK (0x000FFFFFFFFFF000ULL)

typedef uint64_t page_table_entry_t;
typedef page_table_entry_t page_table_t[PAGE_TABLE_ENTRIES] __attribute__((aligned(4096)));

void paging_set_entry(page_table_entry_t *entry, uint64_t physical_address, uint64_t flags);
uint64_t paging_get_address(page_table_entry_t entry);
int paging_is_present(page_table_entry_t entry);
void paging_clear_entry(page_table_entry_t *entry);
int paging_is_writable(page_table_entry_t entry);
int paging_is_user(page_table_entry_t entry);
int paging_is_executable(page_table_entry_t entry);

#endif
