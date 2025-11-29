extern malloc

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
CATERGORIA_CASO_KSC EQU  0X43534B
CATERGORIA_CASO_KDT EQU  0X54444B

global calcular_estadisticas

;void calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id)
calcular_estadisticas:
    push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12
	push r13
	push r14
	push r15
    push rbx

    mov r12, rdi ; arreglo_casos
    mov r13d, esi ; largo
    mov r14d, edx ; usuario_id 

    mov rdi, qword ESTADISTICAS_SIZE
    call malloc

    mov rbx, rax ; puntero resultado
    mov byte [rbx + ESTADISTICAS_CLT_OFFSET], 0
    mov byte [rbx + ESTADISTICAS_RBO_OFFSET], 0
    mov byte [rbx + ESTADISTICAS_KDT_OFFSET], 0
    mov byte [rbx + ESTADISTICAS_KSC_OFFSET], 0
    mov byte [rbx + ESTADISTICAS_ESTADO0_OFFSET], 0
    mov byte [rbx + ESTADISTICAS_ESTADO1_OFFSET], 0
    mov byte [rbx + ESTADISTICAS_ESTADO2_OFFSET], 0

    xor rcx, rcx ; i = 0

    .loop:
    cmp ecx, r13d
    jnl .end

    imul rdi, rcx, CASO_SIZE
    lea rdi, [r12 + rdi]
    ;mov qword [rbp - 16], rdi
    mov rsi, [rdi + CASO_USUARIO_OFFSET]
    mov esi, dword [rsi + USUARIO_ID_OFFSET]

    cmp r14d, 0
    je .contabilizar_categoria

    cmp r14d, esi
    je .contabilizar_categoria

    jmp .continue

    .contabilizar_categoria:
    mov esi, dword [rdi + CASO_CATEGORIA_OFFSET]
    cmp esi, CATERGORIA_CASO_CLT
    je .caso_clt

    cmp esi, CATERGORIA_CASO_RBO
    je .caso_rbo

    cmp esi, CATERGORIA_CASO_KDT
    je .caso_kdt

    cmp esi, CATERGORIA_CASO_KSC
    je .caso_ksc

    jmp .contabilizar_estados

    .caso_clt:
    inc byte [rbx + ESTADISTICAS_CLT_OFFSET]
    jmp .contabilizar_estados
    

    .caso_rbo:
    inc byte [rbx + ESTADISTICAS_RBO_OFFSET]
    jmp .contabilizar_estados

    .caso_kdt: 
    inc byte [rbx + ESTADISTICAS_KDT_OFFSET]
    jmp .contabilizar_estados

    .caso_ksc:
    inc byte [rbx + ESTADISTICAS_KSC_OFFSET]
    jmp .contabilizar_estados

    .contabilizar_estados:
    mov si, word [rdi + CASO_ESTADO_OFFSET]
    cmp si, 0
    je .caso_estado_0
    
    cmp si, 1
    je .caso_estado_1
    
    cmp si, 2
    je .caso_estado_2

    .caso_estado_0:
    inc byte [rbx + ESTADISTICAS_ESTADO0_OFFSET]
    jmp .continue

    .caso_estado_1:
    inc byte [rbx + ESTADISTICAS_ESTADO1_OFFSET]
    jmp .continue

    .caso_estado_2:
    inc byte [rbx + ESTADISTICAS_ESTADO2_OFFSET]
    jmp .continue

    .continue:
    inc rcx
    jmp .loop

    .end:
    mov rax, rbx
    pop rbx
    pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 24
	pop rbp
    ret
