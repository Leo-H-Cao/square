module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	ball_left_data, ball_right_data, left_sc, right_sc,
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	input [31:0] ball_left_data, ball_right_data;

	output [31:0] data_readRegA, data_readRegB, left_sc, right_sc;


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

	genvar i;
	generate
		for(i = 1; i < 32 ; i = i + 1) begin: loop1

			if (i==1) begin
				register score_reg1(data_writeReg, left_sc, clock, select_reg[i], ctrl_reset);
				tri_state tri_state7(left_sc, select_read1[i], data_readRegA);
				tri_state tri_state8(left_sc, select_read2[i], data_readRegB);
			end

			if (i==2) begin
				register score_reg2(data_writeReg, right_sc, clock, select_reg[i], ctrl_reset);
				tri_state tri_state9(right_sc, select_read1[i], data_readRegA);
				tri_state tri_state10(right_sc, select_read2[i], data_readRegB);
			end

			if (i==3) begin
				wire [31:0] ball_right_out;
				register b_reg1(ball_right_data, ball_right_out, clock, 1'b1, ctrl_reset);
				tri_state tri_state1(ball_right_out, select_read1[i], data_readRegA);
				tri_state tri_state2(ball_right_out, select_read2[i], data_readRegB);
			end

			if (i==4) begin
				wire [31:0] ball_left_out;
				register b_reg2(ball_left_data, ball_left_out, clock, 1'b1, ctrl_reset);
				tri_state tri_state3(ball_left_out, select_read1[i], data_readRegA);
				tri_state tri_state4(ball_left_out, select_read2[i], data_readRegB);
			end
			

			if(i != 3 && i !=4 && i != 1 && i != 2) begin
				wire [31:0] reg_out;
				register a_reg(data_writeReg, reg_out, clock, select_reg[i], ctrl_reset);
				tri_state tri_state5(reg_out, select_read1[i], data_readRegA);
				tri_state tri_state6(reg_out, select_read2[i], data_readRegB);
			end
		end

	endgenerate

endmodule
