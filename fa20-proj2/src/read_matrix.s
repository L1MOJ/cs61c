.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -36
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	sw s7, 32(sp)

	mv s0, a0   #pointer to string representing the filename
	mv s1, a1   #pointer to an integer, we will set it to the number of rows
	mv s2, a2   #pointer to an integer, we will set it to the number of cols

	mv a1, s0   #open file
	li a2, 0   #read mode
    jal fopen
    li t0, -1
    beq t0, a0, exit90
    mv s3, a0   #s3 -> file descriptor

    mv a1, s3   #fd
    mv a2, s1   #read rows
    li a3, 4
    jal fread
    li t0, 4
    bne t0, a0, exit91

    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne t0, a0, exit91

    lw s1, 0(s1)    #s1 -> number of rows
    lw s2, 0(s2)    #s2 -> number of cols
    mul s5, s1, s2  #s5 -> number of elements
    mul a0, s1, s2
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit88
    mv s4, a0       #s4 -> matrix memory loop
    mv s7, a0       #s7 -> matrix memory start
    li s6, 0        #i = 0
read_loop:
    mv a1, s3
    mv a2, s4
    li a3, 4
    jal fread
    li t0, 4
    bne t0, a0, exit91
    addi s6, s6, 1
    beq s6, s5, loop_end
    addi s4, s4, 4
    j read_loop
loop_end:
    mv a1, s3
    jal fclose
    li t0, -1
    beq t0, a0, exit92

    mv a0, s7
    lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	lw s6, 28(sp)
	lw s7, 32(sp)
    addi sp, sp, 36
    ret
exit88:
    li a1, 88
    j exit2

exit90:
    li a1, 90
    j exit2

exit91:
    li a1, 91
    j exit2

exit92:
    li a1, 92
    j exit2