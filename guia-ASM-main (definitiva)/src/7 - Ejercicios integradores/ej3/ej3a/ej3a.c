#include "../ejs.h"

enum niveles_posibles {NIVEL0, NIVEL1, NIVEL2};

// Función auxiliar para contar casos por nivel
int contar_casos_por_nivel(caso_t* arreglo_casos, int largo, int nivel) {
    int contador = 0;
    for(int i = 0; i < largo; i++){
        if(arreglo_casos[i].usuario->nivel == (uint32_t) nivel)
            contador ++;
    }
    return contador;
}


segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {
    segmentacion_t* segmentacion = malloc(sizeof(segmentacion_t));
    segmentacion->casos_nivel_0 = NULL;
    segmentacion->casos_nivel_1 = NULL;
    segmentacion->casos_nivel_2 = NULL;

    int casos_0 = contar_casos_por_nivel(arreglo_casos, largo, 0);
    int casos_1 = contar_casos_por_nivel(arreglo_casos, largo, 1);
    int casos_2 = contar_casos_por_nivel(arreglo_casos, largo, 2);


    size_t caso_size = sizeof(caso_t);

    if(casos_0 != 0)
        segmentacion->casos_nivel_0 = malloc(caso_size * casos_0);
    
    if(casos_1 != 0)
        segmentacion->casos_nivel_1 = malloc(caso_size * casos_1);
        
    if(casos_2 != 0)
        segmentacion->casos_nivel_2 = malloc(caso_size * casos_2);
        

    int contador[3] = {0,0,0};
    for(int i = 0; i < largo; i++){
        caso_t caso = arreglo_casos[i];
        int nivel_caso = caso.usuario->nivel;
        int iterador = contador[nivel_caso];
        if(nivel_caso == NIVEL0)
            segmentacion->casos_nivel_0[iterador] = caso;
        if(nivel_caso == NIVEL1)
            segmentacion->casos_nivel_1[iterador] = caso;
        if(nivel_caso == NIVEL2)
            segmentacion->casos_nivel_2[iterador] = caso;
        contador[nivel_caso] ++;
    }
    return segmentacion;
}



