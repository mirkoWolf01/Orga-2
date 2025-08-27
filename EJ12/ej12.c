#include <stdio.h>

#define N 8

int arr[N] = {1, 2, 3, 4, 5, 6, 7, 8};

int main()
{
    print_arr();

    rotacion(4);

    print_arr();
    return 0;
}

void rotacion(int rot)
{
    while (rot--)
    {
        for (int i = 0; i < N - 1; i++)
        {
            int elem = arr[i];

            arr[i] = arr[i + 1];
            arr[i + 1] = elem;
        }
    }
    return;
}

void print_arr(){
    printf("[");
    for (int i = 0; i < N-1; i++)
        printf("%d, ", arr[i]);
    printf("%d]\n", arr[N-1]);
    return;
}