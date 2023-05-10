
module clocks (
	clk_clk,
	reset_reset_n,
	clk_rapido_clk,
	clk_lento_clk,
	clk_mas_lento_clk);	

	input		clk_clk;
	input		reset_reset_n;
	output		clk_rapido_clk;
	output		clk_lento_clk;
	output		clk_mas_lento_clk;
endmodule
