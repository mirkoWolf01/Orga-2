#include <stdio.h>

#define N 8

int main()
{
    int arr[N] = {1,2,3,4,5,6,7,8};

    for (int i = 0; i < N -1; i++)
    {
        int elem = arr[i];

        arr[i] = arr[i+1];
        arr[i+1] = elem;
    }
    
    for (int i = 0; i < N; i++)
    {
        printf("%d\n", arr[i]);
    }
    
    return 0;
}