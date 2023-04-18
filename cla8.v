module cla8(Cin, S, PP, GG, A, B);

    input [7:0] A, B;
    input Cin;
    output PP, GG;
    output [7:0] S;

    wire [7:0] p, g;
    wire [7:1] c;


    // block-level lookahead logic
    wire p0c0, c1;
    wire p1g0, p1p0c0, c2;
    wire p2g1, p2p1g0, p2p1p0c0, c3;
    wire p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0, c4;
    wire p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0, c5;
    wire p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0, c6;
    wire p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0, c7;
    wire p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2p1p0c0, c8; 

    and c1and1(p0c0, p[0], Cin);
    or c1or(c1, p0c0, g[0]);
    assign c[1] = c1;

    and c2and1(p1g0, p[1], g[0]);
    and c2and2(p1p0c0, p[1], p[0], Cin);
    or c2or(c2, g[1], p1g0, p1p0c0);
    assign c[2] = c2;

    and c3and1(p2g1, p[2], g[1]);
    and c3and2(p2p1g0, p[2], p[1], g[0]);
    and c3and3(p2p1p0c0, p[2], p[1], p[0], Cin);
    or c3or(c3, g[2], p2g1, p2p1g0, p2p1p0c0);
    assign c[3] = c3;

    and c4and1(p3g2, p[3], g[2]);
    and c4and2(p3p2g1, p[3], p[2], g[1]);
    and c4and3(p3p2p1g0, p[3], p[2], p[1], g[0]);
    and c4and4(p3p2p1p0c0, p[3], p[2], p[1], p[0], Cin);
    or c4or(c4, g[3], p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);
    assign c[4] = c4;

    and c5and1(p4g3, p[4], g[3]);
    and c5and2(p4p3g2, p[4], p[3], g[2]);
    and c5and3(p4p3p2g1, p[4], p[3], p[2], g[1]);
    and c5and4(p4p3p2p1g0, p[4], p[3], p[2], p[1], g[0]);
    and c5and5(p4p3p2p1p0c0, p[4], p[3], p[2], p[1], p[0], Cin);
    or c5or(c5, g[4], p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0);
    assign c[5] = c5;

    and c6and1(p5g4, p[5], g[4]);
    and c6and2(p5p4g3, p[5], p[4], g[3]);
    and c6and3(p5p4p3g2, p[5], p[4], p[3], g[2]);
    and c6and4(p5p4p3p2g1, p[5], p[4], p[3], p[2], g[1]);
    and c6and5(p5p4p3p2p1g0, p[5], p[4], p[3], p[2], p[1], g[0]);
    and c6and6(p5p4p3p2p1p0c0, p[5], p[4], p[3], p[2], p[1], p[0], Cin);
    or c6or(c6, g[5], p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0);
    assign c[6] = c6;

    and c7and1(p6g5, p[6], g[5]);
    and c7and2(p6p5g4, p[6], p[5], g[4]);
    and c7and3(p6p5p4g3, p[6], p[5], p[4], g[3]);
    and c7and4(p6p5p4p3g2, p[6], p[5], p[4], p[3], g[2]);
    and c7and5(p6p5p4p3p2g1, p[6], p[5], p[4], p[3], p[2], g[1]);
    and c7and6(p6p5p4p3p2p1g0, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and c7and7(p6p5p4p3p2p1p0c0, p[6], p[5], p[4], p[3], p[2], p[1], p[0], Cin);
    or c7or(c7, g[6], p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0);
    assign c[7] = c7;


    // calculate G
    and Gand1(p7g6, p[7], g[6]);
    and Gand2(p7p6g5, p[7], p[6], g[5]);
    and Gand3(p7p6p5g4, p[7], p[6], p[5], g[4]);
    and Gand4(p7p6p5p4g3, p[7], p[6], p[5], p[4], g[3]);
    and Gand5(p7p6p5p4p3g2, p[7], p[6], p[5], p[4], p[3], g[2]);
    and Gand6(p7p6p5p4p3p2g1, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and Gand7(p7p6p5p4p3p2p1g0, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    or Gor(GG, g[7], p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0);

    // calculate P
    and PPand(PP, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);

    // 8 full adders
    full_adder adder1(p[0], g[0], S[0], A[0], B[0], Cin);
    full_adder adder2(p[1], g[1], S[1], A[1], B[1], c[1]);
    full_adder adder3(p[2], g[2], S[2], A[2], B[2], c[2]);
    full_adder adder4(p[3], g[3], S[3], A[3], B[3], c[3]);
    full_adder adder5(p[4], g[4], S[4], A[4], B[4], c[4]);
    full_adder adder6(p[5], g[5], S[5], A[5], B[5], c[5]);
    full_adder adder7(p[6], g[6], S[6], A[6], B[6], c[6]);
    full_adder adder8(p[7], g[7], S[7], A[7], B[7], c[7]);

endmodule