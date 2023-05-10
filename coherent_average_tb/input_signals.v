
module input_signals(

	output clk_rapido,
	output clk_lento,
	output clk_mas_lento,
	output reg reset_n,
	output reg enable


);


/////////////////////////////////////////////////
// ========== Control de la simulacion ===========
/////////////////////////////////////////////////

reg clk;

// Esto genera un clock de periodo=20ns (50 MHz)
always 
begin
	clk = 1'b1; 
  	#10; // high for 20 * timescale = 20 ns

  	clk = 1'b0;
  	#10; // low for 20 * timescale = 20 ns
end

initial 
begin
	reset_n = 0;
	#100
	reset_n = 1;
	#20
	enable= 1;
end

assign clk_rapido = clk;
assign clk_lento = clk;
assign clk_mas_lento = clk;

endmodule



