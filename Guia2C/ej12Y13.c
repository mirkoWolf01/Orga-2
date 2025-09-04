#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NAME_LEN 50

typedef struct persona_s
{
    char nombre[NAME_LEN + 1];
    int edad;
    struct persona_s *hijo;
} persona_t;

persona_t* crearPersona(char* nombre, __int16_t edad){
    persona_t* persona = malloc(sizeof(persona_t));
    persona->edad = edad;
    strcpy(persona->nombre, nombre);
    persona->hijo = NULL;
    return persona;
}

void eliminarPersona(persona_t* persona){
    free(persona);
}

int main()
{
    persona_t* persona = crearPersona("juan", 12);

    printf("%d\n", (*persona).edad);
    printf("%s\n", (*persona).nombre);
    eliminarPersona(persona);
    return 0;
}
