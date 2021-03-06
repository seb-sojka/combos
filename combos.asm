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

;Display on string on single line
disLine		MACRO	buf
	myWriteStr	buf
	call		CrLf
ENDM

;Prints string
myWriteStr		MACRO	buff
	push	edx
	mov		edx, OFFSET buff
	call	WriteString
	pop		edx
ENDM

;PRints the prompt for the problem
probDis		MACRO	num, nM, rM
	push	eax
	
	;;Display Problem number
	myWriteStr	promProb
	mov			eax, num
	call		WriteDec
	call		CrLf
	
	;;Display how many in a set
	myWriteStr	promSet
	mov			eax, nM
	call		WriteDec
	call		CrLf

	;;Display how to choose in a set
	myWriteStr	promCho
	mov			eax, rM
	call		WriteDec
	call		CrLf

	pop		eax
ENDM

NUMHIGH = 12;Upper limit of first number for combos
NUMLOW = 3;Upper limit of first number for combos
CHAR0 = 48;ASCII number of '0'
CHAR9 = 57;ASCII number of '9'
EXITCHAR EQU <'e'>;'e' to exit program

.data

promTitle	BYTE	"Combo Calculator", 0
promPrgmr	BYTE	"By Sebastian Sojka", 0
promFunc1	BYTE	"I will display a combinations problem that you will answer.", 0
promFunc2	BYTE	"I will tell you the answer and if you are right or wrong.", 0
promProb	BYTE	"Problem ",0
promSet		BYTE	"Elements in set: ", 0
promCho		BYTE	"Elements to chose in set: ", 0
promIn		BYTE	"So how many ways can you choose?" ,0
promErrInt	BYTE	"Error - User intput not integer.", 0
promAns1	BYTE	"For ", 0
promAns2	BYTE	" items from a set of ", 0
promAns3	BYTE	", there are ", 0
promAns4	BYTE	" combinations.", 0
promCorr	BYTE	"You were lucky. You got the answer right.", 0
promInc		BYTE	"You were unlucky. You got it wrong.", 0
promAskExit	BYTE	"Press E to exit program. Press any other key continue practicing.", 0


probNum		DWORD	0
r			DWORD	?
n			DWORD	?
useAns		DWORD	?
ans			DWORD	?
ansStr		BYTE	35 DUP(?)

.code
main PROC
	

	;Seed for random number generation
	call	Randomize
	call	intro
	
problems:
	push	OFFSET probNum
	push	OFFSET r
	push	OFFSET n
	call	showPro

	push	OFFSET ansStr
	push	OFFSET useAns
	call	getAns

	push	r
	push	n
	push	OFFSET ans
	call	calcul

	push	r
	push	n
	push	ans
	push	useAns
	call	showRes
	
	disLine	promAskExit

	;Gets ccharacter response from user
	call	ReadChar

	;Compare user input to exit character, e
	cmp		Al, EXITCHAR

	je		exitP
	jmp		problems
exitP:
	exit	; exit to operating system
main ENDP

showRes PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp
	pushad
	
	myWriteStr promAns1
	mov		eax, [ebp+20]
	call	WriteDec

	myWriteStr promAns2
	mov		eax, [ebp+16]
	call	WriteDec

	myWriteStr promAns3
	mov		eax, [ebp+12]
	call	WriteDec

	myWriteStr promAns4

	call	CrLf

	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	cmp		eax, ebx
	je		correct
incorrect:
	disLine	promInc
	jmp		endRes

correct:
	disLine	promCorr	
endRes:
	popad
	pop		ebp
	ret		16
showRes ENDP
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
;Recives: addresses for items within the set and the number of items to be chosen for combo
;Returns: none
;requires: none
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
	push	1
	call	getRan


	;Increase problem count by one
	mov		ecx, [ebp+16]
	mov		eax, [ecx]
	inc		eax
	mov		[ecx], eax
	mov		ecx, [ecx]
	
	;Number items within the set
	mov		eax, [ebp+8]
	mov		edx, [eax]

	;Gets number to choose from the set 
	mov		ebx, [ebp+12]
	mov		ebx, [ebx]

	;Display Problem
	probDis	ecx, edx, ebx

	popad
	;restore stack
	pop		ebp
	ret		12
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

;Description: Gets the user answer
;Recives: addresses for userAnswe
;Returns: r and n for 
;requires: 
getAns PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp
	pushad
	

UserInput:
	disLine	promIn
	mov		edx, [ebp+12]
	mov		ecx, 34
	call	ReadString
	mov		eax, 0
	mov		ecx, 0
	check:
		mov		edx, [ebp+12]
		add		edx, ecx
		mov		bl, [edx]
		cmp		bl, 0
		je		endRead
		
		mov		bh, CHAR9
		cmp		bh, bl
		jl		error

		mov		bh, CHAR0
		cmp		bl, bh
		jl		error
		
		mov		edx, 10

		mul		edx
		
		sub		bl, bh

		movzx	edx,BYTE PTR bl

		add		eax, edx

		inc		ecx
		jmp		check
	error:
		call	CrLf
		disLine	promErrInt
		jmp		userInput

endRead:
	mov		ebx, [ebp+8]
	mov		[ebx], eax

	popad
	;restore stack
	pop		ebp
	ret		8
getAns	ENDP


calcul PROC
	;LOCAL	nFact:DWORD;, rFact:DWORD, difFact:DWORD
	;set up stack frame
	push	ebp
	mov		ebp, esp
	pushad

	
	mov		eax, [ebp+12]
	sub		eax, [ebp+16]
	push	eax
	push	1
	call	factor
	mov		ecx, eax

	push	[ebp+16]
	push	1
	call	factor
	mov		ebx, eax

	push	[ebp+12]
	push	1
	call	factor
	
	div		ebx
	div		ecx

	mov		ebx, [ebp+8]
	mov		[ebx], eax



	popad
	;restore stack
	pop		ebp
	ret		12
calcul ENDP

factor PROC
	;set up stack frame
	push	ebx
	push	ecx
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+20]
	cmp		ecx, 1
	mov		eax, [ebp+16]
	jle		stop
	mul		ecx
	dec		ecx
	push	ecx
	push	eax
	call	factor

stop:		

	;restore stack
	pop		ebp
	pop		ecx
	pop		ebx
	ret		8
factor ENDP



END main
