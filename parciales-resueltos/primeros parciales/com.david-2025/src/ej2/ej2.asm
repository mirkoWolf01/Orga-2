extern free
extern strcmp

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

;catalogo* removerCopias(catalogo* h)
global removerCopias
removerCopias:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; catalogo
    mov r13, qword [r12 + CATALOGO_FIRST_OFFSET] ; publicacion

    .while:
    cmp r13, 0
    je .end

    mov rdi, r13
    call removerAparicionesPosterioresDe

    mov r13, qword [r13 + PUBLICACION_NEXT_OFFSET]
    jmp .while

    .end: 
    mov rax, r12
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

global removerAparicionesPosterioresDe
removerAparicionesPosterioresDe:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; publicacion
    mov r13, rdi ; actual

    .while_exterior: 
    cmp r13, 0
    je .end

    mov rdi, qword [r13 + PUBLICACION_NEXT_OFFSET]
    cmp rdi, 0
    je .end

    .while_interior:
        mov rdi, r12 ; publicacion
        mov rsi, qword [r13 + PUBLICACION_NEXT_OFFSET] ; actual->next

        call mismaPublicacion
        cmp ax, 1
        jne .continue_exterior

        mov r14, qword [r13 + PUBLICACION_NEXT_OFFSET] ; liberar
        mov rdi, qword [r14 + PUBLICACION_NEXT_OFFSET]
        mov qword [r13 + PUBLICACION_NEXT_OFFSET], rdi

        mov rdi, qword [r14 + PUBLICACION_VALUE_OFFSET]
        call free

        mov rdi, r14
        call free

        jmp .while_interior


    .continue_exterior:
    mov r13, qword [r13 + PUBLICACION_NEXT_OFFSET]
    jmp .while_exterior

    
    .end: 
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret



global mismaPublicacion
mismaPublicacion:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    
    mov r12, rdi ; p1
    mov r13, rsi ; p2

    xor r14, r14

    cmp r12, 0
    je .end

    cmp r13, 0
    je .end

    mov rdi, qword [r12 + PUBLICACION_VALUE_OFFSET]
    mov rdi, qword [rdi + PRODUCTO_USUARIO_OFFSET]

    mov rsi, qword [r13 + PUBLICACION_VALUE_OFFSET]
    mov rsi, qword [rsi + PRODUCTO_USUARIO_OFFSET]

    cmp rdi, rsi
    jne .end

    mov rdi, qword [r12 + PUBLICACION_VALUE_OFFSET]
    lea rdi, qword [rdi + PRODUCTO_NOMBRE_OFFSET]

    mov rsi, qword [r13 + PUBLICACION_VALUE_OFFSET]
    lea rsi, qword [rsi + PRODUCTO_NOMBRE_OFFSET]

    call strcmp
    cmp eax, 0
    jne .end

    inc r14b

    .end: 
    mov rax, r14
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret