
module multiplicador 
	#(
		parameter Q1 = 14,
		parameter Q2 = 16
	)
	
	(
		input clk,
		input reset_n,
		input [Q1-1:0] x1,
		input [Q2-1:0] x2,
		output reg [Q1+Q2-1:0] y
	);
	
reg [Q1-1:0] x1_reg;
reg [Q2-1:0] x2_reg;

always @ (posedge clk or negedge reset_n)
begin

	if(!reset_n)
	begin	
		x1_reg <= 0;
		x2_reg <= 0;		
		y <= 0;
	end
	else
	begin

		x1_reg <= x1;
		x2_reg <= x2;		

		y <= x1_reg * x2_reg;
	
	end
end

endmodule
