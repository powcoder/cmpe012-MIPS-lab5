https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
#--------------------------------------------------------------
# Created by:  Rebecca
#              26 May 2019
#
# Description: Test code for Lab 5 for CMPE 12 19sp
#
# Note:        This program is intended to run in the MARS IDE
#--------------------------------------------------------------

#------------------------------------------------------------------------
# STATIC DATA
#------------------------------------------------------------------------

.data

array_: .space  36                 # assume this is 1 word greater than the size of the array
size_:  .word    7                 # max index of array (should update with array size)
score_: .word  100                 # initial score

seed:   .word 0x12345678           # used to generate array of random ints


#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print value as hex

.macro print_hex_val(%val_to_print)

subi  $sp   $sp   8
sw    $a0  ($sp)
sw    $v0 4($sp)

add   $a0 $zero   %val_to_print
addiu $v0 $zero   34                # print value as hex

syscall

addiu $v0 $zero   11                # print 2 new lines
addiu $a0 $zero   0xA
syscall
syscall

lw    $a0  ($sp)
lw    $a0 4($sp)
addi  $sp   $sp   8
.end_macro

#------------------------------------------------------------------------
# print string

.macro print_str(%str)

.data
str_to_print: .asciiz %str

.text
subi  $sp   $sp   8
sw    $a0  ($sp)
sw    $v0 4($sp)

addiu $v0 $zero   4
la    $a0 str_to_print
syscall

addiu $v0 $zero   11
addiu $a0 $zero   0xA
syscall

lw    $a0  ($sp)
lw    $v0 4($sp)
addi  $sp   $sp   8
.end_macro

#------------------------------------------------------------------------
# print horizontal line

.macro print_horiz_line

print_str("==================================================")

.end_macro

#------------------------------------------------------------------------
# initialize array with random positive numbers

#------------------------------------------------------------------------
# REGISTER USAGE
#
# $a0: seed for random number generator, output of rand num gen 
# $a1: upper limit of random number generation
# $t0: max index of array
# $t1: points to rand num gen seed
# $t2: points to max index of array, points to array element
#------------------------------------------------------------------------

.macro init_rand_array

array_init: nop                    # populate array with random numbers
    
    la    $t2  size_
    lw    $t0  ($t2)               # max index of array
    
    addiu $v0  $zero  42           # syscall 42 used to generate random number w/upper limit
    addiu $a1  $zero  0x7fffffff   # set upper limit of random number generation

    la    $t2  array_              # address of index 0
    la    $t1  seed                # address of seed

array_init_loop: nop               # loop to populate array with random numbers 

    lw    $a0  ($t1)               # generate random number
    syscall

    sw    $a0  ($t2)               # store random number in array
    
    addi  $t2   $t2   4
    subi  $t0   $t0   1
    bgez  $t0   array_init_loop
    
    sw    $0   ($t2)               # store 0 at word after array

.end_macro

init_rand_array                    # initialize array_ with random numbers

#------------------------------------------------------------------------
# test find_max

.data
test_array_find_max: .word 1 2 3 4 5 6 7 8 0

.text
la    $a0  test_array_find_max                        # use array_ to test using array of random numbers
jal   find_max

print_horiz_line
print_str("testing find_max\n")

print_str("index of max value in array ($v0): ")
print_hex_val($v0)

print_str("max value ($v1): ")
print_hex_val($v1)


#------------------------------------------------------------------------
# test make_bet

.data
test_score_make_bet: .word 100
test_array_make_bet: .word 1 2 3 4 5 6 7 8 0

.text
print_horiz_line
print_str("testing make_bet\n")

la   $a0  test_score_make_bet                # load arguments to test subroutine
lw   $a0  ($a0)

la   $a1  test_array_make_bet                # use array_ to test using array of random numbers

jal  make_bet

print_str("updated score ($v0): ")
print_hex_val($v0)

#------------------------------------------------------------------------
# test print_array

.text
print_horiz_line
print_str("testing print_array\n")

jal print_array

#------------------------------------------------------------------------
# test win_or_lose

.text
print_horiz_line
print_str("testing win_or_lose\n")

jal win_or_lose

#------------------------------------------------------------------------
# test take_turn

.data
test_score_take_turn: .word 50
test_array_take_turn: .word 1 2 3 4 5 6 7 8 0

.text
print_horiz_line
print_str("testing take_turn\n")

la   $a0  test_score_take_turn                # load arguments to test subroutine
lw   $a0  ($a0)

la   $a1  test_array_take_turn                # use array_ to test using array of random numbers

jal  take_turn

print_str("updated score ($v0): ")
print_hex_val($v0)


#------------------------------------------------------------------------
# test play_game

.text

print_horiz_line
print_str("testing play_game\n")

la   $a0  score_
lw   $a0  ($a0)

la   $a1  array_
jal  play_game



.include  "lab5_template_19sp_cmpe012.asm"             #replace this with Lab5.asm
