module leftshift_4(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[31:4] = A[27:0];
    assign out[0] = 1'b0;        
    assign out[1] = 1'b0;
    assign out[2] = 1'b0;
    assign out[3] = 1'b0;

endmodule