	.section	__TEXT,__text,regular,pure_instructions
	.globl	_printd
	.align	4, 0x90
_printd:                                ## @printd
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	calll	L0$pb
L0$pb:
	popl	%eax
	movl	8(%ebp), %ecx
	leal	L_.str-L0$pb(%eax), %eax
	movl	%ecx, -4(%ebp)
	movl	-4(%ebp), %ecx
	movl	%eax, (%esp)
	movl	%ecx, 4(%esp)
	calll	_printf
	addl	$24, %esp
	popl	%ebp
	retl

	.globl	_get_char_at
	.align	4, 0x90
_get_char_at:                           ## @get_char_at
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	12(%ebp), %eax
	movl	8(%ebp), %ecx
	movl	%ecx, -4(%ebp)
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	-4(%ebp), %ecx
	movsbl	(%ecx,%eax), %eax
	addl	$8, %esp
	popl	%ebp
	retl

	.globl	_put_char_at
	.align	4, 0x90
_put_char_at:                           ## @put_char_at
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$12, %esp
	movl	16(%ebp), %eax
	movl	12(%ebp), %ecx
	movl	8(%ebp), %edx
	movl	%edx, -8(%ebp)
	movl	%ecx, -12(%ebp)
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movb	%al, %bl
	movl	-12(%ebp), %eax
	movl	-8(%ebp), %ecx
	movb	%bl, (%ecx,%eax)
	movl	-16(%ebp), %eax
	addl	$12, %esp
	popl	%ebx
	popl	%ebp
	retl

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"


.subsections_via_symbols
