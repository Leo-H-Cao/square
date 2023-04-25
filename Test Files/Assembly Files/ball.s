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
nop
nop
addi $r5, $r0, 0
addi $r1, $r0, 1
addi $r6, $r0, 0
_loop:
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
bne $r0, $r5, _player2
_player1:
addi $r5, $r0, 1
bne $r9, $r1, _loop
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
nop
nop
addi $r6, $r0, 0
j _loop
_player2:
nop
nop
nop
nop
nop
nop
nop
nop
addi $r5, $r0, 0
bne $r9, $r1, _loop
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
nop
nop
addi $r6, $r0, 0
j _loop
