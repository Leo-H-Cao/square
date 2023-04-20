`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data,
	input [3:0] sw,
	output [7:0] lefts,
	output [7:0] rights
	);
	
	assign left = sw[3];
	assign right = sw[2];
	assign up = sw[1];
	assign down = sw[0];
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/lhc22/Downloads/processor/processor/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	VGARAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color  // When not active, output black
	assign colorOut = active ? (x > square_left && x < square_right && y > square_top && y < square_bottom ? (outSprite ? 12'b11111111111 : 12'b0) : colorData) : 12'd0;
	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	reg [31:0] leftsc, rightsc;
	wire [31:0] left_sc, right_sc;
	wire [31:0] l, r;
	assign left_sc = leftsc;
	assign right_sc = rightsc;
	Wrapper wr(clk, reset, square_left, square_right, l, r);
	assign lefts = left_sc[7:0];
	assign rights = right_sc[7:0];

	//reference points
	wire[9:0] x;
	wire[8:0] y;

	reg[9:0] square_x;
	reg[8:0] square_y;
	reg flag;

	initial begin
		square_x = 270;
		square_y = 240;
		flag = 1'b0;
	end

	reg [9:0] square_left, square_right;
	reg [8:0] square_bottom, square_top;
	

	always @(posedge screenEnd)begin
		if (left) begin
			square_x <= square_x-1;
		end else if (right) begin
			square_x <= square_x +1;
		end else if (up) begin
			square_y <= square_y -1;
		end else if (down) begin
			square_y <= square_y+1;
		end
		if (square_x < 160 & !flag) begin
		     rightsc <= rightsc + 1;
			 flag <= 1'b1;
		end
		if (square_x > 430 & !flag) begin
		     leftsc <= leftsc + 1;
			 flag <= 1'b1;
		end

		if (square_x > 160 && square_x < 430 & flag)begin
			 flag <= 1'b0;
		end
		

		square_left <= square_x;
		square_right <= square_x + 50;
		square_bottom <= square_y + 50;
		square_top <= square_y;


	end
	
	wire [7:0] rx_data;
	wire read_data;
	reg [7:0] latch_rx;
	Ps2Interface my_ps2(ps2_clk, ps2_data, clk, rst, 8'b0, 1'b0, rx_data, read_data, busy, err);

	always @(posedge clk)begin
		if (read_data) begin
			latch_rx <= rx_data;
		end
	end

	reg [7:0] outAscii;
	reg outSprite;
	wire [7:0] outAsciiw;
	wire outSpritew;
	
	VGARAM #(8, 9, 256, {FILES_PATH, "ascii.mem"})ASCIIRAM(clk, 1'b0, latch_rx, 8'b0, outAsciiw);

	always @(posedge clk)begin
		outAscii <= outAsciiw;
	end

	assign spriteAddress = (outAscii - 35)*2500 + (x-square_left+50*(y-square_top));

	VGARAM #(1, 19, 256, {FILES_PATH, "sprites.mem"})SPRITERAM(clk, 1'b0, spriteAddress, 8'b0, outSpritew);

	always @(posedge clk)begin
		outSprite <= outSpritew;
	end
	
endmodule