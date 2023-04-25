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
	output [7:0] rights,
	input [7:0] moveSpeed,
	output player,
	input startGame,
	input eoc,
	output adc_start
	);
	
	assign left = sw[3];
	assign right = sw[2];
	assign up = sw[1];
	assign down = sw[0];
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/lhc22/Desktop/square/";

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
		VIDEO_HEIGHT = 480, // Standard VGA Height
		SQUARE_DIM = 50,
		LEFT_SCORE_X = 20,
		LEFT_SCORE_Y = 20,
		RIGHT_SCORE_X = 590,
		RIGHT_SCORE_Y = 20,
		TITLE_X = 95,
		TITLE_WIDTH = 450,
		TITLE_Y = 30,
		TITLE_HEIGHT = 150;

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	reg[9:0] squareX;
	reg[8:0] squareY;
	initial begin
		squareX = 285;
		squareY = 215;
	end
	
	wire[9:0] xLeftBound = squareX;
	wire[9:0] xRightBound = squareX + SQUARE_DIM;
	wire[8:0] yTopBound = squareY;
	wire[8:0] yBottomBound = squareY + SQUARE_DIM;
	
	assign showSquareHere = (xLeftBound < x & x < xRightBound & yTopBound < y & y < yBottomBound) & ballSpriteData;

	wire[9:0] leftScoreLeftBound = LEFT_SCORE_X;
	wire[9:0] leftScoreRightBound = LEFT_SCORE_X + SQUARE_DIM;
	wire[8:0] leftScoreTopBound = LEFT_SCORE_Y;
	wire[8:0] leftScoreBottomBound = LEFT_SCORE_Y + SQUARE_DIM;
	assign showLeftScoreHere = (leftScoreLeftBound < x & x < leftScoreRightBound & leftScoreTopBound < y & y < leftScoreBottomBound) & leftScoreSpriteData;

	wire[9:0] rightScoreLeftBound = RIGHT_SCORE_X;
	wire[9:0] rightScoreRightBound = RIGHT_SCORE_X + SQUARE_DIM;
	wire[8:0] rightScoreTopBound = RIGHT_SCORE_Y;
	wire[8:0] rightScoreBottomBound = RIGHT_SCORE_Y + SQUARE_DIM;
	assign showRightScoreHere = (rightScoreLeftBound < x & x < rightScoreRightBound & rightScoreTopBound < y & y < rightScoreBottomBound) & rightScoreSpriteData;

	wire[9:0] titleLeftBound = TITLE_X;
	wire[9:0] titleRightBound = TITLE_X + TITLE_WIDTH;
	wire[8:0] titleTopBound = TITLE_Y;
	wire[8:0] titleBottomBound = TITLE_Y + TITLE_HEIGHT;
	assign showTitleHere = (titleLeftBound < x & x < titleRightBound & titleTopBound < y & y < titleBottomBound) & spriteData_title & ~startGame;

	assign showWinnerRight = (titleLeftBound < x & x < titleRightBound & titleTopBound < y & y < titleBottomBound) & spriteData_winnerRight & (leftsc == 8'd5);
	assign showWinnerLeft = (titleLeftBound < x & x < titleRightBound & titleTopBound < y & y < titleBottomBound) & spriteData_winnerLeft & (rightsc == 8'd5);
	
	reg [7:0] leftsc = 8'b0; 
	reg [7:0] rightsc = 8'b0;
	wire [31:0] left_sc, right_sc;
	assign left_sc = leftsc;
	assign right_sc = rightsc;
	assign lefts = moveSpeed[7:0];
	assign rights = 8'b0;
    
    reg flag;

	wire [31:0] sq_left, sq_right;
	assign sq_left = squareX;
	assign sq_right = squareX+SQUARE_DIM;

	wire [31:0] proc_player, proc_start, proc_eoc;

	Wrapper wr(clk25, reset, proc_player, proc_eoc);
	assign player = proc_player[0];
	// assign adc_start = proc_start[0];
	assign proc_eoc = eoc;


	always @(posedge clk)begin
		if  (screenEnd) begin
			if (player & startGame & leftsc != 8'd5 & rightsc != 8'd5) begin
				squareX = squareX - moveSpeed/32;
			end else if (~player & startGame  & leftsc != 8'd5 & rightsc != 8'd5) begin
				squareX = squareX + moveSpeed/32;
			end 

			// if (left) begin
			// 	squareX = squareX - 1;
			// end else if (right) begin
			// 	squareX = squareX + 1;
			// end
			
			if (squareX < 160 & !flag) begin
				rightsc <= rightsc + 1;
				squareX = 285;
				flag <= 1'b1;
			end
			if (squareX > 430 & !flag) begin
				leftsc <= leftsc + 1;
				squareX = 285;
				flag <= 1'b1;
			end

			if (squareX > 160 && squareX < 430 & flag)begin
				flag <= 1'b0;
			end
		end
	end
	
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
		.MEMFILE({FILES_PATH, "field.mem"})) // Memory initialization
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
		.MEMFILE({FILES_PATH, "field_colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading

	// ball sprite
	// wire[17:0] spriteAddress;  	 // Image address for the image data
	wire spriteData; 	 // Color address for the color palette
	// assign spriteAddress = (36)*2500+ x-xLeftBound + 50*(y-yTopBound);			
	VGARAM #(		
		.DEPTH(50*50*37), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(18),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "sprites.mem"})) // Memory initialization
	SpriteData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(realSpriteAddress),					 // Image data address
		.dataOut(spriteData),				 // Color palette address
		.wEn(1'b0));

	wire ballSpriteData, rightScoreSpriteData, leftScoreSpriteData;
	assign ballSpriteData = (xLeftBound < x & x < xRightBound & yTopBound < y & y < yBottomBound) ? spriteData : 1'b0;
	assign rightScoreSpriteData = (rightScoreLeftBound < x & x < rightScoreRightBound & rightScoreTopBound < y & y < rightScoreBottomBound) ? spriteData : 1'b0;
	assign leftScoreSpriteData = (leftScoreLeftBound < x & x < leftScoreRightBound & leftScoreTopBound < y & y < leftScoreBottomBound) ? spriteData : 1'b0;
	
	wire [17:0] realSpriteAddress;
	assign realSpriteAddress = (xLeftBound < x & x < xRightBound & yTopBound < y & y < yBottomBound) ? (36)*2500+ x-xLeftBound + 50*(y-yTopBound) : ((leftScoreLeftBound < x & x < leftScoreRightBound & leftScoreTopBound < y & y < leftScoreBottomBound) ? (right_sc)*2500+ x-leftScoreLeftBound + 50*(y-leftScoreTopBound) : (left_sc)*2500+ x-rightScoreLeftBound + 50*(y-rightScoreTopBound));

	//title
	wire[17:0] spriteAddress_title;  	 // Image address for the image data
	wire spriteData_title; 	 // Color address for the color palette
	assign spriteAddress_title =  x-titleLeftBound + 450*(y-titleTopBound);			
	VGARAM #(		
		.DEPTH(450*150), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(18),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "title.mem"})) // Memory initialization
	SpriteDataTitle(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(spriteAddress_title),					 // Image data address
		.dataOut(spriteData_title),				 // Color palette address
		.wEn(1'b0));

	//winner right
	wire[17:0] spriteAddress_winnerRight;  	 // Image address for the image data
	wire spriteData_winnerRight; 	 // Color address for the color palette
	assign spriteAddress_winnerRight =  x-titleLeftBound + 450*(y-titleTopBound);			
	VGARAM #(		
		.DEPTH(450*150), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(18),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "winnerright.mem"})) // Memory initialization
	SpriteDataWinnerRight(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(spriteAddress_winnerRight),					 // Image data address
		.dataOut(spriteData_winnerRight),				 // Color palette address
		.wEn(1'b0));

	//winner left
	wire[17:0] spriteAddress_winnerLeft;  	 // Image address for the image data
	wire spriteData_winnerLeft; 	 // Color address for the color palette
	assign spriteAddress_winnerLeft =  x-titleLeftBound + 450*(y-titleTopBound);			
	VGARAM #(		
		.DEPTH(450*150), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(18),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "winnerleft.mem"})) // Memory initialization
	SpriteDataWinnerLeft(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(spriteAddress_winnerLeft),					 // Image data address
		.dataOut(spriteData_winnerLeft),				 // Color palette address
		.wEn(1'b0));

	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	// When not active, output black
	assign colorOut = (active & ~showSquareHere & ~showLeftScoreHere & ~showRightScoreHere & ~showTitleHere & ~showWinnerLeft & ~showWinnerRight) ? colorData : 12'd0;
	

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule