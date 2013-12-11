# Matthew Coppola
# CS281 - P1
# MIPS Assembly version of iterative array search


	.data
array:	.word 1,2,3,4,5,6,7  #array with provided values
strFound:
	.asciiz "found at index "		

	.text           # assembly directive that indicates what follows are instructions
	.globl  main    # assembly directive that makes the symbol main global
main:               # assembly label
	addi $t1, $t0, 7 	#Place array size in $t1
	add $t2, $t0, $t0	#Initialize $t2 to 0 (index i)
	addi $t3, $t0, 0	#Initialize $t3 to 0 (array base address)
	addi $t4, $t0, 4	#Initialize $t4 to 4 (the search element)
	la	$a0,array 		#Load address of array in $a0
Loop:
	sll $t3, $t2, 2		#Multiply $t2 by 4 and place it in $t5 (i-th element offset)
	add $a0, $a0, $t3	#Calculate address of i-th element
	lw $t6, 0($a0) 		#Load i-th element into $t6
	addi $t2, $t2, 1 	#Increment index i
	beq $t4, $t6, Found 	#If i'th element == search element goto Found
	slt $t7, $t2, $t1	#Place 1 in $r7 if index i < array size
	beq $t0, $t7, Exit 	#If index i == array size, go to Exit.
	j Loop 				#Else, jump to Loop
Found:
	add $s0, $t2, $zero		#Store index in $s0
	j Done				#Jump over
Exit:
	add $s0, $t0, $zero		#Store 0 to indicate the element was not found
Done:
	add $t0, $t0, $t0	#nop

	li	$v0,4       	# the argument to a system call is placed in register $v0
                        # The value 4 tells syscall to print a string
	la	$a0,strFound     # pseudo-instruction to load the address of the label str
                        # The address of the string must be placed in register $a0
	syscall           # system call to print the string at address str

	li	$v0,1       # The value 1 tells syscall to print an integer
	add	$a0, $s0, $zero  # Load the index from $s0
	syscall           # System call to print the integer in register $a0
