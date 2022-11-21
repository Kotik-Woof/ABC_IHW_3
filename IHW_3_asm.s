	.file	"IHW_3_CPP.c"
	.intel_syntax noprefix
	.text
	.globl	Sqrt
	.type	Sqrt, @function
Sqrt:
	push	rbp									; сохранили старый указатель базы в стек
	mov	rbp, rsp								; копируем значение указателя стека в указатель базы

	movsd	QWORD PTR -24[rbp], xmm0			; формальный параметр (number) в функции
	movsd	xmm0, QWORD PTR -24[rbp]
	movsd	xmm1, QWORD PTR .LC0[rip]			; взяли значение 1

	comisd	xmm0, xmm1							; в xmm0 лежит number, в xmm1 лежит 1. Они сравниваются
	jb	.L11									; number < 1, то переход в L11 (else)

	movsd	xmm0, QWORD PTR -24[rbp]			; поместили number в xmm0
	movsd	xmm1, QWORD PTR .LC1[rip]			; поместили 2 в xmm1
	divsd	xmm0, xmm1							; number / 2
	movsd	QWORD PTR -8[rbp], xmm0				; переместили в result результат деления

	mov	DWORD PTR -16[rbp], 0					; int i = 0
	jmp	.L4										; прыгнули в проверку цилка for

.L5:											; тело цикла for
	movsd	xmm0, QWORD PTR -24[rbp]			; взяли number
	divsd	xmm0, QWORD PTR -8[rbp]				; разделили( number / result) и поместили в xmm0
	movapd	xmm1, xmm0							; выровняли и переместили в xmm0
	addsd	xmm1, QWORD PTR -8[rbp]				; result + (number/result)
	movsd	xmm0, QWORD PTR .LC2[rip]			; взяли чилсо 0.5 и переместили в xmm0
	mulsd	xmm0, xmm1							; умножили весь результат из xmm1 на 0.5
	movsd	QWORD PTR -8[rbp], xmm0				; всё сохранили в переменной result
	add	DWORD PTR -16[rbp], 1					; i++

.L4:											; провекра цилка for
	movsd	xmm1, QWORD PTR -24[rbp]			; взяли number
	movsd	xmm0, QWORD PTR .LC2[rip]			; число 0.5
	mulsd	xmm0, xmm1							; number * 0.5
	cvttsd2si	eax, xmm0						; конвертация из double в int
	cmp	DWORD PTR -16[rbp], eax					; i < (int) (number * 0.5)
	jl	.L5										; если меньше, то заходим в цикл
	jmp	.L6										; выход из цикла, переход дальше по программе

.L11:											; else
	movsd	xmm0, QWORD PTR -24[rbp]			; взяли number
	movsd	QWORD PTR -8[rbp], xmm0				; сохранили number в result
	mov	DWORD PTR -12[rbp], 0					; i = 0
	jmp	.L7										;  переход в проверку цила for

.L8:											; тело цикла for
	movsd	xmm0, QWORD PTR -24[rbp]			; взяли number
	divsd	xmm0, QWORD PTR -8[rbp]				; разделили number на result
	movapd	xmm1, xmm0							; выровняли
	addsd	xmm1, QWORD PTR -8[rbp]				; result + (number/result)
	movsd	xmm0, QWORD PTR .LC2[rip]			; взяли 0.5
	mulsd	xmm0, xmm1							; умножили 0.5 на результат, который лежал в xmm0
	movsd	QWORD PTR -8[rbp], xmm0				; сохранили всё в result
	add	DWORD PTR -12[rbp], 1					; i++

.L7:											; проверка цила for
	cmp	DWORD PTR -12[rbp], 49					; сравнение (i < 50)
	jle	.L8										; когда i != 49, то переход в тело цикла for
.L6:
	movsd	xmm0, QWORD PTR -8[rbp]				; взяли значение result
	movq	rax, xmm0							; переместили возвращаемое значение в rax
	movq	xmm0, rax
	pop	rbp										; достаём старый указатель базы из стека и помещаем в rbp
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

	lea	rax, .LC3[rip]								; сообщение для вывода
	mov	rdi, rax									; переносим сообщение в функцию
	mov	eax, 0										; код выхода
	call	printf@PLT
.L18:
	lea	rax, -18[rbp]								; место, куда пользователь будет вводить значение (buf)
	mov	rdi, rax
	mov	eax, 0										; код выхода
	call	gets@PLT								; вызов функции

	lea	rax, -18[rbp]								; передаём в функцию buf
	mov	rdi, rax
	call	atof@PLT								; вызываем функцию
	movq	rax, xmm0								; получаем значение из функции
	mov	QWORD PTR -32[rbp], rax						; присваиваем number результат функции

	pxor	xmm0, xmm0								; обнуляем xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]				; сравниваем number == 0	ЧТО_ТО СТРАННОЕ 
	jp	.L13										; переходим на метку L13, если условие неверно

	pxor	xmm0, xmm0								; обнуляем xmm0
	ucomisd	xmm0, QWORD PTR -32[rbp]				; сравнивем number == 0
	jne	.L13										; переход если не равно

	movzx	eax, BYTE PTR -18[rbp]					; берём первый элемент массива
	cmp	al, 48										; сравниваем с единицей
	je	.L13										; переход если (buf[0] == '0' )

	lea	rax, .LC5[rip]								; взяли адрес сообщения
	mov	rdi, rax									; поместили сообщение в функцию
	mov	eax, 0										; код возврата
	call	printf@PLT								; вызвали функцию

	mov	BYTE PTR -33[rbp], 70						; is_correct = 'F' (присваиваем)
	jmp	.L15										; переход в условие цикла while

.L13:												; условие else if(number < 0)
	pxor	xmm0, xmm0								; обнуляем xmm0
	comisd	xmm0, QWORD PTR -32[rbp]				; сравниваем number < 0
	jbe	.L23										; переход если >= (то если услововие неверное)

	lea	rax, .LC6[rip]								; взять адресс сообщения
	mov	rdi, rax
	mov	eax, 0										; код возврата
	call	printf@PLT								; вызов функции

	mov	BYTE PTR -33[rbp], 70						; присваивание is_correct = 'F'
	jmp	.L15										; переход в условие цикла while

.L23:												; else 
	mov	BYTE PTR -33[rbp], 84						; is_correct = 'T'

.L15:												; условие цикла while
	cmp	BYTE PTR -33[rbp], 70						; is_correct == 'F'
	je	.L18										; переход, если условие верно

	movsd	xmm0, QWORD PTR -32[rbp]				; берём значение number
	movq	rax, xmm0								; return number
	mov	rdx, QWORD PTR -8[rbp]						; возвращаем всё из стека на место
	sub	rdx, QWORD PTR fs:40
	je	.L20										; переход в конец функции inputNumber
	call	__stack_chk_fail@PLT
.L20:												; конец функции inputNumber
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

	lea	rax, .LC7[rip]						; взяли адрес сообщения
	mov	rdi, rax							; перенос сообщения в функцию	
	call	puts@PLT						; вызов фукции
	
	mov	eax, 0
	call	inputNumber
	movq	rax, xmm0						; вернули значение из функции
	mov	QWORD PTR -16[rbp], rax				; присвоили результат работы функции в number

	mov	rax, QWORD PTR -16[rbp]				; взяли number
	movq	xmm0, rax						; передали number в функцию
	call	Sqrt							; вызвали функцию
	movq	rax, xmm0						; вернули результат из фунцкии
	mov	QWORD PTR -8[rbp], rax				; присвоили результат работы функции в result

	mov	rax, QWORD PTR -8[rbp]				; взяли number
	movq	xmm0, rax						; передали значение number в функцию
	lea	rax, .LC8[rip]						; взяли адрес сообщения
	mov	rdi, rax							; передали сообщение в функцию
	mov	eax, 1
	call	printf@PLT						; вызвали функцию

	lea	rax, .LC9[rip]						; взяли адрес сообщения
	mov	rdi, rax							; передали сообщение в функцию
	call	puts@PLT						; вызвали функцию

	mov	eax, 0								; return 0;
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:										; значение 1
	.long	0
	.long	1072693248
	.align 8
.LC1:										; значение 2
	.long	0
	.long	1073741824
	.align 8
.LC2:										; значение 0.5
	.long	0
	.long	1071644672
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
