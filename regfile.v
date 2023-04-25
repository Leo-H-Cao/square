module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	player, start, eoc
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	output [31:0] player, start;
	input [31:0] eoc;

	// add your code here
	wire [31:0] select_reg;
	decoder32 decoder_write(select_reg, ctrl_writeReg, ctrl_writeEnable);

	wire [31:0] select_read1;
	decoder32 decoder_read1(select_read1, ctrl_readRegA, 1'b1);

	wire [31:0] select_read2;
	decoder32 decoder_read2(select_read2, ctrl_readRegB, 1'b1);


	wire[31:0] reg0_out;
	register reg_0(32'b0, reg0_out, clock, 1'b0, ctrl_reset);

	tri_state tri_state01(reg0_out, select_read1[0], data_readRegA);

	tri_state tri_state02(reg0_out, select_read2[0], data_readRegB);

	wire [31:0] player_reg_out;
	wire [31:0] eoc_reg_out;
	wire [31:0] start_reg_out;
	ila_0 debug(.clk(clock), .probe0(player_reg_out), .probe1(data_writeReg), .probe2(select_reg), .probe3(start_reg_out), .probe4(eoc_reg_out), .probe5(eoc), .probe6(ctrl_writeEnable), .probe7(clock));

	genvar i;
	generate
		for(i = 1; i < 32 ; i = i + 1) begin: loop1

			if (i==5) begin 
				register player_reg(data_writeReg, player_reg_out, clock, select_reg[i], ctrl_reset);
				tri_state tri_state_player1(player_reg_out, select_read1[i], data_readRegA);
				tri_state tri_state_player2(player_reg_out, select_read2[i], data_readRegB);
				assign player = player_reg_out;
			end

			if (i==6) begin
				register start_reg(data_writeReg, start_reg_out, clock, select_reg[i], ctrl_reset);
				tri_state tri_state_start1(start_reg_out, select_read1[i], data_readRegA);
				tri_state tri_state_start2(start_reg_out, select_read2[i], data_readRegB);
				assign start = start_reg_out;
			end

			if (i==9) begin
				register eoc_reg(eoc, eoc_reg_out, clock, 1'b1, ctrl_reset);
				tri_state tri_state_eoc1(eoc_reg_out, select_read1[i], data_readRegA);
				tri_state tri_state_eoc2(eoc_reg_out, select_read2[i], data_readRegB);
			end

			if(i != 5 && i !=6 && i !=9) begin
				wire [31:0] reg_out;
				register a_reg(data_writeReg, reg_out, clock, select_reg[i], ctrl_reset);
				tri_state tri_state5(reg_out, select_read1[i], data_readRegA);
				tri_state tri_state6(reg_out, select_read2[i], data_readRegB);
			end
		end

	endgenerate

endmodule
