/*
 * asmmax.s
 *
 *  Created on: Sep 11, 2023
 *      Author: Gabriel
 */

 .syntax unified

 .global asmFpuSqrt

 .section .text.rodata

/**
 *
 * extern void asmFpuSqrt(const float32_t in, float32_t *pOut);
 *
 * S0 = input value
 * R0 = pointer to output value
 *
 */

 asmFpuSqrt:
 	VSQRT.f32	S0, S0
 	VSTR.f32    S0, [R0]
	BX			LR
