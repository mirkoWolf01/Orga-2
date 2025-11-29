extern strcmp
global invocar_habilidad

; Completar las definiciones o borrarlas (en este ejercicio NO serán revisadas por el ABI enforcer)
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32

POINTER_SIZE EQU 8

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text

; void invocar_habilidad(void* carta, char* habilidad);
invocar_habilidad:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi ; carta
	mov r13, rsi ; habilidad

	xor r14, r14 ; i
	.loop:
		cmp r14w, word [r12 +  FANTASTRUCO_ENTRIES_OFFSET]
		jnl .end

		mov rdi, [r12 + FANTASTRUCO_DIR_OFFSET]
		imul rsi, r14, POINTER_SIZE
		add rdi, rsi
		mov r15, [rdi]

		lea rdi, [r15 + DIRENTRY_NAME_OFFSET]
		mov rsi, r13

		call strcmp
		cmp eax, 0 
		jne .continue

		mov rcx, [r15 + DIRENTRY_PTR_OFFSET]
		
		mov rdi, r12
		call rcx
		jmp .return

		.continue:
		inc r14w
		jmp .loop

	.end:

	mov rdi, [r12 + FANTASTRUCO_ARCHETYPE_OFFSET]
	cmp rdi, 0
	je .return

	mov rsi, r13
	call invocar_habilidad

	.return:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
