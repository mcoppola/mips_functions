#int sumr(int A[],int n)
#{
#  if (n == 1)
#    return A[0];
#  else
#    return A[0] + sumr(&A[1],n-1);
#}      

	

	.text
	.globl  main
main:
	sub	$sp,$sp,8	# push stack
	sw	$ra,0($sp)	# save return address

				# prepare parameters 
	la	$a0,A		# address of A
	la	$a1,n		# address of n
	lw	$a1,0($a1)	# load value of n
	jal	sumr		# call sumr function
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
	

# Sum array recursive.  Recursively add the elements of an integer array.
# Inputs:
#    A : address of an integer array.  Passed in $a0
#    n : positive integer.  n is the size of A.
# Outputs:
#    s : integer, equal to the sum of the elements in A.
#        returned in $v0.
# Notes:  Uses temporary registers $t0.  Recursive procedure.
	.text
sumr:
	li	$t0, 1
      bne	$a1, $t0, rec	# if (n > 1) then recurse
	lw	$t0,0($a0)		# Base case:
	move	$v0,$t0		# return s=A[0]
      jr	$ra

rec:
	sub	$sp,$sp,12		# push stack
	sw	$ra,0($sp)		# save $ra
	sw	$a0,4($sp)		# save argument registers
	sw	$a1,8($sp)

      addi	$a0,$a0,4		# point to next element in array
	addi	$a1,$a1,-1		# n = n - 1
	jal	sumr			# recursively call sumr

	lw	$a0, 4($sp)		# restore $a0 to original address of A
	lw	$t0, 0($a0)		# load A[0]
	add	$v0,$v0,$t0		# s = s + sumr(A+4,n-1)

	lw	$ra, 0($sp)		# restore $ra
	lw	$a1, 8($sp)
	add	$sp, $sp, 12	# pop stack
	jr	$ra			# return to calling function
	