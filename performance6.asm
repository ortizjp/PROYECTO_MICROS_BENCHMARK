;-------------------------  MACRO #1  ----------------------------------
;Macro-2: impr_linea.
;	Imprime un mensaje que se pasa como parametro y un salto de linea
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_linea 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
  mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;primer parametro: Texto
	mov rdx,1	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

;-------------------------  MACRO #2  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------



       
section .data
  cons_header: db 'El porcentaje de rendimiento de su procesador es: '
  cons_tam_header: equ $-cons_header
  cons_porcentaje: db ' %'
  cons_tam_porcentaje: equ $-cons_porcentaje
	cons_nueva_linea: db 0xa
	cons_diez: db '1'
        cons_veinte: db '2'
        cons_treinta: db '3'
        cons_cuarenta: db '4' 
        cons_cincuenta: db '5'
        cons_sesenta: db '6'
        cons_setenta: db '7'
        cons_ochenta: db '8'
        cons_noventa: db '9'
        cons_cien: db '100'
        tabla: db "0123456789ABCDEF",0
        scale: equ 0x10000 ;este numero va a ser util para calcular el porcentaje, equivale a 65536 en decimal 
        cien: equ 0x64 ;este es el 100 que se utilizara para calcular e porcentaje


section .bss


		;Se van a trabajar numeros HEX de maximo 4 bytes (4 digitos)
                valor_hex: resb 1 ;En este ejemplo, se usa una sola
		valor_dec: resb 2 ;Un solo digito Hex puede necesitar maximo 2 digitos decimales
		;valor_ascii: resb 4
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

               mov rbx,cien
               mul rbx
_stop2: 



;Ahora se procedera a realizar la division
;Para ello se necesita que el dato de 64 bits se divida en dos
;Los 32bits de la  parte superior iran a EBX y los  inferiores a EAX

               mov ecx,scale
               div ecx
_stop3:

         mov r8d,eax
 
_stop4:
	impr_texto cons_header,cons_tam_header
_stop5:

        mov r10,r8
_bp01:
	xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 10
	mov r11,0xA
	cmp r10,r11 ;Comparamos R10 y R11b, si r10 es mayor que r11, entonces se debe imprimir 2 nibbles:
	jge mayor_que_10
        ;Si es menor que 10, entonces simplemente lo convertimos a ASCII y se imprime
        ;Primero se hace el lookup con XLAT
	lea ebx,[tabla]
	mov al,r10b
	xlat
	mov [valor_dec],ax
	;Y ahora se imprime
	impr_texto valor_dec,1
	jmp final

	mayor_que_10:        
        xor r11,r11
        mov r11,0xE
        cmp r10,r11
        jge mayor_que_20
	;Si es mayor que 10, entonces el primer paso es imprimir un 1
	impr_texto cons_diez,1
	;Ahora, a r10 se le debe restar 10
	sub r10,0xA
	;Y con el valor actualizado, hacemos el lookup
	lea ebx,[tabla]
	mov al,r10b
	xlat
	mov [valor_dec],ax
	bp02:
	;Y ahora se imprime el remanente
	impr_texto valor_dec,1
        jmp final

        mayor_que_20:

        xor r11,r11
        mov r11,0x1E
        cmp r10,r11
        jge mayor_que_30
        ;Si es mayor que 20,pero menor a 30,  entonces el primer paso es imprimir un 2
        impr_texto cons_veinte,1
        ;Ahora, a r10 se le debe restar 20
        sub r10,0x14
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_30:

        mov r11,0x28
        cmp r10,r11
        jge mayor_que_40
        ;Si es mayor que 30,pero menor a 40,  entonces el primer paso es imprimir un 3
        impr_texto cons_treinta,1
        ;Ahora, a r10 se le debe restar 30
        sub r10,0x1E
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_40:

        mov r11,0x32
        cmp r10,r11
        jge mayor_que_50
        ;Si es mayor que 40,pero menor a 50,  entonces el primer paso es imprimir un 4
        impr_texto cons_cuarenta,1
        ;Ahora, a r10 se le debe restar 50
        sub r10,0x28
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_50:
                
        mov r11,0x3C
        cmp r10,r11
        jge mayor_que_60
        ;Si es mayor que 60,pero menor a 70,  entonces el primer paso es imprimir un 5
        impr_texto cons_cincuenta,1
        ;Ahora, a r10 se le debe restar 50
        sub r10,0x32
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_60:
               
        mov r11,0x46
        cmp r10,r11
        jge mayor_que_70
        ;Si es mayor que 60,pero menor a 70,  entonces el primer paso es imprimir un 6
        impr_texto cons_sesenta,1
        ;Ahora, a r10 se le debe restar 60
        sub r10,0x3C
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_70:
              
        mov r11,0x50
        cmp r10,r11
        jge mayor_que_80
        ;Si es mayor que 70,pero menor a 80,  entonces el primer paso es imprimir un 7
        impr_texto cons_setenta,1
        ;Ahora, a r10 se le debe restar 70
        sub r10,0x46
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_80:

        mov r11,0x5A
        cmp r10,r11
        jge mayor_que_90
        ;Si es mayor que 80,pero menor a 90,  entonces el primer paso es imprimir un 8
        impr_texto cons_ochenta,1
        ;Ahora, a r10 se le debe restar 80
        sub r10,0x50
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        mayor_que_90:

        mov r11,0x64
        cmp r10,r11
        jge igual_100
        ;Si es mayor que 90,pero menor a 100,  entonces el primer paso es imprimir un 9
        impr_texto cons_noventa,1
        ;Ahora, a r10 se le debe restar 90
        sub r10,0x5A
        ;Y con el valor actualizado, hacemos el lookup
        lea ebx,[tabla]
        mov al,r10b
        xlat
        mov [valor_dec],ax
        ;Y ahora se imprime el remanente
        impr_texto valor_dec,1
        jmp final

        igual_100:

                impr_texto valor_dec,1 

	final:

_stop6:
        impr_texto cons_porcentaje,cons_tam_porcentaje

_finalizar_programa:
        ;Primero se imprime una linea en blanco para aclarar la consola
        mov rax,1       ;sys_write
        mov rdi,1       ;std_out
        mov rsi,cons_nueva_linea        ;0xa
        mov rdx,1       ;1 byte
        syscall
        ;Luego se retorna el control al sistema y se termina el programa
        mov rax,60
        mov rdi,0
        syscall




