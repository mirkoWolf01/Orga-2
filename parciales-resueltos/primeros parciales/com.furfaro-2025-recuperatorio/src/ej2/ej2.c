#include "../ejs.h"

Accion invertirAccion(Accion accion)
{
    Accion res;

    if (accion == ACC_NORTE)
        res = ACC_SUR;
    if (accion == ACC_ESTE)
        res = ACC_OESTE;
    if (accion == ACC_SUR)
        res = ACC_NORTE;
    if (accion == ACC_OESTE)
        res = ACC_ESTE;

    return res;
}

Recorrido *invertirRecorridoConDirecciones(const Recorrido *rec, uint64_t len)
{
    uint64_t acciones = len;

    if(acciones == 0)
        return NULL;

    Recorrido* inverso = malloc(sizeof(Recorrido));
    inverso->acciones = malloc(sizeof(Accion) * acciones);
    inverso->cant_acciones = acciones;
    
    for(uint64_t i = 0; i < acciones; i ++){
        Accion accion = rec->acciones[acciones - 1 - i];

        inverso->acciones[i] = invertirAccion(accion);
    }
    return inverso;
}
