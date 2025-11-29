#include "../ejs.h"

bool esPublicacionNuevaDeUsuarioVerificado(publicacion_t* publicacion){
    if(!publicacion)
        return false;

    producto_t* producto = publicacion->value;
    return producto->usuario->nivel >= 1 && producto->estado == 1;
}

uint32_t cantidadPublicacionesQueVerifican(catalogo_t* h){

    uint32_t res = 0;
    publicacion_t* publicacion = h->first;

    while(publicacion){
        if(esPublicacionNuevaDeUsuarioVerificado(publicacion))
            res ++; 

        publicacion = publicacion->next;
    }
    
    return res;
}


producto_t **filtrarPublicacionesNuevasDeUsuariosVerificados(catalogo_t *h) {

    uint32_t cantidad = cantidadPublicacionesQueVerifican(h);

    if(cantidad == 0)
        return (producto_t**) NULL;

    producto_t **res = malloc((cantidad + 1) * sizeof(producto_t*));
    res[cantidad] = NULL;
    
    publicacion_t* publicacion = h->first;
    uint32_t i = 0;

    while(publicacion && i < cantidad){
        if(esPublicacionNuevaDeUsuarioVerificado(publicacion)){
            res[i] = publicacion->value;
            i++;
        }

        publicacion = publicacion->next;
    }    

    return (producto_t**) res;
}
