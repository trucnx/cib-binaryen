	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950915-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load32_s	$push2=, b($pop0)
	i32.const	$push7=, 0
	i64.load32_s	$push1=, a($pop7)
	i64.mul 	$push3=, $pop2, $pop1
	i64.const	$push4=, 16
	i64.shr_u	$push5=, $pop3, $pop4
	i32.wrap/i64	$push6=, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push9=, 0
	i64.load32_s	$push1=, b($pop9)
	i32.const	$push8=, 0
	i64.load32_s	$push0=, a($pop8)
	i64.mul 	$push2=, $pop1, $pop0
	i64.const	$push3=, 16
	i64.shr_u	$push4=, $pop2, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	100000                  # 0x186a0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	21475                   # 0x53e3
	.size	b, 4


	.ident	"clang version 3.9.0 "
