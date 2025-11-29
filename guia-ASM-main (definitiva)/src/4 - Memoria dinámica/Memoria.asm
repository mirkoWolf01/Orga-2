extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

CHAR_SIZE EQU 1

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	push rbp
	mov rbp, rsp

	xor rax, rax

	.for:
		mov cl, byte[rdi]
		mov dl, byte[rsi]

		cmp cl, dl
		je .continue
		jg .amayor
		jl .bmayor


		.continue:
		cmp cl, 0
		je .fin

		add rdi, CHAR_SIZE
		add rsi, CHAR_SIZE
		jmp .for

	.amayor:
		mov eax, -1
		jmp .fin

	.bmayor:
		mov eax, 1
		jmp .fin

	.fin:

	pop rbp
	ret

; char* strClone(char* a)
strClone:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	; alineado a 16

	mov r12, rdi ; guardo el puntero al array

	call strLen
	mov r13, rax ; guardo el tamaño del array
	
	mov rdi, rax

	inc rdi	; le sumo el caracter nulo
	imul rdi, CHAR_SIZE
	call malloc
	
	mov rdi, rax ; el puntero al caracter actual
	xor rcx, rcx
	
	.for: 
		cmp rcx, r13 
		jge .fin

		xor rdx, rdx
		mov dl, byte[r12]
		mov [rdi], byte dl

		add r12, CHAR_SIZE
		add rdi, CHAR_SIZE
		inc rcx
		jmp .for
	.fin:
	mov [rdi] , byte 0 ; siempre al final pongo el caracter nulo, independientemente del tamaño.

	pop r13
	pop r12
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	; como no hice un call no modifica el valor de retorno
	jmp free
	

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	push rbp
	mov rbp, rsp

	xor rax, rax

	.for:
		mov cl, byte[rdi]

		cmp cl, 0
		je .fin

		inc rax
		add rdi, CHAR_SIZE
		jmp .for

	.fin:

	pop rbp
	ret


