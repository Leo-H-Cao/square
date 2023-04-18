module multdiv_control(ctrl_mult, ctrl_div, dx_out_ir, x_alu_a, x_alu_b, clock, multdiv_ready, multdiv_x, multdiv_latch_en, multdiv_ir, multdiv_is_running, multdiv_res);

    output multdiv_ready, multdiv_x, multdiv_latch_en, multdiv_is_running;
    output [31:0] multdiv_ir, multdiv_res;
    input ctrl_mult, ctrl_div, clock;
    input [31:0] dx_out_ir, x_alu_a, x_alu_b;

    wire [31:0] multdiv_a, multdiv_b;
    multdiv mult_div(multdiv_a, multdiv_b, ctrl_mult, ctrl_div, clock, multdiv_res,multdiv_x, multdiv_ready);

    wire multdiv_latch_en;
    assign multdiv_latch_en = ctrl_mult || ctrl_div;

    //latch multdiv inputs
    latch_multdiv multdiv_latch(multdiv_is_running, multdiv_ready, multdiv_latch_en, dx_out_ir, x_alu_a, x_alu_b, multdiv_ir, multdiv_a, multdiv_b, clock);

endmodule