#include <stdio.h>

int main()
{
    char c = 100;
    unsigned char uc = 1;
    short s = -8712;
    unsigned short us = 12;
    int i = 123456;
    unsigned ui = 1000;
    long l = 1234567890;
    unsigned long ul = 1000000000000;

    printf("char: %lu \n", sizeof(c));
    printf("unsigned char: %lu \n", sizeof(uc));

    printf("short: %lu \n", sizeof(s));
    printf("unsigned short: %lu \n", sizeof(us));

    printf("int: %lu \n", sizeof(i));
    printf("unsigned: %lu \n", sizeof(ui));

    printf("long: %lu \n", sizeof(l));
    printf("unsigned long: %lu \n", sizeof(ul));
    return 0;
}
