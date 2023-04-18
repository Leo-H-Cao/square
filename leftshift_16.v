module leftshift_16(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[31:16] = A[15:0];
    assign out[0] = 1'b0;        
    assign out[1] = 1'b0;
    assign out[2] = 1'b0;
    assign out[3] = 1'b0;
    assign out[4] = 1'b0;
    assign out[5] = 1'b0;
    assign out[6] = 1'b0;
    assign out[7] = 1'b0;
    assign out[8] = 1'b0;        
    assign out[9] = 1'b0;
    assign out[10] = 1'b0;
    assign out[11] = 1'b0;
    assign out[12] = 1'b0;
    assign out[13] = 1'b0;
    assign out[14] = 1'b0;
    assign out[15] = 1'b0;
    

endmodule