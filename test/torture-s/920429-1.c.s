	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920429-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.load8_u	$push2=, 0($0)
	tee_local	$push13=, $1=, $pop2
	i32.const	$push0=, 1
	i32.shr_u	$push3=, $pop13, $pop0
	i32.const	$push12=, 1
	i32.and 	$push4=, $pop3, $pop12
	i32.store	$discard=, i($pop5), $pop4
	i32.const	$push11=, 0
	i32.const	$push6=, 7
	i32.and 	$push7=, $1, $pop6
	i32.const	$push10=, 1
	i32.add 	$push8=, $pop7, $pop10
	i32.store	$discard=, j($pop11), $pop8
	i32.const	$push9=, 1
	i32.add 	$push1=, $0, $pop9
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.store	$push1=, i($pop0), $pop4
	tee_local	$push3=, $0=, $pop1
	i32.const	$push2=, 2
	i32.store	$discard=, j($pop3), $pop2
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 3.9.0 "
