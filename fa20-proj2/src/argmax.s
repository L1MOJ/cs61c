.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
#   t0 count for elements
#   t2 stores the current biggest
#   t3 stores the index
# =================================================================
argmax:

    # Prologue
    li t0, 1
    bge a1, t0, continue
    li a1, 77
    j exit2
    
continue:
    #length >= 1
    add t0, x0, x0
    add t2, x0, x0
    add t3, x0, x0
loop_start:
    lw t1, 0(a0)
    bge t2, t1, loop_continue
    add t2, t1, x0
    add t3, t0, x0
loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    bne t0, a1, loop_start
    add a0, t3, x0

loop_end:
    

    # Epilogue


    ret
