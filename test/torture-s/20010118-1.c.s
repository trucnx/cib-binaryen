	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010118-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.load	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	$pop1, 0        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 0($pop3)
	i32.eq  	$push5=, $pop4, $2
	br_if   	$pop5, 1        # 1: down to label0
.LBB1_2:                                # %if.then
	end_block                       # label1:
	i32.load	$push6=, 16($0)
	f64.convert_s/i32	$push8=, $pop6
	f64.const	$push9=, 0x0p0
	f64.mul 	$push10=, $pop8, $pop9
	f64.const	$push11=, 0x1p-1
	f64.mul 	$push12=, $pop10, $pop11
	i32.trunc_s/f64	$5=, $pop12
	i32.load	$push7=, 20($0)
	f64.convert_s/i32	$push13=, $pop7
	f64.const	$push21=, 0x0p0
	f64.mul 	$push14=, $pop13, $pop21
	f64.const	$push20=, 0x1p-1
	f64.mul 	$push15=, $pop14, $pop20
	i32.trunc_s/f64	$6=, $pop15
	i32.add 	$push16=, $5, $1
	i32.store	$discard=, 0($0), $pop16
	i32.const	$push18=, 4
	i32.add 	$push19=, $0, $pop18
	i32.add 	$push17=, $6, $2
	i32.store	$discard=, 0($pop19), $pop17
	i32.store	$discard=, 8($0), $3
	i32.store	$discard=, 12($0), $4
.LBB1_3:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
