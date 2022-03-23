	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)

check_for_event:
	la $t2, KEYBOARD_EVENT
	lb $t2, 0($t2)
	beq $t2, $zero, no_new_event

	bne $t7, LETTER_space, not_space
	addi $t4, $zero, 0x1
	sb $t4, KEYBOARD_EVENT_PENDING
not_space:
	la $t5, KEYBOARD_COUNTS
	
	bne $t7, LETTER_a, not_letter_a
	lb $t6, 0($t5)
	addi $t6, $t6, 1
	sb $t6, 0($t5)
not_letter_a:
	bne $t7, LETTER_b, not_letter_b
	lb $t6, 4($t5)
	addi $t6, $t6, 1
	sb $t6, 4($t5)
not_letter_b:
	bne $t7, LETTER_c, not_letter_c
	lb $t6, 8($t5)
	addi $t6, $t6, 1
	sb $t6, 8($t5)
not_letter_c:
	bne $t7, LETTER_D, other
	lb $t6, 12($t5)
	addi $t6, $t6, 1
	sb $t6, 12($t5)

other:
	la $t2, KEYBOARD_EVENT
	move $t3, $zero
	sb $t3, 0($t2)
no_new_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $s1, $zero, check_for_event	
	
	la $a0, KEYBOARD_COUNTS
	addi $a1, $zero, 4
	jal dump_array

	addi $v0, $zero, 10
	syscall

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

	.kdata

	.ktext 0x80000180
__kernel_entry:
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt

__is_exception:
	# a placeholder for handling some exceptions if necessary
	beq $zero, $zero, __exit_exception
	
__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_kb_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	beq $zero, $zero, __exit_exception	# otherwise, we return exit kernel
	
__is_kb_interrupt:
	la $k0, 0xffff0004
	lb $t7, 0($k0)

	la $t0, KEYBOARD_EVENT
	addi $t1, $zero, 1
	sb $t1, 0($t0)

	beq $zero, $zero, __exit_exception	# Kept here in case we add more handlers.

__exit_exception:
	eret
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
