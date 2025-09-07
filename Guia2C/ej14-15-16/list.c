#include <stdio.h>
#include "list.h"

list_t *listNew(type_t t)
{
    list_t *l = malloc(sizeof(list_t));
    l->type = t; // l->type es equivalente a (*l).type
    l->size = 0;
    l->first = NULL;
    l->last = NULL;
    return l;
}

void listAddFirst(list_t *l, void *data)
{
    node_t *n = malloc(sizeof(node_t));
    switch (l->type)
    {
    case TypeFAT32:
        n->data = (void *)copy_fat32((fat32_t *)data);
        break;
    case TypeEXT4:
        n->data = (void *)copy_ext4((ext4_t *)data);
        break;
    case TypeNTFS:
        n->data = (void *)copy_ntfs((ntfs_t *)data);
        break;
    }
    n->next = l->first;
    n->former = NULL;
    if (l->first != NULL)
        l->first->former = n;
    else
        l->last = n;
    l->first = n;
    l->size++;
}

void listaAddLast(list_t *l, void *data)
{
    node_t *n = malloc(sizeof(node_t));
    switch (l->type)
    {
    case TypeFAT32:
        n->data = (void *)copy_fat32((fat32_t *)data);
        break;
    case TypeEXT4:
        n->data = (void *)copy_ext4((ext4_t *)data);
        break;
    case TypeNTFS:
        n->data = (void *)copy_ntfs((ntfs_t *)data);
        break;
    }
    n->former = l->last;
    n->next = NULL;
    if (l->last != NULL)
        l->last->next = n;
    else
        l->first = n;
    l->last = n;
    l->size++;
}

// se asume: i < l->size
void *listGet(list_t *l, uint8_t i)
{
    node_t *n = l->first;
    for (uint8_t j = 0; j < i; j++)
        n = n->next;
    return n->data;
}

// se asume: i < l->size
void *listRemove(list_t *l, uint8_t i)
{
    node_t *tmp = NULL;
    void *data = NULL;

    if (i == 0)
    {
        data = l->first->data;
        tmp = l->first;
        l->first = l->first->next;
    }
    else if (i == l->size - 1)
    {
        data = l->last->data;
        tmp = l->last;
        l->last = l->last->former;
    }
    else
    {
        node_t *n = l->first;
        for (uint8_t j = 0; j < i - 1; j++)
            n = n->next;
        data = n->next->data;
        tmp = n->next;

        n->next = tmp->next;
        if (tmp->next != NULL)
            tmp->next->former = n;
    }

    free(tmp);
    l->size--;
    return data;
}

void listDelete(list_t *l)
{
    node_t *n = l->first;
    while (n)
    {
        node_t *tmp = n;

        n = n->next;
        switch (l->type)
        {
        case TypeFAT32:
            rm_fat32((fat32_t *)tmp->data);
            break;
        case TypeEXT4:
            rm_ext4((ext4_t *)tmp->data);
            break;
        case TypeNTFS:
            rm_ntfs((ntfs_t *)tmp->data);
            break;
        }
        free(tmp);
    }
    free(l);
}

node_t *_listGetNode(list_t *l, uint8_t i)
{
    node_t *n = l->first;
    for (uint8_t j = 0; j < i; j++)
        n = n->next;
    return n;
}

// Se da por hecho que a, b < l->size
void listSwap(list_t *l, uint8_t a, uint8_t b)
{
    if (l->size < 2 || a == b)
        return;

    node_t *node_a = _listGetNode(l, a);
    node_t *node_b = _listGetNode(l, b);

    node_t *prev_a = node_a->former,
           *prev_b = node_b->former,
           *pos_a = node_a->next,
           *pos_b = node_b->next;

    // Si alguno es el inicial, el otro pasa a serlo
    if (a == 0)
        l->first = node_b;
    else if (a == l->size - 1)
        l->last = node_b;

    if (b == 0)
        l->first = node_a;
    else if (b == l->size - 1)
        l->last = node_a;

    // Si no son adyacentes
    if (abs(a - b) > 1)
    {
        if (prev_a != NULL)
            prev_a->next = node_b;

        if (prev_b != NULL)
            prev_b->next = node_a;

        if (pos_a != NULL)
            pos_a->former = node_b;

        if (pos_b != NULL)
            pos_b->former = node_a;

        node_a->next = pos_b;
        node_a->former = prev_b;

        node_b->next = pos_a;
        node_b->former = prev_a;
    }
    // Si lo son, y a es menor
    else if (a < b)
    {
        if (prev_a != NULL)
            prev_a->next = node_b;

        node_a->next = pos_b;
        node_a->former = node_b;

        node_b->next = node_a;
        node_b->former = prev_a;
    }
    // Si lo son, y a es menor
    else
    {
        if (prev_b != NULL)
            prev_b->next = node_a;

        node_a->next = node_b;
        node_a->former = prev_b;

        node_b->next = pos_a;
        node_b->former = node_a;
    }
    return;
}
