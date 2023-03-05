.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
#   t0 -> loop count
#   t3 -> temp
#   t4 -> sum
#   matrix parameters
# 	a0 (int*)  is the pointer to the start of m0 left
#	a1 (int)   is the # of rows (height) of m0  left
#	a2 (int)   is the # of columns (width) of m0

#	a3 (int*)  is the pointer to the start of m1  right
# 	a4 (int)   is the # of rows (height) of m1    right
#	a5 (int)   is the # of columns (width) of m1

#	a6 (int*)  is the pointer to the the start of d
# =======================================================
dot:
    # Prologue
    li t0, 1
    li t5, 4
    li t6, 4
    ble a2, zero, exit75
    ble a3, zero, exit76
    ble a4, zero, exit76
continue:
    #length >= 1
    add t0, x0, x0
    add t4, x0, x0
    mul t5, t5, a3  #stride of v0
    mul t6, t6, a4  #stride of v1
loop_start:
    beq t0, a2, loop_end
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t3, t1, t2
    add t4, t4, t3
    addi t0, t0, 1
    add a0, a0, t5
    add a1, a1, t6
    j loop_start
loop_end:

    # Epilogue
    add a0, t4, x0
    ret

exit75:
    li a1, 75
    j exit2

exit76:
    li a1,76
    j exit2