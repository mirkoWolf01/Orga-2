#include <stdio.h>

typedef struct 
{
    char *nombre;
    int vida;
    double ataque;
    double defensa;
}monstruo_t;

monstruo_t evolucion(monstruo_t mon)
{
    monstruo_t evol = mon;
    evol.ataque += 10;
    evol.defensa += 10;

    return evol;
}

void print_monster(monstruo_t mon){
    printf("Nombre: %s, Vida: %d", mon.nombre, mon.vida);
    //printf("Ataque: %f, Defensa: %f", mon.ataque, mon.defensa);
    printf("\n");
}

int main()
{
    monstruo_t monsters[] = {
        {.nombre = "chom", .vida = 10000, .ataque = 0.2, .defensa = 130},
        {.nombre = "elmati", .vida = 10, .ataque = 2, .defensa = 7},
        {.nombre = "blob", .vida = 3, .ataque = 0.0001, .defensa = 0}};
    
    print_monster(evolucion(monsters[0]));
    
    return 0;
}
