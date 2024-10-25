`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:25 04/19/2017 
// Design Name: 
// Module Name:    aliens 
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
module alien(	clk,
					reset,
					playing,
					startX,
					startY,
					alienborderX,
					alienborderY,
					shiprocket,
					shiprocketX,
					shiprocketY,
					alienhit,
					direction,
					alienX, 
					alienY
					);
					
input clk, reset, playing, shiprocket;
input [5:0] alienborderX;
input [4:0] alienborderY;
input [9:0] startX, shiprocketX;
input [8:0] startY, shiprocketY;
output reg alienhit, direction;
output reg [9:0] alienX;
output reg [8:0] alienY;

reg dead;

always@ (posedge clk, posedge reset)
begin
	if(reset || !playing)
	begin
		alienX <= startX;
		alienY <= startY;
		alienhit <= 0;
		direction <= 1;
		dead <= 0;
	end
	
	else if (!alienhit && !dead)
	begin
		if((direction && (alienX > (640 - alienborderX))) || (!direction && (alienX < alienborderX)))
		begin
			direction <= ~direction;
			alienY <= alienY + alienborderY;
		end
		
		if((shiprocketX + 2 < alienX + alienborderX) && (shiprocketX - 2 > alienX - alienborderX) && (shiprocketY + 2 < alienY + alienborderY))
		begin	
			alienhit <= 1;
			dead <= 1;
		end
			
		alienX <= (alienY >= 240) ? (direction ? (alienX + 2):(alienX - 2)):(direction ? (alienX + 1):(alienX - 1));
	end
	
	else
	begin
		alienX <= -20;
		alienY <= -20;
	end
end


endmodule
