module rightshift_8(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[23:0] = A[31:8];
    assign out[31] = A[31];        
    assign out[30] = A[31];
    assign out[29] = A[31];
    assign out[28] = A[31];
    assign out[27] = A[31];
    assign out[26] = A[31];
    assign out[25] = A[31];
    assign out[24] = A[31];

endmodule