/*
 * cnewtonsqrt.c
 *
 *  Created on: Sep 11, 2023
 *      Author: Gabriel
 */

#include "main.h"
#include "arm_math.h"

void cNewtonSqrt(const float32_t in, float32_t *pOut) {

	float32_t inx0;
	float32_t inx1;
	const uint32_t max_iterations = 100;
	const float32_t epsilon = 1.1e-7;

	if (in < 0) {
		(*pOut) = 0;
		return;
	}

	inx0 = in/2; // Initial guess.

	// Newton-Raphson method for the square root reduces to this expression.
	// This may be expressed non-recursively.
	for (uint32_t i = 0; i<max_iterations; i++) {
		inx1 = (inx0 + (in / inx0))/2;
		if (inx0 - inx1 < epsilon) { // Save one instruction since the difference is always positive.
			(*pOut) = inx1;
			return;
		}
		inx0 = inx1;
	}

	(*pOut) = 0;

}
