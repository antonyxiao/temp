# a2-morse-encode.asm
#
# For UVic CSC 230, Spring 2022
#
# Original file copyright: Mike Zastre
#

.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
	# jal save_our_souls

	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x42   # dot dot dash dot
	# jal flash_one_symbol
	
	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x37   # dash dash dash
	# jal flash_one_symbol
		
	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x32  	# dot dash dot
	# jal flash_one_symbol
			
	## flash_one_symbol test for part B
	# addi $a0, $zero, 0x11   # dash
	# jal flash_one_symbol	
	
	# display_message test for part C
	# la $a0, test_buffer
	# jal display_message
	
	# char_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	# addi $a0, $zero, 'P'
	# jal char_to_code
	
	# char_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	# addi $a0, $zero, 'A'
	# jal char_to_code
	
	# char_to_code test for part D
	# the space' is properly encoded as 0xff
	# addi $a0, $zero, ' '
	# jal char_to_code
	
	# encode_text test for part E
	# The outcome of the procedure is here
	# immediately used by display_message
	 la $a0, message01
	 la $a1, buffer01
	 jal encode_text
	# buffer01 works for chars but 0xff becomes -1 ================= WHY?
	 la $a0, buffer01
	 jal display_message
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
	add $s1, $zero, $ra

	# S
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off

	jal delay_long

	jal seven_segment_on
	jal delay_short
	jal seven_segment_off

	jal delay_long

	jal seven_segment_on
	jal delay_short
	jal seven_segment_off

	jal delay_long

	# O
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off

	jal delay_long

	jal seven_segment_on
	jal delay_long
	jal seven_segment_off

	jal delay_long

	jal seven_segment_on
	jal delay_long
	jal seven_segment_off

	jal delay_long
	
	# S
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off

	jal delay_long

	jal seven_segment_on
	jal delay_short
	jal seven_segment_off

	jal delay_long

	jal seven_segment_on
	jal delay_short
	jal seven_segment_off

	add $ra, $zero, $s1
	jr $31


# PROCEDURE
# $t0: iterator
# $t3: high nybble
# $t4: low nybble
# $t5: least significant bit of $t4
# $t6: low nybble reversed
flash_one_symbol:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	bne $a0, 0xff, flash_one_symbol_else # does not equal space between words
	jal delay_long
	jal delay_long
	jal delay_long
	beq $zero, $zero, flash_one_symbol_end

flash_one_symbol_else:
	srl $t3, $a0, 4
	
	addi $t0, $zero, 4
	andi $t4, $a0, 15

# reverse low nybble
loop1:
	andi $t5, $t4, 1
	or $t6, $t6, $t5
	sll $t6, $t6, 1
	srl $t4, $t4, 1
	addi $t0, $t0, -1
	bne $t0, $zero, loop1 
	srl $t6, $t6, 1

	move $t5, $zero

# $t5: least significant bit of $t6

loop2:
	jal seven_segment_on
	andi $t5, $t6, 1
	beq $t5, $zero, else_dot
	jal delay_long
	beq $zero, $zero, after_segment_on	

else_dot:
	jal delay_short

after_segment_on:
	jal seven_segment_off

	addi $t3, $t3, -1
	beq $t3, $zero, flash_one_symbol_end 
	jal delay_long
	bne $t3, $zero, loop2

flash_one_symbol_end:

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


###########
# PROCEDURE
display_message:
	addi $sp, $sp, -8 # grow stack by 2 words
	sw $ra, 4($sp) # assume 4($sp) was in $ra
	sw $s0, 0($sp) # assume 0($sp) was in #s0

	la $a1, ($a0) # set content of $a0 to $a1

display_message_loop:
	lb $t3, 0($a1) # load byte that $a1 points to
	
	beq $t3, $zero, display_message_end # branch if byte is 0

	add $a0, $zero, $t3 # pass $t3 to flash_one_symbol
	jal flash_one_symbol

	addi $a1, $a1, 1 # increment $a1 to point to next byte
	beq $zero, $zero, display_message_loop # loop

display_message_end:

	lw $s0, 0($sp) # $s0 overwritten by 0($sp)
	lw $ra, 4($sp) # $ra overwriten by 4($sp)
	addi $sp, $sp, 8 # shrink stack by 2 words

	jr $ra
	
	
###########
# PROCEDURE
char_to_code:
	move $t4, $zero	
	move $t5, $zero
	move $v0, $zero

	bne $a0, 32, not_space # not space character
	addi $v0, $zero, 0xff
	b char_to_code_end
not_space:
	la $a1, codes
	b char_to_code_loop

char_to_code_increment_pointer:
	addi $a1, $a1, 1	

char_to_code_loop: 
	lb $t3, 0($a1)
	bne $a0, $t3, char_to_code_increment_pointer

morse_code_loop:

	addi $a1, $a1, 1
	lb $t3, 0($a1)

	beq $t3, $zero, char_to_code_loop_end
	addi $t5, $t5, 1 # length of sequence (high nybble)

	sll $t4, $t4, 1
	
	beq $t3, 46, set_dot
	or $t4, $t4, 1
set_dot:
	b morse_code_loop

char_to_code_loop_end:
	
	sll $t5, $t5, 4
	or $v0, $t5, $t4
	
char_to_code_end:

	jr $ra


###########
# PROCEDURE
encode_text:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a2, ($a0)
	la $a3, ($a1)

encode_text_loop:	
	lb $t3, ($a2)

	beq $t3, $zero, encode_text_end
	addi $t7, $t7, 1

	add $a0, $zero, $t3
	jal char_to_code
	add $t6, $zero, $v0
	#===================== 0xff becomes -1 ============================ WHY?
	sb $v0, ($a3)


	addi $a2, $a2, 1
	addi $a3, $a3, 1

	b encode_text_loop
	
encode_text_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31



#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS
