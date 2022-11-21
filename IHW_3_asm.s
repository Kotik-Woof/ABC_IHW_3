	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	Sqrt
	.type	Sqrt, @function
Sqrt:
	push	rbp					 ; пролог функции
	mov	rbp, rsp

	movsd	QWORD PTR -24[rbp], xmm0		; формальный параметр number
	pxor	xmm0, xmm0				; обнуление xmm0
	ucomisd	xmm0, QWORD PTR -24[rbp]		; сравнине number == 0
	jp	.L2					; переходим на метку L2, если нечётно

	pxor	xmm0, xmm0				; обнуление xmm0
	ucomisd	xmm0, QWORD PTR -24[rbp]		; сравнине number == 0
	jne	.L2					; переход на метку L2, если они не равны
	pxor	xmm0, xmm0				; обнуление xmm0
	jmp	.L4									
.L2:
	movsd	xmm0, QWORD PTR -24[rbp]		; берём значение number
	movsd	xmm1, QWORD PTR .LC1[rip]		; берём значение 1
	comisd	xmm0, xmm1				; в xmm0 лежит number, в xmm1 лежит 1. Они сравниваются
	jb	.L14					; если number < 1, то переход в L14 (else)

	movsd	xmm0, QWORD PTR -24[rbp]		; берём значение number и помещаем в xmm0
	movsd	xmm1, QWORD PTR .LC2[rip]		; берём значение 2 и помещаем в xmm1
	divsd	xmm0, xmm1				; делим number на 2
	movsd	QWORD PTR -8[rbp], xmm0			; сохраняем результат из xmm0 в стек (переменная result)

	mov	DWORD PTR -16[rbp], 0			; инициализируем i = 0
	jmp	.L7					; переход в условие цикла for
	
.L8:							; тело цикла for
	movsd	xmm0, QWORD PTR -24[rbp]		; взяли nnumber и поместили в xmm0
	divsd	xmm0, QWORD PTR -8[rbp]			; разделили number на result
	movapd	xmm1, xmm0				; переместили результат деления в xmm1
	addsd	xmm1, QWORD PTR -8[rbp]			; прибавили к результату result
	movsd	xmm0, QWORD PTR .LC3[rip]		; взяли 0.5 (LC3)
	mulsd	xmm0, xmm1				; и умножили 0.5 на result
	movsd	QWORD PTR -8[rbp], xmm0			; сохранили в result результат
	add	DWORD PTR -16[rbp], 1			; i++

.L7:							; условие цикла for
	movsd	xmm1, QWORD PTR -24[rbp]		; помещаем number в xmm1
	movsd	xmm0, QWORD PTR .LC3[rip]		; помещаем 0.5 в xmm0
	mulsd	xmm0, xmm1				; умножаем 0.5 и number
	cvttsd2si	eax, xmm0			; конвертация результата из double в int

	add	eax, 1					; прибавили 1
	cmp	DWORD PTR -16[rbp], eax			; сравниваем i с результатом из eax

	jle	.L8					; если i меньше результата, то заходим в тело цикла for
	jmp	.L9					; выход из цикла for

.L14:							; else
	movsd	xmm0, QWORD PTR -24[rbp]		; взяли number и поместили в xmm0
	movsd	QWORD PTR -8[rbp], xmm0			; переместили number в result
	mov	DWORD PTR -12[rbp], 0			; инициализация i = 0 для цикла for
	jmp	.L10					; переход в условие цилка for

.L11:							; тело цикла for
	movsd	xmm0, QWORD PTR -24[rbp]		; взяли number и поместили в xmm0
	divsd	xmm0, QWORD PTR -8[rbp]			; делим number на result (-8[rbp])
	movapd	xmm1, xmm0				; перемещаем результат деления в xmm1
	addsd	xmm1, QWORD PTR -8[rbp]			; прибавляем к результату переменную result
	movsd	xmm0, QWORD PTR .LC3[rip]		; помещаем 0.5 в xmm0
	mulsd	xmm0, xmm1				; умножаем 0.5 и result
	movsd	QWORD PTR -8[rbp], xmm0			; присваиваем result резултат операции
	add	DWORD PTR -12[rbp], 1			; i++

.L10:							; условие цикла for
	cmp	DWORD PTR -12[rbp], 49			; строчка i < 50
	jle	.L11					; переход в тело цикла for если меньше
.L9:
	movsd	xmm0, QWORD PTR -8[rbp]			; return result
.L4:							; возврат значения из функции
	movq	rax, xmm0				; переносим 0 в rax
	movq	xmm0, rax
	pop	rbp					; востанавливаем указатель стека
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

	lea	rax, .LC4[rip]				; сообщение для вывода
	mov	rdi, rax				; переносим сообщение в функцию
	mov	eax, 0					; код выхода
	call	printf@PLT
.L21:
	lea	rax, -18[rbp]				; место, куда пользователь будет вводить значение (buf)
	mov	rdi, rax
	mov	eax, 0					; код выхода
	call	gets@PLT				; вызов функции

	lea	rax, -18[rbp]				; передаём в функцию buf
	mov	rdi, rax
	call	atof@PLT				; вызываем функцию
	movq	rax, xmm0				; получаем значение из функции
	mov	QWORD PTR -32[rbp], rax			; присваиваем number результат функции

	pxor	xmm0, xmm0				; обнуляем xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]
	jp	.L16					; проверка на чётный бит. Переходим 

	pxor	xmm0, xmm0				; обнуление xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]		; сравниваем number == 0
	jne	.L16					; переходим, если не равно

	movzx	eax, BYTE PTR -18[rbp]			; берём первое значение в массиве buf
	cmp	al, 48					; сравниваем buf[0] == '0'
	je	.L16					; Переходим в (else if) если равно

	lea	rax, .LC5[rip]				; берём сообщение
	mov	rdi, rax				; заносим сообщение в функцию
	mov	eax, 0					; код возврата
	call	printf@PLT				; вызов функии

	mov	BYTE PTR -33[rbp], 70			; is_correct = 'F'
	jmp	.L18					; переход на условие цикла while

.L16:							; esle if (number < 0)
	pxor	xmm0, xmm0				; обнуление xmm0
	comisd	xmm0, QWORD PTR -32[rbp]		; сравниваем number и 0
	jbe	.L26					; переходим в else, если условие number >= 0

	lea	rax, .LC6[rip]				; берём адрес сообщения
	mov	rdi, rax				; передача сообщения в функцию
	mov	eax, 0					; код возврата
	call	printf@PLT				;  вызов функции

	mov	BYTE PTR -33[rbp], 70			; is_correct = 'F'
	jmp	.L18					; переход в условие цикла while

.L26:
	mov	BYTE PTR -33[rbp], 84

.L18:							; услоивие цикла while
	cmp	BYTE PTR -33[rbp], 70			; while(is_correct == 'F')
	je	.L21					; если равно, то заходим в тело цикла while

	movsd	xmm0, QWORD PTR -32[rbp]		; переносим значение number в xmm0
	movq	rax, xmm0				; копируем значение в rax, чтобы его вернуть

	mov	rdx, QWORD PTR -8[rbp]			; возвращаем всё из стека на место
	sub	rdx, QWORD PTR fs:40
	je	.L23					; если со стеком всё впорядке, то идём в возврат функции
	call	__stack_chk_fail@PLT

.L23:							; возврат значения из функции
	movq	xmm0, rax				; return number
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
	push	rbp					; пролог функции
	mov	rbp, rsp
	sub	rsp, 16

	lea	rax, .LC7[rip]				; берём адрес сообщения
	mov	rdi, rax				; передаём сообщение в функцию
	call	puts@PLT

	mov	eax, 0
	call	inputNumber
	movq	rax, xmm0				; возвращаем значение из фунцкии 
	mov	QWORD PTR -16[rbp], rax			; присваиваем number результат работы функции

	mov	rax, QWORD PTR -16[rbp]			; берём значение number
	movq	xmm0, rax				; передаём занчение в функцию 
	call	Sqrt					; вызываем функцию
	movq	rax, xmm0				; возвращаем результат работы функции (который хранится в xmm0)
	mov	QWORD PTR -8[rbp], rax			; присваиваем результат переменной result

	mov	rax, QWORD PTR -8[rbp]			; берём result
	movq	xmm0, rax				; передаём result в функцию

	lea	rax, .LC8[rip]				; берём адрес текстового сообщения
	mov	rdi, rax				; передаём сообщение в функцию
	mov	eax, 1					; код возврата
	call	printf@PLT				; вызов функции

	lea	rax, .LC9[rip]				; берём адрес текстового сообщения
	mov	rdi, rax				; передаём сообщение в функцию
	call	puts@PLT				; вызываем функцию

	mov	eax, 0					; return 0

	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:							; значение 1
	.long	0
	.long	1072693248
	.align 8
.LC2:							; значение 2
	.long	0
	.long	1073741824
	.align 8
.LC3:							; значение 0.5
	.long	0
	.long	1071644672
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
