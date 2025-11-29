#include "../ejs.h"
#include <string.h>


bool encontrarTesoroEnMapa(Mapa *mapa, Recorrido *rec, uint64_t *acciones_ejecutadas) {

    uint32_t id_entrada = mapa->id_entrada;
    Habitacion *habitacion = &mapa->habitaciones[id_entrada];
    *acciones_ejecutadas = 0;

    if(habitacion->contenido.es_tesoro)
            return true;

    for(int i = 0; i< rec->cant_acciones; i++){
        Accion accion = rec->acciones[i];
        uint32_t id_proxima_habitacion = habitacion->vecinos[accion];

        if(id_proxima_habitacion > 98)
            return false;

        *acciones_ejecutadas += 1;
        habitacion = &mapa->habitaciones[id_proxima_habitacion];

        if(habitacion->contenido.es_tesoro)
            return true;
    }

    return false;
}

