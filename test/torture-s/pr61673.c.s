	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61673.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -121
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, 84
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load8_s	$push0=, 0($0)
	tee_local	$push4=, $0=, $pop0
	i32.const	$push1=, -1
	i32.gt_s	$push2=, $pop4, $pop1
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push3=, 0
	i32.store8	$discard=, e($pop3), $0
.LBB1_2:                                # %if.end
	end_block                       # label1:
	call    	bar@FUNCTION, $0
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load8_s	$push0=, 0($0)
	tee_local	$push4=, $0=, $pop0
	i32.const	$push1=, -1
	i32.gt_s	$push2=, $pop4, $pop1
	br_if   	$pop2, 0        # 0: down to label2
# BB#1:                                 # %if.then
	i32.const	$push3=, 0
	i32.store8	$discard=, e($pop3), $0
.LBB2_2:                                # %if.end
	end_block                       # label2:
	return
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push0=, 33
	i32.store8	$0=, e($pop18), $pop0
	i32.const	$push1=, main.c
	call    	foo@FUNCTION, $pop1
	block
	i32.const	$push17=, 0
	i32.load8_u	$push2=, e($pop17)
	i32.ne  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push4=, main.c+1
	call    	foo@FUNCTION, $pop4
	block
	i32.const	$push19=, 0
	i32.load8_u	$push5=, e($pop19)
	i32.const	$push6=, 135
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label4
# BB#2:                                 # %if.end6
	i32.const	$push21=, 0
	i32.const	$push8=, 33
	i32.store8	$0=, e($pop21), $pop8
	i32.const	$push9=, main.c
	call    	baz@FUNCTION, $pop9
	block
	i32.const	$push20=, 0
	i32.load8_u	$push10=, e($pop20)
	i32.ne  	$push11=, $0, $pop10
	br_if   	$pop11, 0       # 0: down to label5
# BB#3:                                 # %if.end11
	i32.const	$push12=, main.c+1
	call    	baz@FUNCTION, $pop12
	block
	i32.const	$push22=, 0
	i32.load8_u	$push13=, e($pop22)
	i32.const	$push14=, 135
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label6
# BB#4:                                 # %if.end16
	i32.const	$push16=, 0
	return  	$pop16
.LBB3_5:                                # %if.then15
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then10
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB3_7:                                # %if.then5
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB3_8:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1

	.type	main.c,@object          # @main.c
	.section	.rodata.main.c,"a",@progbits
main.c:
	.ascii	"T\207"
	.size	main.c, 2


	.ident	"clang version 3.9.0 "
