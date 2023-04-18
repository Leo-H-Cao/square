module rightshift_16(A, out);
    input [31:0] A;
    output [31:0] out;

    // assign out [31:0] = A [31:0];

    assign out[15:0] = A[31:16];
    assign out[31] = A[31];        
    assign out[30] = A[31];
    assign out[29] = A[31];
    assign out[28] = A[31];
    assign out[27] = A[31];
    assign out[26] = A[31];
    assign out[25] = A[31];
    assign out[24] = A[31];      
    assign out[23] = A[31];      
    assign out[22] = A[31];
    assign out[21] = A[31];
    assign out[20] = A[31];
    assign out[19] = A[31];
    assign out[18] = A[31];
    assign out[17] = A[31];
    assign out[16] = A[31];
    
endmodule