TITLE Generating Sorting Counting Random Integers    (RandomIntegers.asm)

; Author: Shimey Loo
; Last Modified: February 28, 2021
; OSU email address: LOOSH@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 5       Due Date:  February 28, 2021
; Description:


INCLUDE Irvine32.inc

; (insert macro definitions here)

	LO = 10
	HI = 99
	ARRAYSIZE = 200
	COUNTARRAYSIZE = HI - LO + 1
	COUNTINSTANCES = HI - LO


.data

    intro_1	 	    BYTE   "Generating, Sorting, and Counting Random integers! Programmed by Shimey Loo", 0
	intro_2	 	    BYTE   "This program generates a list of random numbers in a specific range, displays the", 13, 10,
                           "original list, sorts the list, displays the median value of the list, displays the ", 13, 10,
	                       "list sorted in ascending order, then displays the number of instances of each ", 13, 10,
                           "generated value, starting with the lowest number.", 0
	prompt_1	 	BYTE   "Your unsorted random numbers:", 0
	prompt_2	 	BYTE   "Your sorted random numbers:", 0
	randomArray     DWORD  ARRAYSIZE DUP(?) 
	prompt_3	 	BYTE   "The median value of the array: ", 0
	prompt_4	 	BYTE   "Your list of instances of each generated number:", 0
	prompt_5   	 	BYTE   "Goodbye, and thanks for using this program!", 0
	countSize       DWORD  ?
	countArray      DWORD  COUNTINSTANCES DUP(?) 

.code

; ---------------------------------------------------------------------------------
; Name: main
;
; Consist of only procedure calls:
;     introduction, fillArray, displayList, sortList, displayMedian, countList, farewell 
;                 
; Receives: 
;     Data segment variables - intro_1, intro_2, LO, HI, ARRAYSIZE, randomArray, prompt_1, prompt_2, prompt_3, prompt_4
;                              countArray, countSize, COUNTARRAYSIZE, goodbye
; ---------------------------------------------------------------------------------
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

	; Calls displayList, displays sorted numbers
	PUSH  OFFSET prompt_2
	PUSH  OFFSET randomArray
	PUSH  OFFSET ARRAYSIZE
	CALL  displayList

	; Calls countList
	PUSH  OFFSET randomArray
	PUSH  OFFSET countArray
	PUSH  OFFSET ARRAYSIZE
	PUSH  OFFSET countSize
	PUSH  OFFSET LO
	PUSH  OFFSET HI
	CALL  countList

	; Calls displayList, displays instances of each generated number
	PUSH  OFFSET prompt_4
	PUSH  OFFSET countArray
	PUSH  OFFSET COUNTARRAYSIZE
	CALL  displayList

	; Calls farewell
	PUSH  OFFSET prompt_5
	CALL  farewell

	Invoke ExitProcess,0	               ; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Introduces the name of the program and programmer and Displays a description of program functionality
;
; Preconditions: none
;
; Postconditions: changes registers EDX
;                 
; Receives: 
;     [EBP + 12] =  intro_1    
;     [EBP + 8]  =  intro_2
;
; returns: none
; ---------------------------------------------------------------------------------
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

; ---------------------------------------------------------------------------------
; Name: 
;
; Description HERE 
;
; Postconditions: changes registers EAX, EBX, ECX, EDX, ESI, EDI
;                 
;
; Receives: 
;           
;
; returns: 
; ---------------------------------------------------------------------------------
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

; ---------------------------------------------------------------------------------
; Name: 
;
; Description HERE 
;
; Postconditions: changes registers EAX, EBX, ECX, EDX, ESI, EDI
;                 
;
; Receives: 
;           
;
; returns: 
; ---------------------------------------------------------------------------------
displayList PROC 
	PUSH  EBP
	MOV   EBP, ESP

	; Display text regarding list
	MOV   EDX, [EBP + 16]
	CALL  WriteString
	CALL  CrLf

	; Displays list 
	MOV   ESI, [EBP + 12]                  ; randomArray
	MOV   EDX, 1   
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

; ---------------------------------------------------------------------------------
; Name: 
;
; Description HERE 
;
; Postconditions: changes registers EAX, EBX, ECX, EDX, ESI, EDI
;                 
;
; Receives: 
;           
;
; returns: 
; ---------------------------------------------------------------------------------
sortList PROC
	PUSH  EBP
	MOV   EBP, ESP

	; Sort the array
	MOV   ESI, [EBP + 12]             ; randomArray
	MOV   ECX, [EBP + 8]              ; ARRAYSIZE
	
_outerLoop:
	DEC   ECX
	PUSH  ECX                         ; position
	MOV   EDX, 0
  _innerLoop: 
	MOV   EAX, [ESI+EDX*4]            ; current 
	INC   EDX 
	MOV   EBX, [ESI+EDX*4]            ; next
	CMP   EAX, EBX 
	JG    _exchange
	JMP   _loop
  _exchange: 
	; call exchangeElements
	PUSH  EAX
	PUSH  EBX
	PUSH  EDX 
	PUSH  ESI
	CALL  exchangeElements
	JMP   _loop
  _loop: 
	LOOP  _innerLoop
	POP   ECX  
	CMP   ECX, 2
	JGE   _outerLoop  
	POP   EBP 
	RET   8

sortList ENDP

; ---------------------------------------------------------------------------------
; Name: 
;
; Description HERE 
;
; Postconditions: changes registers EAX, EBX, ECX, EDX, ESI, EDI
;                 
;
; Receives: 
;           
;
; returns: 
; ---------------------------------------------------------------------------------
exchangeElements PROC
	PUSH  EBP
	MOV   EBP, ESP

	MOV   ESI, [EBP + 8]
	MOV   EDX, [EBP + 12]
	MOV   EBX, [EBP + 16]
	MOV   EAX, [EBP + 20]
	MOV   [ESI+EDX*4], EAX
	DEC   EDX
	MOV   [ESI+EDX*4], EBX 
	INC   EDX

	POP   EBP 
	RET   16
exchangeElements ENDP

; ---------------------------------------------------------------------------------
; Name: 
;
; Description HERE 
;
; Postconditions: changes registers EAX, EBX, ECX, EDX, ESI, EDI
;                 
;
; Receives: 
;           
;
; returns: 
; ---------------------------------------------------------------------------------
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
	JMP   _isOdd
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

_isOdd: 
	MOV   EDX, EAX
	MOV   EAX, [ESI+EDX*4]

_displayResults: 
	CALL  WriteDec 
	CALL  CrLf
	CALL  CrLf
	POP   EBP 
	RET   12

displayMedian ENDP

; ---------------------------------------------------------------------------------
; Name: 
;
; Description HERE 
;
; Postconditions: changes registers EAX, EBX, ECX, EDX, ESI, EDI
;                 
;
; Receives: 
;           
;
; returns: 
; ---------------------------------------------------------------------------------
countList PROC
	PUSH  EBP
	MOV   EBP, ESP

	; Update countSize 
	MOV   EBX, [EBP + 12]    ; low
	MOV   EAX, [EBP + 8]     ; hi
	SUB   EAX, EBX
	MOV   [EBP + 16], EAX    ; save countSize

	; Count how many of each number there are
	MOV   ESI, [EBP + 28]    ; randomArray
	MOV   EDI, [EBP + 24]    ; countArray
	MOV   EAX, [EBP + 12]    ; lo 
	MOV   ECX, [EBP + 20]    ; ARRAYSIZE
	MOV   EBX, 0             ; occurance counter 

_LoopCount:  
	CMP   EAX, [ESI]
	JE    _addOne
	JMP   _magical
_addOne:
	INC   EBX 
_magical: 
	ADD   ESI, 4
	LOOP  _LoopCount
	JMP   _recordCounter

_recordCounter:
	MOV   [EDI], EBX         ; adds new count to countArray
	MOV   ESI, [EBP + 28]    ; randomArray
	ADD   EDI, 4 
	INC   EAX
	MOV   ECX, [EBP + 20]    ; ARRAYSIZE
	MOV   EBX, 0 
	CMP   EAX, [EBP + 8]
	JLE   _LoopCount

	POP   EBP 
	RET   24

countList ENDP

; ---------------------------------------------------------------------------------
; Name: farewell
;
; Say goodbye by displaying a parting message 
;
; Receives:  
;     [ebp+8] = prompt_5
; ---------------------------------------------------------------------------------
farewell PROC
	PUSH  EBP
	MOV   EBP, ESP

	MOV   EDX, [EBP + 8]
	CALL  WriteString
	CALL  CrLf

	POP   EBP 
	RET   4
farewell ENDP

END main