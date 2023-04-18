module latch_dx(in_pc, in_ir, in_a, in_b, out_pc, out_ir, out_a, out_b, clk, clr);

    input [31:0] in_pc, in_ir, in_a, in_b;
    input clk, clr;
    output [31:0] out_pc, out_ir, out_a, out_b;

    register32_neg dx_pc_reg(in_pc, out_pc, clk, 1'b1, clr);
    register32_neg dx_ir_reg(in_ir, out_ir, clk, 1'b1, clr);
    register32_neg dx_a_reg(in_a, out_a, clk, 1'b1, clr);
    register32_neg dx_b_reg(in_b, out_b, clk, 1'b1, clr);
    
endmodule

