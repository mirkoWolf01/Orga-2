extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28

INT16_SIZE EQU 2
POINTER_SIZE EQU 8

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
es_indice_ordenado:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12
	push r13
	push r14
	push r15
	push rbx
	

	mov r12, rdi 			; inventario
	mov r13, rsi 			; indice
	mov r14w, dx 			; tamaño
	dec r14w
	mov r15, rcx 			; comparador
	mov byte [rbp - 8], 1	; res


	xor rbx, rbx
	.for:
		cmp bx, r14w
		jge .end 

		xor r8, r8
		xor r9, r9

		mov r8w, word [r13 + rbx * INT16_SIZE]
		mov r9w, word [r13 + rbx * INT16_SIZE + INT16_SIZE]

		mov rdi, [r12 + r8 * POINTER_SIZE]	; inventario[indice_elemento]
		mov rsi, [r12 + r9 * POINTER_SIZE] ; inventario[indice_siguiente]

		call r15

		cmp ax, 0
		je .caso_desordenado

		inc rbx
		jmp .for
	
	.caso_desordenado:
	mov byte [rbp - 8], 0

	.end:
	xor rax, rax
	mov al, byte [rbp - 8]
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 24
	pop rbp
	ret


global indice_a_inventario
indice_a_inventario:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi 			; inventario
	mov r13, rsi 			; indice
	mov r14w, dx 			; tamaño
	
	mov edi, r14d
	imul edi, POINTER_SIZE

	call malloc
	mov r15, rax

	xor rbx, rbx
	.for:
		cmp bx, r14w
		jge .end 

		xor r8, r8
		mov r8w, word [r13 + rbx * INT16_SIZE]

		mov rdi, [r12 + r8 * POINTER_SIZE]	; inventario[indice_elemento]
		mov [r15 + rbx * POINTER_SIZE], rdi ; resultado[i]

		inc rbx
		jmp .for

	.end:
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 8
	pop rbp
	ret
