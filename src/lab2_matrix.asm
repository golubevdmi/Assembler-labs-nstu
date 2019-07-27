.686P

.model flat, stdcall
option casemap:none

include ..\irvine\Irvine32.inc
include ..\masm32\include\msvcrt.inc

includelib ..\irvine\User32.lib
includelib ..\irvine\Kernel32.lib
includelib ..\irvine\Irvine32.lib
includelib ..\masm32\lib\msvcrt.lib

; ����������� �� ������ �������
maxSize = 10000000

; ������������� �������
InitMat PROTO,
	lpArray:PTR DWORD

; ����� ������������ ��������� �� ��������
ArithmeticMeanOfColumns PROTO,
	lpArray:PTR DWORD,
	mCols:DWORD,
	mRows:DWORD

; ������ �������
PrintMat PROTO,
	lpArray:PTR DWORD,
	mRows:DWORD,
	mCols:DWORD
            

.data?
    rows		DWORD ?      ; ����� �����
    cols		DWORD ?	     ; ����� ��������
    matrixSize	DWORD ?      ; ���������� ���������

	vSum		DWORD ?
	vAmountOfEl	DWORD ?
	
	vArithMeanInt	DWORD ?
	vArithMeanRem	DWORD ?

	Array dword maxSize dup(?)

.const
	maxRandNumb	dword 100

	sConsoleTitle   byte "Lab 2 ASM", 13, 10, 0

	sSize			byte "Enter a Mat size: ", 0
	sMat			byte "Matrix [%d x %d]: ", 13, 10, 0
	sFormat			byte " %d",0

	sSpace			byte "  ", 0
	sError			byte "Err", 13, 10, 0

	sSum			byte "Sum: %d", 13, 10, 0
	sAmountOfEl		byte "Amount of elements: %d", 13, 10, 0
	
	sArithMean		byte "Arithmetic Mean Of Columns: %d.%d", 13, 10, 0

	sExit			byte "Press any key to Exit", 13, 10, 0
	
    fm  db '%d, ',0
	
    
.code
main PROC
	; ���������(title) �������
	invoke SetConsoleTitleA, addr sConsoleTitle


	invoke InitMat, addr Array

	invoke crt_printf, addr sMat, rows, cols
	invoke PrintMat, addr Array, rows, cols

	invoke ArithmeticMeanOfColumns, addr Array, cols, rows

	; exit
	invoke crt_printf, addr sExit

	; _getch()
	invoke crt__getch
	invoke ExitProcess, 0
    
main ENDP

InitMat PROC,
		lpArray: PTR DWORD

	invoke crt_printf, addr sSize
	invoke ReadInt

	; �������� �����
    jo error                ; ������ � �����(�������� �� ������������)

	cmp eax, 0
	jle error               ; ������ ��� ����� ����

    ;cmp eax, maxSize
	;jg error                ; ��������� maxSize
	
    mov rows, eax
    mov cols, eax
	
	mul eax					; ��������� �a ����(�������� ���������� ���������)
	mov matrixSize, eax		; ������� ������ �������

	; ������� �������� ��� ����� ����������
    mov ebx, lpArray		; ������� ��������� �� ������ ������� � �������
    mov esi, 0				; ������������� �� 0
    mov ecx, matrixSize		; ������� ������ � �������-�������

	
	; ����
    ;invoke Randomize           ; ������������� ��������� ��������� �����
InitVal:
    mov eax, maxRandNumb		; �������� ��� RandomRange
    invoke RandomRange			; ���������� ��������� �����

    mov [ebx + esi], eax		; ��������� ��������������� ��������
    add esi, TYPE lpArray		; � ���� ��������
    loop InitVal

    ret

; ������� ��� ������
error:
	invoke crt_printf, addr sError
	invoke ExitProcess, 0
    
InitMat ENDP

ArithmeticMeanOfColumns PROC,
	lpArray:PTR DWORD,		; ����� �������
	mCols:DWORD,			; ���������� ���������
	mRows:DWORD

	LOCAL shift
	mov eax, mCols
	imul eax, TYPE lpArray
	mov shift, eax

	mov eax, 0	; �������� �����
	mov ebx, 0	; �������� �������� ������� � ������
	mov ecx, mCols	; ���������� ��������

	cycleCols:
		push ecx				; ��������� �������
		mov ecx, mRows			; ������� ��������� � �������
		mov edx, Array[ebx]		; ������� ������ ������� �������
		mov esi, shift				; �������� ������� �������� �������(cols*TYPE arr)

		cycleEl: 
			cmp edx, Array[ebx] + [esi]	; ����������
			jge next					; ���� ������ ��� ����� - � ����������
			mov edx, Array[ebx] + [esi]	; ���� ������, �� ���������

		next: 
			add esi, shift				; ��������� � ���������� ��������
			loop cycleEl					; ���� �� ��������� �������

			add eax, edx				; �������������� ������������ �������
			pop ecx					; ������������ �������
			add ebx, TYPE lpArray				; ������� � ���������� �������
	loop cycleCols					; ���� �� ��������


	mov vSum, eax		; ������� ����� 

	mov edx, 0			; ������ ������� ���� ��������, � eax �������
	mov ebx, mCols		; ���������� ���������, �� ������� ����� ������
	idiv ebx
	
	mov vArithMeanRem, edx		; �������
	mov vArithMeanInt, eax		; �����
	
	
	; �����	
	invoke crt_printf, ADDR sSum, vSum
	invoke crt_printf, ADDR sAmountOfEl, mCols
	invoke crt_printf, ADDR sArithMean, vArithMeanInt, vArithMeanRem

	ret

ArithmeticMeanOfColumns ENDP

PrintMat PROC,
		lpArray:PTR DWORD,
		mRows:DWORD,
		mCols:DWORD

		pushad
    mov ebx, lpArray		; ��������� �� ������ �������
    mov esi, 0				; ������������� �� 0 
    mov ecx, mRows          ; ������� �������� �����

loopCols:
    push ecx               ; ��������� ������� �������� �����
    mov ecx, mCols         ; ������� ���������� �����
    
    LoopRows:
		; ������� �����
        mov eax,[ebx + esi]
		invoke WriteInt

		; ��������� �����
        add esi, TYPE lpArray

		; �������� ������ ����� ������� �������
		mov edx, offset sSpace
		invoke WriteString


        loop LoopRows
		
    invoke Crlf		 ; ������� �� ����� ������
    pop ecx          ; ��������������� ������� �������X
    loop loopCols
	popad
    ret

PrintMat ENDP

END main