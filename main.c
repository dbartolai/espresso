#include <stdint.h>

void uart_putc(char c){

    volatile uint8_t *thr = (volatile uint8_t *)0x10000000;
    volatile uint8_t *lsr = (volatile uint8_t *)0x10000005;
    uint8_t status_mask = 0x20;

    uint8_t status = *lsr;

    while (!status){    
        status = *lsr;
        status &= status_mask;
    }

    *thr = c;

}

void kernel_main(void) {

    char * drake = "hi, my name is drake \n";
    char * c = drake;
    while (*c != '\0'){
        uart_putc(*c);
        c++;
    }

    while (1) {
        // while running
    }
}