module leftshift_8(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[31:8] = A[23:0];
    assign out[0] = 1'b0;        
    assign out[1] = 1'b0;
    assign out[2] = 1'b0;
    assign out[3] = 1'b0;
    assign out[4] = 1'b0;
    assign out[5] = 1'b0;
    assign out[6] = 1'b0;
    assign out[7] = 1'b0;

endmodule