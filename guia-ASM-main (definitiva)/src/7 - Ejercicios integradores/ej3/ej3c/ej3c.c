#include "../ejs.h"
#include "malloc.h"
#include "string.h"

#define CATEGORIA_SIZE 4

estadisticas_t* calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id){

    estadisticas_t* res = malloc(sizeof(estadisticas_t));
    res->cantidad_CLT = 0;
    res->cantidad_KDT = 0;
    res->cantidad_KSC = 0;
    res->cantidad_RBO = 0;
    res->cantidad_estado_0 = 0;
    res->cantidad_estado_1 = 0;
    res->cantidad_estado_2 = 0;

    for(int i = 0; i < largo; i++){
        caso_t caso = arreglo_casos[i];

        if(usuario_id == 0 || caso.usuario->id == usuario_id){
            if(strncmp("RBO\0", caso.categoria, CATEGORIA_SIZE) == 0)
                res->cantidad_RBO ++; 
            if(strncmp("CLT\0", caso.categoria, CATEGORIA_SIZE) == 0)
                res->cantidad_CLT ++; 
            if(strncmp("KSC\0", caso.categoria, CATEGORIA_SIZE) == 0)
                res->cantidad_KSC ++; 
            if(strncmp("KDT\0", caso.categoria, CATEGORIA_SIZE) == 0)
                res->cantidad_KDT ++; 
            
            if(caso.estado == 0)
                res->cantidad_estado_0 ++;
            if(caso.estado == 1)
                res->cantidad_estado_1 ++;
            if(caso.estado == 2)
                res->cantidad_estado_2 ++;
        }
    }
    return res;
}

