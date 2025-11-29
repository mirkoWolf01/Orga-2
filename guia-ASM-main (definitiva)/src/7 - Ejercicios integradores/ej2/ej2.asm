extern malloc
extern free
extern strncpy

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text

FALSE EQU 0
TRUE  EQU 1


global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

MAP_SIZE EQU 255
POINTER_SIZE EQU 8

global optimizar
optimizar:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi ; mapa
	mov r13, rsi ; compartida
	mov r14, rdx ; fun_hash

	xor r15, r15 ; i
	xor rbx, rbx ; j

	mov rdi, r13
	call r14
	mov dword [rbp - 16], eax

	.loop_i: 
		cmp r15, MAP_SIZE
		jge .end_i

		.loop_j:
			cmp rbx, MAP_SIZE
			jge .end_j
			
			mov rcx, r15
			imul rcx, MAP_SIZE
			imul rcx, POINTER_SIZE

			mov rdx, rbx
			imul rdx, POINTER_SIZE

			lea rdi, [r12 + rcx]
			lea rdi, [rdi + rdx]
			mov qword [rbp - 8], rdi ; *mapa[i][j]

			mov rdi, [rdi]

			cmp rdi, 0
			je .continue

			call r14
			cmp eax, dword [rbp - 16]
			jne .continue

			mov rdi, [rbp-8]
			mov rdi, [rdi]

			dec byte [rdi + ATTACKUNIT_REFERENCES]
			inc byte [r13 + ATTACKUNIT_REFERENCES]

			cmp byte [rdi + ATTACKUNIT_REFERENCES], 0
			jne .dont_free

			; si las referencias al puntero son 0, lo tengo que liberar
			mov rdi, [rbp-8]
			mov rdi, [rdi]
			call free

			.dont_free:
			mov rdi, [rbp-8]
			mov [rdi], r13

			.continue:
			inc rbx
			jmp .loop_j
		.end_j:

		xor rbx, rbx
		inc r15
		jmp .loop_i
	.end_i:

	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 24
	pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi ; mapa
	mov r13, rsi ; fun_combustible

	xor r15, r15 ; i
	xor rbx, rbx ; j

	xor r14, r14

	.loop_i: 
		cmp r15, MAP_SIZE
		jge .end_i

		.loop_j:
			cmp rbx, MAP_SIZE
			jge .end_j
			
			mov rcx, r15
			imul rcx, MAP_SIZE
			imul rcx, POINTER_SIZE

			mov rdx, rbx
			imul rdx, POINTER_SIZE

			lea rdi, [r12 + rcx]
			lea rdi, [rdi + rdx]
			mov qword [rbp - 8], rdi ; *mapa[i][j]

			mov rdi, [rdi]

			cmp rdi, 0
			je .continue

			lea rdi, [rdi + ATTACKUNIT_CLASE]
			call r13

			xor rdx, rdx

			mov rdi, [rbp - 8]
			mov rdi, [rdi]
			mov dx, word  [rdi + ATTACKUNIT_COMBUSTIBLE]

			sub dx, ax
			add r14d, edx

			.continue:
			inc rbx
			jmp .loop_j
		.end_j:

		xor rbx, rbx
		inc r15
		jmp .loop_i
	.end_i:
	mov eax, r14d
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 8
	pop rbp
	ret

global modificarUnidad
modificarUnidad:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi ; mapa
	mov r13, rcx ; fun_modificar
	mov r14, rsi ; x
	mov r15, rdx ; y


	mov rcx, r14
	imul rcx, MAP_SIZE
	imul rcx, POINTER_SIZE
	
	mov rdx, r15
	imul rdx, POINTER_SIZE

	lea rdi, [r12 + rcx]
	lea rdi, [rdi + rdx]
	mov qword [rbp - 8], rdi ; *mapa[i][j]

	mov rdi, [rdi]

	cmp rdi, 0
	je .end

	mov rdi, ATTACKUNIT_SIZE
	call malloc
	mov rbx, rax ; unit_m

	lea rdi, [rbx + ATTACKUNIT_CLASE]
	mov rsi, [rbp - 8]
	mov rsi, [rsi]
	lea rsi, [rsi + ATTACKUNIT_CLASE]
	
	mov rdx, ATTACKUNIT_COMBUSTIBLE

	call strncpy

	mov rdi, [rbp - 8]
	mov rdi, [rdi]
	mov si, word [rdi + ATTACKUNIT_COMBUSTIBLE]
	mov word [rbx + ATTACKUNIT_COMBUSTIBLE], si
	mov byte [rbx + ATTACKUNIT_REFERENCES], 1

	dec byte [rdi + ATTACKUNIT_REFERENCES] ; unit->references --

	cmp byte [rdi + ATTACKUNIT_REFERENCES], 0
	jne .dont_free

	call free

	.dont_free:
	mov rdi, [rbp - 8]
	mov [rdi], rbx

	mov rdi, rbx
	call r13	

	.end:
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 8
	pop rbp
	ret

; Funciona todo, pasan todos los abi.