#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

bool EJERCICIO_2A_HECHO = true;
bool EJERCICIO_2B_HECHO = true;
bool EJERCICIO_2C_HECHO = true;

#define MAP_SIZE 255
#define CLASE_CHAR_SIZE 12

void optimizar(mapa_t mapa, attackunit_t* compartida, uint32_t (*fun_hash)(attackunit_t*)) {

    uint32_t hash_compartida = fun_hash(compartida);
    
    for(int i = 0; i< MAP_SIZE; i++){
        for(int j = 0; j< MAP_SIZE; j++){
            attackunit_t* unit = mapa[i][j];

            if(!unit || unit == compartida)
                continue;

            if(fun_hash(unit) == hash_compartida){
                unit->references --;
                if (unit->references == 0)
                    free(unit);
                compartida->references ++;
                mapa[i][j] = compartida;
            }
        }
    }
    return;
}

/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
    
    uint32_t sum = 0;

    for(int i = 0; i< MAP_SIZE; i++){
        for(int j = 0; j< MAP_SIZE; j++){
            attackunit_t* unit = mapa[i][j];

            if(unit)
                sum += unit->combustible - fun_combustible(unit->clase);
        }
    }
    return sum;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {

    attackunit_t* unit = mapa[x][y]; 

    if(!unit)
        return;

    attackunit_t* unit_m = (attackunit_t*) malloc(sizeof(attackunit_t));

    strncpy(unit_m->clase, unit->clase, CLASE_CHAR_SIZE);
    unit_m->combustible = unit->combustible;
    unit_m->references = 1; 
    
    unit->references --;

    if (unit->references == 0)
        free(unit);

    fun_modificar(unit_m);
    mapa[x][y] = unit_m;
    
    return;
}
