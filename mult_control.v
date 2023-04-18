module mult_control(multiplier_LSB, shift, add, sub);
    input [2:0] multiplier_LSB;
    output sub, shift, add;

    
    // mux output is sub=1st bit, add=2nd bit, shift=3rd bit
    wire [31:0] mux_out;
    mux_8 control_mux(mux_out, multiplier_LSB, 32'b000, 32'b010, 32'b010, 32'b110, 32'b101, 32'b001, 32'b001, 32'b000);

    assign sub = mux_out[0];
    assign shift = mux_out[2];
    assign add = mux_out[1];
    
endmodule