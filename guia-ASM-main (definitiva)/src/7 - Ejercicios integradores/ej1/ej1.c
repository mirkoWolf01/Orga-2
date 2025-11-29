#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_1A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
#define POINTER_SIZE 8

bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {

	for(int i = 0; i < tamanio - 1; i++){
		int16_t indice_elemento = indice[i];
		int16_t indice_siguiente = indice[i+1];
		if(comparador(inventario[indice_elemento], inventario[indice_siguiente]) == 0)
			return false; 
	}
	return true;
}

/**
 * OPCIONAL: implementar en C
 */
item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
	// ¿Cuánta memoria hay que pedir para el resultado?
	item_t** resultado;
	resultado = malloc(POINTER_SIZE * tamanio);

	for(int i = 0; i < tamanio ; i++){
		int16_t indice_elemento = indice[i];
		resultado[i] = inventario[indice_elemento];
	}

	return resultado;
}
