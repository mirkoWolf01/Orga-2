#include "../ejs.h"
#include <stdint.h>

usuario_t **asignarNivelesParaNuevosUsuarios(uint32_t *ids, uint32_t cantidadDeIds, uint8_t (*deQueNivelEs)(uint32_t))
{
  if (cantidadDeIds == 0)
    return (usuario_t **)NULL;

  usuario_t **res = malloc(sizeof(usuario_t *) * cantidadDeIds);

  for (int i = 0; i < cantidadDeIds; i++)
  {
    uint32_t id = ids[i];
    uint8_t nivel = deQueNivelEs(id);

    usuario_t* user = malloc(sizeof(usuario_t));
    user->id = id;
    user->nivel = nivel;

    res[i] = user;
  }

  return (usuario_t **) res;
}
