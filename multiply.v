module multiply(multiplicand, multiplier, product, clk, clr, ready, data_exception);

    input [31:0] multiplicand, multiplier;
    output[31:0] product;
    input clk, clr;
    output ready, data_exception;


    wire shift, add, sub;
    mult_control control(cur_product[2:0], shift, add, sub);

    // shift multiplicand if control calls for it
    wire [31:0] shifted_multiplicand;
    assign shifted_multiplicand = shift ? multiplicand << 1 : multiplicand;

    // invert multiplicand if we are doing subtraction
    wire [31:0] multiplicand_shifted_inverted; 
    assign multiplicand_shifted_inverted = sub ? ~shifted_multiplicand : shifted_multiplicand;

    // set input to adder to be 0 if control says to do nothing
    wire [31:0] multiplicand_adder_in;
    assign multiplicand_adder_in = (~shift) & (~add) & (~sub) ? 32'b0 : multiplicand_shifted_inverted;

    // store initial product 
    wire[64:0] first_product;
    assign first_product = {32'b0, multiplier, 1'b0};
    // assign first_product[0] = 1'b0;
    // assign first_product[32:1] = multiplier;
    // assign first_product[64:33] = 32'b0;

    // product in all other iterations besides first
    wire signed [64:0] cur_product;

    wire [31:0] product_upper, adder_out;
    wire overflow;
    cla32 adder(sub, adder_out, multiplicand_adder_in, product_upper, overflow);

    assign product_upper = cur_product[64:33];
    
    // set product upper bits to addition output, make lower bits the current multiplier
    wire signed [64:0] product_after_add;
    assign product_after_add[64:33] = adder_out;
    assign product_after_add[32:0] = cur_product[32:0];

    
    // shift new product
    wire signed [64:0] shifted_prod;
    assign shifted_prod = $signed(product_after_add) >>> 2;

    // set input to product register by shifting the new product, or using the initial product for first iteration
    wire signed [64:0] product_reg_in;
    wire first_iter;
    assign first_iter = (iteration ^ 6'b0) ? 1'b0 : 1'b1;
    assign product_reg_in = first_iter ? first_product : shifted_prod;

    // register for storing running product
    reg65 product_reg(product_reg_in, cur_product, clk, 1'b1, clr);

    // assign output
    assign product = cur_product[32:1];

    // track which iteration we are on
    wire [5:0] iteration;
    counter mult_counter(iteration, clk, clr);

    // set ready to be true when multiplication completes
    assign ready = (iteration ^ 6'b010001) ? 1'b0 : 1'b1;

    // true if sign of answer doesn't make sense (inputs are positive and product is negative, or 1 negative input but product is positive)
    wire output_sign;
    assign output_sign = (multiplicand[31] ^ multiplier[31]) ^ product[31];

    // if output sign doesnt make sense and both inputs are not zero
    wire sign_exception;
    assign sign_exception = output_sign & |multiplicand & |multiplier;

    // check if any significant bits in upper 32
    wire upper_bits_exception;
    assign upper_bits_exception = (|cur_product[64:32]) & (|(~cur_product[64:32]));

    assign data_exception = sign_exception | upper_bits_exception;



endmodule
