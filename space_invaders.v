module space_invaders_core(ClkPort, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, btnC, btnU, btnL, btnR,
	St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar,
	An0, An1, An2, An3, Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp);
	input ClkPort, btnC, btnU, btnL, btnR;
	output St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar;
	output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;
	output An0, An1, An2, An3, Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp;
	reg vga_r, vga_g, vga_b;
	
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/*  LOCAL SIGNALS */
	wire reset, start, ClkPort, board_clk, clk, button_clk, VGA_clk, C_Ack_SCEN, U_Ack_SCEN, L_Ack_SCEN, R_Ack_SCEN, C_Ack_MCEN, U_Ack_MCEN, L_Ack_MCEN, R_Ack_MCEN, C_Ack_CCEN, U_Ack_CCEN, L_Ack_CCEN, R_Ack_CCEN;
	wire dbtnC, dbtnU, dbtnL, dbtnR;
	wire resetbtn, firebtn, leftbtn, rightbtn;
	wire [9:0] shipX;
	wire [8:0] shipY;
	wire shiprocket;
	wire [9:0] shiprocketX;
	wire [8:0] shiprocketY;
	wire shiphit;
	wire [5:0] shipborderX;
	wire [4:0] shipborderY;
	wire [9:0] aliencol1, aliencol2, aliencol3, aliencol4;
	wire [8:0] alienrow1, alienrow2;
	wire [9:0] alien1X, alien2X;
	wire [8:0] alien1Y, alien2Y;
	wire aliendirection;
	wire alienrocket1, alienrocket2;
	wire alienfire1;
	wire [9:0] alienrocket1X, alienrocket2X;
	wire [8:0] alienrocket1Y, alienrocket2Y;
	wire alienhit1, alienhit2;
	wire [5:0] alienborderX;
	wire [4:0] alienborderY;
	
	reg playing;
	reg [3:0] score;
	reg [2:0] lives;
	
	BUF BUF1 (board_clk, ClkPort);
	BUF BUF2 (reset, resetbtn);
	
	reg [27:0] DIV_CLK;
	always @ (posedge board_clk, posedge reset)  
	begin : CLOCK_DIVIDER
      if (reset)
			DIV_CLK <= 0;
      else
			DIV_CLK <= DIV_CLK + 1;
	end	

	assign button_clk = DIV_CLK[18];
	assign VGA_clk = DIV_CLK[19];
	assign clk = DIV_CLK[1];
	assign {St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
	assign resetbtn = dbtnC && C_Ack_CCEN;
	assign firebtn = dbtnU && U_Ack_CCEN;
	assign leftbtn = dbtnL && L_Ack_CCEN;
	assign rightbtn = dbtnR && R_Ack_CCEN;
	assign shipborderX = 16;
	assign shipborderY = 8;
	assign aliencol1 = 30;
	assign aliencol2 = 60;
	assign aliencol3 = 90;
	assign aliencol4 = 120;
	assign alienrow1 = 50;
	assign alienrow2 = 100;
	assign alienborderX = 20;
	assign alienborderY = 10;
	assign alienfire1 = DIV_CLK[26];
	
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;

	hvsync_generator syncgen(.clk(clk), .reset(reset),.vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));
	debouncer d1(.clk(button_clk), .reset(reset), .pb(btnC), .dpb(dbtnC), .scen(C_Ack_SCEN), .mcen(C_Ack_MCEN), .ccen(C_Ack_CCEN));
	debouncer d2(.clk(button_clk), .reset(reset), .pb(btnU), .dpb(dbtnU), .scen(U_Ack_SCEN), .mcen(U_Ack_MCEN), .ccen(U_Ack_CCEN));
	debouncer d3(.clk(button_clk), .reset(reset), .pb(btnL), .dpb(dbtnL), .scen(L_Ack_SCEN), .mcen(L_Ack_MCEN), .ccen(L_Ack_CCEN));
	debouncer d4(.clk(button_clk), .reset(reset), .pb(btnR), .dpb(dbtnR), .scen(R_Ack_SCEN), .mcen(R_Ack_MCEN), .ccen(R_Ack_CCEN));
	spaceship ship(.clk(VGA_clk), .reset(reset), .playing(playing), .left(leftbtn), .right(rightbtn), .shipborderX(shipborderX), .shipborderY(shipborderY), .alienrocket1(alienrocket1), .alienrocket1X(alienrocket1X), .alienrocket1Y(alienrocket1Y), .shiphit(shiphit), .shipX(shipX), .shipY(shipY));
	alien alien1(.clk(VGA_clk), .reset(reset), .playing(playing), .startX(aliencol1), .startY(alienrow1), .alienborderX(alienborderX), .alienborderY(alienborderY), .shiprocket(shiprocket), .shiprocketX(shiprocketX), .shiprocketY(shiprocketY), .alienhit(alienhit1), .direction(aliendirection), .alienX(alien1X), .alienY(alien1Y));
	rocket srocket(.clk(VGA_clk), .reset(reset), .playing(playing), .startX(shipX), .startY(shipY), .rocketX(shiprocketX), .rocketY(shiprocketY), .direction(1'b1), .fire(firebtn), .flying(shiprocket), .hit(alienhit1));
	rocket arocket1(.clk(VGA_clk), .reset(reset), .playing(playing), .startX(alien1X), .startY(alien1Y), .rocketX(alienrocket1X), .rocketY(alienrocket1Y), .direction(1'b0), .fire(alienfire1), .flying(alienrocket1), .hit(shiphit));
	
	reg state;
	
	localparam
	INITIAL = 1'b0,
	PLAYING = 1'b1;
	
	always @ (posedge VGA_clk, posedge reset)
		begin : CU_n_DPU
			if (reset)
				begin
					state <= INITIAL;
					playing <= 0;
					score <= 0;
					lives <= 4;
				end
			else
				begin //(state machine begins)
					case (state)
						INITIAL : 
						begin
							if (firebtn || leftbtn || rightbtn)
							begin
								state <= PLAYING;
								playing <= 1;
								score <= 0;
								lives <= 4;
							end
						end
						PLAYING :
						begin
							if ((score >= 10'd10) || (lives == 0) || (alien1Y + alienborderY >= shipY - shipborderY))
							begin
								state <= INITIAL;
								playing <= 0;
							end
							if (alienhit1)
								score <= score + 1;
							if (shiphit)
								lives <= lives - 1;
						end
					endcase
				end
		end						
	
	/////////////////////////////////////////////////////////////////
	///////////////		VGA control starts here		/////////////////
	/////////////////////////////////////////////////////////////////
	
	
	wire R = playing && ((CounterY <= (shiprocketY + 2) && CounterY >= (shiprocketY - 2) && CounterX <= (shiprocketX + 2) && CounterX >= (shiprocketX - 2))
				|| (CounterY <= (alienrocket1Y + 2) && CounterY >= (alienrocket1Y - 2) && CounterX <= (alienrocket1X + 2) && CounterX >= (alienrocket1X - 2)));
	wire G = playing && CounterY <= (shipY + shipborderY) && CounterY >= (shipY - shipborderY) && CounterX <= (shipX + shipborderX) && CounterX >= (shipX - shipborderX);
	wire B = playing && CounterY <= (alien1Y + alienborderY) && CounterY >= (alien1Y - alienborderY) && CounterX <= (alien1X + alienborderX) && CounterX >= (alien1X - alienborderX);
	
	always @(posedge clk)
	begin
		vga_r <= R & inDisplayArea;
		vga_g <= G & inDisplayArea;
		vga_b <= B & inDisplayArea;
	end
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  VGA control ends here 	 ///////////////////
	/////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  SSD control starts here 	 ///////////////////
	/////////////////////////////////////////////////////////////////
	
	reg 	[3:0]	SSD;
	wire 	[3:0]	SSD0, SSD1, SSD2, SSD3;
	wire 	[1:0] ssdscan_clk;
	
	assign SSD3 = 0;
	assign SSD2 = lives[2:0];
	assign SSD1 = score[3];
	assign SSD0 = score[2:0];
	
	// need a scan clk for the seven segment display 
	// 191Hz (50MHz / 2^18) works well
	assign ssdscan_clk = DIV_CLK[19:18];	
	assign An0 = !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1 = !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2 = !( (ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3 = !( (ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
			2'b00:
					SSD = SSD0;
			2'b01:
					SSD = SSD1;
			2'b10:
					SSD = SSD2;
			2'b11:
					SSD = SSD3;
		endcase 
	end	

	// and finally convert SSD_num to ssd
	reg [6:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES, 1'b1};
	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD)		
			4'b1111: SSD_CATHODES = 7'b1111111 ; //Nothing 
			4'b0000: SSD_CATHODES = 7'b0000001 ; //0
			4'b0001: SSD_CATHODES = 7'b1001111 ; //1
			4'b0010: SSD_CATHODES = 7'b0010010 ; //2
			4'b0011: SSD_CATHODES = 7'b0000110 ; //3
			4'b0100: SSD_CATHODES = 7'b1001100 ; //4
			4'b0101: SSD_CATHODES = 7'b0100100 ; //5
			4'b0110: SSD_CATHODES = 7'b0100000 ; //6
			4'b0111: SSD_CATHODES = 7'b0001111 ; //7
			4'b1000: SSD_CATHODES = 7'b0000000 ; //8
			4'b1001: SSD_CATHODES = 7'b0000100 ; //9
			4'b1010: SSD_CATHODES = 7'b0001000 ; //10 or A
			default: SSD_CATHODES = 7'bXXXXXXX ; // default is not needed as we covered all cases
		endcase
	end
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  SSD control ends here 	 ///////////////////
	/////////////////////////////////////////////////////////////////

endmodule