extern strcpy
extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

ITEM_OFFSET_NOMBRE EQU 0
ITEM_OFFSET_ID EQU 12
ITEM_OFFSET_CANTIDAD EQU 16

POINTER_SIZE EQU 8
UINT32_SIZE EQU 4

; Marcar el ejercicio como hecho (`true`) o pendiente (`false`).

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global ejercicio1
ejercicio1:
	push rbp 
	mov rbp, rsp

	add rdi, rsi
	add rdi, rdx
    add rdi, rcx
    add rdi, r8
	
	mov rax, rdi

	pop rbp
	ret

global ejercicio2
ejercicio2:
	push rbp
	mov rbp, rsp
	push r12
	push r13

	mov [rdi+ITEM_OFFSET_ID], dword esi
	mov [rdi+ITEM_OFFSET_CANTIDAD], dword edx
	
	; tambien sirve para arrays de char el strcpy
	mov rsi, rcx
	add rdi, ITEM_OFFSET_NOMBRE
	call strcpy 

	pop r13
	pop r12
	pop rbp
	ret


global ejercicio3
ejercicio3:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8

	cmp rsi, 0
	je .vacio
	
	mov r12, rdi ; * array
	xor r13, r13 ; res

	mov r15d, dword esi	; n
	mov rbx, rdx		; puntero a la func

	cmp rsi, 1
	jg .caso_mayor

	.caso_1:
	mov edi, dword 0
	mov esi, dword [r12]

	call rbx
	jmp .end

	.caso_mayor:
	mov rdi, r12	; array
	dec r15d 	; n -1
	mov esi, r15d
	mov rdx, rbx	; func

	call ejercicio3
	
	mov r13d, eax	; lo pongo en res
	mov edi, eax
	
	mov esi, r15d	; n -1
	imul esi, UINT32_SIZE
	add rsi, r12

	mov esi, dword [rsi]

	call rbx 

	add eax, dword r13d

	jmp .end

	.vacio:
	mov eax, 64

	.end:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global ejercicio4
ejercicio4:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8

	mov r12, rdi ; puntero de punteros
	mov r13d, esi ; size
	mov r14d, edx ; constante

	xor rdi, rdi
	mov eax, UINT32_SIZE
	mul esi
	mov edi, eax

	call malloc
	mov r15, rax ; puntero al res
	
	xor rbx, rbx

	.loop:
	cmp ebx, r13d
	jge .end

	; xor rax, rax

	lea rdi, [r12 + rbx*POINTER_SIZE] ; calculo la posicion de memoria buscada
	mov r8, [rdi]
	mov qword [rdi], 0
	
	mov r9d, [r8]
	mov eax, r14d
	mul r9d
	mov dword [r15 + rbx*UINT32_SIZE], eax

	mov rdi, r8 ; muevo el puntero a liberar
	call free 
	
	inc ebx
	jmp .loop

	.end:
	mov rax, r15
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
