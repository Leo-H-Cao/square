module rightshift_1(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[30:0] = A[31:1];
    assign out[31] = A[31];        
    
endmodule