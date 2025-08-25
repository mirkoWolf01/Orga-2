#include <stdio.h>
#include <stdint.h>

int main()
{
    int8_t a = 0;
    uint8_t ua = 0;

    int16_t b = 0;
    uint16_t ub = 0;

    int32_t c = 0;
    uint32_t uc = 0;

    int64_t d = 0;
    uint64_t ud = 0;

    printf("int 8b: %lu \n", sizeof(a));
    printf("unsigned int 8b: %lu \n", sizeof(ua));

    printf("int 16b: %lu \n", sizeof(b));
    printf("unsigned int 16b: %lu \n", sizeof(ub));

    printf("int 32b: %lu \n", sizeof(c));
    printf("unsigned int 32b: %lu \n", sizeof(uc));

    printf("int 64b: %lu \n", sizeof(d));
    printf("unsigned int 64b: %lu \n", sizeof(ud));

    return 0;
}
