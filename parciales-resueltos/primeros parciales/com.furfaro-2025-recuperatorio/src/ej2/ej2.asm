; ------------------------
; Offsets para los structs
; Plataforma: x86_64 (LP64)
; ------------------------
extern malloc

section .data

section .text

; COMPLETAR las definiciones (serán revisadas por ABI enforcer):
; ------------------------
; Contenido
; ------------------------
CONT_NOMBRE_OFFSET      EQU 0        ; char nombre[64]
CONT_VALOR_OFFSET       EQU 64       ; uint32_t valor
CONT_COLOR_OFFSET       EQU 68       ; char color[32]
CONT_ES_TESORO_OFFSET   EQU 100      ; bool es_tesoro
CONT_PESO_OFFSET        EQU 104      ; float peso
CONT_SIZE               EQU 108      ; sizeof(Contenido) (rounded)

; ------------------------
; Habitacion
; ------------------------
HAB_ID_OFFSET          EQU 0         ; uint32_t id
HAB_VECINOS_OFFSET     EQU 4        ; uint32_t vecinos[ACC_CANT] (4 entradas)
HAB_CONTENIDO_OFFSET   EQU 20        ; Contenido contenido (aligned to 4)
HAB_VISITAS_OFFSET     EQU 128       ; uint32_t visitas
HAB_SIZE               EQU 132       ; sizeof(Habitacion)

; ------------------------
; Mapa
; ------------------------
MAP_HABITACIONES_OFFSET    EQU 0     ; Habitacion *habitaciones  (pointer, 8 bytes)
MAP_N_HABITACIONES_OFFSET  EQU 8     ; uint64_t n_habitaciones       (8 bytes)
MAP_ID_ENTRADA_OFFSET      EQU 16    ; uint32_t id_entrada         (4 bytes)
MAP_SIZE                   EQU 24    ; sizeof(Mapa) (padded to 8)

; ------------------------
; Recorrido
; ------------------------
REC_ACCIONES_OFFSET        EQU 0     ; Accion *acciones  (pointer, 8 bytes)
REC_CANT_ACCIONES_OFFSET   EQU 8     ; uint64_t cant_acciones (8 bytes)
REC_SIZE                  EQU 16     ; sizeof(Recorrido)

; Notar que el enum aparece como puntero, entonces no afecta los offsets

INT_32_SIZE EQU 4

global  invertirRecorridoConDirecciones
invertirRecorridoConDirecciones:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; rec
    mov r13, rsi ; len
    
    xor r15, r15 ; inverso

    cmp r13, 0
    je .end

    mov rdi, REC_SIZE
    call malloc

    mov r15, rax
    mov qword [r15 + REC_CANT_ACCIONES_OFFSET], r13

    mov rdi, r13
    imul rdi, INT_32_SIZE
    call malloc 

    mov [r15 + REC_ACCIONES_OFFSET], rax

    xor r14, r14

    .for:
    cmp r14, r13
    jnl .end

    mov rdi, r13
    dec rdi
    sub rdi, r14
 
    mov rcx, [r12 + REC_ACCIONES_OFFSET]
    imul rdi, INT_32_SIZE
    add rcx, rdi

    mov edi, dword [rcx]
    call invertirAccion

    mov rdi, r14
    imul rdi, INT_32_SIZE
 
    mov rcx, [r15 + REC_ACCIONES_OFFSET]
    add rcx, rdi

    mov dword [rcx], eax

    inc r14
    jmp .for



    .end: 
    mov rax, r15
    pop r15
    pop r14
    pop r13
    pop r12
    add rsp, 16
    pop rbp
    ret


global  invertirAccion
invertirAccion:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12d, edi ; accion
    xor r15, r15 ; res

    cmp r12d, 0
    je .caso_Norte

    cmp r12, 1
    je .caso_Sur

    cmp r12, 2
    je .caso_Este

    cmp r12, 3
    je .caso_Oeste
    
    .caso_Norte
    mov r15d, 1
    jmp .end

    .caso_Sur
    mov r15d, 0
    jmp .end

    .caso_Este
    mov r15d, 3
    jmp .end

    .caso_Oeste
    mov r15d, 2
    jmp .end

    .end: 
    mov eax, r15d
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret