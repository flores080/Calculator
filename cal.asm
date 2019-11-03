.model small
.stack 100h
print macro _str		;it make the sequence to print a string
	push ax
	push dx
	mov ah,9
	mov dx,offset _str	;display the string passed as messlab
	int 21h				;dos call
	pop dx
	pop ax
endm

writef macro _str
	mov ah, 40h
	mov bx, handle
	lea dx, offset _str
	int 21h
	xor cx,cx
endm

read macro _str
  lea si, _str      	;load string into si
  mov cx, si            ;cx == buffer start address
  _read:
  mov ah,01h
  int 21h               ;dos call
  cmp al,13             ;is it return?
  je done               ;yes, we are done reading in characters
  cmp al,37
  je _read
  mov [si],al           ;no, move character into buffer
  inc si                ;increase pointer
  jmp _read             ;loop back
  done:
  mov ax, '$'
  mov [si], ax          ;terminate string
  mov ax, si            ;ax == buffer end address
  sub ax, cx            ;return characters read in ax
endm

read_len macro _str, _len
  lea si, _str			;load string into si
  mov cx, si            ;cx == buffer start address
  _read:
  mov ah,01h
  int 21h               ;dos call
  cmp al,13             ;is it return?
  je done               ;yes, we are done reading in characters
  cmp al,37
  je _read
	sub al, 30h
  mov [si],al           ;no, move character into buffer
  inc si                ;increase pointer
  jmp _read             ;loop back
  done:
  mov ax, '$'
  mov [si], ax          ;terminate string
  mov ax, si            ;ax == buffer end address
  sub ax, cx            ;return characters read in ax
	dec ax
  mov _len, ax			;sets the string lenght
endm

print_op macro ope, len
	mov si, 0
	mov dx, 0
	.while si<len
		mov ax, 0
		mov dx, ope[si]
		.if	(dl == 42 || dl == 43 || dl == 45 || dl == 47)
			mov ah, 2
			int 21h
		.else
			mov al, dl
			call PrintNumber
		.endif
		inc si
	.endw
endm

write_op macro ope, len
	mov si, 0
	mov dx, 0
	.while si<len
		mov bx, handle
		xor ax, ax
		mov cx, 1
		lea dx, offset space
		mov ah, 40h
		int 21h
		xor dx, dx
		xor cx, cx
		mov dx, ope[si]
		mov char, dx
		.if	(dl == 42 || dl == 43 || dl == 45 || dl == 47)
			lea dx, offset char
			mov cx, 1
			mov ah, 40h
			int 21h
		.else
			mov al, dl
			call WriteNumber
		.endif
		inc si
	.endw
endm

;///////////////////////////////////////////// DATA SEGMENT /////////////////////////////////////////////
.386					;to use 32bits
.data

fecha  	db      "Date:	"
date	  db      "00/00/0000", 13, 10
hora   	db      "Time:	"
time    db      "00:00:00", 13, 10, 13, 10, 13, 10,'$'

prompt1 db 13,10,"Load the files path (*.arq): $"
prompt2 db 'No valid char $'
prompt3 db 'Missing completion character (;) $'
congra	db 'Successfully generated file! $'
sure 		db 'Do you wanna exit from application?',13,10,'1. Yes',13,10,'2. No',13,10,'$'
;//////////////////////// ESPECIAL CHARACTERS //////////////////////////
break 		db 10,13,'$'
space     db ' $'
admi		  db '!$'
equal 	  db ' = $'
aste      db '	* $'
dotcom    db ';$'
tdots     db ' : $'
min 			db '-$'
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////
header db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",13,10
       db "FACULTAD DE INGENIERIA",13,10
       db "ESCUELA DE CIENCIAS Y SISTEMAS",13,10
       db "ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 A",13,10
       db "SEGUNDO SEMESTRE 2017",13,10
       db "FERNANDO JOSUE FLORES VALDEZ",13,10
       db "201504385",13,10,13,10,'$'

report db "REPORTE PRACTICA NO. 2",13,10,13,10,'$'

inf 			 db 	'Input:			$'
infix  		 dw 200 dup(?)
anns 			 db 	'Answer: 		$'
ans 			 dw 0, "$"
pos 			 db 	'Postfix Notation:	$'
postfix 	 dw 200 dup(?)
pre				 db 	'Prefix Notation:	$'
prefix 		 dw 200 dup(?)
fact 			 db 	'Factorial: 		$'
fans			 dw 0, "$"


header_men db "          ___         ___         ___         ___     ",13,10
       db "         /\__\       /\  \       /\__\       /\__\    ",13,10
       db "        /::|  |     /::\  \     /::|  |     /:/  /    ",13,10
       db "       /:|:|  |    /:/\:\  \   /:|:|  |    /:/  /        1. LOAD FILE",13,10
       db "      /:/|:|__|__ /::\~\:\  \ /:/|:|  |__ /:/  /  ___	 2. CALCULATOR",13,10
       db "     /:/ |::::\__/:/\:\ \:\__/:/ |:| /\__/:/__/  /\__\	 3. FACTORIAL",13,10
       db "     \/__/~~/:/  \:\~\:\ \/__\/__|:|/:/  \:\  \ /:/  /   4. REPORT",13,10
       db "           /:/  / \:\ \:\__\     |:/:/  / \:\  /:/  /    5. EXIT",13,10
       db "          /:/  /   \:\ \/__/     |::/  /   \:\/:/  /  	",13,10
       db "         /:/  /     \:\__\       /:/  /     \::/  /   ",13,10
       db "         \/__/       \/__/       \/__/       \/__/    ",13,10,13,10,13,10,'$'

h_operaciones db "                                          _ ",13,10
							db "            ___   ___  ___  ____ ___ _ ____ (_)___   ___  ___  ___",13,10
							db "           / _ \ / _ \/ -_)/ __// _  // __// // _ \ / _ \/ -_)(_-< ",13,10
							db "           \___// .__/\__//_/   \_,_/ \__//_/ \___//_//_/\__//___/",13,10
							db "               /_/ ",13,10,"$"

oper_opt			db "                           1. Answer",13,10
							db "                           2. Prefix Notation",13,10
							db "                           3. Postfix Notation",13,10
							db "                           4. Exit",13,10,"$"

h_calculator 	db "           _____       __            __       __            ",13,10
							db "             / ___/___ _ / /____ __ __ / /___ _ / /_ ___   ____",13,10
							db "            / /__ / _  // // __// // // // _  // __// _ \ / __/",13,10
							db "            \___/ \_,_//_/ \__/ \_,_//_/ \_,_/ \__/ \___//_/   ",13,10,13,10,13,10,13,10,"$"

h_factorial 	db "             ____            __              _        __     ",13,10
							db "               / __/___ _ ____ / /_ ___   ____ (_)___ _ / /     ",13,10
							db "              / _/ / _  // __// __// _ \ / __// // _  // /      ",13,10
							db "             /_/   \_,_/ \__/ \__/ \___//_/  /_/ \_,_//_/       ",13,10,13,10,13,10,13,10,"$"

filename      db 80 dup(?)
flen 					dw 0
ffilename			db "\arq\p.txt",0

handle     dw   ?
hand 			 dw   ?
fbuff      db   ?     		  ;file data buffer
exmsg 		 db 	'Cannot open files with this extention (only *.arq), press *Enter* to continue...$'
oemsg      db   'Cannot open the file, press *Enter* to continue...$'
rfmsg      db   'Cannot read the file, press *Enter* to continue...$'
cfmsg      db   'Cannot close the file, press *Enter* to continue...$'
enternum   db 	'Ingrese un numero (00-08): $'
pedirnumero db 10, 13, 'Number: ', '$'
pediroperador db 'Arithmetic operator (+,-,*,/): $'
resultado db 'Answer: ', '$'
num1 dw 0, '$'
num2 dw 0, '$'
resul dw 0, '$'
signo1 db 2bh, '$'
signo2 db 2bh, '$'
operador db 0, '$'
unidad db 0, '$'
decena db 0, '$'
centena db 0, '$'
millar db 0, '$'

_prefix dw 200 dup(?)


bandera db 0

tmp db 3 dup(?)
counter dw 0
psize dw 0
char dw 0,"$"
writec dw 0

fac db 0

sign db 0

;//////////////////////////////////////////// CODE SEGMENT ////////////////////////////////////////////
.code
.startup
mov     ax, @data
mov     ds, ax

men:
	.while al != 53				;repeat if the key pressed is different from '4'
		call clear_screen
		call color
		print header			;print menu options
		print header_men
		mov ax, 0h				;clear the ax register
		call wait_for_key		;read a key and

		.if al == 49			;if the key pressed is '1'
			call clear_vars
			call filerequest	;request the files path
			.if	bandera == 1
				call oper_menu
			.endif
		.elseif al == 50		;if the key pressed is '2'
				call clear_screen
				call color
				print h_calculator
				jmp modocalculadora
		.elseif al == 51		;if the key pressed is '3'
				call clear_screen
				call color
				print h_factorial
				print enternum
				call rslfactorial
		.elseif al == 52		;if the key pressed is '4'
				call writeFile
				print congra
				call wait_for_key
		.endif
	.endw						;repeat all process

	call exit
ret
modocalculadora:
	mov num1, 0
	mov num2, 0
	mov signo1, 0
	mov signo2, 0
	print pedirnumero
	mov ah, 01h
	int 21h
	cmp al, 2dh 				; comparo si es un signo menos.
	je signomenos1
	.if al == 65
		mov bx, resul
		mov num1, bx
		xor bx, bx
		mov bx, signoresul
		mov signo1, bl
		.while al != 0dh
			call wait_for_key
			mov dx, ax
			mov ah, 2
			int 21h
		.endw
		print break
		jmp leeroperador
	.else
		jmp leerprimero
	.endif
signomenos1:
	mov signo1, 2dh
	mov ah, 01h
	int 21h
	jmp leerprimero

leerprimero:
	sub al, 30h 		; le resto para obtener el numero en decimal.
	mov bx, num1
	add bx, ax 			; le sumo el numero ingresado a lo que tiene mi variable num1.
	mov num1, bx
	mov ah, 01h			; leo caracter.
	int 21h
	cmp al, 0dh 		; espero un enter para ingresar operador.
	je negarnum1
	mov tmp, al
	mov ax, num1
	mov bl, 10d
	mul bl 				; ax = al * bl
	mov num1, ax		; guardo en mi variable el nuevo valor.
	mov al, tmp
	jmp leerprimero

negarnum1:
	cmp signo1, 2dh
	jne leeroperador
	mov cx, num1
	neg cx
	mov num1, cx
	jmp leeroperador

leeroperador:
	print pediroperador
	mov ah, 01h
	int 21h
	mov operador, al
	jmp pedirsegundo

pedirsegundo:
	print pedirnumero
	mov ah, 01h
	int 21h
	cmp al, 2dh 		; comparo si es un signo menos
	je signomenos2
	.if al == 65
		mov bx, resul
		mov num2, bx
		xor bx, bx
		mov bx, signoresul
		mov signo2, bl
		.while al != 0dh
			call wait_for_key
			mov dx, ax
			mov ah, 2
			int 21h
		.endw
		print break
		jmp operaciones
	.else
		jmp leersegundo
	.endif

signomenos2:
	mov signo2, 2dh
	mov ah, 01h
	int 21h
	jmp leersegundo

leersegundo:
	sub al, 30h 		; le resto para obtener el numero en decimal.
	mov bx, num2
	add bx, ax 			; le sumo el numero ingresado a lo que tiene mi variable num1.
	mov num2, bx
	mov ah, 01h			; leo caracter.
	int 21h
	cmp al, 0dh	 		; espero un enter para ingresar operador.
	je negarnum2
	mov tmp, al
	mov ax, num2
	mov bl, 10d
	mul bl 				; ax = al * bl
	mov num2, ax 		; guardo en mi variable el nuevo valor.
	mov al, tmp
	jmp leersegundo

negarnum2:
	cmp signo2, 2dh
	jne operaciones
	mov cx, num2
	neg cx
	mov num2, cx
	jmp operaciones

operaciones:
	mov al, operador
	cmp al, 2bh 		; ascii para suma.
	je suma
	cmp al, 2dh 		; ascii para resta.
	je resta
	cmp al, 2ah			; ascii para multiplicacion.
	je multiplicacion
	cmp al, 2fh 		; ascii para division.
	je division

multiplicacion:
	mov bx, num2
	mov ax, num1
	imul bx
	mov resul, ax
	cmp ax, 0
	jg signoresul
	mov signo1, 2dh 	; negativo
	neg resul
	call printresul
	neg resul
	mov cx, resul
	mov num1, cx
	jmp ask

division:
	xor edx, edx
	mov ax, num1
	mov bx, num2
	idiv bx
	mov resul, ax
	cmp ax, 0
	jg signoresul
	mov signo1, 2dh 
	neg resul
	call printresul
	neg resul
	mov cx, resul
	mov num1, cx
	jmp ask

suma:
	mov bx, num2
	mov ax, num1
	add bx, ax
	mov resul, bx
	cmp bx, 0
	jg signoresul
	mov signo1, 2dh 
	neg resul
	call printresul
	neg resul
	mov cx, resul
	mov num1, cx
	jmp ask

resta:
	mov bx, num1
	mov ax, num2
	sbb bx, ax
	mov resul, bx
	cmp bx, 0
	jg signoresul
	mov signo1, 2dh 
	neg resul
	call printresul
	neg resul
	mov cx, resul
	mov num1, cx
	jmp ask

signoresul:
	mov signo1, 2bh 
	call printresul
	mov cx, resul
	mov num1, cx
	jmp ask

printresul:
	mov ax, resul
	aam
	mov unidad, al
	movzx ax, ah
	aam
	mov decena, al
	movzx ax, ah
	aam
	mov centena, al
	print resultado
	print signo1
	mov ah, 02h
	mov dl, centena
	add dl, 30h
	int 21h
	mov ah, 02h
	mov dl, decena
	add dl, 30h
	int 21h
	mov ah, 02h
	mov dl, unidad
	add dl, 30h
	int 21h
	print break
	xor cx, cx
	xor ax, ax
	xor bx, bx
	mov num2, 0d
	mov signo2, 2bh
ret

ask:
	.while al !=  50 && al != 49
		xor eax, eax
		print sure
		call wait_for_key
		.if al == 50
			mov al, 0
			jmp men
		.elseif al == 49
			call exit
		.endif
	.endw
	ret
;///////////////////////////////////////////////////////////////		SHOW DATA 	///////////////////////////////////////////////////////////////
oper_menu proc near
	.while al != 52					;repeat if the key prssed is different from 4
		call clear_screen
		call color
		print h_operaciones			;show header and
		print oper_opt				;show options
		xor ax, ax
		mov sign, 0
		call wait_for_key
			.if al == 49			;if the key pressed is 1
				call clear_screen
				call color
				print h_operaciones
				call showinfix		;show infix expression and
				call showresult		;the result
			.elseif al == 50		;else if the key pressed is 2
				call clear_screen
				call color
				print h_operaciones
				call showprefix		;show prefix expression
			.elseif al == 51		;else if the key pressed is 3
				call clear_screen
				call color
				print h_operaciones
				call showposfix		;show postfix expression
			.endif
	.endw
	xor ax,ax
	ret
oper_menu endp

showresult proc near
	call topostfix
	print break
	print anns
	call resolver
	print break
	call wait_for_key
	ret
showresult endp

showinfix proc near
	print break
	print inf
	print_op infix, counter
	print break
	call wait_for_key
	ret
showinfix endp

showposfix proc near
	call topostfix
	print break
	print pos
	print_op postfix, counter
	print break
	call wait_for_key
	ret
showposfix endp

showprefix proc near
	call toprefix
	print break
	print pre
	print_op prefix, counter
	print break
	call wait_for_key
	ret
showprefix endp

;/////////////////////////////////////////////////////////////// 	LOGIG		///////////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////////////////// FROM INFIX TO POSTFIX
topostfix proc near
	mov psize, 0		;clears registers
	mov di, 0
	mov si, 0
	mov dx, 0
	.while si<counter			;repeat while counter (array size) isnt zero
		mov dx, infix[si]		;moves infix byte to dx
		mov bp, sp				;moves stack pointer to base pointer
		mov bx, [bp]			;moves to bx, the stack pointer
		;+ ->43
		;- ->45
		;* ->42
		;/ ->47
		.if (dl == '+' || dl == '-')		;if infix position is + or -
			.if (bl == '+' || bl == '-')	;and stack pointer is + or -
				pop bx						;pop the first elemento on stack
				dec psize					;decrement the stack size
				mov postfix[di], bx			;add the stack element to postifix array
				push dx						;push the infix position to stack
				inc psize					;increment stack size
				inc di						;increment postifix size
			.elseif (bl == '*' || bl == '/');if infix position is * or /
				.while psize>0				;clear the stack
					pop bx					;pop the first elemento on stack
					dec psize				;decrement the stack size
					mov postfix[di], bx		;add the stack element to postifix array
					inc di					;increment postifix size
				.endw
				push dx						;pushe the infix position to stack
				inc psize					;increment stack size
			.else
				push dx						;pushe the infix position to stack
				inc psize					;increment stack size
			.endif
		.elseif(dl == '*' || dl == '/')		;if infix position is * or /
			.if (bl == '*' || bl == '/')	;and stack pointer is + or -
				pop bx						;pop the first elemento on stack
				dec psize					;decrement the stack size
				mov postfix[di], bx			;add the stack element to postifix array
				push dx						;pushe the infix position to stack
				inc psize					;increment stack size
				inc di						;increment postifix size
			.elseif (bl == '+' || bl == '-');if infix position is + or -
				push dx						;pushe the infix position to stack
				inc psize					;increment stack size
			.else
				push dx						;pushe the infix position to stack
				inc psize					;increment stack size
			.endif
		.else
			mov postfix[di], dx				;add the stack element to postifix array
			inc di							;increment postifix size
		.endif
		inc si
	.endw

	.while psize>0							;filnally clear the stack
		pop bx
		dec psize
		mov postfix[di], bx
		inc di
	.endw
	ret
topostfix endp

;/////////////////////////////////////////////////////////////////////////// FROM INFIX TO PREFIX
toprefix proc near
	mov psize, 0			;clears registers
	mov di, 0
	mov si, counter
	mov dx, 0

	.while si>0				;repeat while counter (array size) isnt zero
		dec si
		mov dx, infix[si]	;moves infix byte to dx
		mov bp, sp			;moves stack pointer to base pointer
		mov bx, [bp]		;moves to bx, the stack pointer
		;+ ->43
		;- ->45
		;* ->42
		;/ ->47
		.if (dl == '+' || dl == '-')	;if infix position is + or -
				push dx					;pushe the infix position to stack
				inc psize				;increment stack size
		.elseif(dl == '*' || dl == '/')	;if infix position is * or /
				dec si
				mov bx, infix[si]		;moves infix byte to dx
				mov _prefix[di], bx		;add the stack element to postifix array
				inc di
				mov _prefix[di], dx		;add the stack element to postifix array
				inc di					;increment postifix size
		.else
			mov _prefix[di], dx			;add the stack element to postifix array
			inc di						;increment postifix size
		.endif
	.endw

	.while psize>0			;filnally clear the stack
		pop bx
		dec psize
		mov _prefix[di], bx
		inc di
	.endw

	mov si, counter
	mov di, 0
	.while si>0				;repeat while counter (array size) isnt zero
		dec si
		mov dx, _prefix[si]	;moves infix byte to dx
		mov prefix[di], dx
		inc di
	.endw

	ret
toprefix endp

;/////////////////////////////////////////////////////////////////////////// CLEAR VARS (INFIX POSTFIX AND PRFIX ARRAYS)
clear_vars proc near
	mov di, 0
	.while di<200
		mov infix[di], '$'	;moves a '$' in all registers of the array
		mov postfix[di], '$'
		mov prefix[di], '$'
		inc di
	.endw
	ret
	clear_vars endp

	exit proc near
	.exit
	ret
exit endp

;/////////////////////////////////////////////////////////////////////////// FROM ASCII TO DECIMAL
conv proc near			;the lowest digit of the number is on ax, and the highest digit was move from bx, to si
	.while si != 0		;repeat while the tens are not zero
		add ax, 10		;add to ax, 10
		dec si			;decrement si
	.endw
	ret
conv endp
;/////////////////////////////////////////////////////////////////////////// READ KEY
wait_for_key proc
  mov  ah, 7	;command to read key
  int  21h		;call DOS
  ret
wait_for_key endp

;/////////////////////////////////////////////////////////////////////////// REQUEST, OPEN, READ AND CLOSE FILE
filerequest proc
	print prompt1			;display prompt1

	lea     si, filename	;load string into si
	call    readstring		;get info from keyboard
	mov si, flen
	dec si
	xor dl, dl
	mov dl, filename[si]
	.if dl != 'q'
		mov bandera, 0
		print exmsg
		call wait_for_key
		jmp finish
	.endif
	dec si
	xor dl, dl
	mov dl, filename[si]
	.if dl != 'r'
		mov bandera, 0
		print exmsg
		call wait_for_key
		jmp finish
	.endif
	dec si
	xor dl, dl
	mov dl, filename[si]
	.if dl != 'a'
		mov bandera, 0
		print exmsg
		call wait_for_key
		jmp finish
	.endif

	call openfile         	;open file (path)
	jc   finish            	;jump if error
	mov counter, 0
	mov di, 0
	mov bandera,0
	call readfile         	;read file (path)
	call closefile        	;close file (path)
	.if	bandera == 1		;verifies if was readed the ';' on the file
		jmp finish
	.else
		print prompt3		;if not was readed, display the message and
		jmp filerequest		;lopp it again
	.endif
finish: ret
filerequest endp

;/////////////////////////////////////////////////////////////////////////// READ STRING AND PUT INTO A BUFER
readstring proc near
    mov     cx, si          ;cx == buffer start address
		mov flen, 0
	_read:
		mov ah,01h
		int 21h				;dos call
		cmp al,13			;is it return?
		je done				;yes, we are done reading in characters
		cmp al,64			;if it´s different of '@'
		je _read
		mov [si],al			;no, move character into buffer
		inc flen
		inc si				;increase pointer
		jmp _read			;loop back
	done:
		mov ax, '$'
	    mov [si], ax		;terminate string
	    mov ax, si			;ax == buffer end address
	    sub ax, cx			;return characters read in ax
		ret
readstring endp

;/////////////////////////////////////////////////////////////////////////// FACTORIAL
rslfactorial proc near
	call wait_for_key				;print first number
	mov dx, ax
	mov ah, 2
	int 21h
	call wait_for_key				;print second number
	mov dx, ax
	mov ah, 2
	int 21h
	call wait_for_key				;read enter key
	print break
	print break
	xor dh,dh
	sub dl, 48
	mov char, dx
	.if (dl>=0 && dl<=8)			;if the number is between 0 and 8
		mov fac, dl
		.if(dl == 0 || dl == 1)
			mov ax, 1
			mov fans, ax
			print break
		.else
			xor si, si				;clear si
			mov si, dx				;mov counter to si
			mov fans, dx			;mov to ans the value
			dec si					;substract 1 to the counter
			.while (si>0)
				xor ax, ax			;clear ax
				mov ax, fans
				call PrintNumber	;print ans
				print aste			;print *
				xor ax, ax
				mov ax, si
				call PrintNumber	;print counter
				print equal			;print =
				xor ax, ax			;clear ax
				mov ax, fans		;mov answer to ax
				mul si				;mult ax by the counter
				mov fans, ax		;restore the new anwser
				call PrintNumber	;print the number
				print dotcom		;at this point the console shows (	ans * counter = newans ; )
				print break			;print breaks
				dec si
			.endw
			.endif
	.endif
	print break
	xor ax, ax
	mov ax, char
	call PrintNumber			;print number entered
	print admi					;print !
	print equal					;print =
	xor ax, ax
	mov ax, fans
	call PrintNumber			;print final answer
	call wait_for_key
	ret
rslfactorial endp

wrtfactorial proc near
	mov dl, fac
	.if(dl == 0 || dl == 1)
		mov ax, 1
		mov fans, ax
		mov cx, 2
		writef break
	.else
		xor si, si				;clear si
		mov si, dx				;mov counter to si
		mov fans, dx			;mov to ans the value
		dec si					;substract 1 to the counter
		.while (si>0)
			mov bx, handle
			xor ax, ax			;clear ax
			mov cx, 2
			mov ax, fans
			call WriteNumber	;print ans
			mov cx, 2
			writef aste			;print *
			mov bx, handle
			mov cx, 2
			xor ax, ax
			mov ax, si
			call WriteNumber	;print counter
			mov cx, 2
			writef equal		;print =
			mov bx, handle
			mov cx, 2
			xor ax, ax
			mov ax, fans		;mov answer to ax
			mul si				;mult ax by the counter
			mov fans, ax		;restore the new anwser
			call WriteNumber	;print the number
			mov cx, 1
			writef dotcom		;at this point the console shows (	ans * counter = newans ; )
			mov cx, 2
			writef break		;print breaks
			mov cx, 2
			writef break		;print breaks
			dec si
		.endw
		.endif
	ret
wrtfactorial endp
;/////////////////////////////////////////////////////////////////////////// REGULAR OPERATION
resolver proc near
	mov ans, 0
	mov psize, 0
	mov cx, 0
	mov ax, 0
	mov dx, 0
	mov si, 0
	.while si<counter
		xor ebx, ebx
		xor edx, edx
		mov dx, postfix[si]			;read the postfix expression
		xor ecx, ecx
		xor eax, eax
		.if(dl == '+' || dl == '-' || dl == '*' || dl == '/') ;if the byte readed is an operator
				pop cx 				;pop OP 2
				dec psize
				pop ax				;pop OP 1
				dec psize
			.if (dl == '+')			;if is +
				.if sign == 1
					mov bx, ax
					sub ax, cx
					.if bx < cx
						call signed
						mov sign, 0
					.endif
					push ax			;push the answer
				.else
					add ax, cx
					push ax			;push the answer
				.endif
				inc psize
			.elseif(dl == '-')
				.if sign == 0
					sub ax, cx
					mov bx, ax				;move current value at ax, to bx
					and bx, 1000000000000000b;let only the highest bit on bx
					.if bx == 8000h			;if the highest bit on bx is 1
						call signed			;we have a negative number, the sign flag is on 1
					.else
						mov sign, 0			;else we have a positive number, the sign flag is on 0
					.endif
				.else
					add ax, cx
				.endif
				push ax			;push the answer
				inc psize
			.elseif(dl == '*')
				mul cx
				push ax			;push the answer
				inc psize
			.elseif(dl == '/')
				xor edx, edx
				div cx
				push ax			;push the answer
				inc psize
			.endif
		.else
			xor dh, dh
			push dx
			inc psize
		.endif
		inc si
	.endw

	.while psize>0				;filnally clear the stack
		xor ecx, ecx
		xor eax, eax
		mov ans, ax
		.if sign == 1
			xor dx, dx
			mov dl, '-'
			mov ah, 2
			int 21h
		.endif
		pop cx
		mov ax, cx
		mov ans, cx
		call PrintNumber		;print the anser
		dec psize
	.endw
	ret
resolver endp

signed proc near
	neg ax
	mov sign, 1
	ret
signed endp

;/////////////////////////////////////////////////////////////////////////// OPEN FILE
openfile proc near
         mov  ah,3dh         	;open file with handle function
         lea  dx,filename    	;set up pointer to asciiz string
		 mov  al,0           		 	;read access
         int  21h            	;dos call
         jc   openerr        	;jump if error
         mov  handle,ax      	;save file handle
         ret
openerr: print oemsg      	 	;set up pointer to error message
				 mov bandera, 0
				 call wait_for_key
         stc                 	;set error flag
         ret
openfile endp

;/////////////////////////////////////////////////////////////////////////// READ FILE (BYTE BY BYTE)
readfile proc near
        mov  ah,3fh         	;read from file function
        mov  bx,handle      	;load file handle
        lea  dx,fbuff       	;set up pointer to data buffer
        mov  cx,1           	;read one byte
        int  21h            	;dos call
        jc   readerr        	;jump if error
        cmp  ax,0           	;were 0 bytes read?
        jz   eoff           	;yes, end of file found
        mov  dl,fbuff       	;no, load file character
        cmp  dl,1ah         	;is it <eof>?
        jz   eoff           	;jump if yes
				.if (dl > 47 && dl < 58);if the byte readed is a digit
					sub dl, 48			;substracts 48 to the ascii code (gets the real number value) and
					mov tmp[di], dl		;moves the real value to (0 or 1 arrays position)
					inc di				;incremets the counter
				.elseif (dl == 32)		;else if the byte readed is an space
					jmp readfile		;just repeat the cicle
				.elseif (dl == 59)		;els eif the byte readed is ';'
					mov ax, 0			;clears ax register
					mov bx, 0			;clears bx register
					mov al, tmp[1]		;moves lowest digit to al
					mov bl, tmp[0]		;moves highest digit to bl
					mov si, 0			;clears si register
					mov si, bx			;moves bx, to si

					call conv			;converts the two digits number to a byte

					mov si, 0
					mov si, counter		;moves the counter to si and
					mov infix[si], ax	;moves the number to the infix array in the 'counter' position
					inc counter			;incremets the counter
					mov bandera, 1
				.elseif (dl == 42 || dl == 43 || dl == 45 || dl == 47) ;if the byte readed is a sign (+,-,*,/)
					mov char, dx		;moves the sign to char var

					mov ax, 0			;clears ax register
					mov bx, 0			;clears bx register
					mov al, tmp[1]		;moves lowest digit to al
					mov bl, tmp[0]		;moves highest digit to bl
					mov si, 0			;clear si register
					mov si, bx			;moves bx, to si

					call conv			;convert the two digits number to a byte

					mov si, 0
					mov si, counter		;moves the counter to si and
					mov infix[si], ax	;moves the number to the infix array in the 'counter' position
					inc counter			;incremets the counter
					mov di, 0			;resets the di counter

					mov si, 0
					mov si, counter		;moves the counter to si and
					mov dx, char		;moves the char value to dx
					mov infix[si], dx	;moves the dx to the infix array in the 'counter' position
					inc counter			;incremets the counter
				.else
					jmp norecog
				.endif
				jmp readfile
readerr: print rfmsg       				;set up pointer to error message
				 mov bandera, 0
				 call wait_for_key
         stc                			;set error flag
		 ret
norecog: print prompt2
				 mov bandera, 0
		 		 mov  ah,2				;display character function
         int  21h            			;dos call
		 jmp filerequest
eoff:    ret
readfile endp

;/////////////////////////////////////////////////////////////////////////// CLOSE FILE
closefile proc near
          mov  ah,3eh        			;close file with handle function
          mov  bx,handle     			;load file handle
          int  21h           			;dos call
          jc   closerr       			;jump if error
          ret
closerr:  print cfmsg      				;set up pointer to error message
					mov bandera, 0
					call wait_for_key
          ret
closefile endp

;/////////////////////////////////////////////////////////////////////////// WRITE FILE
writeFile proc near
;CREATE FILE.
	xor ax, ax
	xor cx, cx
	xor dx, dx

  mov  ah, 3ch
	mov  al, 2
  mov  cx, 0
  mov  dx, offset ffilename
  int  21h

;PRESERVE FILE HANDLER RETURNED.
	mov hand, 0
  mov  hand, ax

;WRITE STRING.
  mov  cx, 212  ;STRING LENGTH.
  writef header
	mov cx, 26
 	writef report
	call datetime
	mov cx, 7
	writef fecha
	mov cx, 12
	writef date
	mov cx, 6
	writef hora
	mov cx, 9
	writef time
	mov cx, 2
	writef break
	mov cx, 2
	writef break

	mov cx, 9
	writef inf
	write_op infix, counter
	mov cx, 1
	writef dotcom

	mov cx, 2
	writef break
	mov cx, 2
	writef break

	mov cx, 10
	writef anns

	.if sign == 1
		mov cx, 1
		xor dx, dx
		xor ax, ax
		lea dx, offset min
		mov ah, 40h
		int 21h
	.endif

	mov cx, 2
	xor dx, dx
	xor ax, ax
	mov ax, ans
	call WriteNumber
	mov cx, 1
	writef dotcom

	mov cx, 2
	writef break
	mov cx, 2
	writef break

	mov cx, 17
	writef pre
	write_op prefix, counter
	mov cx, 1
	writef dotcom

	mov cx, 2
	writef break
	mov cx, 2
	writef break

	mov cx, 18
	writef pos
	write_op postfix, counter
	mov cx, 1
	writef dotcom

	mov cx, 2
	writef break
	mov cx, 2
	writef break

	mov cx, 13
	writef	fact

	mov cx, 1
	xor dx, dx
	xor ax, ax
	mov al, fac
	call WriteNumber
	mov cx, 1
	writef dotcom

	mov cx, 2
	writef break
	mov cx, 2
	writef break

	call wrtfactorial

	mov cx, 10
	writef anns

	mov cx, 1
	xor dx, dx
	xor ax, ax
	mov ax, fans
	call WriteNumber
	mov cx, 1
	writef dotcom

	xor cx, cx
	xor dx, dx
	mov  ah,3eh        			;close file with handle function
	mov  bx,hand     			;load file handle
	int  21h           			;dos call
	jc   closerr       			;jump if error
	ret
closerr:  print cfmsg      				;set up pointer to error message
	ret
writeFile endp

datetime proc near
    mov     ah, 04h             ; get date from bios.
    int     1ah

    mov     bx, offset date     ; do day.
    mov     al, dl
    call    put_bcd2

    inc     bx                  ; do month.
    mov     al, dh
    call    put_bcd2

    inc     bx                  ; do year.
    mov     al, ch
    call    put_bcd2
    mov     al, cl
    call    put_bcd2

    mov     ah, 02h             ; get time from bios.
    int     1ah

    mov     bx, offset time     ; do hour.
    mov     al, ch
    call    put_bcd2

    inc     bx                  ; do minute.
    mov     al, cl
    call    put_bcd2

    inc     bx                  ; do second.
    mov     al, dh
    call    put_bcd2

    ret

; Places two-digit BCD value (in al) as two characters to [bx].
;   bx is advanced by two, ax is destroyed.
put_bcd2:
    push    ax                  ; temporary save for low nybble.
    shr     ax, 4               ; get high nybble as digit.
    and     ax, 0fh
    add     ax, '0'
    mov     [bx], al            ; store that to string.
    inc     bx
    pop     ax                  ; recover low nybble.

    and     ax, 0fh             ; make it digit and store.
    add     ax, '0'
    mov     [bx], al

    inc     bx                  ; leave bx pointing at next char.

    ret
datetime endp


;/////////////////////////////////////////////////////////////////////////// CLEAR THE CONSOLE
clear_screen proc           			;clear the console
  mov  ah, 0
  mov  al, 3
  int  10h
  ret
clear_screen endp

;/////////////////////////////////////////////////////////////////////////// SET CONSOLE COLORS
color proc
	mov ax, 0600h
	mov bh, 074h
	mov cx, 0000h
	mov dx, 184Fh
	int 10h
color endp

;/////////////////////////////////////////////////////////////////////////// PRINT A NUMBER IN DECIMAL ON CONSOLE
PrintNumber proc
		xor bx, bx
		xor cx, cx
    mov cx, 0
    mov bx, 10
@@loophere:
    xor edx, edx
    div bx					;divide by ten

    ; now ax <-- ax/10
    ;     dx <-- ax % 10

    ; print dx
    ; this is one digit, which we have to convert to ASCII
    ; the print routine uses dx and ax, so let's push ax
    ; onto the stack. we clear dx at the beginning of the
    ; loop anyway, so we don't care if we much around with it

    push ax
    add dl, '0'				;convert dl to ascii

    pop ax					;restore ax
    push dx					;digits are in reversed order, must use stack
    inc cx					;remember how many digits we pushed to stack
    cmp ax, 0				;if ax is zero, we can quit
jnz @@loophere

    ;cx is already set
    mov ah, 2				;2 is the function number of output char in the DOS Services.
@@loophere2:
    pop dx					;restore digits from last to first
    int 21h					;calls DOS Services
    loop @@loophere2

    ret
PrintNumber endp


WriteNumber proc
		mov writec, 0
		xor bx, bx
		xor cx, cx
    mov cx, 0
    mov bx, 10
@@loophere:
    xor edx, edx
    div bx                          ;divide by ten

    ; now ax <-- ax/10
    ;     dx <-- ax % 10

    ; print dx
    ; this is one digit, which we have to convert to ASCII
    ; the print routine uses dx and ax, so let's push ax
    ; onto the stack. we clear dx at the beginning of the
    ; loop anyway, so we don't care if we much around with it

    push ax
    add dl, '0'					;convert dl to ascii

    pop ax						;restore ax
    push dx						;digits are in reversed order, must use stack
    inc writec					;remember how many digits we pushed to stack
    cmp ax, 0					;if ax is zero, we can quit
jnz @@loophere

    ;cx is already set
                        ;2 is the function number of output char in the DOS Services.
.while writec != 0
		mov ah, 40h
		mov cx, 1
		mov bx, handle
		mov char, 0
    pop char					;restore digits from last to first
		lea dx, offset char
    int 21h						;calls DOS Services
		dec writec
.endw

    ret
WriteNumber endp

end
