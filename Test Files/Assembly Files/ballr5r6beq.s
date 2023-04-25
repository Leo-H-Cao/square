addi $r5, $r0, 0
addi $r1, $r0, 1
_loop:
beq $r9, $r0, _loop
beq $r1, $r5, _player2
_player1:
addi $r5, $r0, 1
j _loop
_player2:
addi $r5, $r0, 0
beq $r9, $r0, _loop
j _loop
