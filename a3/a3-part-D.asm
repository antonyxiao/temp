# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_s 115
    .eqv SPACE    32
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# initialize variables
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)	

	la $t2, BOX_ROW
	sb $zero, ($t2)	
	la $t2, BOX_COLUMN
	sb $zero, ($t2)	
	
	la $a0, BOX_COLUMN
	la $a1, BOX_ROW
	lb $a0, ($a0)
	lb $a1, ($a1)
	addi $a2, $zero, BOX_COLOUR

check_for_event:
	# get a0 and a1 from constant
	la $a0, BOX_COLUMN
	la $a1, BOX_ROW
	lb $a0, ($a0)
	lb $a1, ($a1)
	jal draw_bitmap_box

	lb $t3, KEYBOARD_EVENT
	beq $t3, $zero, no_new_event

	bne $t3, SPACE, not_space

	bne $a2, BOX_COLOUR, change_color
	addi $a2, $zero, 0x00950191
	b other
change_color:
	addi $a2, $zero, BOX_COLOUR
	b other
not_space:
	bne $t3, LETTER_a, not_letter_a
	
	add $t6, $zero, $a2
	
	la $a0, BOX_COLUMN
	la $a1, BOX_ROW
	lb $a0, ($a0)
	lb $a1, ($a1)
	addi $a2, $zero, 0x00000000

	jal draw_bitmap_box	

	la $t2, BOX_ROW
	lb $t5, ($t2)
	subi $t5, $t5, 1
	sb $t5, 0($t2)

	add $a2, $zero, $t6

	b other
not_letter_a:
	bne $t3, LETTER_d, not_letter_d
	
	add $t6, $zero, $a2
	
	la $a0, BOX_COLUMN
	la $a1, BOX_ROW
	lb $a0, ($a0)
	lb $a1, ($a1)
	addi $a2, $zero, 0x00000000

	jal draw_bitmap_box	

	la $t2, BOX_ROW
	lb $t5, ($t2)
	add $t5, $t5, 1
	sb $t5, 0($t2)

	add $a2, $zero, $t6

	b other	
not_letter_d:
	bne $t3, LETTER_w, not_letter_w

	add $t6, $zero, $a2

	la $a0, BOX_COLUMN
	la $a1, BOX_ROW
	lb $a0, ($a0)
	lb $a1, ($a1)
	addi $a2, $zero, 0x00000000

	jal draw_bitmap_box	

	la $t2, BOX_COLUMN
	lb $t5, ($t2)
	subi $t5, $t5, 1
	sb $t5, 0($t2)

	add $a2, $zero, $t6

	b other
not_letter_w:
	bne $t3, LETTER_s, other

	add $t6, $zero, $a2

	la $a0, BOX_COLUMN
	la $a1, BOX_ROW
	lb $a0, ($a0)
	lb $a1, ($a1)
	addi $a2, $zero, 0x00000000

	jal draw_bitmap_box	

	la $t2, BOX_COLUMN
	lb $t5, ($t2)
	addi $t5, $t5, 1
	sb $t5, 0($t2)

	add $a2, $zero, $t6

	b other
other:

	sw $zero, KEYBOARD_EVENT
no_new_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)

	beq $zero, $zero, check_for_event
	
	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10

.data
    .eqv BOX_COLOUR_BLACK 0x00000000
.text

	addi $v0, $zero, BOX_COLOUR_BLACK
	syscall



# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
#
# You can copy-and-paste some of your code from part (c)
# to provide the procedure body.
#
	addi $sp, $sp, -4 # grow stack by 2 words
	sw $ra, 0($sp) # assume 4($sp) was in $ra
	move $t2, $zero
	move $t3, $zero
	
loop:
	jal set_pixel
	addi $a1, $a1, 1
	addi $t2, $t2, 1
	bne $t2, 4, loop

	addi $a0, $a0, 1
	move $t2, $zero
	subi $a1, $a1, 4
	addi $t3, $t3, 1
	bne $t3, 4, loop

	move $a0, $zero
	move $a1, $zero

	lw $ra, 0($sp) # $ra overwriten by 4($sp)
	addi $sp, $sp, 4 # shrink stack by 2 words
	jr $ra


	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
__kernel_entry:
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt

__is_exception:
	# a placeholder for handling some exceptions if necessary
	b __exit_exception
	
__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_kb_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	b __exit_exception	# otherwise, we return exit kernel
	
__is_kb_interrupt:
	lw $k0, 0xffff0004
	sw $k0, KEYBOARD_EVENT

__exit_exception:
	eret


.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv BOX_COLOUR_WHITE 0x00FFFFFF
	
