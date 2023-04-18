module rightshift_32(A, out, shiftamt);
    input [31:0] A;
    input [4:0] shiftamt;
    output [31:0] out;

    wire [31:0] out16, out8, out4, out2, out1;
    wire [31:0] in8, in4, in2, in1;

    rightshift_16 shift16(A, out16);
    assign in8 = shiftamt[4] ? out16 : A;
    rightshift_8 shift8(in8, out8);
    assign in4 = shiftamt[3] ? out8 : in8;
    rightshift_4 shift4(in4, out4);
    assign in2 = shiftamt[2] ? out4 : in4;
    rightshift_2 shift2(in2, out2); 
    assign in1 = shiftamt[1] ? out2: in2;
    rightshift_1 shift1(in1, out1);
    assign out = shiftamt[0] ? out1 : in1; 

endmodule