
	 AREA     spiral, CODE, READONLY
     IMPORT printValue
	 IMPORT print_delimeter
	 IMPORT printNextline
     IMPORT printheader	 
	 EXPORT __main
		ENTRY 






__computeCos FUNCTION							;in_register S7=X  out_register S6=COS(X)
		
loop12	VLDR.F32 S9,=3.141592654
		VLDR.F32 S8,=180.0
		VLDR.F32 S5,=1.0
		MOV R1,#22         					;Number of terms in COMPUTATION

		

		VMUL.F32 S1,S7,S9
		VDIV.F32 S1,S1,S8					;x=PI*(theta)/180
		VMUL.F32 S2,S1,S1					;x^2
		VNEG.F32 S2,S2						;-x^2
		VLDR.F32 S1,=1.0
		VMOV.F32 S3,S1						;S3 stores the current term in the series
		VLDR.F32 S4,=1.0
		VMOV.F32 S24,S1		                ;COSX=1

		

loop2	VMUL.F32 S3,S3,S2					;S3*(-x^2)
		VDIV.F32 S3,S3,S4					;S3/(2n-1)
		VADD.F32 S4,S4,S5					
		VDIV.F32 S3,S3,S4					;S3/(2n)
		VADD.F32 S4,S4,S5					
		VADD.F32 S24,S24,S3					;S24 stores cos(X)

		
		SUB R1,R1,#1						;R1-- 
		CMP R1,#0
		BNE loop2							;loop for next Term                                   
		BX lr

		
	ENDFUNC	

__computeSine FUNCTION			;in_register S7=X  out_register S6=Sin(X)
     				            ;x=0 to 360(in degrees)
								;keeping angle value between -90 to 90 to gain accurate value from series in sine
        VLDR.F32 S1,=90.0
        VMOV.F32 S0,S7
        VCMP.F32 S7,S1
		VMRS APSR_nzcv, FPSCR
		BLT loop1
        VLDR.F32 S1,=180.0		
		VSUB.F32 S0,S1,S7
        VLDR.F32 S1,=270.0
		VCMP.F32 S7,S1
		VMRS APSR_nzcv, FPSCR
        BLT loop1
		VLDR.F32 S1,=360.0
        VSUB.F32 S0,S7,S1

											
loop1   VLDR.F32 S9,=3.141592654  
		VLDR.F32 S8,=180.0
		VLDR.F32 S5,=1.0
		MOV R1,#22         					;Number of terms in series
		VMUL.F32 S1,S0,S9
		VDIV.F32 S1,S1,S8					;x=PI*(THETA)/180
		VMUL.F32 S2,S1,S1					;x^2
		VNEG.F32 S2,S2						;-x^2
		VMOV.F32 S3,S1						;S3 stores the current term in the series
		VLDR.F32 S4,=2.0
		VMOV.F32 S6,S1		                

		

loop	VMUL.F32 S3,S3,S2					;S3*(-x^2)
		VDIV.F32 S3,S3,S4					;S3/(2n)
		VADD.F32 S4,S4,S5					
		VDIV.F32 S3,S3,S4					;S3/(2n+1)
		VADD.F32 S4,S4,S5
		VADD.F32 S6,S6,S3					;S6 stores Sin(X)
		SUB R1,R1,#1						;R1-- 

		CMP R1,#0

		BNE loop							;loop for next Term
        VMOV.F32 R0,S6						;R0 stores Sin(X)	                                    
		BX lr

		
	ENDFUNC










__SPIRALTWO FUNCTION					;(Draws spiral Two takes S22, S26, S27 as r, X, Y)
		;PUSH {lr}
		VLDR.F32 S20,=1.0	
		VLDR.F32 S29,= 0.5
		VLDR.F32 S21,=361.0
		VLDR.F32 S7,=0.0 					;Interates from 0 to 360 
loop4	VMOV.F32 R0,S7
		BL printValue		
		BL print_delimeter
		BL __computeSine							;S7 has current angle and Sin value is stored in S6
		VMUL.F32 S6,S6,S22					;S6= r * sin(angle)
		VADD.F32 S6,S27,S6					;S6= Y + r * sin(angle)
		VMOV.F32 R0,S6
		BL printValue		
		BL print_delimeter
		BL __computeCos							;S7 has current angle and cos value is stored in S24
		VMUL.F32 S24,S24,S22					;S6=  r * sin(angle)
		VADD.F32 S24,S24,S26					;S6= X + r * sin(angle)
		VMOV.F32 R0,S24
		BL printValue
		BL printNextline
		VADD.F32 S7,S7,S20
		VSUB.F32 S22,S22,S29                ; decrementing radius on every degree
		VCMP.F32 S7,S21						;Compare and continue till 360 degree
		VMRS APSR_nzcv, FPSCR
		BNE loop4
		VSUB.F32 S30,S30,S20
		VLDR.F32 S7,=0.0
		VCMP.F32 S30,S7
		VMRS APSR_nzcv, FPSCR
		BNE loop4
		;POP {lr}
		BX lr
		
		ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------	
__SPIRALONE FUNCTION					  ;(Draws spiral one takes S22, S26, S27 as r, X, Y)
		VLDR.F32 S20,=1.0	
		VLDR.F32 S29,= 1.2
		VLDR.F32 S21,=361.0               ;loop3 stops at 361
		VLDR.F32 S7,=0.0 					;Iterates FROM 0 to 360 degrees
loop3	VMOV.F32 R0,S7
		BL printValue		
		BL print_delimeter
		BL __computeSine					;S7 has current angle and Sin value is stored in S6
		VMUL.F32 S6,S6,S22					;S6= r * sin(angle)
		VADD.F32 S6,S27,S6					;S6= Y + r * sin(angle)
		VMOV.F32 R0,S6
		BL printValue		
		BL print_delimeter
		BL __computeCos						;S7 has current angle and cos value is stored in S24
		VMUL.F32 S24,S24,S22				;S6=  r * sin(angle)
		VADD.F32 S24,S24,S26				;S6= X + r * sin(angle)
		VMOV.F32 R0,S24
		BL printValue
		BL printNextline
		VADD.F32 S7,S7,S20
		VADD.F32 S22,S22,S29				;Increamenting radius on every degree
		VCMP.F32 S7,S21						;Compare and continue till 360 degree
		VMRS APSR_nzcv, FPSCR
		BNE loop3
		VSUB.F32 S30,S30,S20
		VLDR.F32 S7,=0.0
		VCMP.F32 S30,S7
		VMRS APSR_nzcv, FPSCR
		BNE loop3
		VLDR.F32 s22,=400.0				;radius
		VMOV.F32 R0,S22
		VLDR.F32 S26,= 8000.0		    ;X
		VMOV.F32 R1,S26
		VLDR.F32 S27,=500.0				;Y
		VMOV.F32 R2,S27
		VLDR.F32 S30, =4.0
		BL __SPIRALTWO	
		BX lr
		
		ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
		
		
__main  FUNCTION
		                                
		
		VLDR.F32 s22,=0.0				;radius
		VLDR.F32 S26,=0.0				;X Took centre as origin X=0, Y=0
		VLDR.F32 S27,=0.0				;Y
		VLDR.F32 S30, =4.0
		BL printheader
		
		BL __SPIRALONE					;Drawing SPIRAL 

stop    B stop                              ; stop program

     ENDFUNC
	 END
	
