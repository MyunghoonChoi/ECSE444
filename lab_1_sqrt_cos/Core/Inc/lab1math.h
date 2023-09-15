/*
 * lab1math.h
 *
 *  Created on: Sep 11, 2023
 *      Author: Gabriel
 */

#ifndef INC_LAB1MATH_H_
#define INC_LAB1MATH_H_

void cNewtonSqrt(const float32_t in, float32_t *pOut);
extern void asmFpuSqrt(const float32_t in, float32_t *pOut);
void cNewtonx2cos(float32_t guess, float32_t phi, float32_t omega, float32_t *pOut);
extern void asmx2cos(float32_t guess, float32_t phi, float32_t omega, float32_t *pOut);

#endif /* INC_LAB1MATH_H_ */
