#include <stdio.h>
void contarHasta(int hasta)
{
    for (int i = 0; i < hasta; i++)
    {
        printf("%d\n", i);
    }
}
int main(void)
{
    contarHasta(100);
    return 0;
}