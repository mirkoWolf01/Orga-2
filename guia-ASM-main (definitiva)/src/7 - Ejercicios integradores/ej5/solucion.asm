; Definiciones comunes
TRUE  EQU 1
FALSE EQU 0

; Identificador del jugador rojo
JUGADOR_ROJO EQU 1
; Identificador del jugador azul
JUGADOR_AZUL EQU 2

; Ancho y alto del tablero de juego
tablero.ANCHO EQU 10
tablero.ALTO  EQU 5


NO_COMPLETADO EQU -1

extern strcmp

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
carta.en_juego EQU 0
carta.nombre   EQU 1
carta.vida     EQU 14
carta.jugador  EQU 16
carta.SIZE     EQU 18

tablero.mano_jugador_rojo EQU 0
tablero.mano_jugador_azul EQU 8
tablero.campo             EQU 16
tablero.SIZE              EQU 416

accion.invocar   EQU 0
accion.destino   EQU 8
accion.siguiente EQU 16
accion.SIZE      EQU 24

POINTER_SIZE EQU 8

section .rodata


global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE

section .text


global hay_accion_que_toque
hay_accion_que_toque:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi ; accion
	mov r13, rsi ; nombre

	xor rax, rax

	cmp r12, 0
	je .return

	mov rdi, [r12 + accion.destino]
	
	lea rdi, [rdi + carta.nombre]
	mov rsi, r13

	call strcmp

	cmp rax, 0
	jne .continue

	mov rax, 1
	jmp .return

	.continue:
	mov rdi, [r12 + accion.siguiente]
	mov rsi, r13

	call hay_accion_que_toque

	.return:
	pop r15
	pop r14
	pop r13
	pop r12 
	pop rbp
	ret


global invocar_acciones
invocar_acciones:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi ; accion
	mov r13, rsi ; tablero

	cmp r12, 0
	je .return

	mov rdi, [r12 + accion.destino]
	mov r14, rdi ; destino
	
	mov al, byte [rdi + carta.en_juego]
	cmp al, 1 
	jne .continue

	mov rcx, [r12 + accion.invocar]	

	mov rdi, r13
	mov rsi, r14

	call rcx

	cmp word [r14 + carta.vida], 0 
	jne .continue

	mov byte [r14 + carta.en_juego], 0

	.continue:
	mov rdi, [r12 + accion.siguiente]
	mov rsi, r13

	call invocar_acciones

	.return:
	mov rax, rax
	pop r15
	pop r14
	pop r13
	pop r12 
	pop rbp
	ret


; NO OLVIDAR
; 1. REINICIAR EL CONTADOR DE LA SEGUNDA VARIABLE
; 2. SALTAR AL TERMINAR CON J A LOOP I
; 3. SE MULTIPLICA A I POR EL ANCHO !!!

global contar_cartas
contar_cartas:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi ; tablero
	mov r13, rsi ; cant_rojas
	mov r14, rdx ; cant_azules

	mov dword [r13], 0
	mov dword [r14], 0

	xor r15, r15 ; i
	xor rbx, rbx ; j

	.loop_i:
	cmp r15, tablero.ALTO
	jnl .end

		.loop_j:
		cmp rbx, tablero.ANCHO
		jnl .continue_i

		lea rdi, [r12 + tablero.campo]

		imul rsi, r15, tablero.ANCHO
		imul rsi, POINTER_SIZE

		add rdi, rsi

		imul rsi, rbx, POINTER_SIZE

		add rdi, rsi

		mov rdi, [rdi]
		mov [rbp - 8], rdi

		cmp rdi, 0 
		je .continue_j

		mov cl, byte [rdi + carta.jugador]

		cmp cl, JUGADOR_AZUL
		jne .comprobar_jugador_rojo

		inc dword [r14]
		jmp .continue_j

		.comprobar_jugador_rojo:
		cmp cl, JUGADOR_ROJO
		jne .continue_j

		inc dword [r13]
		jmp .continue_j

		.continue_j:
		inc rbx
		jmp .loop_j

	.continue_i:
	inc r15
	xor rbx, rbx
	jmp .loop_i

	.end:
	mov rax, rax
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12 
	add rsp, 24
	pop rbp
	ret
