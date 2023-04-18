module reg64(in, out, clk, en, clr);

input [63:0] in;
output [63:0] out;
input clk, en, clr;

genvar i;
generate
    for(i = 0; i < 64 ; i = i + 1) begin: loop1
        dffe_ref a_dff(out[i], in[i], clk, en, clr);
    end
endgenerate

   
endmodule