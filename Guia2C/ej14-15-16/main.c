#include <stdio.h>
#include "list.h"

int main()
{
    list_t *l = listNew(TypeFAT32);
    fat32_t *f1 = new_fat32();
    fat32_t *f2 = new_fat32();
    fat32_t *f3 = new_fat32();
    fat32_t *f4 = new_fat32();
    fat32_t *f5 = new_fat32();

    // Defino las variables
    *f1 = 1;
    *f2 = 2;
    *f3 = 3;
    *f4 = 4;
    *f5 = 5;

    listAddFirst(l, f5);
    listAddFirst(l, f4);
    listAddFirst(l, f3);
    listAddFirst(l, f2);
    listAddFirst(l, f1);

    listSwap(l, 0, 4); // Aca llega: 1 2 3 4 5

    listRemove(l, 0); //  Aca llega: 5 2 3 4 1

    listaAddLast(l, f5);

    for (int i = 0; i < l->size; i++)
    {
        fat32_t *val = listGet(l, i);
        printf("Posicion del array[%d], val: %d\n", i, *val);
    }

    // PARA TESTEAR
    int n = 3;
    node_t *nodo = _listGetNode(l, n);
    fat32_t *former = nodo->former->data;

    printf("Valor del anterior al nodo [%d]: %d\n", n, *former);

    // Desalojo memoria
    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    rm_fat32(f3);
    rm_fat32(f4);
    rm_fat32(f5);
    return 0;
}