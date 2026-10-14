.section .text.boot, "ax"
.global _start
.type   _start, @function
        
_start:
    
    la      sp, stack_top


    la      t0, __bss_start
    la      t1, __bss_end

    bgeu     t0, t1, _call

    _zero_bss:
        sb      x0, 0(t0)
        addi    t0, t0, 1
        bltu    t0, t1, _zero_bss

    _call:

        la      t0, _trap
        csrw    mtvec, t0

        call    kernel_main 

_loop:

    j       _loop