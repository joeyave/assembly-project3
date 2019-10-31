TITLE lab2

.386
.model flat, stdcall
.stack 4096
	ExitProcess PROTO, dwExitCode:DWORD

.data
	avar db 7
	bvar db 1
	cvar db 10

	yvar dw 0

.code
_main proc
	; if |a| + |b| > |c| then y = [a * b / c]
	; if |a| + |b| = |c| then y = a * b * c
	; if |a| + |b| < |c| then y = {a / (b * c)}

	mov al, avar
	cbw
	mov bx, ax
	cmp ax, 0
	; skip if positive
	jge short abs_b
	; if negative 
	neg ax
	mov bx, ax ; avar now in bx

	abs_b:
	mov al, bvar
	cbw
	cmp ax, 0
	jge short add_ab
	neg ax
	add_ab:
	add bx, ax
	; |a| + |b| now is in bx

	mov al, cvar
	cbw
	cmp ax, 0
	jge short comparison
	neg ax

	; ax contains |c|, bx contains |a| + |b|
	comparison:
	cmp bx, ax
	jg short greater
	jl short less
	

	; y = a * b * c
	mov al, avar
	imul bvar
	imul cvar
	cbw
	mov yvar, ax
	jmp exit


	; y = [a * b / c]
	greater:
	mov bl, cvar 
	mov al, avar
	imul bvar
	cbw
	idiv bl
	mov yvar, ax
	jmp exit

	; y = {a / (b * c)}
	less:
	mov bl, bvar
	mov cl, cvar
	mov al, avar
	cbw
	idiv bl
	cbw
	idiv cl
	mov dl, ah
	mov al, dl
	cbw
	mov yvar, ax
	jmp exit
	
	exit:
	INVOKE ExitProcess, 0
_main ENDP
END _main