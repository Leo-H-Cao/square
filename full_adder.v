module full_adder(P, G, S, A, B, Cin);

    input A, B, Cin;
    output S, P, G;

    or POR(P, A, B);
    and GAND(G, A,B);
    xor SXOR(S, A, B, Cin);

endmodule