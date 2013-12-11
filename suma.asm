#int suma(int A[],int n)
#{
#  int s = 0;
#  int i;
#
#  for (i=0;i<n;i++)
#    s = s + A[i];
#  return s;
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
	jal	suma		# call suma function
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
	

# Sum array.  Add the elements of an integer array.
# Inputs:
#    A : address of an integer array.  Passed in $a0
#    n : positive integer.  n is the size of A.
# Outputs:
#    s : integer, equal to the sum of the elements in A.
#        stored in $s0 and returned in $v0.
# Notes:  Uses temporary registers $t0-$t3.  Leaf procedure.
	.text
suma:
	sub	$sp,$sp,4	# push stack
	sw	$s0,0($sp)	# save $s0
	
	move	$t0,$zero	      # i = 0
	add	$s0,$zero,$zero	# $s0 = s = 0
Loop: add   $t1, $t0, $t0     # $t1 = i*2
      add   $t1, $t1, $t1     # $t1 = i*4
      add   $t2, $a0, $t1     # $t2 = &array[i]
      lw    $t3, 0($t2)       # s = s + array[i]
      add	$s0, $s0, $t3
      addi  $t0, $t0, 1       # i = i + 1
      slt   $t3, $t0, $a1     # if i < n goto Loop
      bne   $t3, $zero, Loop

	move	$v0,$s0		# return s	
	lw	$s0,0($sp)		# restore $s0
	add	$sp,$sp,4		# pop stack
	jr	$ra			# return to calling function
	