#include <stdio.h>

int main()
{
    int a = 5, b = 3, c = 2, d = 1;

    printf("%d \n", a + b * c / d); // 11

    printf("%d \n", a % b); // 2

    printf("%d \n", a == b); // 0

    printf("%d \n", a != b); // 1

    printf("%x \n", a & b); // 0101 & 0011 = 0001

    printf("%x \n", a | b); // 0101 | 0011 = 0111 (7)

    printf("%x \n", a << 1); // 1010

    printf("%x \n", a >> 1); // 0010

    a += b;
    printf("%d \n", a); // 8

    a -= b;
    printf("%d \n", a); // 5

    a *= b;
    printf("%d \n", a); // 15

    a /= b;
    printf("%d \n", a); // 5

    a %= b;
    printf("%d \n", a); // 2
    return 0;
}
