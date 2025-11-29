#include "../ejs.h"

uint32_t sumarTesoros(Mapa *mapa, uint32_t actual, bool *visitado) {

    uint32_t res = 0;

    if(actual >= 99 || visitado[actual])
        return 0;

    Habitacion* habitacion = &mapa->habitaciones[actual];
    Contenido* contenido = &habitacion->contenido;
    if(contenido->es_tesoro)
        res += contenido->valor;

    visitado[actual] = true;
    
    for(int i = 0; i < ACC_CANT; i++){
        uint32_t vecino_id = habitacion->vecinos[i];
        if(vecino_id < 99)
            res += sumarTesoros(mapa, vecino_id, visitado);
    }
    
    return res;
}