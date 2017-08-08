TITLE Program Combos     (combos.asm)

; Author Sebastian Sojka
; Class: CS271-400
; Program Number: 5
; Program Name: Paths
; Date: 8/7/2017
; Description: Program will allow students to practice with combinatorics. A random will
; be genertera between 3 and 12 and then another random number between 1 and the previous random number.
; User will enter thier answer and then will elevualte it and show the correct answer. Continues 
; unitl user quits. 

INCLUDE Irvine32.inc

disLine		MACRO	buf
	myWrite buf
	call	CrLf
ENDM

myWrite		MACRO	buff
	push	edx
	mov		edx, OFFSET buff
	call	WriteString
	pop		edx
ENDM

prob		MACRO	num, r, n
	push	eax
	myWrite promProb
	mov		eax, num
	call	WriteDec
	pop		eax
ENDM

NUMHIGH = 12;Upper limit of first number for combos
NUMLOW = 3;Upper limit of first number for combos



.data

promTitle	BYTE	"Combo Calculator", 0
promPrgmr	BYTE	"By Sebastian Sojka", 0
promFunc1	BYTE	"I will display a combinations problem that you will answer.", 0
promFunc2	BYTE	"I will tell you the answer and if you are right or wrong.", 0
promProb	BYTE	"Problem ",0


r			BYTE	?
n			BYTE	?

.code
main PROC
	

	;Seed for random number generation
	call	Randomize
	call	intro
	
	push	OFFSET r
	push	OFFSET n
	call	showPro



	exit	; exit to operating system
main ENDP

;Description: Display name of program, the programmer, and function of the program
;Recives: None
;Returns: None
;register changes: none
intro PROC
	pushad
	;Displays title and author of the program
	;Display title name
	disLine	promTitle

	;Display programmer name (me)
	disLine	 promPrgmr

	;Display Function of the pogram
	disLine promFunc1

	;Display Function of the pogram
	disLine promFunc2

	popad
	ret
intro ENDP

;Description: Shows the problem to the user along with number limits 
;Recives: addresses for upper and lower limit
;Returns: nothin
;requires: 
showPro PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp
	pushad
	
	push	[ebp+8]
	push	NUMHIGH
	push	NUMLOW
	call	getRan


	push	[ebp+12]
	mov		eax, [ebp+8]
	push	[eax]
	push	NUMLOW
	call	getRan



	popad
	;restore stack
	pop		ebp
	ret		8
showPro	ENDP


;Description: Gets a single random number within a range
;Recives: addresses for random number and upper and lower limit of the number
;Returns: Random number
;requires: upper >= lower
getRan PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp
	pushad	

	;Sets the range for random number
	mov		eax, [ebp+12]
	sub		eax, [ebp+8]
	inc		eax

	;Call random number
	call	RandomRange
	add		eax, [ebp+8]

	mov		ebx, [ebp+16]
	mov		[ebx], eax

	popad
	;restore stack
	pop		ebp
	ret		12
getRan ENDP

END main
