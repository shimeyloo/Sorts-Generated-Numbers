TITLE Generating Sorting Counting Random Integers    (RandomIntegers.asm)

; Author: Shimey Loo
; Last Modified: February 28, 2021
; OSU email address: LOOSH@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 5       Due Date:  February 28, 2021
; Description: test


INCLUDE Irvine32.inc

; (insert macro definitions here)

    ; constant values
	LO = 10
	HI = 99
	ARRAYSIZE = 200


.data

    intro_1	 	    BYTE   "Generating, Sorting, and Counting Random integers! Programmed by Shimey Loo", 0
	intro_2	 	    BYTE   "This program generates 200 random numbers in the range [10 ... 29], displays the", 13, 10,
                           "original list, sorts the list, displays the median value of the list, displays the ", 13, 10,
	                       "list sorted in ascending order, then displays the number of instances of each ", 13, 10,
                           "generated value, starting with the number of 10s.", 0
	prompt_1	 	BYTE   "Your unsorted random numbers:", 0
	prompt_2	 	BYTE   "Your sorted random numbers:", 0
	randomArray     DWORD  ARRAYSIZE DUP(?) 
	prompt_3	 	BYTE   "The median value of the array: ", 0



.code
main PROC
	
	; Calls introduction procedure, greets user and displays explanation of program
	PUSH  OFFSET intro_1
	PUSH  OFFSET intro_2
	CALL  introduction

	; Calls fillArray, generate an array of ARRAYSIZE random numbers
	PUSH  OFFSET LO 
	PUSH  OFFSET HI
	PUSH  OFFSET ARRAYSIZE
	PUSH  OFFSET randomArray
	CALL  fillArray 

	; Calls displayList, displays unsorted random numbers
	PUSH  OFFSET prompt_1
	PUSH  OFFSET randomArray
	PUSH  OFFSET ARRAYSIZE
	CALL  displayList

	; Calls sortList
	PUSH  OFFSET randomArray
	PUSH  OFFSET ARRAYSIZE
	CALL  sortList

	; Calls displayMedian 
	PUSH  OFFSET ARRAYSIZE
	PUSH  OFFSET prompt_3
	PUSH  OFFSET randomArray
	CALL  displayMedian

	; Calls displaySortedList
	PUSH  OFFSET prompt_2
	PUSH  OFFSET randomArray
	PUSH  OFFSET ARRAYSIZE
	CALL  displayList

	

	Invoke ExitProcess,0	               ; exit to operating system
main ENDP

introduction PROC

    ; Introduces the name of the program and programmer
    PUSH  EBP
	MOV   EBP, ESP
	PUSH  EDX
	MOV   EDX, [EBP + 12]
	CALL  WriteString
	CALL  CrLf
	CALL  CrLf

	; Displays a description of program functionality
	MOV   EDX, [EBP + 8]
	CALL  WriteString
	CALL  CrLf
	CALL  CrLf
	POP   EDX
	POP   EBP
	RET   8

introduction ENDP

fillArray PROC 
	PUSH  EBP
	MOV   EBP, ESP

	; generates random number
	MOV   ECX, [EBP + 12]                  ; ARRAYSIZE
	MOV   EDI, [EBP + 8]                   ; address of array in EDI 
    CALL  Randomize                        ; Sets seed
	MOV   EBX, 0 
_fillLoop: 
	MOV   EAX, [EBP + 16]                  ; upper range (HI)
	ADD   EAX, 1
	CALL  RandomRange 
	CMP   EAX, [EBP + 20]                  ; checks if generated number is less than LO
	JL    _fillLoop
	MOV   [EDI], EAX                       ; adds new num to randomArray
	ADD   EDI, 4 
	INC   EBX 
	LOOP  _fillLoop

	; saves list of random numbers 
	MOV   [EBP + 8], EDI 
	POP   EBP 
	RET   16

fillArray ENDP 

displayList PROC 
	PUSH  EBP
	MOV   EBP, ESP

	; Display text regarding random unsorted list
	MOV   EDX, [EBP + 16]
	CALL  WriteString
	CALL  CrLf

	; Displays random unsorted list
	MOV   EDX, 1                   
	MOV   ESI, [EBP + 12]                  ; randomArray
	DEC   EDX 
	MOV   EBX, 0
_showElement:
	MOV   EAX, EBX 
	CMP   EAX, 20
	JGE   _twentyPerLine               
	JMP   _continue
_twentyPerLine: 
	CALL  CrLf                             ; creates a new line when 20 values have been displayed 
	MOV   EBX, 0
_continue:
	MOV   EAX,[ESI+EDX*4]          
	CALL  WriteDec                 
	MOV   AL,32
	CALL  WriteChar
	INC   EBX
    INC   EDX
	CMP   EDX, [EBP + 8]                   ; ARRAYSIZE
	JL    _showElement
	CALL  CrLf
	CALL  CrLf
	POP   EBP
	RET   12

displayList ENDP 

sortList PROC
	PUSH  EBP
	MOV   EBP, ESP

	; Sort the array
	MOV   ESI, [EBP + 12]             ; randomArray
	MOV   ECX, [EBP + 8]              ; ARRAYSIZE
	DEC   ECX
	
_outerLoop:
	MOV   EDX, 0
	DEC   ECX
	PUSH  ECX
	INC   ECX
  _innerLoop: 
	MOV   EAX, [ESI+EDX*4]            ; previous 
	INC   EDX 
	MOV   EBX, [ESI+EDX*4]            ; current 
	CMP   EAX, EBX 
	JG    _swap
	JMP   _loop
  _swap: 
	MOV   [ESI+EDX*4], EAX
	DEC   EDX
	MOV   [ESI+EDX*4], EBX 
	INC   EDX
	JMP   _loop
  _loop: 
	LOOP  _innerLoop
	POP   ECX  
	CMP   ECX, 2
	JG    _outerLoop  
	POP   EBP 
	RET   8

sortList ENDP

displayMedian PROC
	PUSH  EBP
	MOV   EBP, ESP

	; Display text regarding median 
	MOV   EDX, [EBP + 12]
	CALL  WriteString

	; Determin if the size of the array is even or odd
	; By dividing the array size by 2 and looking if there is a remainder
	MOV   EAX, [EBP + 16]                  ; ARRAYSIZE
	MOV   EDX, 0
    MOV   EBX, 2
	DIV   EBX 
	CMP   EDX, 0 
	JE    _isEven
	JMP   _displayResults
_isEven: 
	; Check to see if middle 2 values are the same
	MOV   EDX, EAX 
	DEC   EDX
	MOV   EAX, [ESI+EDX*4]
	INC   EDX
	MOV   EBX, [ESI+EDX*4]
	CMP   EAX, EBX
	JE    _displayResults

	; Add the middle 2 arrays and divide by 2
	ADD   EAX, EBX 
	MOV   EDX, 0 
	MOV   EBX, 2
	DIV   EBX 
	CMP   EDX, 0
	JNE   _roundUp
	JMP   _displayResults
_roundUp: 
	INC   EAX 
	JMP   _displayResults

_displayResults: 
	CALL  WriteDec 
	CALL  CrLf
	CALL  CrLf
	POP   EBP 
	RET   12

displayMedian ENDP



END main
