#include <stdio.h>
#include <string.h>

int main()
{
    char str[] = "salmon rosado";

    // Recordar reservar memoria necesaria
    char string_copy[50] = "";

    // Copia el valor de str a string_copy
    strcpy(string_copy, str);
    printf("String copiado: %s\n", string_copy);
    
    char conc[] = "no me gusta el ";
    // Concatena dos strings y lo pone en el primero
    strcat(conc, str);
    printf("Strings concatenados: %s\n", conc);

    int i = strlen(str);
    printf("Tamaño del array: %d\n", i);
    
    // Compara los string, como si los restara.s
    printf("Comparacion: %d\n", strcmp(str, str));
    return 0;
}
