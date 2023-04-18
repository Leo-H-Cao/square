module leftshift_1(A, out);
    input [31:0] A;
    output [31:0] out;

    assign out[31:1] = A[30:0];
    assign out[0] = 1'b0;        
    
endmodule