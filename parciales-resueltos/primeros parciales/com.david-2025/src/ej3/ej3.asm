extern malloc
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

PRODUCTO_USUARIO_OFFSET EQU 0
PRODUCTO_CATEGORIA_OFFSET EQU 8
PRODUCTO_NOMBRE_OFFSET EQU 17
PRODUCTO_ESTADO_OFFSET EQU 42
PRODUCTO_PRECIO_OFFSET EQU 44
PRODUCTO_ID_OFFSET EQU 48
PRODUCTO_SIZE EQU 56

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

CATALOGO_FIRST_OFFSET EQU 0
CATALOGO_SIZE EQU 8

POINTER_SIZE EQU 8
INT_32_SIZE EQU 4

;usuario_t **asignarNivelesParaNuevosUsuarios(uint32_t *ids, uint32_t cantidadDeIds, uint8_t (*deQueNivelEs)(uint32_t)) {
global asignarNivelesParaNuevosUsuarios 
asignarNivelesParaNuevosUsuarios:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    push r12
    push r13
    push r14
    push r15
    push rbx

    mov r12, rdi ; ids
    mov r13d, esi ; cantidadDeIds
    mov r14, rdx ; deQueNivelEs

    xor r15, r15 ; res

    cmp r13d, 0
    je .end

    mov edi, r13d
    imul rdi, POINTER_SIZE
    call malloc
    mov r15, rax

    mov qword [rbp - 8], 0 ; iterador
    .for:
    cmp dword [rbp-8], r13d
    jnl .end

    mov rdi, USUARIO_SIZE
    call malloc
    mov rbx, rax ; usuario actual

    mov edx, dword [rbp-8]
    imul edx, INT_32_SIZE ; Multiplico por el tamaño del tipo de dato
    add rdx, r12
    
    mov ecx, dword [rdx] ; ids[i]
    mov dword [rbx + USUARIO_ID_OFFSET], ecx ; user->id = id

    mov edi, ecx
    call r14
    mov byte [rbx + USUARIO_NIVEL_OFFSET], al

    mov edx, dword [rbp-8]
    imul edx, POINTER_SIZE
    add rdx, r15
    
    mov [rdx], rbx

    inc dword [rbp-8]
    jmp .for

    .end: 
    mov rax, r15
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    add rsp, 24
    pop rbp
    ret
