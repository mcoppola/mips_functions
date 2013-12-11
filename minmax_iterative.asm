# Matthew Coppola
# CS281 - G1
# Min/Max interative funtion


#REGISTER USAGE
#
#t0 = address of array
#t1 = size of array / limit of loop (min_max)
#t2 = loop index (min_max)
#t3 = loop index*4 for word access in array
#t4 = array[i]
#t5 = conditional register
#
#a0 = min
#a1 = max
#a2 = size of array
#
#s0 = min during loop
#s1 = max during loop


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
	li  $a2,9		# a2 = size of array

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

	sw	$v1,8($sp)  # max returned in $v1 and stored on the stack
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
	la	$t0, numbers 	#load address of array to t0

	add $t1,$a2,$zero 	#store size of array as limit index for loop       
    li  $t2, 0  	  	#t2 will be index of loop
    				  	#t3 will be index*4 for array access
#    add $s0,$a0,$zero 	#store min in s0
#    add $s1,$a1,$zero 	#store max in s1
    lw  $s0, ($t0)		#store first value of array as min and max
    lw  $s1, ($t0)

    loop:
    	beq $t2, $t1, end		#if t1 == t0 go to end
    	lw  $t4, ($t0)			#store array[i] in t4
    	slt $t5, $t4, $s0		# if array[i] < min
    	beq $t5, 1, setmin		# if ^ is true go to setmin
    	slt $t5, $t4, $s1		# if array[i] < max
    	beq $t5, $zero, setmax	# if ^ is false go to setmax

    loopend:
    	addi $t2, $t2, 1		#add 1 to t1
    	addi $t0, $t0, 4		#increment memory address by 4

	j  loop

	setmin:
		lw $s0, ($t0)		#load array[i] into min (s0)
		j  loopend
	setmax:
		lw $s1, ($t0)		#load array[i] into max (s1)
		j  loopend
	end:
		add	$v0,$s0,$zero	# return min to v0
		add	$v1,$s1,$zero	# return max to v1

		lw	$s0,0($sp)  # restore $s0 to value prior to function call
		add	$sp,$sp,4   # pop stack
		jr	$ra         # return to calling procedure