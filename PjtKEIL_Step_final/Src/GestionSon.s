	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
SortieSon	dcw 0 ;16 bits
	EXPORT SortieSon
		
Index dcw 0

	
; ===============================================================================================
	
	EXPORT CallbackSon
	EXPORT StartSon
	IMPORT Son
	IMPORT LongueurSon

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici	

	include ./Driver/DriverJeuLaser.inc

CallbackSon proc
		push {r4-r5, lr} 
Si ; (Index == LongueurSon)
		; S'arrete quand on a parcouru l'ensemble du tableau
		ldr r1, =Index
		ldrsh r2, [r1]

		ldr r3, =LongueurSon
		ldr r4, [r3]

		cmp r2, r4
		bne Sinon

Alors
		ldr r4, =SortieSon
		ldrh r0, [r4]
		b FinSi

Sinon
		; SortieSon = Son[Index]
		ldr r3, =Son
		ldrsh r0,[r3, r2, lsl #1]
		add r0, #32768 ; mise à l'échelle de SortieSon [-32 768 ; 32 767] -> [0 ; 65 535]
		mov r5, #92
		udiv r0, r5 ; [0 ; 65 535] -> [0 ; 712]
		ldr r4, =SortieSon
		strh r0, [r4]
		
		; Index ++
		add r2, #1 
		strh r2, [r1]

FinSi
		bl PWM_Set_Value_TIM3_Ch3
		pop {r4-r5, pc}
		endp
			
StartSon proc
		ldr r1, =Index
		mov r2, #0
		strh r2, [r1]
		bx lr
		endp

	END	