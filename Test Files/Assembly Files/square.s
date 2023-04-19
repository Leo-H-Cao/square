addi $r1, $r0, 0
addi $r2, $r0, 0
addi $r10, $r0, 480 //right table edge
addi $r11, $r0, 160 //left table edge
loop:
blt $r10, $r3, exit_loop1a
nop
nop
nop
nop
nop
blt $r4, $r11, exit_loop2a
nop
nop
nop
nop
nop
j loop
exit_loop1a:
addi $r1, $r1, 1
exit_loop1b:
blt $r3, $r10, loop
nop
nop
nop
nop
nop
j exit_loop1b
exit_loop2a:
addi $r2, $r2, 1
exit_loop2b:
blt $r11, $r4, loop
nop
nop
nop
nop
nop
j exit_loop2b