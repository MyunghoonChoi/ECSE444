/*
 * cnewtonsqrt.c
 *
 *  Created on: Sep 14, 2023
 *      Author: Gabriel
 */

#include "main.h"
#include "arm_math.h"

void cNewtonx2cos(float32_t guess, float32_t phi, float32_t omega, float32_t *pOut) {

	float32_t x0 = guess;
	float32_t fx0arg;
	float32_t fx0;
	float32_t fprimex0;
	float32_t x1;
	const uint32_t max_iterations = 64;
	const float32_t epsilon = 1.1e-7;

	for (uint32_t i = 0; i<max_iterations; i++) {
		fx0arg = x0*omega + phi;
		fx0 = x0*x0 - arm_cos_f32(fx0arg);
		fprimex0 = 2*x0 + omega*arm_sin_f32(fx0arg);
		x1 = x0 - fx0/fprimex0;
		if (fabs(x1 - x0) < epsilon) {
			(*pOut) = x1;
			return;
		}
		x0 = x1;
	}

	(*pOut) = 0;
}
