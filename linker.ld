OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    ram (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
    .text :
    {
        KEEP(*(.text.boot))
        *(.text .text.*)
    } > ram

    .rodata :
    {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    } > ram

    .data :
    {
        *(.data .data.*)
        *(.sdata .sdata.*)
    } > ram

    .bss (NOLOAD) :
    {
        . = ALIGN(8);
        __bss_start = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        *(COMMON)
        . = ALIGN(8);
        __bss_end = .;
    } > ram

    .stack (NOLOAD) :
    {
        . = ALIGN(16);
        stack_bottom = .;
        . += 4K;
        stack_top = .;
    } > ram
}