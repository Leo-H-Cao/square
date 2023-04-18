module latch_mw(in_overflow, in_ir, in_o, in_d, out_ir, out_o, out_d, out_overflow,clk, clr);

    input [31:0] in_ir, in_o, in_d;
    input clk, clr, in_overflow;
    output [31:0] out_o, out_ir, out_d;
    output out_overflow;

    register32_neg mw_pc_reg(in_o, out_o, clk, 1'b1, clr);
    register32_neg mw_ir_reg(in_ir, out_ir, clk, 1'b1, clr);
    register32_neg mw_b_reg(in_d, out_d, clk, 1'b1, clr);
    dffe_ref_falling overflow_dff(out_overflow, in_overflow, clk, 1'b1, clr);
    
endmodule