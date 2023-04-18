module cla32(Cin, S, A, B, Over);

    input Cin;
    wire [3:0] PP, GG;
    input [31:0] A, B;
    output Over;
    output [31:0] S;
    wire c8, c16, c24, c32;

    // second-level lookahead logic
    wire P0c0;
    wire P1G0, P1P0c0;
    wire P2G1, P2P1G0, P2P1P0c0;
    wire P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0; 

    and c8and1(P0c0, PP[0], Cin);
    or c8or(c8, P0c0, GG[0]);

    and c16and1(P1G0, PP[1], GG[0]);
    and c16and2(P1P0c0, PP[1], PP[0], Cin);
    or c16or(c16, P1G0, P1P0c0, GG[1]);

    and c24and1(P2G1, PP[2], GG[1]);
    and c24and2(P2P1G0, PP[2], PP[1], GG[0]);
    and c24and3(P2P1P0c0, PP[2], PP[1], PP[0], Cin);
    or c24or(c24, P2G1, P2P1G0, P2P1P0c0, GG[2]);

    and c32and1(P3G2, PP[3], GG[2]);
    and c32and2(P3P2G1, PP[3], PP[2], GG[1]);
    and c32and3(P3P2P1G0, PP[3], PP[2], PP[1], GG[0]);
    and c32and4(P3P2P1P0c0, PP[3], PP[2], PP[1], PP[0], Cin);
    or c32or(c32, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0, GG[3]);

    // adders
    cla8 cla1(Cin, S[7:0], PP[0], GG[0], A[7:0], B[7:0]);
    cla8 cla2(c8, S[15:8], PP[1], GG[1], A[15:8], B[15:8]);
    cla8 cla3(c16, S[23:16], PP[2], GG[2], A[23:16], B[23:16]);
    cla8 cla4(c24, S[31:24], PP[3], GG[3], A[31:24], B[31:24]);

    // overflow
    wire operand_match, answer_sign_match, not_ans_sign_match;
    xnor operand_signs(operand_match, A[31], B[31]);
    xnor answer_sign(answer_sign_match, A[31], S[31]);
    not answer_sign_not(not_ans_sign_match, answer_sign_match);
    and overflow(Over, not_ans_sign_match, operand_match);
    
endmodule