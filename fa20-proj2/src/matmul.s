.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 left
#	a1 (int)   is the # of rows (height) of m0  left
#	a2 (int)   is the # of columns (width) of m0

#	a3 (int*)  is the pointer to the start of m1  right
# 	a4 (int)   is the # of rows (height) of m1    right
#	a5 (int)   is the # of columns (width) of m1

#	a6 (int*)  is the pointer to the the start of d
#   a1  row
#   a5 column
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    #Left metrix error
    blt a1, t0, exit72
    blt a2, t0, exit72
    #Right metrix error
    blt a4, t0, exit73
    blt a5, t0, exit73
    #Match error
    bne a2, a4, exit74

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    li a3, 1    #v0 stride 1
    add a4, a5, x0  #v1 stride -> num of columns
    add a2, s2, x0  #length of vectors
    add a1, s3, x0  #the pointer to the start of v1
    li t3, 4
    mul t3, t3, s2  #the stride of v0's row after one inner loop
    li t0, 0    #outer loop
outer_loop_start:
    li t1, 0    #inner loop

#Traverse the whole row of a0, the whole column of a1
inner_loop_start:
    
    addi sp, sp, -32
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    sw a1, 28(sp)

    jal dot

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    lw a1, 28(sp)
    addi sp, sp, 32

inner_loop_end:

    #store the return value in d
    sw a0, 0(s6)
    addi s6, s6, 4
    addi t1, t1, 1
    addi a1, a1, 4
    add a0, s0, x0
    bne t1, s5, inner_loop_start    #if the number of loops != rows, continue
    add a1, s3, x0
    add s0, s0, t3
    addi a0, s0, 0
    addi t0, t0, 1
    bne t0, s1, outer_loop_start
outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    ret

exit72:
    li a1, 72
    j exit2

exit73:
    li a1, 73
    j exit2

exit74:
    li a1, 74
    j exit2