# Matthew Coppola
# CS281 - G1
# Min/Max recursive funtion


#REGISTER USAGE
#
#t0 = address of array "numbers"
#t1 = 4 + t0
#t2 = loop index (min_max)
#t3 = starting point * 4
#t4 = array[i]
#t5 = conditional register
#t6 = size of array - starting point of array
#t7 = 2
#
#a0 = min
#a1 = max
#a2 = starting point of array 
#a3 = ending point of array
#
#s0 = min during loop
#s1 = max during loop
#s2 = min1
#s3 = max1
#s4 = min2
#s5 = max2

#s7 = saved n


	.data
numbers:	.word 5,2,3,28,3,6,20,8,9  #array of numbers to find min/max of
strMin:
	.asciiz "min = "
strMax:
	.asciiz " max = "		

	.text           # assembly directive that indicates what follows are instructions
	.globl  main    # assembly directive that makes the symbol main global
main:               # assembly label
	sub	$sp,$sp,8	# push stack to save registers needed by the system code that called main
	sw	$ra,0($sp)	# save return address

	li	$a0,0		# a0 = min, initialized at 0
	li	$a1,0		# a1 = max, initialized at 0
	li  $a2,0		# a2 = starting point of array
	li  $a3,9		# a3 = ending point of array
	li  $s2,0
	li  $s3,0
	li	$s4,0
	li	$s5,0
	li  $s7,9		# s7 = size of array
	li $t7, 2 		# t7 = 2 for div in min_max
	
	jal	min_max		# call subroutine min_max

	sw	$v0,4($sp)  # min returned in $v0 and stored on the stack
	li	$v0,4       # the argument to a system call is placed in register $v0
                        # The value 4 tells syscall to print a string
	la	$a0,strMin     # pseudo-instruction to load the address of the label str
                        # The address of the string must be placed in register $a0
	syscall           # system call to print the string at address str

	li	$v0,1       # The value 1 tells syscall to print an integer
	lw	$a0,4($sp)  # Load the min from the stack to register $a0 
	syscall           # System call to print the integer in register $a0

	sw	$v1,8($sp)  # max returned in $v0 and stored on the stack
	li	$v0,4       # the argument to a system call is placed in register $v0
                        # The value 4 tells syscall to print a string
	la	$a0,strMax     # pseudo-instruction to load the address of the label str
                        # The address of the string must be placed in register $a0
	syscall           # system call to print the string at address str

	li	$v0,1       # The value 1 tells syscall to print an integer
	lw	$a0,8($sp)  # Load the sum from the stack to register $a0 
	syscall           # System call to print the integer in register $a0
	
	lw	$ra,0($sp)	# restore return address used to jump back to system
	add	$sp,$sp,8	# pop stack to prepare for the return to the system
	jr	$ra         # [jump register] return to the system 


min_max:
	sub	$sp,$sp,4   	# Push stack to create room to save register $s0
	sw	$s0,0($sp)  	# save $s0 on stack

	la $t0,numbers		# reset address of numbers
	mul $t3,$a2,4		# starting point*4 for accessing array
	add $t0,$t0,$t3		# set address of t0 at starting point
	#sub $a2,$s7,$a2		# a2 = n = (starting point - size of array)
    loop:
    	beq $a3, 1, none		#if n == 1, set only value as min/max and end
    	beq $a3, 2, ntwo		#if n == 2

    	#first recursive call (set arguments then jal)
    	lw $s6, 0($a3)	# save n in s6
    	lw $a0, 0($s2)	# a0 = min1
    	lw $a1, 0($s3)	# a1 = max1
    	div $a2, $t7 		# n/2
    	mflo $a3		# a3 = n/2
    	li $a2, 0		# a2 = 0
    	jal min_max

    	#second recursive call (set arguments then jal)
    	lw $a0, 0($s4)	# a0 = min2
    	lw $a1, 0($s5)	# a1 = max2
    	lw $a2, 0($a3)   # a2 = n/2 previously in a3
    	lw $a3, 0($s7)	# a3 = n (stored in s7)
    	jal min_max

    	slt $t5, $s2, $s4
    	beq $t4, 1, setmin1
    	j setmin2
    maxend:
    	slt $t5, $s3, $s5
    	beq $t4, 1, setmax1
    	j setmax2

	end:
		add	$v0,$s0,$zero	# return min to v0
		add	$v1,$s1,$zero	# return max to v1

		lw	$s0,0($sp)  # restore $s0 to value prior to function call
		add	$sp,$sp,4   # pop stack
		jr	$ra         # return to calling procedure

	setmin1:
		lw $s0, ($s2) 	# min = min1
		j maxend
	setmin2:
		lw $s0, ($s4) 	# min = min2
		j maxend
	setmax1:
		lw $s1, ($s3) 	# min = min1
		j end
	setmax:
		lw $s1, ($s5) 	# min = min2
		j end

	none:
    	lw $s0, ($t0)		#load array[0] into min (s0)
		lw $s1, ($t0)		#load array[0] into max (s1)
		j  end
	ntwo:
		addi $t1, $t0, 4
		slt $t5, $t0, $t1	# if array[0] < array[i]
    	beq $t5, 1, set01	# if ^ is true go to setmin
    	j set10
	set01:
		lw $s0, 0($t0)	# min = array[0]
		lw $s1, 4($t0)	# max = array[1]
		j end
	set10:
		lw $s0, 4($t0)	# min = array[0]
		lw $s1, 0($t0)	# max = array[1]
		j end