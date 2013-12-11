# Matthew Coppola
# CS281 - W4 #2.3 	Exc. #3.6.3 from book
# MIPS assembly bitwise shift multiplier

	.data
A:	.word 0x21
B:	.word 0x37

	.text           
	.globl  main    
main:        
	la	$t0,A 		#A -> s0
	lw  $s0, 0($t0)	
	la	$t0,B 		#B -> s1      
	lw  $s1, 0($t0)	

	log2 $t1, $s0 			#Psudo instruction for log base 2 function, returns int
	rem $t2, $s0, 2			#Get remainder of A/2, store in $t2
	mul $t0, $s1, $t2		#mul multiplicand by remainder of A/2
	sll $s1, $s1, $t1		#shift multiplicand left by log2(A)
	add $s1, $s1, $t0		#add remainder if any

	li	$v0,1       	# The value 1 tells syscall to print an integer
	add	$a0, $s1, $zero  # Load the product from $s3
	syscall           	# System call to print the integer in register $a0
