	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57829.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.or  	$push5=, $pop3, $pop4
	return  	$pop5
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.or  	$push5=, $pop3, $pop4
	return  	$pop5
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 63
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 5
	i32.shr_u	$push5=, $pop3, $pop4
	i32.const	$push6=, 4
	i32.or  	$push7=, $pop5, $pop6
	return  	$pop7
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	i32.call	$1=, f1, $0
	i32.const	$2=, 2
	block   	.LBB3_5
	i32.ne  	$push0=, $1, $2
	br_if   	$pop0, .LBB3_5
# BB#1:                                 # %lor.lhs.false
	i32.call	$push1=, f2, $0
	i32.ne  	$push2=, $pop1, $2
	br_if   	$pop2, .LBB3_5
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push3=, 63
	i32.call	$push4=, f3, $pop3
	i32.const	$push5=, 6
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, .LBB3_5
# BB#3:                                 # %lor.lhs.false6
	i32.call	$push7=, f3, $0
	i32.const	$push8=, 4
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, .LBB3_5
# BB#4:                                 # %if.end
	i32.const	$push10=, 0
	return  	$pop10
.LBB3_5:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits