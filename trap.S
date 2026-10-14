.section .text.boot, "ax"
.global _trap
.type   _trap, @function

.balign 4
_trap:

    # set the params to relevant CSr values before calling handler
    csrr a0, mcause
    csrr a1, mepc
    csrr a2, mtval

    call trap_handler

    # loop on return
    _trap_loop:

        j   _trap_loop