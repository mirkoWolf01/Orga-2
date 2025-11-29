#include "ej4b.h"

#include <string.h>

// OPCIONAL: implementar en C
void invocar_habilidad(void *carta_generica, char *habilidad)
{
	card_t *carta = carta_generica;

	for (int i = 0; i < carta->__dir_entries; i++)
	{
		directory_entry_t *habilidad_entrada = carta->__dir[i];
		if (strcmp(habilidad_entrada->ability_name, habilidad) == 0)
		{
			void (*func)(void *carta) = habilidad_entrada->ability_ptr;
			func(carta);
			return;
		}
	}

	if (carta->__archetype != NULL)
	{
		carta = carta->__archetype;
		invocar_habilidad(carta, habilidad);
	}
	return;
}
