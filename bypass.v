module bypass(data, xm_out_ir, mw_out_ir, dx_out_ir, x_alu_a_select, x_alu_b_select, data_mem_bypass_select, xm_out_over, mw_out_over);

    input [31:0] xm_out_ir, mw_out_ir, dx_out_ir;
    input xm_out_over, mw_out_over;
    output [31:0] data; 
    output [1:0] x_alu_a_select, x_alu_b_select;
    output data_mem_bypass_select;

    // wm bypass
    // select data to write to dmem correctly, potentially bypass
    assign data_mem_bypass_select = (xm_out_ir[31:27] == 5'b00111) & (xm_ir_rd == mw_ir_rd);

    wire [4:0] dx_opcode, xm_opcode, mw_opcode;
    assign dx_opcode = dx_out_ir[31:27];
    assign xm_opcode = xm_out_ir[31:27];
    assign mw_opcode = mw_out_ir[31:27];

    wire dx_r_type, dx_bex;
    assign dx_r_type = dx_opcode == 5'b0;
    assign dx_bex = dx_opcode == 5'b10110;

    // booleans for different types of instructions
    wire xm_branch, xm_sw, xm_setx, mw_branch, mw_sw, mw_setx;
    assign xm_branch = (xm_opcode == 5'b00010 || xm_opcode == 5'b00110 || xm_opcode == 5'b11010);
    assign xm_sw = xm_opcode == 5'b00111;
    assign xm_setx = xm_opcode == 5'b10101;
    assign mw_branch = (mw_opcode == 5'b00010 || mw_opcode == 5'b00110 || mw_opcode ==5'b11010);
    assign mw_sw = mw_opcode == 5'b00111;
    assign mw_setx = mw_opcode == 5'b10101;

    // select correct read and destination registers for instructions
    wire [4:0] dx_ir_rs1, dx_ir_rs2, xm_rd, mw_rd;
    assign dx_ir_rs1 = dx_out_ir[21:17];
    // r type instructions read from rt, bex reads from reg 30
    assign dx_ir_rs2 = dx_r_type ? dx_out_ir[16:12] : (dx_bex ? 5'b11110 : dx_out_ir[26:22]);

    // also write to reg 30 when overflow
    assign xm_rd = (xm_setx || xm_out_over) ? 5'b11110 : xm_ir_rd;
    assign mw_rd = (mw_setx || mw_out_over) ? 5'b11110 : mw_ir_rd;

    // bypass logic for alu a and b, don't need to bypass if sw or branch in xm or mw stage
    wire a_xm_bp, a_mw_bp, b_xm_bp, b_mw_bp;
    assign a_xm_bp = !xm_sw && !xm_branch && dx_ir_rs1 == xm_rd && xm_rd != 5'b0;
    assign a_mw_bp = !mw_sw && !mw_branch && dx_ir_rs1 == mw_rd && mw_rd != 5'b0;
    assign b_xm_bp = !xm_sw && !xm_branch && dx_ir_rs2 == xm_rd && xm_rd != 5'b0;
    assign b_mw_bp = !mw_sw && !mw_branch && dx_ir_rs2 == mw_rd && mw_rd != 5'b0;
    assign x_alu_a_select[0] = !a_xm_bp && a_mw_bp;
    assign x_alu_a_select[1] = !a_xm_bp && !a_mw_bp;
    assign x_alu_b_select[0] = !b_xm_bp && b_mw_bp;
    assign x_alu_b_select[1] = !b_xm_bp && !b_mw_bp;

    wire [4:0] xm_ir_rd, mw_ir_rd;
    assign mw_ir_rd = mw_out_ir[26:22];
    assign xm_ir_rd = xm_out_ir[26:22];
    assign dx_ir_rs1 = dx_out_ir[21:17];


    // x bypass
    // mux control for ALUinA
    // wire [4:0] xm_ir_rd, mw_ir_rd;
    // assign mw_ir_rd = mw_out_ir[26:22];
    // assign xm_ir_rd = xm_out_ir[26:22];

    // wire [1:0] a_bp_select;
    // assign a_bp_select = {dx_ir_rs1 == mw_ir_rd, dx_ir_rs1 == xm_ir_rd};
    // mux_4_2bit a_select_mux(x_alu_a_select, a_bp_select, 2'd2, 2'd0, 2'd1, 2'd2);
    
    // // mux control for ALUinB
    // assign dx_ir_rs2 = dx_r_type ? dx_out_ir[16:12] : (dx_bex ? 5'b11110 : dx_out_ir[26:22]);

    // wire [1:0] b_bp_select;
    // assign b_bp_select = {dx_ir_rs2 == xm_ir_rd, dx_ir_rs2 == mw_ir_rd};
    // mux_4_2bit b_select_mux(x_alu_b_select, b_bp_select, 2'd2, 2'd0, 2'd1, 2'd2);

endmodule