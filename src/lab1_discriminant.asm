.686P

.model flat, stdcall
option casemap:none


include		..\masm32\include\windows.inc
includelib	..\masm32\lib\kernel32.lib
include		..\masm32\include\kernel32.inc
includelib	..\masm32\lib\user32.lib
include		..\masm32\include\user32.inc
include		..\masm32\include\masm32.inc
include		..\masm32\include\msvcrt.inc
include		..\masm32\macros\macros.asm
includelib	..\masm32\lib\masm32.lib
includelib	..\masm32\lib\msvcrt.lib


.data
sOut	db  "mas[%d] = %d",13, 10, 0

nArr	dd	3		; количество переменных

varA dd ?
varB dd ?
varC dd ?

varD dd ?		; Discriminant
varX1 dd ?
varX2 dd ?

varTmp dd ?


 .const
 sConsoleTitle   db "Lab 1 ASM"

sFormat			db "%d", 0

sVarA			db "Enter a: ", 0
sVarB			db "Enter b: ", 0
sVarC			db "Enter c: ", 0

sNoValid		db "No valid roots", 13, 10, 0
sEqual			db "Roots are equal. x1 = x2, D = %d", 13, 10, 0
sOk				db "D > 0", 13, 10, 0
sResX1			db "Result x1: %d", 13, 10, 0
sResX2			db "Result x2: %d", 13, 10, 0

sExpr			db "Expression: ax^2 + bx + c", 13, 10, 0
sDiscr			db "Discr = %d", 13, 10, 0

sANull			db "a = 0", 13, 10, 0 
sExit			db "Press any key to Exit", 13, 10, 0

 .code
Main PROC
	; заголовок(title) консоли
	invoke SetConsoleTitleA, ADDR sConsoleTitle
  
	; вывод строки
	invoke crt_printf, ADDR sExpr

	; enter var a
	invoke crt_printf, ADDR sVarA
	invoke crt_scanf, ADDR sFormat, ADDR varA
	cmp varA, 0
	JE aNull
	
	; enter var b
	invoke crt_printf, ADDR sVarB
	invoke crt_scanf, ADDR sFormat, ADDR varB
	
	; enter var c
	invoke crt_printf, ADDR sVarC
	invoke crt_scanf, ADDR sFormat, ADDR varC


	; Discriminant

	; 4ac
	mov  eax, [varA]
	imul eax, [varC]
	shl  eax, 2			;* 4
	mov  ebx, eax

	; b * b
	mov  eax, [varB]
	imul eax

	sub  eax, ebx
	mov  [varD], eax
	
	invoke crt_printf, ADDR sDiscr, varD

	cmp varD, 0
	JE dNull
	JL dLessNull
	JG dMoreNull
	
	
	dMoreNull:		
		invoke crt_printf, ADDR sOk, varD
		JMP exitProgram
	
	dNull:
		invoke crt_printf, ADDR sEqual, varD
		JMP exitProgram

	dLessNull:
		invoke crt_printf, ADDR sNoValid
		JMP exitProgram

	aNull:
		invoke crt_printf, ADDR sANull
		JMP exitProgram

	exitProgram:
	invoke crt_printf, ADDR sExit

	; _getch()
	invoke crt__getch

	invoke ExitProcess, 0
Main ENDP

end Main
