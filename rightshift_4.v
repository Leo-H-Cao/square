module rightshift_4(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[27:0] = A[31:4];
    assign out[31] = A[31];        
    assign out[30] = A[31];
    assign out[29] = A[31];
    assign out[28] = A[31];

endmodule