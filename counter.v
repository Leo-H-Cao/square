module counter(count, clock, reset);

    input reset, clock;
    output [5:0] count;

    wire tff3_T, tff4_T, tff5_T, tff6_T;
    assign tff3_T = count[0] & count[1];
    assign tff4_T = count[0] & count[1] & count[2];
    assign tff5_T = count[0] & count[1] & count[2] & count[3];
    assign tff6_T = count[0] & count[1] & count[2] & count[3] & count[4];


    tff tff1(1'b1, clock, reset, count[0]);
    tff tff2(count[0], clock, reset, count[1]);
    tff tff3(tff3_T, clock, reset, count[2]);
    tff tff4(tff4_T, clock, reset, count[3]);
    tff tff5(tff5_T, clock, reset, count[4]);
    tff tff6(tff6_T, clock, reset, count[5]);


endmodule