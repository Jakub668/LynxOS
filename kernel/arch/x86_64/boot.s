.intel_syntax noprefix
.code32
.global start
.section .multiboot,"a"
.align 8

header_start:
    .long 0xE85250D6
    .long 0
    .long header_end - header_start
    .long -(0xE85250D6 + (header_end - header_start))

    .short 0
    .short 0
    .long 8

header_end:

.section .text
start:
    cli
    mov esp, OFFSET stack_top
    lgdt [gdt_descriptor]
    push eax
    push ebx
    pushfd
    pop eax
    mov ebx, eax
    xor ebx, 0x00200000
    push ebx
    popfd
    pushfd
    pop ebx
    push eax
    popfd
    xor eax, ebx
    test eax, 0x00200000
    jz no_cpuid
    jmp have_cpuid
have_cpuid:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb not_long_mode
    jmp long_mode_supported
no_cpuid:
    hlt
    jmp no_cpuid
not_long_mode:
    hlt
    jmp not_long_mode
long_mode_supported:
    mov eax, 0x80000001
    cpuid
    test edx, 0x20000000
    jz bit_not_set
    jmp bit_set
bit_not_set:
    hlt
    jmp bit_not_set
bit_set:
    mov eax, OFFSET pdpt_table
    or eax, 0x3
    mov dword ptr [pml4_table], eax
    mov dword ptr [pml4_table + 4], 0
    mov eax, OFFSET pd_table
    or eax, 0x3
    mov dword ptr [pdpt_table], eax
    mov dword ptr [pdpt_table + 4], 0
    mov eax, 0x00000000
    or eax, 0x83
    mov dword ptr [pd_table], eax
    mov dword ptr [pd_table + 4], 0
    mov eax, cr4
    or eax, (1 << 5)
    mov cr4, eax
    mov eax, OFFSET pml4_table
    mov cr3, eax
    mov ecx, 0xC0000080
    RDMSR
    or eax, (1 << 8)
    WRMSR
    mov eax, cr0
    or eax, (1 << 31)
    mov cr0, eax
    pop ebx
    pop eax
    ljmp 0x08, long_mode_start

.hang:
    hlt
    jmp .hang

.section .bss
.align 16
stack_bottom:
    .skip 16384
stack_top:
    .align 4096
    pml4_table:
        .skip 4096
    .align 4096
    pdpt_table:
        .skip 4096
    .align 4096
    pd_table:
        .skip 4096

.section .rodata
gdt_start:
    .quad 0
    .quad 0x00AF9A000000FFFF
    .quad 0x00CF92000000FFFF

gdt_end:

gdt_descriptor:
    .short 23
    .long gdt_start


.section .text
.code64
long_mode_start:
    mov rsp, OFFSET stack_top
    push rax
    push rbx
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    pop rbx
    pop rax
    mov edi, eax
    mov esi, ebx
    call kernel_main

.hang64:
    hlt
    jmp .hang64
