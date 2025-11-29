# Resolucion de Mirko Wolf

Lo primero que tendria que hacer es agregar las nuevas entradas a de la idt definida en `idt.c`.  
En la idt tengo que definir tanto la entrada de la interrupcion del boton (la numero 41) y otras dos para las syscalls de `solicitar` y `recurso_listo`. Como para estas dos tengo libertad de eleccion, voy a usar las 50 y 51 respectivamente. 


``` c
void idt_init()
{
	// Excepciones
	... 

	// Interrupciones de reloj y teclado
	IDT_ENTRY0(32);
	IDT_ENTRY0(33);


	// Defino la interrupcion de el boton.
	IDT_ENTRY0(41);

	// Defino las interrupciones de solicitar y recurso_listo
	IDT_ENTRY3(50);
	IDT_ENTRY3(51);

	...
}
```
Ahora que tengo definidas las interrupciones, tengo que implementar sus rutinas de atencion de interrupciones en `isr.asm`.

```asm
global _isr41
_isr41:
		pushad

		; aviso al pic que atendi la interrupcion.
		call pic_finish1

		; como es una direccion de kernel, y la interrupcion tiene permisos de kernel no debe de tirar #PF (page fault)
		; asumo que recurso_t es como mucho de 32b
		mov eax, dword [0xFAFAFA]
		push eax
		call iniciar_produccion
		add esp, 4


    popad
    iret

; Por eax me pasan el recurso solicitado por eax
global _isr50
_isr50:
  pushad

	; le paso el recurso solicitado por la pila
	push eax
	call solicitar
	add esp, 4

	; si se encotro a alguien que le de el recurso, sigue ejecutando la tarea (hasta que lo determine el scheduler en la interrupcion de reloj).
	; en caso contrario, pasa a otra tarea hasta que alguien le de el recurso que necesita.
	cmp eax, 0
	jne .fin

	call sched_next_task

	str cx
	cmp ax, cx
	je .fin

	mov word [sched_task_selector], ax
	jmp far [sched_task_offset]

	.fin:
	popad
	iret

global _isr51
_isr51:
	pushad

	call recurso_listo

	popad
	iret
```

Ahora las defino ambas funciones en `sched.c`, a la vez que modifico la estructura de tas_state_t y sched_entry_t.

El campo produciendo_para debe de inicializarse en 0, que simboliza que no produce para nadie.

```c
typedef enum {
  TASK_SLOT_FREE,
  TASK_RUNNABLE,
  TASK_PAUSED,
	TASK_WAITING_FOR_RESOURCE,
	TASK_PRODUCING,
} task_state_t;

typedef struct {
  int16_t selector;
  task_state_t state;

	// nuevos atributos para definir que tipo de recurso produce una tarea.
	// debe ir un NULL en los recursos que cuenta para producir, en caso contrario el tipo de recurso que solicita.
	// asumo que al crear una tarea que produce, se definen los recursos que solicita para poder iniciar su produccion, y max_cantidad_recursos_solicitados es la cantidad de recuros que solicita.
	recursos_t* recursos_solicitados;
	int max_cantidad_recursos_solicitados;
	task_id_t produciendo_para; 
	
	recurso_t recurso;
} sched_entry_t;

// Asumo que se pasa el recurso luego de asignarle para quien debe producir
// Si la solicitud fue exitosa (logro encontrar a alguien) devuelve 1, sino 0. Esto es para ver si puede empezar a producir o no.
int8_t solicitar(recurso_t recurso){
	sched_entry_t* task = &sched_tasks[current_task];
	task_id_t producer_task_id = hay_tarea_disponible_para_recurso(recurso);
	if (producer_task_id == 0){
		task->state = TASK_WAITING_FOR_RESOURCE;
	}
	else{
		agregar_recurso_a_tarea(current_task, recurso);
		
		sched_entry_t* producer_task = &sched_tasks[producer_task_id];
		producer_task->produciendo_para = current_task;

		// Compruebo si puede iniciar la produccion, o si le falta algun recurso. En caso de faltar el recurso lo dejo como estaba, ya que estaba esperando recurso.
		if(puede_iniciar_produccion(current_task)){
			task->state = TASK_PRODUCING;
			return 1;
		}
	
		return 0;
	}
}

#define VADDR_INFO_DEJADA 0x0AAAA000
#define VADDR_ESCRITURA 0x0BBBB000

void recurso_listo(){
	sched_entry_t* task = &sched_tasks[current_task];
	recurso_t recurso = task->recurso_producido;

	task_id_t tarea_esperando_id = hay_consumidora_esperando(recurso);
	if(tarea_esperando_id == 0)
		return;

	sched_entry_t* tarea_esperando = &sched_tasks[tarea_esperando_id];

	uint32_t cr3_tarea_actual = rcr3();
	uint32_t cr3_tarea_esperando = (uint32_t) selector_to_cr3(tarea_esperando->selector);
	
	paddr_t copy_dir = mmu_next_free_user_page();

	// Asumo que estaba mapeada anteriormente, ya que al inicializarse la tarea para producir debe de tener mapeada su propio sector de copia a alguna direccion fisica.
	zero_page(VADDR_ESCRITURA); 

	// Como la direccion donde deja la informacion es el inicio de una pagina, los 4KB que tiene que copiar son exactamente la pagina que esta en esa direccion virtual.
	// Por suerte copy_page copia la pagina entera.
	copy_page(copy_dir, virt_to_phy(cr3_tarea_actual, VADDR_INFO_DEJADA));
	mmu_map_page(tarea_esperando, VADDR_ESCRITURA, copy_dir, MMU_U | MMU_P);

	// Ahora desalojo la tarea actual
	task->state = TASK_PAUSED;
	restaurar_tarea(current_task);

	// Comrpuebo si puede iniciar la produccion, o si le falta algun recurso. En caso de faltar el recurso lo dejo como estaba, ya que estaba esperando recurso.
	if(puede_iniciar_produccion(tarea_esperando_id))
		tarea_esperando->state = TASK_PRODUCING;
	agregar_recurso_a_tarea(tarea_esperando_id, recurso);
	return;
}

bool puede_iniciar_produccion(task_id_t id_tarea){
	sched_entry_t task = sched_tasks[id_tarea];

	for(int8_t i = 0; i < task.max_cantidad_recursos_solicitados; i++){
		if(task.recursos_solicitados[i] != NULL)
			return false;
	}
	return true;
}
// Se asume que si o si requeria ese recurso
void agregar_recurso_a_tarea(task_id_t id_tarea, recurso_t recurso){
	sched_entry_t* task = &sched_tasks[id_tarea];

	for(int8_t i = 0; i < task.max_cantidad_recursos_solicitados; i++){
		if((task->recursos_solicitados)[i] == recurso)
			(task->recursos_solicitados)[i] = NULL;
	}
	return;
}
```

Implemento estas funciones auxiliares
```c
pd_entry_t* selector_to_cr3(int16_t selector){
	gdt_entry_t* taskDescripor = &gdt[selector >> 3]; 

	tss_t * tss = (tss_t*)(taskDescriptor.base_31_24 | taskDescriptor.base_23_16 | taskDescriptor.base_15_0);

	return tss->cr3;
}

paddr_t virt_to_phy(uint32_t cr3, vaddr_t virt){

	uint32_t pd_index = VIRT_PAGE_DIR(virt);
	uint32_t pt_index = VIRT_PAGE_TABLE(virt);
	uint32_t offset = VIRT_PAGE_OFFSET(virt);

	pd_entry_t* pd = CR3_TO_PD(cr3);
	pt_entry_t* pt = pd[pd_index].pt << 12;

	return (paddr_t) (pt[pt_index].page << 12) + offset;
}
```
Como hice cambios en la estructura de sched.c, ahora debo actualizar el scheduler para que trabaje tambien con los nuevos estados.

```c
uint16_t sched_next_task(void) {
  int8_t i;
  for (i = (current_task + 1); (i % MAX_TASKS) != current_task; i++) {
    if (sched_tasks[i % MAX_TASKS].state == TASK_RUNNABLE | sched_tasks[i % MAX_TASKS].state == TASK_PRODUCING) {
      break;
    }
  }

  i = i % MAX_TASKS;

  if (sched_tasks[i].state == TASK_RUNNABLE | sched_tasks[i].state == TASK_PRODUCING ) {
    current_task = i;
    return sched_tasks[i].selector;
  }

  return GDT_IDX_TASK_IDLE << 3;
}
```

Debe de haber un array global, que para determinada tarea te diga que tipo de recursos se requieren para completar el recurso que produce esa tarea.  
Esto facilita las cosas ya que en el campo `recursos_solicitados`, debo restaurar el valor original.

```c 
void restaurar_tarea(task_id_t id_tarea){
	// <--- aca iria un array copy para copiar los recursos del global a esta tarea.	
	(&sched_tasks[id_tarea])->produciendo_para = 0;
	// luego, debo desmapear la tarea de la posicion que tenia mapeada a 0x0BBBB000.
	// Para ello utilizo la funcion mmu_unmap_page, y saco el cr3 de la tarea usando su selector. De esta forma lo puedo desmapear desde el pd de esa tarea.

	uint32_t cr3_tarea = selector_to_cr3(sched_tasks[id_tarea].selector);
	// solo hace falta desmapear la posicion donde lee datos de otra tarea, ya que la tarea actual puede seguir escribiendo en la misma direccion de memoria.
	// Por esta razon, solo voy a vaciar todos los datos que tenia en esa pagina.
	zero_page(0x0AAAA000);
	mmu_unmap_page(cr3_tarea,0x0BBBB000);

}
```

Lo unico que me falta a este punto para completar el ejercicio 3, es definir la funcion `iniciar_produccion`. 
Luego, la defino.

```c
void iniciar_produccion(recurso_t recurso){
	task_id_t consumer = hay_consumidora_esperando(recurso);
	task_id_t task_id = hay_tarea_disponible_para_recurso(recurso);

	if(consumer == 0 || task_id != 0)
		return;

	sched_entry_t* task = &sched_tasks[task_id];
	if(puede_iniciar_produccion(task_id))
		task->state = TASK_PRODUCING;
	else
		task->state = TASK_WAITING_FOR_RESOURCE	;
	
	task->produciendo_para = consumer;
	return;	
}
```


4. 
Lo que me parece que deberia agregar para saber que produce cada tarea es un campo en shed_entry_t que se llame recurso y que defina que clase de recurso produce la tarea.  	
Esto se lo debe definir cuando se define la tarea.

Para saber que tarea espera a recibir un recurso no debo de modificar nada, ya que tengo creado el estado TASK_WAITING_FOR_RESOURCE, que me permite hacer un for sobre todas las tareas y filtrar cuales esperan y, gracias a lo que comente anteriormente, me pueden decir que clase de recurso produce la misma. 



	```c 
	task_id_t hay_tarea_disponible_para_recurso(recurso_t recurso){
		for(int i = 0; i < MAX_TASKS; i++){
      sched_entry_t* task = &sched_tasks[i];

			if(task->recurso == recurso)
				return i;
		}
		return 0;
	}


	task_id_t para_quien_produce(task_id_t id_tarea){
		return sched_tasks[i].produciendo_para;
	}


	task_id_t hay_consumidora_esperando(recurso_t recurso){
		for(int i = 0; i < MAX_TASKS; i++){
      sched_entry_t* task = &sched_tasks[i];

			if(task->state == TASK_WAITING_FOR_RESOURCE)
				bool consume_recurso = false;
				for(int i=0; i < task->max_cantidad_recursos_solicitados; i++){	
					if((task->recursos_solicitados)[i] == recurso)
						consume_recurso = true;
				}
				if(consume_recurso)
					return i;
		}
		return 0;
	}

	```
