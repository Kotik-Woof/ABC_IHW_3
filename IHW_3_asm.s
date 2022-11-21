	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	Sqrt
	.type	Sqrt, @function
Sqrt:
	push	rbp								 ; ������ �������
	mov	rbp, rsp

	movsd	QWORD PTR -24[rbp], xmm0		; ���������� �������� number
	pxor	xmm0, xmm0						; ��������� xmm0
	ucomisd	xmm0, QWORD PTR -24[rbp]		; �������� number == 0
	jp	.L2									; ��������� �� ����� L2, ���� �������

	pxor	xmm0, xmm0						; ��������� xmm0
	ucomisd	xmm0, QWORD PTR -24[rbp]		; �������� number == 0
	jne	.L2									; ������� �� ����� L2, ���� ��� �� �����
	pxor	xmm0, xmm0						; ��������� xmm0
	jmp	.L4									
.L2:
	movsd	xmm0, QWORD PTR -24[rbp]		; ���� �������� number
	movsd	xmm1, QWORD PTR .LC1[rip]		; ���� �������� 1
	comisd	xmm0, xmm1						; � xmm0 ����� number, � xmm1 ����� 1. ��� ������������
	jb	.L14								; ���� number < 1, �� ������� � L14 (else)

	movsd	xmm0, QWORD PTR -24[rbp]		; ���� �������� number � �������� � xmm0
	movsd	xmm1, QWORD PTR .LC2[rip]		; ���� �������� 2 � �������� � xmm1
	divsd	xmm0, xmm1						; ����� number �� 2
	movsd	QWORD PTR -8[rbp], xmm0			; ��������� ��������� �� xmm0 � ���� (���������� result)

	mov	DWORD PTR -16[rbp], 0				; �������������� i = 0
	jmp	.L7									; ������� � ������� ����� for
	
.L8:										; ���� ����� for
	movsd	xmm0, QWORD PTR -24[rbp]		; ����� nnumber � ��������� � xmm0
	divsd	xmm0, QWORD PTR -8[rbp]			; ��������� number �� result
	movapd	xmm1, xmm0						; ����������� ��������� ������� � xmm1
	addsd	xmm1, QWORD PTR -8[rbp]			; ��������� � ���������� result
	movsd	xmm0, QWORD PTR .LC3[rip]		; ����� 0.5 (LC3)
	mulsd	xmm0, xmm1						; � �������� 0.5 �� result
	movsd	QWORD PTR -8[rbp], xmm0			; ��������� � result ���������
	add	DWORD PTR -16[rbp], 1				; i++

.L7:										; ������� ����� for
	movsd	xmm1, QWORD PTR -24[rbp]		; �������� number � xmm1
	movsd	xmm0, QWORD PTR .LC3[rip]		; �������� 0.5 � xmm0
	mulsd	xmm0, xmm1						; �������� 0.5 � number
	cvttsd2si	eax, xmm0					; ����������� ���������� �� double � int

	add	eax, 1								; ��������� 1
	cmp	DWORD PTR -16[rbp], eax				; ���������� i � ����������� �� eax

	jle	.L8									; ���� i ������ ����������, �� ������� � ���� ����� for
	jmp	.L9									; ����� �� ����� for

.L14:										; else
	movsd	xmm0, QWORD PTR -24[rbp]		; ����� number � ��������� � xmm0
	movsd	QWORD PTR -8[rbp], xmm0			; ����������� number � result
	mov	DWORD PTR -12[rbp], 0				; ������������� i = 0 ��� ����� for
	jmp	.L10								; ������� � ������� ����� for

.L11:										; ���� ����� for
	movsd	xmm0, QWORD PTR -24[rbp]		; ����� number � ��������� � xmm0
	divsd	xmm0, QWORD PTR -8[rbp]			; ����� number �� result (-8[rbp])
	movapd	xmm1, xmm0						; ���������� ��������� ������� � xmm1
	addsd	xmm1, QWORD PTR -8[rbp]			; ���������� � ���������� ���������� result
	movsd	xmm0, QWORD PTR .LC3[rip]		; �������� 0.5 � xmm0
	mulsd	xmm0, xmm1						; �������� 0.5 � result
	movsd	QWORD PTR -8[rbp], xmm0			; ����������� result �������� ��������
	add	DWORD PTR -12[rbp], 1				; i++

.L10:										; ������� ����� for
	cmp	DWORD PTR -12[rbp], 49				; ������� i < 50
	jle	.L11								; ������� � ���� ����� for ���� ������
.L9:
	movsd	xmm0, QWORD PTR -8[rbp]			; return result
.L4:										; ������� �������� �� �������
	movq	rax, xmm0						; ��������� 0 � rax
	movq	xmm0, rax
	pop	rbp									; �������������� ��������� �����
	ret
	.size	Sqrt, .-Sqrt
	.section	.rodata
.LC4:
	.string	"number = "
	.align 8
.LC5:
	.string	"You input a not number.\nnumber = "
	.align 8
.LC6:
	.string	"You should input a positive number\nnumber = "
	.text
	.globl	inputNumber
	.type	inputNumber, @function
inputNumber:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax

	lea	rax, .LC4[rip]								; ��������� ��� ������
	mov	rdi, rax									; ��������� ��������� � �������
	mov	eax, 0										; ��� ������
	call	printf@PLT
.L21:
	lea	rax, -18[rbp]								; �����, ���� ������������ ����� ������� �������� (buf)
	mov	rdi, rax
	mov	eax, 0										; ��� ������
	call	gets@PLT								; ����� �������

	lea	rax, -18[rbp]								; ������� � ������� buf
	mov	rdi, rax
	call	atof@PLT								; �������� �������
	movq	rax, xmm0								; �������� �������� �� �������
	mov	QWORD PTR -32[rbp], rax						; ����������� number ��������� �������

	pxor	xmm0, xmm0								; �������� xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]
	jp	.L16										; �������� �� ������ ���. ��������� 

	pxor	xmm0, xmm0								; ��������� xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]				; ���������� number == 0
	jne	.L16										; ���������, ���� �� �����

	movzx	eax, BYTE PTR -18[rbp]					; ���� ������ �������� � ������� buf
	cmp	al, 48										; ���������� buf[0] == '0'
	je	.L16										; ��������� � (else if) ���� �����

	lea	rax, .LC5[rip]								; ���� ���������
	mov	rdi, rax									; ������� ��������� � �������
	mov	eax, 0										; ��� ��������
	call	printf@PLT								; ����� ������

	mov	BYTE PTR -33[rbp], 70						; is_correct = 'F'
	jmp	.L18										; ������� �� ������� ����� while

.L16:												; esle if (number < 0)
	pxor	xmm0, xmm0								; ��������� xmm0
	comisd	xmm0, QWORD PTR -32[rbp]				; ���������� number � 0
	jbe	.L26										; ��������� � else, ���� ������� number >= 0

	lea	rax, .LC6[rip]								; ���� ����� ���������
	mov	rdi, rax									; �������� ��������� � �������
	mov	eax, 0										; ��� ��������
	call	printf@PLT								;  ����� �������

	mov	BYTE PTR -33[rbp], 70						; is_correct = 'F'
	jmp	.L18										; ������� � ������� ����� while

.L26:
	mov	BYTE PTR -33[rbp], 84

.L18:												; �������� ����� while
	cmp	BYTE PTR -33[rbp], 70						; while(is_correct == 'F')
	je	.L21										; ���� �����, �� ������� � ���� ����� while

	movsd	xmm0, QWORD PTR -32[rbp]				; ��������� �������� number � xmm0
	movq	rax, xmm0								; �������� �������� � rax, ����� ��� �������

	mov	rdx, QWORD PTR -8[rbp]						; ���������� �� �� ����� �� �����
	sub	rdx, QWORD PTR fs:40
	je	.L23										; ���� �� ������ �� ��������, �� ��� � ������� �������
	call	__stack_chk_fail@PLT

.L23:												; ������� �������� �� �������
	movq	xmm0, rax								; return number
	leave
	ret
	.size	inputNumber, .-inputNumber
	.section	.rodata
	.align 8
.LC7:
	.string	"This program counts the square root of the number."
.LC8:
	.string	"\nResult = %f"
.LC9:
	.string	"\nFinish."
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp								; ������ �������
	mov	rbp, rsp
	sub	rsp, 16

	lea	rax, .LC7[rip]						; ���� ����� ���������
	mov	rdi, rax							; ������� ��������� � �������
	call	puts@PLT

	mov	eax, 0
	call	inputNumber
	movq	rax, xmm0						; ���������� �������� �� ������� 
	mov	QWORD PTR -16[rbp], rax				; ����������� number ��������� ������ �������

	mov	rax, QWORD PTR -16[rbp]				; ���� �������� number
	movq	xmm0, rax						; ������� �������� � ������� 
	call	Sqrt							; �������� �������
	movq	rax, xmm0						; ���������� ��������� ������ ������� (������� �������� � xmm0)
	mov	QWORD PTR -8[rbp], rax				; ����������� ��������� ���������� result

	mov	rax, QWORD PTR -8[rbp]				; ���� result
	movq	xmm0, rax						; ������� result � �������

	lea	rax, .LC8[rip]						; ���� ����� ���������� ���������
	mov	rdi, rax							; ������� ��������� � �������
	mov	eax, 1								; ��� ��������
	call	printf@PLT						; ����� �������

	lea	rax, .LC9[rip]						; ���� ����� ���������� ���������
	mov	rdi, rax							; ������� ��������� � �������
	call	puts@PLT						; �������� �������

	mov	eax, 0								; return 0

	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:										; �������� 1
	.long	0
	.long	1072693248
	.align 8
.LC2:										; �������� 2
	.long	0
	.long	1073741824
	.align 8
.LC3:										; �������� 0.5
	.long	0
	.long	1071644672
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
