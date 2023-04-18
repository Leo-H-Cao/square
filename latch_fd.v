module latch_fd(in_pc, out_pc, in_ir, out_ir, clk, en, clear);

    input [31:0] in_pc, in_ir;
    input clk, en, clear;
    output[31:0] out_pc, out_ir;

    register32_neg pc_reg(in_pc, out_pc, clk, en, clear);
    register32_neg ir_reg(in_ir, out_ir, clk, en, clear);
endmodule

