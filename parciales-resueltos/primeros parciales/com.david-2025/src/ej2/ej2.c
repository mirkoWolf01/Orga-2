#include "../ejs.h"
#include "string.h"

bool mismaPublicacion(publicacion_t* p1, publicacion_t* p2){
   if(!p1 || !p2)
      return false;

   return p1->value->usuario == p2->value->usuario && 
      strcmp(p1->value->nombre, p2->value->nombre) == 0;
}

void removerAparicionesPosterioresDe(publicacion_t* publicacion){
   publicacion_t* actual = publicacion;

   while(actual && actual->next){
      while(mismaPublicacion(publicacion, actual->next)){
         publicacion_t* liberar = actual->next;
         actual->next = liberar->next;
         free(liberar->value);
         free(liberar);
      }
      actual = actual->next;
   }
   return;
}

catalogo_t *removerCopias(catalogo_t *h) {

   publicacion_t* publicacion = h->first;

   while (publicacion)
   {
      removerAparicionesPosterioresDe(publicacion);
      publicacion = publicacion->next;
   }

   return h;
}
