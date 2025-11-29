#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

	assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 10);

	assert(alternate_sum_8(8, 2, 5, 1, 2, 2, 9, 4) == 15);

	uint32_t res_product2;
	product_2_f(&res_product2, 3, 13.1);
	assert(res_product2 == 39);

	double prod9;
	product_9_f(&prod9, 2, 1.5, 2, 1.5, 2, 1.5, 2, 1.5, 2, 1.5, 2, 1.5, 2, 1.5, 2, 1.5, 2, 1.5);
	assert(prod9 == 19683);

	printf("Pasaron los test!\n");
	return 0;
}

