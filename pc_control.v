module pc_control(next_pc, branch_or_jump_pc, cur_pc, immediate_sx, dx_out_pc, dx_out_ir, rd_val, alu_INE, rd_ILT_rs );

    output [31:0] next_pc;
    output branch_or_jump_pc;
    input rd_ILT_rs, alu_INE;
    input [31:0] cur_pc, dx_out_pc, immediate_sx, rd_val, dx_out_ir;

    // calculate pc+1
    wire [31:0] pc_plus_1;
    wire pc_adder_overflow;
    cla32 pc_adder(1'b0, pc_plus_1, cur_pc, 32'b1, pc_adder_overflow);

    // store T if instruction is a jump to T
    wire [31:0] T;
    assign T[31:0] = {5'b0, dx_out_ir[26:0]};

    // calculate pc if we take branch or jump
    wire [31:0] branch_pc;
    wire branch_pc_adder_overflow;
    cla32 branch(1'b0, branch_pc, dx_out_pc, immediate_sx, branch_pc_adder_overflow);

    // mux to select correct next pc
    wire [2:0] next_pc_select;
    wire [31:0] next_pc_mux_out;
    assign next_pc_select = dx_out_ir[29:27];
    wire [31:0] bne_pc, blt_pc;
    assign bne_pc = alu_INE || !alu_INE && dx_out_ir[31:27] == 5'b11010 ? branch_pc : pc_plus_1;
    assign blt_pc = rd_ILT_rs ? branch_pc : pc_plus_1;
    mux_8 pc_mux(next_pc_mux_out, next_pc_select, pc_plus_1, T, bne_pc, T, rd_val, pc_plus_1, blt_pc, pc_plus_1);

    // check if instruction is bex
    wire is_bex;
    assign is_bex = dx_out_ir[31:27] == 5'b10110;

    // if bex instruction, jump if rstatus != 0
    assign next_pc = (is_bex && rd_val != 0) ? T : next_pc_mux_out;

    assign branch_or_jump_pc = next_pc_select == 3'b001 || (next_pc_select == 3'b010 && alu_INE) || (next_pc_select == 3'b010 && (dx_out_ir[31:27] == 5'b11010 && !alu_INE)) || next_pc_select == 3'b011 || next_pc_select == 3'b100 || (next_pc_select == 3'b110 && rd_ILT_rs) || (is_bex && rd_val != 0);
    
endmodule