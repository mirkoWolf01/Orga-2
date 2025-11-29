#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Estructuras.h"

int main() {
	

	nodo_t nodo = {
		.next = NULL, 
		.categoria = 2,
		.arreglo = NULL, 
		.longitud = 8};
	
	lista_t lista = {.head = &nodo};
	assert(cantidad_total_de_elementos(&lista) == 8);

	printf("Pasaron los tests!\n");
	return 0;
}
