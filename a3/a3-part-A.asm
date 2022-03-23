
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	addi $a1, $zero, 9
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	
dump_array:
	la $s0, ($a0) # store the array in a separate place

loop:
	lw $a0, 0($s0) # store integer to be printed
	addi $v0, $zero, 1 # print integer to console
	syscall

	la $a0, SPACE # store the space string to be printed
	addi $v0, $zero, 4 # print null-terminated string to console
	syscall

	addi $s0, $s0, 4 # increment array pointer by a word
	addi $a1, $a1, -1 # update loop counter
	bne $a1, $zero, loop # loop when loop counter is not zero

	la $a0, NEWLINE # store the new line string to be printed
	addi $v0, $zero, 4 # print null-terminated string to console
	syscall

	jr $ra
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
