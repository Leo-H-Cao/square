module tff(T, clock, reset, Q);

    input T, clock, reset;
    output Q;
    
    wire dff_input, dff_out;
    assign dff_input = T ^ dff_out;

    dffe_ref dff(Q, dff_input, clock, 1'b1, reset);
    assign dff_out = Q;


endmodule