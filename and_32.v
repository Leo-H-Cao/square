module and_32(A, B, out);
        
    input [31:0] A, B;
    output [31:0] out;

    genvar c;

    generate
        for (c = 0; c <= 31; c = c + 1) begin: loop1
            and and_1bit(out[c], A[c], B[c]);
        end
    endgenerate
endmodule