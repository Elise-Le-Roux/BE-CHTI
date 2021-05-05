	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
FlagCligno	dcb 0 ;char FlagCligno
	EXPORT FlagCligno
		

	
; ===============================================================================================
	
	EXPORT timer_callback

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		
	include ./Driver/DriverJeuLaser.inc
; écrire le code ici		

;char FlagCligno;

;void timer_callback(void)
;{
;	if (FlagCligno==1)
;	{
;		FlagCligno=0;
;		GPIOB_Set(1);
;	}
;	else
;	{
;		FlagCligno=1;
;		GPIOB_Clear(1);
;	}
;		
;}

timer_callback proc ;void timer_callback(void)

Si ; (FlagCligno == 1)
		ldr r1,=FlagCligno
		ldrb r0, [r1]
		cmp r0, #1
		bne Sinon
Alors
		;	FlagCligno=0;
		mov r2, #0
		strb r2, [r1]
		mov r0, #1
		push {lr, r1, r2} 
		bl GPIOB_Set ;	GPIOB_Set(1);
		pop {lr, r1, r2} 
		
		
		b FinSi
		
Sinon
		;	FlagCligno=1;
		mov r2, #1
		strb r2, [r1]
		mov r0, #1
		push {lr, r1, r2} 
		bl GPIOB_Clear ;	GPIOB_Clear(1);
		pop {lr, r1, r2}
FinSi

		bx lr
		endp

		
		
	END	