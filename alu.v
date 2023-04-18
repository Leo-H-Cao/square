module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // subtract?
    wire sub, op1_not, op2_not;
    not op1not(op1_not, ctrl_ALUopcode[1]);
    not op2not(op2_not, ctrl_ALUopcode[2]);
    and suband(sub, op1_not, op2_not, ctrl_ALUopcode[0]);

    // negate b
    wire [31:0] b_neg;
    invert b_not(data_operandB, b_neg);

    // set B to negated if subtracting
    wire [31:0] adder_B;
    assign adder_B = sub ? b_neg : data_operandB;

    // run 32 CLA adder
    wire [31:0] adder_res;
    cla32 adder(sub, adder_res, data_operandA, adder_B, overflow);

    // determine A isNotEqual B
    assign isNotEqual = adder_res ? 1 : 0;

    // determine A isLessThan B
    wire not_result_msb;
    not not_msb(not_result_msb, adder_res[31]);
    assign isLessThan = overflow ? not_result_msb : adder_res[31];

    // logical left shift
    wire [31:0] sll;
    leftshift_32 shiftleft(data_operandA, sll, ctrl_shiftamt);

    // arithmetic right shift
    wire [31:0] sra;
    rightshift_32 shiftright(data_operandA, sra, ctrl_shiftamt);

    // bitwise and
    wire [31:0] and_bitwise;
    and_32 and1(data_operandA, data_operandB, and_bitwise);

    // bitwise or
    wire [31:0] or_bitwise;
    or_32 or1(data_operandA, data_operandB, or_bitwise);

    // mux for final result
    mux_8 alu_mux(data_result, ctrl_ALUopcode[2:0], adder_res, adder_res, and_bitwise, or_bitwise, sll, sra, 0, 0);
   

endmodule