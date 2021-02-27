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
	HI = 30
	COUNT = 200


.data

    intro_1	 	    BYTE   "Generating, Sorting, and Counting Random integers! Programmed by Shimey Loo", 0
	intro_2	 	    BYTE   "This program generates 200 random numbers in the range [10 ... 29], displays the", 13, 10,
                           "original list, sorts the list, displays the median value of the list, displays the ", 13, 10,
	                       "list sorted in ascending order, then displays the number of instances of each ", 13, 10,
                           "generated value, starting with the number of 10s.", 0
	prompt_1	 	BYTE   "Your unsorted random numbers:", 0
	randomArray     DWORD  COUNT DUP(?) 
	sortedArray     DWORD  COUNT DUP(?) 



.code
main PROC
	
	; Calls introduction procedure, greets user and displays explanation of program
	PUSH  OFFSET intro_1
	PUSH  OFFSET intro_2
	CALL  introduction

	; Calls fillArray, generate an array of COUNT random numbers
	PUSH  OFFSET LO 
	PUSH  OFFSET HI
	PUSH  OFFSET COUNT
	PUSH  OFFSET randomArray
	CALL  fillArray 

	; Calls displayList, displays unsorted random numbers
	PUSH  OFFSET prompt_1
	PUSH  OFFSET randomArray
	PUSH  OFFSET COUNT
	CALL  displayList

	; Sorts array of numbers
	PUSH  OFFSET randomArray
	PUSH  OFFSET sortedArray

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
	MOV   ECX, [EBP + 12]                  ; COUNT
	MOV   EDI, [EBP + 8]                   ; address of array in EDI 
    CALL  Randomize                        ; Sets seed
	MOV   EBX, 0 
_fillLoop: 
	MOV   EAX, [EBP + 16]                  ; upper range 
	CALL  RandomRange 
	CMP   EAX, 10                          ; checks if generated number is less than 10
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
	MOV   EDX, [EBP + 8]                   ; COUNT
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
    DEC   EDX
	CMP   EDX, 0
	JGE   _showElement
	POP   EBP
	RET   16


displayList ENDP 


END main
