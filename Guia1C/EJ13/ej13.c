#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 6
#define MAX_TIRADAS 60000000

int cant_ap[N] = {0, 0, 0, 0, 0, 0};

void print_ap();
int tirar_dado();

int main()
{
    srand(time(NULL));
    for (int i = 0; i < MAX_TIRADAS; i++)
    {
        int val = tirar_dado();
        cant_ap[val]++;
    }
    print_ap();

    return 0;
}

void print_ap()
{
    printf("[");
    for (int i = 0; i < N - 1; i++)
        printf("%d, ", cant_ap[i]);
    printf("%d]\n", cant_ap[N - 1]);
    return;
}

int tirar_dado()
{
    int random_number =  (rand() % (6));
    return random_number;
}