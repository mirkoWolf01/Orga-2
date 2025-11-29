#include "../ejs.h"
#include "string.h"

#define CATEGORY_SIZE 4

void resolver_automaticamente(funcionCierraCasos_t* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo){
    int r = 0;

    for(int i = 0; i < largo; i++){
        caso_t caso = arreglo_casos[i];
        int nivel_caso = caso.usuario->nivel;
        
        
        if (nivel_caso == 0){
            casos_a_revisar[r] = caso;
            r++;
        }
        else{
            uint16_t res = funcion(&caso);
            
            if(res)
                caso.estado = 1;
            else if(strncmp(caso.categoria, "RB0\0", CATEGORY_SIZE) == 0 || strncmp(caso.categoria, "CLT\0", CATEGORY_SIZE) == 0)
                caso.estado = 2;
            else
            {
                casos_a_revisar[r] = caso;
                r++;
            }
        }
        arreglo_casos[i] = caso; // actualizo el valor del caso
    }
    return;
}

