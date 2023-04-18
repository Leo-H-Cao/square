module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // save result for mult and div
    wire[31:0] mult_res, div_res; 
    wire mult_overflow, div_by_0, mult_ready, div_ready;

    multiply mult(data_operandA, data_operandB, mult_res, clock, ctrl_MULT, mult_ready, mult_overflow);

    divide div(data_operandA, data_operandB, div_res, clock, ctrl_DIV, div_ready, div_by_0);

    // determine which operation we are doing, make sure either ctrl_MULT or ctrl_DIV are high, indicating start of new operation
    wire dff_enable, mult_dff, div_dff;
    assign dff_enable = ctrl_DIV | ctrl_MULT;
    dffe_ref mul_dff(mult_dff, ctrl_MULT, clock, dff_enable, 1'b0);
    dffe_ref divide_dff(div_dff, ctrl_DIV, clock, dff_enable, 1'b0);

    // set actual outputs to match the current operation
    assign data_result = mult_dff ? mult_res : (div_dff ? div_res : 32'b0);
    assign data_exception = mult_dff ? mult_overflow : (div_dff ? div_by_0 : 1'b0);
    assign data_resultRDY = mult_dff ? mult_ready : (div_dff ? div_ready : 1'b0);

endmodule
