module latch_multdiv(multdiv_is_running, res_ready, is_multdiv, in_ir, in_a, in_b, out_ir, out_a, out_b, clk);

    input [31:0] in_ir, in_a, in_b;
    input clk, res_ready, is_multdiv;
    output [31:0] out_a, out_ir, out_b;
    output multdiv_is_running;

    // dff for tracking when multdiv result is ready
    dffe_ref_falling multdiv_running_dff(multdiv_is_running, 1'b1, clk, is_multdiv, res_ready);

    register32_neg xm_pc_reg(in_a, out_a, clk, is_multdiv, 1'b0);
    register32_neg xm_ir_reg(in_ir, out_ir, clk, is_multdiv, 1'b0);
    register32_neg xm_b_reg(in_b, out_b, clk, is_multdiv, 1'b0);
    
endmodule