	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0 ;long VarTime=0
	EXPORT VarTime ; pour le test

; ===============================================================================================
	
;constantes (équivalent du #define en C)
TimeValue	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.

	
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette manière de créer une temporisation n'est clairement pas la bonne manière de procéder :
; - elle est peu précise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'accés écr/lec de variable en RAM
; - le mécanisme d'appel / retour sous programme
;
; et donc possède un intérêt pour débuter en ASM pur

Delay_100ms proc
	
	    ; VarTime=TimeValue
	    ldr r0,=VarTime ; r0=&VarTime
		ldr r1,=TimeValue ; r1=TimeValue=900000
		str r1,[r0] ; VarTime=TimeValue
		
BoucleTempo
		; Vartime=Vartime-1
		ldr r1,[r0] ; r1=Vartime
		subs r1,#1 ; r1--
		str  r1,[r0] ; Vartime=Vartime-1
		
		; branch if Vartime not equal to 0
		bne	 BoucleTempo ; branch if not equal (if not zero)
			
		bx lr ; indirect jump to [LR] (adresse retour)
		endp
		
		
	END	