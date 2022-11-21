	.file	"IHW_3_CPP.c"
	.intel_syntax noprefix
	.text
	.globl	Sqrt
	.type	Sqrt, @function
Sqrt:
	push	rbp									; ��������� ������ ��������� ���� � ����
	mov	rbp, rsp								; �������� �������� ��������� ����� � ��������� ����

	movsd	QWORD PTR -24[rbp], xmm0			; ���������� �������� (number) � �������
	movsd	xmm0, QWORD PTR -24[rbp]
	movsd	xmm1, QWORD PTR .LC0[rip]			; ����� �������� 1

	comisd	xmm0, xmm1							; � xmm0 ����� number, � xmm1 ����� 1. ��� ������������
	jb	.L11									; number < 1, �� ������� � L11 (else)

	movsd	xmm0, QWORD PTR -24[rbp]			; ��������� number � xmm0
	movsd	xmm1, QWORD PTR .LC1[rip]			; ��������� 2 � xmm1
	divsd	xmm0, xmm1							; number / 2
	movsd	QWORD PTR -8[rbp], xmm0				; ����������� � result ��������� �������

	mov	DWORD PTR -16[rbp], 0					; int i = 0
	jmp	.L4										; �������� � �������� ����� for

.L5:											; ���� ����� for
	movsd	xmm0, QWORD PTR -24[rbp]			; ����� number
	divsd	xmm0, QWORD PTR -8[rbp]				; ���������( number / result) � ��������� � xmm0
	movapd	xmm1, xmm0							; ��������� � ����������� � xmm0
	addsd	xmm1, QWORD PTR -8[rbp]				; result + (number/result)
	movsd	xmm0, QWORD PTR .LC2[rip]			; ����� ����� 0.5 � ����������� � xmm0
	mulsd	xmm0, xmm1							; �������� ���� ��������� �� xmm1 �� 0.5
	movsd	QWORD PTR -8[rbp], xmm0				; �� ��������� � ���������� result
	add	DWORD PTR -16[rbp], 1					; i++

.L4:											; �������� ����� for
	movsd	xmm1, QWORD PTR -24[rbp]			; ����� number
	movsd	xmm0, QWORD PTR .LC2[rip]			; ����� 0.5
	mulsd	xmm0, xmm1							; number * 0.5
	cvttsd2si	eax, xmm0						; ����������� �� double � int
	cmp	DWORD PTR -16[rbp], eax					; i < (int) (number * 0.5)
	jl	.L5										; ���� ������, �� ������� � ����
	jmp	.L6										; ����� �� �����, ������� ������ �� ���������

.L11:											; else
	movsd	xmm0, QWORD PTR -24[rbp]			; ����� number
	movsd	QWORD PTR -8[rbp], xmm0				; ��������� number � result
	mov	DWORD PTR -12[rbp], 0					; i = 0
	jmp	.L7										;  ������� � �������� ���� for

.L8:											; ���� ����� for
	movsd	xmm0, QWORD PTR -24[rbp]			; ����� number
	divsd	xmm0, QWORD PTR -8[rbp]				; ��������� number �� result
	movapd	xmm1, xmm0							; ���������
	addsd	xmm1, QWORD PTR -8[rbp]				; result + (number/result)
	movsd	xmm0, QWORD PTR .LC2[rip]			; ����� 0.5
	mulsd	xmm0, xmm1							; �������� 0.5 �� ���������, ������� ����� � xmm0
	movsd	QWORD PTR -8[rbp], xmm0				; ��������� �� � result
	add	DWORD PTR -12[rbp], 1					; i++

.L7:											; �������� ���� for
	cmp	DWORD PTR -12[rbp], 49					; ��������� (i < 50)
	jle	.L8										; ����� i != 49, �� ������� � ���� ����� for
.L6:
	movsd	xmm0, QWORD PTR -8[rbp]				; ����� �������� result
	movq	rax, xmm0							; ����������� ������������ �������� � rax
	movq	xmm0, rax
	pop	rbp										; ������ ������ ��������� ���� �� ����� � �������� � rbp
	ret
	.size	Sqrt, .-Sqrt
	.section	.rodata
.LC3:
	.string	"number = "
	.align 8
.LC5:
	.string	"You input a not number.\nnumber = "
	.align 8
.LC6:
	.string	"You should input a pusitive number\nnumber = "
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

	lea	rax, .LC3[rip]								; ��������� ��� ������
	mov	rdi, rax									; ��������� ��������� � �������
	mov	eax, 0										; ��� ������
	call	printf@PLT
.L18:
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
	ucomisd	xmm0, QWORD PTR -32[rbp]				; ���������� number == 0	���_�� �������� 
	jp	.L13										; ��������� �� ����� L13, ���� ������� �������

	pxor	xmm0, xmm0								; �������� xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]				; ��������� number == 0
	jne	.L13										; ������� ���� �� �����

	movzx	eax, BYTE PTR -18[rbp]					; ���� ������ ������� �������
	cmp	al, 48										; ���������� � ��������
	je	.L13										; ������� ���� (buf[0] == '0' )

	lea	rax, .LC5[rip]								; ����� ����� ���������
	mov	rdi, rax									; ��������� ��������� � �������
	mov	eax, 0										; ��� ��������
	call	printf@PLT								; ������� �������

	mov	BYTE PTR -33[rbp], 70						; is_correct = 'F' (�����������)
	jmp	.L15										; ������� � ������� ����� while

.L13:												; ������� else if(number < 0)
	pxor	xmm0, xmm0								; �������� xmm0
	comisd	xmm0, QWORD PTR -32[rbp]				; ���������� number < 0
	jbe	.L23										; ������� ���� >= (�� ���� ��������� ��������)

	lea	rax, .LC6[rip]								; ����� ������ ���������
	mov	rdi, rax
	mov	eax, 0										; ��� ��������
	call	printf@PLT								; ����� �������

	mov	BYTE PTR -33[rbp], 70						; ������������ is_correct = 'F'
	jmp	.L15										; ������� � ������� ����� while

.L23:												; else 
	mov	BYTE PTR -33[rbp], 84						; is_correct = 'T'

.L15:												; ������� ����� while
	cmp	BYTE PTR -33[rbp], 70						; is_correct == 'F'
	je	.L18										; �������, ���� ������� �����

	movsd	xmm0, QWORD PTR -32[rbp]				; ���� �������� number
	movq	rax, xmm0								; return number
	mov	rdx, QWORD PTR -8[rbp]						; ���������� �� �� ����� �� �����
	sub	rdx, QWORD PTR fs:40
	je	.L20										; ������� � ����� ������� inputNumber
	call	__stack_chk_fail@PLT
.L20:												; ����� ������� inputNumber
	movq	xmm0, rax
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
	push	rbp
	mov	rbp, rsp

	sub	rsp, 16

	lea	rax, .LC7[rip]						; ����� ����� ���������
	mov	rdi, rax							; ������� ��������� � �������	
	call	puts@PLT						; ����� ������
	
	mov	eax, 0
	call	inputNumber
	movq	rax, xmm0						; ������� �������� �� �������
	mov	QWORD PTR -16[rbp], rax				; ��������� ��������� ������ ������� � number

	mov	rax, QWORD PTR -16[rbp]				; ����� number
	movq	xmm0, rax						; �������� number � �������
	call	Sqrt							; ������� �������
	movq	rax, xmm0						; ������� ��������� �� �������
	mov	QWORD PTR -8[rbp], rax				; ��������� ��������� ������ ������� � result

	mov	rax, QWORD PTR -8[rbp]				; ����� number
	movq	xmm0, rax						; �������� �������� number � �������
	lea	rax, .LC8[rip]						; ����� ����� ���������
	mov	rdi, rax							; �������� ��������� � �������
	mov	eax, 1
	call	printf@PLT						; ������� �������

	lea	rax, .LC9[rip]						; ����� ����� ���������
	mov	rdi, rax							; �������� ��������� � �������
	call	puts@PLT						; ������� �������

	mov	eax, 0								; return 0;
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:										; �������� 1
	.long	0
	.long	1072693248
	.align 8
.LC1:										; �������� 2
	.long	0
	.long	1073741824
	.align 8
.LC2:										; �������� 0.5
	.long	0
	.long	1071644672
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
