/*
 * asmx2cos.s
 *
 *  Created on: Sep 14, 2023
 *      Author: Gabriel
 */

.syntax unified

.global asmx2cos

.extern arm_cos_f32
.extern arm_sin_f32

.section .text.rodata

epsilon: .word 0x33ec3924 // floating-point: 1.1e-7

/**
 *
 * void asmx2cos(float32_t guess, float32_t phi, float32_t omega, float32_t *pOut);
 *
 * S0 = initial guess for Newton-Raphson method
 * S1 = phase of cos
 * S2 = angular speed of cos
 * R0 = pointer to the output
 *
 */

asmx2cos:
 	PUSH		{R4-R5, LR}
 	VPUSH.f32	{S4-S11}
 	VMOV.f32	S4, S0 // float32_t x0;
 	MOV			R3, #0
 	VMOV.f32	S5, R3 // float32_t fx0arg;
 	VMOV.f32	S6, R3 // float32_t fx0;
 	VMOV.f32	S7, R3 // float32_t fprimex0;
 	VMOV.f32	S8, R3 // float32_t x1;
 	VMOV.f32    S9, S0 // S8 - S4 = S9, to compare with epsilon
 	VMOV.f32	S10, S1 // copy: float32_t phi
 	VMOV.f32	S11, S2 // copy: float32_t omega
 	MOV			R4, R0 // copy: float32_t *pOut
 	MOV			R5, #64 // const uint32_t max_iterations = 64;
 	LDR			R6, epsilon

asmx2cos_loop:
	SUBS		R5, R5, #1
	BLT			asmx2cos_end_failure
	VMUL.f32	S5, S4, S11 // fx0arg = x0*omega + phi;
	VADD.f32	S5, S5, S10
	VMOV.f32	S0, S5
 	BL			arm_cos_f32 // output arm_cos_f32(fx0arg) to S0
	VNMLS.f32	S0, S4, S4  // fx0 = x0*x0 - arm_cos_f32(fx0arg);
	VMOV.f32	S6, S0
	VMOV.f32	S0, S5
	BL			arm_sin_f32 // output: arm_cos_f32(fx0arg) to S0
	VADD.f32	S1, S4, S4 // fprimex0 = 2*x0 + omega*arm_sin_f32(fx0arg);
	VMLA.f32	S1, S0, S11
	VDIV.f32	S8, S6, S1 // x1 = x0 - fx0/fprimex0;
	VSUB.f32	S8, S4, S8
	VSUB.f32    S9, S8, S4
	VABS.f32    S9, S9
	VMOV.f32	S2, R6
	VCMP.f32	S9, S2
	VMRS		APSR_nzcv, FPSCR
	BLT			asmx2cos_end_success
	VMOV.f32	S4, S8
	B			asmx2cos_loop

asmx2cos_end_success:
	VSTR.f32	S8, [R4]
	B			asmx2cos_end

asmx2cos_end_failure:
	MOV			R3, #0
	VMOV.f32	S8, R0
	VSTR.f32	S8, [R4]
	B			asmx2cos_end

asmx2cos_end:
	VPOP.f32	{S4-S11}
	POP			{R4-R5, PC}
