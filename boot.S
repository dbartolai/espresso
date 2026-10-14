.section .text.boot, "ax"
.global _start
.type   _start, @function
        
_start:
    
    # assign stack pointer reg to top of stack
    la      sp, stack_top

    # zero out the bss region
    la      t0, __bss_start
    la      t1, __bss_end

    # skip if the bss region is empty
    bgeu     t0, t1, _call

    # iterate through the memory and zero it
    _zero_bss:
        sb      x0, 0(t0)
        addi    t0, t0, 1
        bltu    t0, t1, _zero_bss

    # set the trap handler address and jump into main()
    _call:

        la      t0, _trap
        csrw    mtvec, t0

        call    kernel_main 

# infinite loop if main returns
_loop:

    j       _loop