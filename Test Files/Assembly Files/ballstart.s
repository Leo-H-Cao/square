addi $r2, $r0, 1
addi $r5, $r0, 0
addi $r1, $r0, 1
_loop:
bne $r9, $r1, _loop
xor $r5, $r5, $r2
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi $r6, $r0, 1
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi $r6, $r0, 0
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
j _loop
