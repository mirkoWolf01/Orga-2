; ------------------------
; Offsets para los structs
; Plataforma: x86_64 (LP64)
; ------------------------

section .data

section .text

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

INT_8_SIZE EQU 1
INT_32_SIZE EQU 4

ACC_CANT EQU 4
MAX_ROOMS EQU 99 


global sumarTesoros
sumarTesoros
   push rbp
   mov rbp, rsp
   sub rsp, 24
   push r12
   push r13
   push r14
   push r15
   push rbx

   mov r12, rdi ; mapa
   mov r13d, esi ; actual
   mov r14, rdx ; visitado

   xor r15, r15 ; res

   cmp r13d, dword MAX_ROOMS
   jge .end

   mov rdi, r14
   imul esi, r13d, INT_8_SIZE
   add rdi, rsi 

   cmp byte [rdi], 1
   je .end

   mov rdi, qword [r12 + MAP_HABITACIONES_OFFSET]
   imul rsi, r13,  HAB_SIZE
   lea rdi, qword [rdi + rsi]
   mov qword [rbp - 8], rdi ; habitacion_actual

   lea rcx, qword [rdi + HAB_CONTENIDO_OFFSET]

   cmp byte [rcx + CONT_ES_TESORO_OFFSET], 0
   je .continue

   add r15d, dword [rcx + CONT_VALOR_OFFSET]
   
   .continue:

   mov rdi, r14
   imul esi, r13d, INT_8_SIZE
   add rdi, rsi 

   mov byte [rdi], 1

   xor rbx, rbx

   .for:
   cmp rbx, qword ACC_CANT
   jnl .end

   mov rdi, qword [rbp - 8]
   lea rdi, qword [rdi + HAB_VECINOS_OFFSET]

   mov rsi, rbx
   imul rsi, INT_32_SIZE

   lea rdi, qword [rdi + rsi]

   mov esi, dword [rdi] ; vecino_id
   cmp esi, MAX_ROOMS
   jnl .continue_for

   mov rdi, r12 ; mapa
   mov rdx, r14 ; visitado

   call sumarTesoros
   add r15d, eax

   .continue_for:
   inc rbx
   jmp .for

   .end: 
   mov eax, r15d
   pop rbx
   pop r15
   pop r14
   pop r13
   pop r12
   add rsp, 24
   pop rbp
   ret
    
