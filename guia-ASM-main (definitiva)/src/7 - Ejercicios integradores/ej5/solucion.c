#include <stdlib.h>
#include <string.h>

#include "ejercicio.h"

bool EJERCICIO_1_HECHO = true;
bool EJERCICIO_2_HECHO = true;
bool EJERCICIO_3_HECHO = true;


bool hay_accion_que_toque(accion_t *accion, char *nombre)
{

	if (!accion)
		return false;

	carta_t *destino = accion->destino;

	if (strncmp(destino->nombre, nombre, 12) == 0)
		return true;

	return hay_accion_que_toque(accion->siguiente, nombre);
}

void invocar_acciones(accion_t *accion, tablero_t *tablero)
{

	if (!accion)
		return;

	carta_t *destino = accion->destino;
	void (*invocar_accion)(tablero_t *tablero, carta_t *carta) = accion->invocar;

	if (destino->en_juego)
	{
		invocar_accion(tablero, destino);
		if (destino->vida == 0)
			destino->en_juego = false;
	}

	invocar_acciones(accion->siguiente, tablero);
	return;
}

void contar_cartas(tablero_t *tablero, uint32_t *cant_rojas, uint32_t *cant_azules)
{
	*cant_rojas = *cant_azules = 0;

	for (int i = 0; i < ALTO_CAMPO; i++)
	{
		for (int j = 0; j < ANCHO_CAMPO; j++)
		{
			carta_t* card = tablero->campo[i][j];
			if(card){
				// funciona haciando un pre-incremento. Tambien funciona += 1
				if(card->jugador == JUGADOR_AZUL)
					++ (*cant_azules);
				if(card->jugador == JUGADOR_ROJO)
					++ (*cant_rojas); 
			}
		}
	}
	return;
}
