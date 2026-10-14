#include <stdint.h>

void uart_putc(char c){

    volatile uint8_t *thr = (volatile uint8_t *)0x10000000;
    volatile uint8_t *lsr = (volatile uint8_t *)0x10000005;
    uint8_t status_mask = 0x20;

    uint8_t status = *lsr & status_mask;

    while (!status){    
        status = *lsr & status_mask;
    }

    *thr = c;

}


void _print(char * c){
    char * i = c;
    while (*i != '\0'){
        uart_putc(*i);
        i++;
    }
    return;
}

void uart_puthex(uint64_t hex){

    char * chars = "0123456789ABCDEF";
    char output[19];
    output[0] = '0';
    output[1]= 'x';
    for (int i = 0; i < 8; i++){
        uint8_t byte = (uint8_t)(hex >> (56-8*i));
        char c_lh = chars[(byte & 0xF0) >> 4];
        char c_rh = chars[(byte & 0x0F)];
        output[2+2*i] = c_lh;
        output[2*i+3] = c_rh;
    }

    output[18] = '\0';
    _print((char*)output);
    return;
}

void trap_handler(uint64_t mcause, uint64_t mepc, uint64_t mtval){
    _print("trap!!!\n");
    _print("mcause: ");
    uart_puthex(mcause);
    _print("\n");
    _print("mepc: ");
    uart_puthex(mepc);
    _print("\n");
    _print("mtval: ");
    uart_puthex(mtval);
    _print("\n");
}


void kernel_main(void) {

    _print("hi my name is drake\n");
    uint64_t num = 0x8877665513ABD467;
    uart_puthex(num);
    uart_putc('\n');

    __asm__ volatile("ecall");

    while (1) {
        // while running
    }
}
