`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:11 04/19/2017 
// Design Name: 
// Module Name:    spaceship 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spaceship(	clk,
						reset,
						playing,
						left,
						right,
						shipborderX,
						shipborderY,
						alienrocket1,
						alienrocket1X,
						alienrocket1Y,
						shiphit,
						shipX,
						shipY,
						);
						
input clk, reset, playing, left, right;
input [5:0] shipborderX;
input [4:0] shipborderY;
input alienrocket1;
input [9:0] alienrocket1X;
input [8:0] alienrocket1Y;
output reg shiphit;
output reg [9:0] shipX;
output reg [8:0] shipY;

always@ (posedge clk, posedge reset)
	begin
		if(reset || !playing)
		begin
			shipX <= 320;
			shipY <= 450;
			shiphit <= 0;
		end
		
		else
		begin
			if(left && !right)
				shipX <= (shipX > shipborderX) ? (shipX - 2):shipX;
				
			else if(right)
				shipX <= (shipX < 640 - shipborderX) ? (shipX + 2):shipX;
				
			//if((alienrocket1X - 2 > shipX - shipborderX) && (alienrocket1X + 2 < shipX + shipborderX) && (alienrocket1Y + 2 < shipY + shipborderY))
				//shiphit <= 1;
				
			else
				shiphit <= 0;
		end
	end

endmodule
