extern strncmp

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0
CASO_ESTADO_OFFSET EQU 4
CASO_USUARIO_OFFSET EQU 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7

CATERGORIA_CASO_CLT EQU  0x544C43
CATERGORIA_CASO_RBO EQU  0x4F4252

global resolver_automaticamente

;void resolver_automaticamente(funcionCierraCasos* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo)
resolver_automaticamente:
    push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12
	push r13
	push r14
	push r15
    push rbx

    mov r12, rdi ; funcion
    mov r13, rsi ; arreglo_casos
    mov r14, rdx ; casos_a_revisar
    mov r15, rcx ; largo

    mov qword [rbp - 8], 0
    
    xor rbx, rbx

    .loop:
    cmp rbx, r15 
    jnl .end

    imul rdx,  rbx, CASO_SIZE
    lea rdi, [r13 + rdx]
    mov qword [rbp - 16], rdi
    mov rcx, [rdi + CASO_USUARIO_OFFSET]
    mov edx, dword [rcx + USUARIO_NIVEL_OFFSET]


    cmp edx, dword 0
    je .caso_revision

    ; caso != 0

    call r12

    cmp ax, 0 
    je .res1

    mov rdi, qword [rbp -16]
    mov word [rdi + CASO_ESTADO_OFFSET], 1

    jmp .continue

    .res1: 

    mov rdi, qword [rbp -16]
    mov edi, dword [rdi + CASO_CATEGORIA_OFFSET]
    mov esi, CATERGORIA_CASO_RBO

    cmp edi, esi
    je .caso_termina_desfaborablemente

    mov esi, CATERGORIA_CASO_CLT
    cmp edi, esi
    jne .else

    .caso_termina_desfaborablemente:

    mov rdi, qword [rbp -16]
    mov word [rdi + CASO_ESTADO_OFFSET], word 2

    jmp .continue

    .else:
    mov rdi, qword [rbp -16]
    jmp .caso_revision

    jmp .continue

    .caso_revision:
    mov rsi, [rbp - 8]
    imul rsi, CASO_SIZE
    lea rdx, [r14 + rsi] 

    mov rcx, qword [rdi]
    mov qword [rdx], rcx

    mov rcx, qword [rdi + 8]
    mov qword [rdx + 8], rcx

    inc qword [rbp - 8]


    .continue:
    inc rbx
    jmp .loop

    .end:

    pop rbx
    pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 24
	pop rbp
    ret
