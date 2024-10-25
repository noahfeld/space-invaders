`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:45:32 04/19/2017 
// Design Name: 
// Module Name:    rockets 
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
module rocket(	clk,
					reset,
					playing,
					direction,
					fire,
					hit,
					startX,
					startY,
					flying,
					rocketX,
					rocketY
					);
						
input clk, reset, playing, direction, fire, hit;
input [9:0] startX;
input [8:0] startY;
output reg flying;
output reg [9:0] rocketX;
output reg [8:0] rocketY;

always@ (posedge clk, posedge reset)
begin
	if(reset || !playing)
	begin
		flying <= 0;
		rocketX <= -20;
		rocketY <= -20;
	end
	
	else
	begin
		if(flying)
		begin
			if((rocketY == 2) || (rocketY == 453) || hit)
			begin
				flying <= 0;
				rocketX <= -20;
				rocketY <= -20;
         end
			
			else
				rocketY <= direction ? (rocketY - 2):(rocketY + 2);
		end	
		
		else if(fire)
		begin
			if(!flying && !hit)
			begin
				flying <= 1;
				rocketX <= startX;
				rocketY <= startY;
			end
		end
	end
end

endmodule
