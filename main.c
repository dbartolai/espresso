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

void _printf(char * c){
    char * i = c;
    while (*i != '\0'){
        uart_putc(*i);
        i++;
    }
    return;
}

void kernel_main(void) {

    _printf("welcome to espresso\n");

    while (1) {
        // while running
    }
}