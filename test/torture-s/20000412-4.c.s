	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.sub 	$push0=, $0, $2
	tee_local	$push17=, $7=, $pop0
	i32.const	$push16=, 0
	i32.gt_s	$push1=, $pop17, $pop16
	tee_local	$push15=, $6=, $pop1
	i32.const	$push14=, 0
	i32.select	$push12=, $pop15, $7, $pop14
	tee_local	$push13=, $5=, $pop12
	i32.const	$push2=, 3
	i32.ge_s	$push3=, $pop13, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push19=, 0
	i32.select	$push4=, $6, $7, $pop19
	i32.add 	$push5=, $2, $pop4
	i32.const	$push18=, -1
	i32.add 	$push6=, $pop5, $pop18
	i32.sub 	$push7=, $pop6, $0
	i32.mul 	$push8=, $3, $pop7
	i32.add 	$push9=, $2, $pop8
	i32.sub 	$2=, $pop9, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$2=, $2, $3
	i32.const	$push22=, -1
	i32.le_s	$push10=, $2, $pop22
	br_if   	$pop10, 1       # 1: down to label2
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push21=, 1
	i32.add 	$5=, $5, $pop21
	i32.const	$push20=, 2
	i32.le_s	$push11=, $5, $pop20
	br_if   	$pop11, 0       # 0: up to label1
	br      	2               # 2: down to label0
.LBB0_4:                                # %if.then
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %for.cond6.preheader
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %for.cond.i.2.1
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
