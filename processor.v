/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    // program counter logic
    wire [31:0] next_pc, cur_pc;
    assign address_imem = cur_pc;
    wire branch_or_jump_pc, stall;

    // store pc in register, output of register is the address of the next instruction
    register32 pcReg(next_pc, cur_pc, clock, !stall, reset);

    // F/D latch created
    wire [31:0] fd_out_pc, fd_out_ir, fd_in_ir, instruction;
    assign fd_in_ir = branch_or_jump_pc ? 32'b0 : q_imem;

    latch_fd fd_latch(cur_pc, fd_out_pc, fd_in_ir, fd_out_ir, clock, !stall, reset);

    // decode regfile access
    assign ctrl_readRegA = fd_out_ir[21:17];

    // determine if instruction is r-type or a bex instruction
    wire [4:0] d_opcode;
    assign d_opcode = fd_out_ir[31:27];
    wire d_r_type_ins, d_bex_ins;
    assign d_r_type_ins = d_opcode == 5'b0;
    assign d_bex_ins = d_opcode == 5'b10110;

    // r type instructions read from rt, bex reads from reg 30
    assign ctrl_readRegB = d_r_type_ins ? fd_out_ir[16:12] : (d_bex_ins ? 5'b11110 : fd_out_ir[26:22]);

    // D/X latch
    wire[31:0] dx_out_pc, dx_out_ir, dx_out_a, dx_out_b, dx_in_ir;

    //insert no op if necessary
    assign dx_in_ir = (stall | branch_or_jump_pc) ? 32'b0 : fd_out_ir;
    latch_dx dx_latch(fd_out_pc, dx_in_ir, data_readRegA, data_readRegB, dx_out_pc, dx_out_ir, dx_out_a, dx_out_b, clock, reset);

    //execute stage

    // select alu input a, potentially bypass
    wire [31:0] x_alu_a, xm_out_o;
    wire [1:0] x_alu_a_select;
    mux_4 alu_a_bypass(x_alu_a, x_alu_a_select, xm_out_o, data_writeReg, dx_out_a, 32'b0);

    // select alu input b, potentially bypass 
    wire [31:0] x_alu_b_bypass;
    wire [1:0] x_alu_b_select;
    mux_4 alu_b_bypass(x_alu_b_bypass, x_alu_b_select, xm_out_o, data_writeReg, dx_out_b, 32'b0);

    // check whether instruction is i-type, r_type, or branch op using instruction opcode from IR
    wire x_i_type_ins, x_r_type_ins, x_branch_op;
    wire[4:0] x_opcode;
    assign x_opcode = dx_out_ir[31:27];
    assign x_i_type_ins = x_opcode == 5'b00110 || x_opcode == 5'b00010 || x_opcode == 5'b00111 || x_opcode == 5'b01000 || x_opcode == 5'b00101;
    assign x_r_type_ins = x_opcode == 5'b00000;
    assign x_branch_op = x_opcode == 5'b00010 || x_opcode == 5'b00110;

    // handle setx instruction (need to propagate sx immediate)
    wire x_setx_ins;
    assign x_setx_ins = x_opcode == 5'b10101;

    // sign extend immediate
    wire [31:0] sign_extended_immediate;
    assign sign_extended_immediate[16:0] = dx_out_ir[16:0];
    assign sign_extended_immediate[31:17] = dx_out_ir[16] ? 15'b111111111111111 : 15'b0;

    // select b input to alu (reg file data/bypass otherwise fo branch or r-type)
    wire [31:0] x_alu_b;
    assign x_alu_b = ((x_i_type_ins && !x_branch_op) || x_setx_ins) ? sign_extended_immediate : x_alu_b_bypass;

    // get alu opcode and shift amount from instruction, set to alu op to add for i type instructions
    wire[4:0] alu_op, alu_shamt;
    assign alu_op = x_r_type_ins ? dx_out_ir[6:2] : (x_branch_op ? 5'b00001 : 5'b0);
    assign alu_shamt = x_r_type_ins ? dx_out_ir[11:7] : 5'b0;

    // alu result
    wire [31:0] x_alu_res;
    wire alu_INE, alu_ILT, alu_over;
    alu x_alu(x_alu_a, x_alu_b, alu_op, alu_shamt, x_alu_res, alu_INE, alu_ILT, alu_over);

    //handle overflow
    wire overflow;
    assign overflow = alu_over || (multdiv_ready && multdiv_x);

    //determine which type of overflow
    wire overflow_type, add_op, addi_op, sub_op, mult_op, div_op;
    wire[4:0] overflow_opcode, overflow_alu_op;
    assign overflow_opcode = multdiv_ready ? multdiv_ir[31:27] : x_opcode;
    assign overflow_alu_op = multdiv_ready ? multdiv_ir[6:2] : alu_op;
    wire overflow_r_type;
    assign overflow_r_type = overflow_opcode == 5'b00000;
    assign add_op = overflow_r_type && overflow_alu_op == 5'b00000;
    assign sub_op = overflow_r_type && overflow_alu_op == 5'b00001;
    assign mult_op = overflow_r_type && overflow_alu_op == 5'b00110;
    assign div_op = overflow_r_type && overflow_alu_op == 5'b00111;
    assign addi_op = overflow_opcode == 5'b00101;

    // set the correct value to be written to status reg
    wire [31:0] rstatus_val;
    tri_state add_buffer(32'd1, add_op, rstatus_val);
    tri_state sub_buffer(32'd3, sub_op, rstatus_val);
    tri_state mult_buffer(32'd4, mult_op, rstatus_val);
    tri_state div_buffer(32'd5, div_op, rstatus_val);
    tri_state addi_buffer(32'd2, addi_op, rstatus_val);

    // if jal instruction, then o input to xm latch should be pc+1, not alu output
    wire dx_jal;
    assign dx_jal = x_opcode == 5'b00011;
    wire [31:0] xm_in_o;
    assign xm_in_o = overflow ? rstatus_val : (dx_jal ? dx_out_pc : x_alu_res);

    // X/M latch
    wire[31:0] xm_out_b, xm_out_ir;
    wire xm_out_over;
    latch_xm xm_latch(overflow, dx_out_ir, xm_in_o, x_alu_b_bypass, xm_out_ir, xm_out_o, xm_out_b, xm_out_over, clock, reset);

    //multdiv

    //multdiv unit
    wire multdiv_is_running, multdiv_ready, multdiv_x, multdiv_latch_en;
    wire [31:0] multdiv_a, multdiv_b, multdiv_ir, multdiv_res;
    multdiv_control md_logic (ctrl_mult, ctrl_div, dx_out_ir, x_alu_a, x_alu_b, clock, multdiv_ready, multdiv_x, multdiv_latch_en, multdiv_ir, multdiv_is_running, multdiv_res);

    // detect if current instruction is multdiv
    wire ctrl_mult, ctrl_div;
    assign ctrl_mult = x_r_type_ins && alu_op == 5'b00110;
    assign ctrl_div =  x_r_type_ins && alu_op == 5'b00111;

    // memory stage

    // assign data memory access address
    assign address_dmem = xm_out_o;

    // data to be written based on bypass
    assign data = data_mem_bypass_select ? data_writeReg : xm_out_b;

    // assign write enable for dmem from opcode for memory stage, only enabled for sw
    assign wren = xm_out_ir[31:27] == 5'b00111;

    // M/W latch
    wire [31:0] mw_out_ir, mw_out_d, mw_out_o;
    wire mw_out_over;
    latch_mw mw_latch(xm_out_over, xm_out_ir, xm_out_o, q_dmem, mw_out_ir, mw_out_o, mw_out_d, mw_out_over, clock, reset);


    //writeback stage

    wire [4:0] w_opcode;
    assign w_opcode = mw_out_ir[31:27];
    
    // M/W O or D mux, only load word writes back D, if multdiv is ready, set write data to the multdiv result
    assign data_writeReg = w_is_lw ? mw_out_d : ((multdiv_ready && !multdiv_x) ? multdiv_res : mw_out_o);

    // determine which register to write to
    // if instruction writes to normal rd, not reg 31, 30 or multdiv result
    wire [2:0] write_reg_select;
    assign write_reg_select = { w_is_setx | mw_out_over, w_is_jal, multdiv_ready & !multdiv_x };
    mux_8_5bit write_reg_mux(ctrl_writeReg, write_reg_select, mw_out_ir[26:22],multdiv_ir[26:22], 5'd31, 5'd0, 5'd30, 5'd0, 5'd0, 5'd0);

    // determine which instruction and if instruction needs to write back
    wire w_is_r_type, w_is_addi, w_is_lw, w_is_jal, w_is_setx;
    assign w_is_r_type = w_opcode == 5'b00000;
    assign w_is_addi = w_opcode == 5'b00101;
    assign w_is_lw = w_opcode == 5'b01000;
    assign w_is_jal = w_opcode == 5'b00011;
    assign w_is_setx = w_opcode == 5'b10101;
    assign ctrl_writeEnable = w_is_r_type | w_is_addi | w_is_lw | w_is_jal | w_is_setx | (multdiv_ready & !multdiv_x) ;

    // stall logic
    wire fd_r_type, fd_bex;
    assign fd_r_type = fd_ir_op == 5'b00000;
    assign fd_bex = fd_ir_op == 5'b10110;

    wire [4:0] dx_ir_op, fd_ir_rs1, fd_ir_rs2, dx_ir_rd, fd_ir_op;
    assign dx_ir_op = dx_out_ir[31:27];
    assign fd_ir_rs1 = fd_out_ir[21:17];
    assign fd_ir_rs2 = fd_r_type ? fd_out_ir[16:12] : (fd_bex ? 5'b11110 : fd_out_ir[26:22]);
    assign dx_ir_rd = dx_out_ir[26:22];
    assign fd_ir_op = fd_out_ir[31:27];

    assign stall = ((dx_ir_op == 5'b01000) && ((fd_ir_rs1 == dx_ir_rd) || ((fd_ir_rs2 == dx_ir_rd) && (fd_ir_op != 5'b00111)))) || multdiv_is_running || multdiv_latch_en;

    // blt branches if rd is less than rs, but rd goes in b of alu and rs goes in a, and alu_ILT is true if a is less than b, we need to flip this to get rd < rs
    wire rd_less_than_rs;
    assign rd_less_than_rs = alu_INE ? ~alu_ILT : 1'b0;

    pc_control control(next_pc, branch_or_jump_pc, cur_pc, sign_extended_immediate, dx_out_pc, dx_out_ir, x_alu_b_bypass, alu_INE, rd_less_than_rs);

    wire data_mem_bypass_select;
    bypass bp(data, xm_out_ir, mw_out_ir, dx_out_ir, x_alu_a_select, x_alu_b_select, data_mem_bypass_select, xm_out_over, mw_out_over);
	
	/* END CODE */

endmodule
