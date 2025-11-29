#include <stdio.h>

#define SIZE 3

typedef struct

{

    char *nombre;

    int vida;

    double ataque;

    double defensa;

} monstruo_t;

void print_monster(monstruo_t mon)
{

    printf("Nombre: %s, Vida: %d", mon.nombre, mon.vida);

    printf("\n");
}

int main()

{

    monstruo_t monsters[SIZE] = {

        {.nombre = "chom", .vida = 10000, .ataque = 0.2, .defensa = 130},

        {.nombre = "elmati", .vida = 10, .ataque = 2, .defensa = 7},

        {.nombre = "blob", .vida = 3, .ataque = 0.0001, .defensa = 0}

    };

    for (int i = 0; i < SIZE; i++)
    {

        print_monster(monsters[i]);
    }

    return 0;
}