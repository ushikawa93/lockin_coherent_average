
`timescale 1ns/1ps

module testbench(
);



/////////////////////////////////////////////////
// ========== Control de la simulacion ===========
/////////////////////////////////////////////////

reg clk;
wire [9:0] SW;
wire [3:0] KEY;
wire [9:0] LEDR;
wire [0:6] HEX0;
wire [0:6] HEX1;
wire [0:6] HEX2;
wire [0:6] HEX3;
wire [0:6] HEX4;
wire [0:6] HEX5;


// Esto genera un clock de periodo=20ns (50 MHz)
always 
begin
	clk = 1'b1; 
  	#10; // high for 20 * timescale = 20 ns

  	clk = 1'b0;
  	#10; // low for 20 * timescale = 20 ns
end

reg enable,reset_n;
initial 
begin
	reset_n = 0;
	#100
	reset_n = 1;
	enable= 1;	
	
	// Si queremos que corte...
	// 8192*128*20ns + 1000ns (x las dudas)
	#1310720
	enable=0;
	reset_n = 0;
	#100
	enable=1;
	reset_n = 1;
	
end

assign KEY[0] = reset_n;
assign SW[8] = enable;

wire [15:0] A_li;
wire [15:0] A_ca_li;


coherent_average_tb ca_inst(

	////////// CLK /////////
	.CLOCK_50(clk),
	
	 ///////// SW /////////
    .SW(SW),
	
	///////// KEYS ////////
	.KEY(KEY),
	
	///////// LED /////////
	.LEDR(LEDR),
	
	///////// HEX0 /////////
    .HEX0(HEX0),

   ///////// HEX1 /////////
    .HEX1(HEX1),

   ///////// HEX2 /////////
    .HEX2(HEX2),

   ///////// HEX3 /////////
    .HEX3(HEX3),

   ///////// HEX4 /////////
    .HEX4(HEX4),

   ///////// HEX5 /////////
    .HEX5(HEX5),
	
	.A_li(A_li),
	.A_ca_li(A_ca_li)
);


endmodule
