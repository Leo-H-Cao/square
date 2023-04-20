addi $r1, $r0, 0
addi $r2, $r0, 0
addi $r10, $r0, 480 //right table edge
addi $r11, $r0, 160 //left table edge
addi $r5, $r0, 50
addi $r6, $r0, 50
addi $r7, $r0, 1
addi $r8, $r0, 1
loop:
blt $r8, $r7, end
blt $r10, $r5, exit_loop1a
blt $r10, $r5, exit_loop1a
add $r5, $r5, $r5
j loop
exit_loop1a:
addi $r1, $r1, 1
exit_loop1b:
blt $10, $r6, loop
add $r6, $r6, $r6
addi $r7, $r0, 2
j exit_loop1b
end:
addi $r8, $r0, 80