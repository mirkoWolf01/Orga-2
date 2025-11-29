; ------------------------
; Offsets para los structs
; Plataforma: x86_64 (LP64)
; ------------------------

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

global  encontrarTesoroEnMapa
encontrarTesoroEnMapa:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    push r12
    push r13
    push r14
    push r15
    push rbx

    mov r12, rdi ; mapa
    mov r13, rsi ; recorrido
    mov r14, rdx ; acciones_ejecutadas
    xor r15, r15 ; resultado

    mov qword [r14], 0

    ; compruebo habitacion  inicial es tesoro
    mov edi, dword [r12 + MAP_ID_ENTRADA_OFFSET]
    imul edi, HAB_SIZE

    mov rdx, qword [r12 + MAP_HABITACIONES_OFFSET]
    add rdi, rdx
    mov qword [rbp - 8], rdi ; habitacion actual

    lea rsi, [rdi + HAB_CONTENIDO_OFFSET]
    mov al, byte [rsi + CONT_ES_TESORO_OFFSET]

    cmp al, 1
    je .tesoro_encontrado


    ; comienza el for
    xor rbx, rbx ; i

    .for:
    mov rcx, qword [r13 + REC_CANT_ACCIONES_OFFSET]
    cmp rbx, rcx
    jnl .end

    mov rdi, qword [r13 + REC_ACCIONES_OFFSET]
    imul rcx, rbx, INT_32_SIZE
    add rdi, rcx

    xor r8, r8
    mov r8d, dword [rdi]
    imul r8, INT_32_SIZE

    mov rdi, [rbp - 8]
    lea rdi, qword [rdi + HAB_VECINOS_OFFSET]
    mov edi, dword [rdi + r8] ; id_proxima_habitacion

    cmp edi, 98
    jg .end

    inc qword [r14]

    mov rcx, r12
    mov rcx, [rcx + MAP_HABITACIONES_OFFSET]

    imul rsi, rdi, HAB_SIZE
    add rcx, rsi

    mov qword [rbp - 8], rcx ; habitacion actual

    lea rsi, [rcx + HAB_CONTENIDO_OFFSET]
    mov al, byte [rsi + CONT_ES_TESORO_OFFSET]

    cmp al, 1
    je .tesoro_encontrado

    ; fin del if
    inc rbx
    jmp .for

    .tesoro_encontrado:
    mov r15, 1
    jmp .end

    .end: 
    mov rax, r15 ; retorno
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    add rsp, 24
    pop rbp
    ret