section .data

scale: equ 0x10000 ;este numero va a ser util para calcular el porcentaje, equivale a 65536 en decimal 
cien: equ 0x64 ;este es el 100 que se utilizara para calcular e porcentaje

section .bss

resultado: resb 50 ; Espacio en memoria con 50 bytes


section .text

   global _start
        
_start: 

      nop  ;Parece que esta instruccion no hace nada.
      mov rdi, resultado ;Se pasa la direccion de resultado a rdi
      mov rax, 0x63 ;Se carga 99 decimal en rdi, que equivale a sysinfo
      syscall ;se llama al sistema



;De acuerdo a la estructura de datos que retorna sysinfo, el segundo
;espacio en memoria corresponde a CPU Load/min
;Se utilizara este parametro para el calculo del porcentaje de rendimiento.
      
     mov rax,[resultado+8] ;Movemos el contenido de la varible resultado en la posicion 8 a ebx.

;Ahora, es necesario realizar una multiplicacion por cien. 
_stop1:

     mov ebx,cien
     mul ebx
_stop2: 



;Ahora se procedera a realizar la division
;Para ello se necesita que el dato de 64 bits se divida en dos
;Los 32bits de la  parte superior iran a EBX y los  inferiores a EAX

    mov ecx,scale
    div ecx 

_stop3:

;Finalizacion del programa. Devolver condiciones para evitar un segmentation fault
        mov	eax,1	;(sys_exit)
	mov	ebx,0	;exit status 0
	int	0x80	;llamar al sistema
