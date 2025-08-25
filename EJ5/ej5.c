#include <stdio.h>


int main()
{
    float fval = 0.1;
    double dval = 0.1;

    printf("Valor del float: %g\n", fval);
    printf("Valor del double: %g\n", dval);

    printf("Valor conversion del float: %d\n", (int) fval);
    printf("Valor conversion del double: %d\n", (int) dval);
    
    return 0;
}
