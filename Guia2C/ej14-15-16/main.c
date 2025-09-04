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

    listSwap(l, 2, 3); // 1 2 3 4 5

    for (int i = 0; i < l->size; i++)
    {
        fat32_t *val = listGet(l, i);
        printf("%d\n", *val);
    }

    // Desalojo memoria
    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    return 0;
}