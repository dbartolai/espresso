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

void uart_puthex(uint32_t hex){

    char * chars = "0123456789ABCDEF";
    char output[11];
    output[0] = '0';
    output[1]= 'x';
    for (int i = 0; i < 4; i++){
        uint8_t byte = (uint8_t)(hex >> (24-8*i));
        char c_lh = chars[(byte & 0xF0) >> 4];
        char c_rh = chars[(byte & 0x0F)];
        output[2+2*i] = c_lh;
        output[2*i+3] = c_rh;
    }

    output[10] = '\0';
    _print((char*)output);
    return;
}


void kernel_main(void) {

    _print("hi my name is drake\n");
    uint32_t num = 0x13ABD467;
    uart_puthex(num);
    uart_putc('\n');

    while (1) {
        // while running
    }
}
