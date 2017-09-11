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
  cons_header: db ' El porcentaje de rendimiento de su procesador es: '
  cons_tam_header: equ $-cons_header
  cons_porcentaje: db '%'
  cons_tam_porcentaje: equ $-cons_porcentaje
  cons_enero: db 'Ene'
  cons_tam_enero: equ $-cons_enero
  cons_febrero: db 'Feb'
  cons_tam_febrero: equ $-cons_febrero
  cons_marzo: db 'Mar'
  cons_tam_marzo: equ $-cons_marzo
  cons_abril: db 'Abr'
  cons_tam_abril: equ $-cons_abril
  cons_mayo: db 'May'
  cons_tam_mayo: equ $-cons_mayo
  cons_junio: db 'Jun'
  cons_tam_junio: equ $-cons_junio
  cons_julio: db 'Jul'
  cons_tam_julio: equ $-cons_julio
  cons_agosto: db 'Ago'
  cons_tam_agosto: equ $-cons_agosto
  cons_setiembre: db 'Set'
  cons_tam_setiembre: equ $-cons_setiembre
  cons_octubre: db 'Oct'
  cons_tam_octubre: equ $-cons_octubre
  cons_noviembre: db 'Nov'
  cons_tam_noviembre: equ $-cons_noviembre
  cons_diciembre: db 'Dic'
  cons_tam_diciembre: equ $-cons_diciembre
  cons_slash: db  "/"
  cons_tam_slash: equ $-cons_slash
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
  year: equ 0x01E1853E; numero de segundos que hay en un año
  day: equ 0x15180; numero de segundos que hay en un dia
  ys70: equ 0x1E ; Cantidad de años desde 1970,hasta el año 2000. Lease years since 1970

section .bss


		;Se van a trabajar numeros HEX de maximo 4 bytes (4 digitos)
                valor_hex: resb 1 ;En este ejemplo, se usa una sola
		valor_dec: resb 2 ;Un solo digito Hex puede necesitar maximo 2 digitos decimales
		;valor_ascii: resb 4
                resultado: resb 50 ; Espacio en memoria con 50 bytes
                fecha: resw 1 ;Reserva un word para la fecha.
                anho: resb 1 ;Variable que guardara el año
                dia: resb 1 ; Variable que guardara el dia

section .text
  global _start

_start:

                    ;Solicitud de la fecha

                     nop
                     mov rax,0x60
                     mov rdi,fecha
                     syscall

                   ;Calculo del año.
                    mov rax,[fecha]
                    mov r12d,year
                    div r12d
                    mov r12d,eax 
                    mov r13d,ys70
                    sub r12d,r13d
                    mov r8d,r12d
                    mov [anho],r8d
 
                    xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 10
                    mov r11,0xA 
                    
                    mov r10,r8 
	            cmp r10,r11 ;Comparamos R10 y R11b, si r10 es mayor que r11, entonces se debe imprimir 2 nibbles:
	            jge anho_mayor_que_10
                    ;Si es menor que 10, entonces simplemente lo convertimos a ASCII y se imprime
                    ;Primero se hace el lookup con XLAT
	            lea ebx,[tabla]
	            mov al,r10b
	            xlat
	            mov [valor_dec],ax
	            ;Y ahora se imprime
	            impr_texto valor_dec,1
	            jmp final_anho

	            anho_mayor_que_10:        
                    ;xor r11,r11
                    ;mov r11,0xE
                    ;cmp r10,r11
                    ;jge anho_mayor_que_20
	            ;Si es mayor que 10, entonces el primer paso es imprimir un 1
	            impr_texto cons_diez,1
	            ;Ahora, a r10 se le debe restar 10
	            sub r10,0xA
	            ;Y con el valor actualizado, hacemos el lookup
	            lea ebx,[tabla]
	            mov al,r10b
	            xlat
	            mov [valor_dec],ax
	            ;Y ahora se imprime el remanente
                    impr_texto valor_dec,1 
                    jmp final_anho

                    ;A continuacion se agregan las funciones que cambiaran el hexadecimal del año hasta  2038.
                    ;anho_mayor_que_20:

                    ;xor r11,r11 
                    ;mov r11,0x1E
                    ;cmp r10,r11
                    ;jge anho_mayor_que_30
                    ;Si es mayor que 20,pero menor a 30,  entonces el primer paso es imprimir un 2
                    ;impr_texto cons_veinte,1
                    ;Ahora, a r10 se le debe restar 20
                    ;sub r10,0x14
                    ;Y con el valor actualizado, hacemos el lookup
                    ;lea ebx,[tabla]
                    ;mov al,r10b
                    ;xlat
                    ;mov [valor_dec],ax
                   ;Y ahora se imprime el remanente
                    ;impr_texto valor_dec,1
                    ;jmp final_anho

                    ;anho_mayor_que_30: 

                    ;mov r11,0x28
                    ;Si es mayor que 30,pero menor a 40,  entonces el primer paso es imprimir un 3
                    ;impr_texto cons_treinta,1
                    ;Ahora, a r10 se le debe restar 30
        	    ;sub r10,0x1E
        	   ;Y con el valor actualizado, hacemos el lookup
        	    ;lea ebx,[tabla]
        	    ;mov al,r10b
                    ;xlat
                    ;mov [valor_dec],ax
                    ;Y ahora se imprime el remanente
                    ;impr_texto valor_dec,1
                    ;jmp final_anho            
                    final_anho:

                    ;Calculo del dia

                     nop
                     mov rax,0x60
                     mov rdi,fecha
                     syscall
 
                     mov rax,[fecha]
                     mov r11d,eax
_stopa:
                     mov r12d,r8d
_stopb:
                     mov r13d,ys70
_stopc:
                     add r12d,r13d
_stopd:
                     mov eax,year
_stope:
                     mul r12d
                     mov r12d,eax
_stopf:
                     sub r11d,r12d
_stopg:
                     mov eax,r11d
_stopi: 
                     mov r14d,day
_stopj:
                     div r14d
                     mov r15d,eax
_stopk:
                     
                     mov [dia],r15d        
_stopl:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
	             mov r11,0x1F
	             cmp r10,r11
                     jge febrero
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_enero,cons_tam_enero
                     jmp calculo_dia
                     febrero:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x3B
                     cmp r10,r11
                     jge marzo
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_febrero,cons_tam_febrero
                     sub r10,0x1F
                     jmp calculo_dia
                     marzo:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x3B
                     cmp r10,r11
                     jge abril
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_marzo,cons_tam_marzo
                     sub r10,0xF3
                     jmp calculo_dia

                     abril:
                     xor r10,r10 
                     mov r10,r15
                     _bp:
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x78
                     cmp r10,r11
                     jmp mayo
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_abril,cons_tam_abril
                     sub r10,0x5A
                     jmp calculo_dia

                     mayo:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x97
                     cmp r10,r11
                     jge junio
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_mayo,cons_tam_mayo
                     sub r10,0x78
                     jmp calculo_dia
                     junio:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0xB5
                     cmp r10,r11
                     jge julio
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_junio,cons_tam_junio
                     sub r10,0x97
                     jmp calculo_dia
                     julio:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0xD4
                     cmp r10,r11
                     jge agosto
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_julio,cons_tam_julio
                     sub r10,0xB5
                     jmp calculo_dia
                     agosto:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0xF3
                     cmp r10,r11
                     jge setiembre
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_agosto,cons_tam_agosto
                     sub r10,0xD4
                     jmp calculo_dia

                     setiembre:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x111
                     cmp r10,r11
                     jge octubre
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_setiembre,cons_tam_setiembre
                     sub r10,0xF3
                     jmp calculo_dia

                     octubre:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x130
                     cmp r10,r11
                     jge noviembre
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_octubre,cons_tam_octubre
                     jmp calculo_dia

                     noviembre:
                     xor r10,r10 
                     mov r10,r15
                     xor r11,r11 ;Ahora limpiamos R11 y lo cargamos con un 31
                     mov r11,0x14E
                     cmp r10,r11
                     jge diciembre
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_noviembre,cons_tam_noviembre
                     jmp calculo_dia

 
                     diciembre: 
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_diciembre,cons_tam_diciembre
                     jmp calculo_dia


                     calculo_dia:

                     xor r11,r11
                     mov r11,0xA
                     cmp r10,r11
                     jge dia_mayor_que_10
                     _stopz:
        
                     ;Si es menor que 10, entonces simplemente lo convertimos a ASCII y se imprime
		     lea ebx,[tabla]
		     mov al,r10b
		     xlat
		     mov [valor_dec],ax
		     ;Y ahora se imprime
                     impr_texto cons_slash,cons_tam_slash
		     impr_texto valor_dec,1
		     ;y salimos de la macro
		     jmp final_calculo_dia
	             dia_mayor_que_10:
                     xor r11,r11
                     mov r11,0x14
                     cmp r10,r11
                     jge dia_mayor_que_20
		     ;Si es mayor que 10, entonces el primer paso es imprimir un 1
                     impr_texto cons_slash,cons_tam_slash
		     impr_texto cons_diez,1
		     ;Ahora, a r10 se le debe restar 10
		     sub r10,0xA
		     ;Y con el valor actualizado, hacemos el lookup
		     lea ebx,[tabla]
		     mov al,r10b
		     xlat
		     mov [valor_dec],ax
		     ;Y ahora se imprime el remanente
		     impr_texto valor_dec,1
		     ;y salimos de la macro
                     jmp final_calculo_dia

       		     dia_mayor_que_20:
                     xor r11,r11
                     mov r11,0x1E
                     cmp r10,r11
                     jge dia_mayor_que_30
                     ;Si es mayor que 20,pero menor a 30,  entonces el primer paso es imprimir un 2
                     impr_texto cons_slash,cons_tam_slash
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
                     ;y salimos del macro
                     jmp final_calculo_dia

                     dia_mayor_que_30:
                     impr_texto cons_slash,cons_tam_slash
                     impr_texto cons_treinta,1
                     mov r8,0x1
                     mov [valor_dec],r8
                     ;Y ahora se imprime el remanente
                     impr_texto valor_dec,1
                     ;y salimos del macro  
                     jmp final_calculo_dia                                 

                     final_calculo_dia:


                 

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






