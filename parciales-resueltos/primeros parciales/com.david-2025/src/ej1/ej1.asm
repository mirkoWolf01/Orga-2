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

;producto_t* filtrarPublicacionesNuevasDeUsuariosVerificados (catalogo*)
global filtrarPublicacionesNuevasDeUsuariosVerificados
filtrarPublicacionesNuevasDeUsuariosVerificados:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; catalogo
    xor r14, r14 ; res

    call cantidadPublicacionesQueVerifican
    mov dword [rbp - 8], eax

    cmp eax, 0
    je .end

    mov edi, eax
    inc rdi
    imul rdi, POINTER_SIZE
    
    call malloc
    mov r14, rax

    mov edi, dword [rbp - 8] ; cantidad
    imul edi, POINTER_SIZE
    add rax, rdi
    mov qword [rax], qword 0

    mov r15, qword [r12 + CATALOGO_FIRST_OFFSET] ; publicacion
    xor r13, r13

    .while:
    cmp r15, 0
    je .end

    cmp r13d, dword [rbp - 8]
    jnl .end

    mov rdi, r15
    call esPublicacionNuevaDeUsuarioVerificado

    cmp ax, 0
    je .continue

    mov edi, r13d
    imul rdi, POINTER_SIZE
    add rdi, r14
    mov rsi, qword [r15 + PUBLICACION_VALUE_OFFSET]
    mov qword [rdi], rsi

    inc r13d

    .continue:
    mov r15, qword [r15 + PUBLICACION_NEXT_OFFSET]
    jmp .while

    .end: 
    mov rax, r14
    pop r15
    pop r14
    pop r13
    pop r12
    add rsp, 16
    pop rbp
    ret

global cantidadPublicacionesQueVerifican
cantidadPublicacionesQueVerifican:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; catalogo
    xor r15, r15 ; res

    mov r13, qword [r12 + CATALOGO_FIRST_OFFSET] ; publicacion

    .while:
    cmp r13, 0
    je .end

    mov rdi, r13
    call esPublicacionNuevaDeUsuarioVerificado

    cmp ax, 1
    jne .continue

    inc r15d

    .continue:
    mov r13, qword [r13 + PUBLICACION_NEXT_OFFSET]
    jmp .while

    .end: 
    mov eax, r15d
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

global esPublicacionNuevaDeUsuarioVerificado
esPublicacionNuevaDeUsuarioVerificado:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; publicacion
    xor rax, rax

    cmp r12, 0
    je .end

    mov rdi, qword [r12 + PUBLICACION_VALUE_OFFSET]

    cmp word [rdi + PRODUCTO_ESTADO_OFFSET], 1
    jne .end

    mov rdi, qword [rdi + PRODUCTO_USUARIO_OFFSET]
    
    cmp byte [rdi + USUARIO_NIVEL_OFFSET], 0
    jng .end

    inc rax

    .end: 
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret