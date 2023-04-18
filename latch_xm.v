module latch_xm(in_overflow, in_ir, in_o, in_b, out_ir, out_o, out_b, out_overflow, clk, clr);

    input [31:0] in_ir, in_o, in_b;
    input clk, clr, in_overflow;
    output [31:0] out_o, out_ir, out_b;
    output out_overflow;


    register32_neg xm_pc_reg(in_o, out_o, clk, 1'b1, clr);
    register32_neg xm_ir_reg(in_ir, out_ir, clk, 1'b1, clr);
    register32_neg xm_b_reg(in_b, out_b, clk, 1'b1, clr);
    dffe_ref_falling overflow_dff(out_overflow, in_overflow, clk, 1'b1, clr);
    
endmodule