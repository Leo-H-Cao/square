addi $r5, $r0, 0
addi $r1, $r0, 1
_loop:
bne $r9, $r1, _loop
bne $r0, $r5, _player2
_player1:
addi $r5, $r0, 1
j _loop
_player2:
addi $r5, $r0, 0
bne $r9, $r1, _loop
j _loop
