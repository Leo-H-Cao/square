addi $r5, $r0, 0
addi $r1, $r0, 1
addi $r6, $r0, 0
addi $r10, $r0, 313
addi $r11, $r0, 312
addi $r12, $r0, 1
_loop:
bne $r0, $r5, _player2
_player1:
addi $r12, $r0, 1
_loop1:
addi $r5, $r0, 1
addi $r12, $r12, 1
bne $r9, $r1, _loop1
blt $r10, $r12, _loop
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 0
j _loop1
_player2:
addi $r12, $r0, 1
_loop2:
addi $r5, $r0, 0
addi $r12, $r12, 1
bne $r9, $r1, _loop2
blt $r11, $r12, _loop
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 1
addi $r6, $r0, 0
j _loop2