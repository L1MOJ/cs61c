.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

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

    mv s0, a0   #s0 -> ptr to filename
    mv s1, a1   #s1 -> ptr to matrix
    mv s2, a2   #s2 -> rows
    mv s3, a3   #s3 -> cols
    #fopen
    mv a1, s0
    li a2, 1    #write
    jal fopen
    li t0, -1
    beq a0, t0, exit93
    mv s4, a0   #s4 -> file descriptor

    li a0, 8
    jal malloc
    sw s2, 0(a0)
    sw s3, 4(a0)
    #write row/col
    mv a1, s4
    mv a2, a0
    li a3, 2
    li a4, 4
    jal fwrite
    li t0, 2
    bne t0, a0, exit94
    jal free
    #write elements in matrix
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul t0, s2, s3
    bne t0, a0, exit94

    mv a1, s4
    jal fclose
    li t0, -1
    beq t0, a0, exit95
    # Epilogue
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
exit93:
    li a1, 93
    j exit2

exit94:
    li a1, 94
    j exit2

exit95:
    li a1, 95
    j exit2

