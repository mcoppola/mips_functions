#  int sump(int *A, int n)
#  {
#    int s = 0;
#    int *p;
#    for (p = &A[0];  p < &A[n];  p = p + 1)
#      s = s + *p;
#    return s;
#  } 
	

	.text
	.globl  main
main:
	sub	$sp,$sp,8	# push stack
	sw	$ra,0($sp)	# save return address

				# prepare parameters 
	la	$a0,A		# address of A
	la	$a1,n		# address of n
	lw	$a1,0($a1)	# load value of n
	jal	sump		# call sump function
	sw	$v0,4($sp)	# save return result

	li	$v0,4
	la	$a0,str
	syscall

	li	$v0,1
	lw	$a0,4($sp)
	syscall

	lw	$ra,0($sp)	# restore return address
	add	$sp,$sp,8	# pop stack
	jr	$ra

	.data
A:
	.word  1,2,3,4,5,6,7,8,9,10
n:	.word  10
str:	.asciiz "The sum of the elements in A = "
	

	.text
sump:
	sub	$sp,$sp,4	# push stack
	sw	$s0,0($sp)	# save $s0
	
	move	$t0,$a0		# p = &A[0]
	add	$t1,$a1,$a1	# $t1 = size * 2
	add	$t1,$t1,$t1	# $t1 = size * 4
	add	$t2,$t0,$t1	# $t2 = &A[size]
	add	$s0,$zero,$zero	# $s0 = s = 0
Loop:
	lw	$t3,0($t0)	# $t3 = memory[p]
	add	$s0,$s0,$t3	# s = s + *p
	add	$t0,$t0,4	# p = p + 1
	slt	$t1,$t0,$t2	# test if p < &A[size]
	bne	$t1,$zero,Loop	# if (p < &A[size]) goto L

	move	$v0,$s0		# return s	
	lw	$s0,0($sp)	# restore $s0
	add	$sp,$sp,4	# pop stack
	jr	$ra		# return to calling function
	