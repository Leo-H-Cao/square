module divide(dividend, divisor, result, clk, clr, ready, data_exception);

input [31:0] dividend, divisor;
output[31:0] result;
input clk, clr;
output ready, data_exception;

// keep track of number of iterations
wire [5:0] N;
counter count_N(N, clk, clr);

// result is ready after 33 iterations
assign ready = ((N ^ 6'b100001)) ? 1'b0 : 1'b1;

// get negatives of inputs
wire dividend_negate_overflow;
wire [31:0] negative_dividend;
cla32 negate_dividend(1'b0,  negative_dividend, ~dividend, 32'b1, dividend_negate_overflow);

wire divisor_negate_overflow;
wire [31:0] negative_divisor;
cla32 negate_divisor(1'b0,  negative_divisor, ~divisor, 32'b1, dividend_negate_overflow);

// use the unsigned versions of dividend and divisor for algorithm
wire [31:0] dividend_us, divisor_us;
assign dividend_us = dividend[31] ? negative_dividend : dividend;
assign divisor_us = divisor[31] ? negative_divisor: divisor;

// initialize register value
wire [63:0] init_reg_val;
assign init_reg_val[31:0] = dividend_us;
assign init_reg_val[63:32] = 32'b0;

// update register with initial value or new value after operation
wire[63:0] cur_quotient;
wire[63:0] no_divideby0_reg_input;
wire first_iter;
assign first_iter = (N ^ 6'b0) ? 1'b0 : 1'b1;
assign no_divideby0_reg_input = first_iter ? init_reg_val : next_quotient;
// if divide by zero, just always return 0
wire [63:0] real_reg_input;
assign real_reg_input = data_exception ? 64'b0 : no_divideby0_reg_input;
reg64 AQ(real_reg_input, cur_quotient, clk, 1'b1, clr);

// shift current quotient
wire[63:0] shifted_cur_quotient;
assign shifted_cur_quotient = cur_quotient <<< 1'b1;

// calculate A = A-M
wire [31:0] A_minus_M;
wire subtractIsNotEqual, subtractIsLessThan, subtractOverflow;
alu subtract(shifted_cur_quotient[63:32], divisor_us, 5'b1, 5'b0, A_minus_M, subtractIsNotEqual, subtractIsLessThan, subtractOverflow);

// set the next AQ depending on most significant bit of A-M is positive (if the subtraction needs to be restored or not)
wire [63:0] next_quotient;
assign next_quotient[63:32] = A_minus_M[31] ? shifted_cur_quotient[63:32] : A_minus_M;
assign next_quotient[31:1] = shifted_cur_quotient[31:1];

// set Q[0] depending on most significant bit of A-M is positive (if the subtraction needs to be restored or not)
assign next_quotient[0] = A_minus_M[31] ? 1'b0 : 1'b1;

// handle signs of inputs and results
wire input_diff_signs;
assign input_diff_signs = dividend[31] ^ divisor[31];

wire quotient_negate_overflow;
wire [31:0] negative_quotient;
cla32 negate_quotient(1'b0, negative_quotient, ~(cur_quotient[31:0]), 32'b1, quotient_negate_overflow);

assign result = input_diff_signs ? negative_quotient: cur_quotient;

//detect divide by 0
assign data_exception = !(divisor ^ 32'b0);

endmodule
