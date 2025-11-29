extern malloc
extern free

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

CASO_0 EQU 0
CASO_1 EQU 1
CASO_2 EQU 2


;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)
global segmentar_casos
segmentar_casos:
    push rbp
	mov rbp, rsp
	sub rsp, 40
	push r12
	push r13
	push r14
	push r15
    push rbx

    mov r12, rdi ; arreglo_casos
    mov r13, rsi ; largo

    mov rdi, SEGMENTACION_SIZE
    call malloc

    ; inicializo en 0
    mov qword [rax + SEGMENTACION_CASOS0_OFFSET], 0
    mov qword [rax + SEGMENTACION_CASOS1_OFFSET], 0
    mov qword [rax + SEGMENTACION_CASOS2_OFFSET], 0

    mov rbx, rax ; me guardo el puntero a segmentacion, mas adeltante lo saco

    mov rdi, r12
    mov rsi, r13
    mov rdx, qword 0

    ; casos_0
    call contar_casos_por_nivel
    mov [rbp - 8], ax

    mov rdi, r12
    mov rsi, r13
    mov rdx, qword 1

    ; casos_1
    call contar_casos_por_nivel
    mov [rbp - 16], ax

    mov rdi, r12
    mov rsi, r13
    mov rdx, qword 2

    ; casos_2
    call contar_casos_por_nivel
    mov [rbp - 24], ax


    cmp word [rbp - 8], 0
    je .continue_0

    xor rdi, rdi
    mov di, word [rbp - 8]
    imul rdi, CASO_SIZE

    call malloc
    mov qword [rbx + SEGMENTACION_CASOS0_OFFSET], rax
    .continue_0:

    cmp word [rbp - 16], 0
    je .continue_1

    xor rdi, rdi
    mov di, word [rbp - 16]
    imul rdi, CASO_SIZE

    call malloc
    mov qword [rbx + SEGMENTACION_CASOS1_OFFSET], rax
    .continue_1:
    
    cmp word [rbp - 24], 0
    je .continue_2

    xor rdi, rdi
    mov di, word [rbp - 24]
    imul rdi, CASO_SIZE

    call malloc
    mov qword [rbx + SEGMENTACION_CASOS2_OFFSET], rax
    .continue_2:
    
    mov [rbp - 32], rbx
    mov [rbp - 40], r13
    
    xor r13, r13 ; lo vacio para usarlo mas tarde
    xor r14, r14 ; i0
    xor r15, r15 ; i1
    xor rbx, rbx ; i2
    xor rcx, rcx ; i del loop

    .loop:
    cmp ecx, dword [rbp - 40]
    jnl .end

    imul rdx,  rcx, CASO_SIZE
    lea rdi, [r12 + rdx]
    mov r13, rdi ; me guardo el puntero al caso
    mov rdi, [rdi + CASO_USUARIO_OFFSET]
    mov edi, dword [rdi + USUARIO_NIVEL_OFFSET]

    mov rsi, [rbp - 32] ; me traigo el puntero res

    cmp edi, 0
    je .caso_0

    cmp edi, 1
    je .caso_1

    cmp edi, 2
    je .caso_2

    jmp .continue

    .caso_0:
    mov rdi, r14
    inc r14
    mov rsi, [rsi + SEGMENTACION_CASOS0_OFFSET]

    jmp .continue

    .caso_1:
    mov rdi, r15
    inc r15
    mov rsi, [rsi + SEGMENTACION_CASOS1_OFFSET]

    jmp .continue

    .caso_2:
    mov rdi, rbx
    inc rbx
    mov rsi, [rsi + SEGMENTACION_CASOS2_OFFSET]

    jmp .continue

    .continue:
    imul rdi, CASO_SIZE
    add rsi, rdi
    mov r8, qword [r13]
    mov r9, qword [r13 + 8]
    mov [rsi], r8
    mov [rsi + 8], r9

    inc rcx
    jmp .loop

    .end:

    mov rax, [rbp - 32]
    pop rbx
    pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 40
	pop rbp
ret

global contar_casos_por_nivel
contar_casos_por_nivel:
    push rbp
	mov rbp, rsp
	;sub rsp, 24
	push r12
	push r13
	push r14
	push r15

    mov r12, rdi ; arreglo_casos
    mov r13, rsi ; largo
    mov r14, rdx ; nivel

    xor rax, rax
    xor rcx, rcx

    .loop: 
    cmp rcx, r13
    jnl .end

    imul rdx,  rcx, CASO_SIZE
    lea rdi, [r12 + rdx]
    mov rdi, [rdi + CASO_USUARIO_OFFSET]
    mov edx, dword [rdi + USUARIO_NIVEL_OFFSET]

    cmp r14d, edx
    jne .continue

    inc ax

    .continue:
    inc rcx
    jmp .loop

    .end:
    pop r15
	pop r14
	pop r13
	pop r12
	;add rsp, 24
	pop rbp
ret