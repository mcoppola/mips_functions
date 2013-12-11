# Matthew Coppola
# CS281 - W4 #1.2 	Exc. #3.4.3 from book
# MIPS assembly bitwise multiplier

	.data
A:	.word 0x33
B:	.word 0xA

	.text           
	.globl  main    
main:        
	la	$t0,A 		#A -> s0
	lw  $s0, 0($t0)	
	la	$t0,B 		#B -> s1      
	lw  $s1, 0($t0)	

	addi $t1, $zero, 6 		#Places bit count in $t1
	addi $s2, $zero, 1		#Place 1 in $s2 to compare
	add $t2, $zero, $zero	#Initialize $t2 to 0 (index i)
	addi $s3, $zero, 0		#Initialize $s3 to 0 (Product)

Loop:
	and $t0, $s0, 1			#If 1 in right-most bit of multiplier, add mcand to product
	beq $t0, $s2, AddToProduct 	
	j Shift 				#Else, jump to Shift
AddToProduct:
	add $s3, $s3, $s1		#Product = Product + mulitplicand
Shift:
	srl $s0, $s0, 1		#shift multiplier right
	sll $s1, $s1, 1		#shift multiplicand left
	addi $t2, $t2, 1 	#Increment index i
	beq $t1, $t2, Done 	#If index == bit count goto Done
	j Loop 				#Else, jump to Loop
Done:
	li	$v0,1       	# The value 1 tells syscall to print an integer
	add	$a0, $s3, $zero  # Load the product from $s3
	syscall           	# System call to print the integer in register $a0