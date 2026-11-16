#include <stddef.h>
#include "lynx/memory/paging.h"

void paging_set_entry(page_table_entry_t *entry, uint64_t physical_address, uint64_t flags) {
    if (entry == NULL) {
        return;
    }

    if (physical_address & 0xFFF) {
        return;
    }

    *entry = (physical_address & PAGE_ADDRESS_MASK) | (flags & ~PAGE_ADDRESS_MASK);
}

uint64_t paging_get_address(page_table_entry_t entry) {
    return (entry & PAGE_ADDRESS_MASK);
}

int paging_is_present(page_table_entry_t entry) {
    if ((entry & PAGE_PRESENT) == 0) {
        return 0;
    }else {
        return 1;
    }
}

void paging_clear_entry(page_table_entry_t *entry) {
    if (entry == NULL) {
        return;
    }
    *entry = 0x0000;
}

int paging_is_writable(page_table_entry_t entry) {
    if ((entry & PAGE_WRITABLE) == 0) {
        return 0;
    }else {
        return 1;
    }
}

int paging_is_user(page_table_entry_t entry) {
    if ((entry & PAGE_USER) == 0) {
        return 0;
    }else {
        return 1;
    }
}

int paging_is_executable(page_table_entry_t entry) {
    if ((entry & PAGE_NO_EXECUTE) == 0) {
        return 1;
    }else {
        return 0;
    }
}