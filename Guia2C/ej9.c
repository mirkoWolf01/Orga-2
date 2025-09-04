#include <stdio.h>

void caps(char *str)
{
    while (*str != '\0')
    {
        int c = (int) *str;
        if(c < 122 && c >96)
            *str = (char) c -32;
        str++; // Paso al siguiente elemento
    }
}

int main()
{
    char str[] = "salmon rosado";

    caps(str);
    printf("%s\n", str);
    return 0;
}