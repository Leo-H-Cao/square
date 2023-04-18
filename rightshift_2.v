module rightshift_2(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[29:0] = A[31:2];
    assign out[31] = A[31];        
    assign out[30] = A[31];
    
endmodule