#include <stdio.h>


int main()
{
    __uint32_t val_1 = 0xe0000000;
    __uint32_t val_2 = 0xffffffff;

    __uint32_t mask = 0x7;

    printf("val_1: %x\n", (val_1 >> sizeof(val_1) * 8 -3));
    printf("val_2: %x\n", val_2);

    if ((val_1 >> sizeof(val_1) * 8 -3) & mask == (val_2 & mask)){
        printf("En efecto, son iguales\n");
    }
    return 0;
}
