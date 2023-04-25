// Clock on E3
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

// Rest Signal
set_property PACKAGE_PIN N17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

// VGA Port
set_property PACKAGE_PIN P17 [get_ports {sw[3]}]
set_property PACKAGE_PIN M17 [get_ports {sw[2]}]
set_property PACKAGE_PIN M18 [get_ports {sw[1]}]
set_property PACKAGE_PIN P18 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]

set_property PACKAGE_PIN C17 [get_ports {moveSpeed[0]}]
set_property PACKAGE_PIN D18 [get_ports {moveSpeed[1]}]
set_property PACKAGE_PIN E18 [get_ports {moveSpeed[2]}]
set_property PACKAGE_PIN G17 [get_ports {moveSpeed[3]}]
set_property PACKAGE_PIN D17 [get_ports {moveSpeed[4]}]
set_property PACKAGE_PIN E17 [get_ports {moveSpeed[5]}]
set_property PACKAGE_PIN F18 [get_ports {moveSpeed[6]}]
set_property PACKAGE_PIN D14 [get_ports {moveSpeed[7]}]

set_property PACKAGE_PIN H14 [get_ports {player}]
set_property PACKAGE_PIN G16 [get_ports {adc_start}]
set_property PACKAGE_PIN F16 [get_ports {eoc}]

set_property PACKAGE_PIN J15 [get_ports {startGame}]

set_property PACKAGE_PIN H17 [get_ports {rights[0]}]
set_property PACKAGE_PIN K15 [get_ports {rights[1]}]
set_property PACKAGE_PIN J13 [get_ports {rights[2]}]
set_property PACKAGE_PIN N14 [get_ports {rights[3]}]
set_property PACKAGE_PIN R18 [get_ports {rights[4]}]
set_property PACKAGE_PIN V17 [get_ports {rights[5]}]
set_property PACKAGE_PIN U17 [get_ports {rights[6]}]
set_property PACKAGE_PIN U16 [get_ports {rights[7]}]

set_property PACKAGE_PIN V16 [get_ports {lefts[0]}]
set_property PACKAGE_PIN T15 [get_ports {lefts[1]}]
set_property PACKAGE_PIN U14 [get_ports {lefts[2]}]
set_property PACKAGE_PIN T16 [get_ports {lefts[3]}]
set_property PACKAGE_PIN V15 [get_ports {lefts[4]}]
set_property PACKAGE_PIN V14 [get_ports {lefts[5]}]
set_property PACKAGE_PIN V12 [get_ports {lefts[6]}]
set_property PACKAGE_PIN V11 [get_ports {lefts[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {moveSpeed[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {player}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_start}]
set_property IOSTANDARD LVCMOS33 [get_ports {eoc}]

set_property IOSTANDARD LVCMOS33 [get_ports {startGame}]


set_property IOSTANDARD LVCMOS33 [get_ports {rights[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rights[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {lefts[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lefts[7]}]


set_property PACKAGE_PIN D8 [get_ports {VGA_B[3]}]
set_property PACKAGE_PIN D7 [get_ports {VGA_B[2]}]
set_property PACKAGE_PIN C7 [get_ports {VGA_B[1]}]
set_property PACKAGE_PIN B7 [get_ports {VGA_B[0]}]
set_property PACKAGE_PIN A6 [get_ports {VGA_G[3]}]
set_property PACKAGE_PIN B6 [get_ports {VGA_G[2]}]
set_property PACKAGE_PIN A5 [get_ports {VGA_G[1]}]
set_property PACKAGE_PIN C6 [get_ports {VGA_G[0]}]
set_property PACKAGE_PIN A4 [get_ports {VGA_R[3]}]
set_property PACKAGE_PIN C5 [get_ports {VGA_R[2]}]
set_property PACKAGE_PIN B4 [get_ports {VGA_R[1]}]
set_property PACKAGE_PIN A3 [get_ports {VGA_R[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[0]}]

// Sync Ports
set_property PACKAGE_PIN B11 [get_ports hSync]
set_property PACKAGE_PIN B12 [get_ports vSync]
set_property IOSTANDARD LVCMOS33 [get_ports hSync]
set_property IOSTANDARD LVCMOS33 [get_ports vSync]

// PS2 Stuff
set_property PACKAGE_PIN F4 [get_ports ps2_clk]
set_property PACKAGE_PIN B2 [get_ports ps2_data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]