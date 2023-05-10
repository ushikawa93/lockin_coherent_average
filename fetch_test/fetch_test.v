
module fetch_test
	#(
		parameter Q = 32,
		parameter M = 128
	)
	
	(
		input clk1,
		input clk2,
		input reset_n,
		input [Q-1:0] x,
		output reg [Q-1:0] y
	);
	
reg [7:0] i, j ;
	
reg [Q-1:0] x_reg;

reg [Q-1:0] mem [M-1:0];


// T save seria con el clk1
always @ (posedge clk1 or negedge reset_n)
begin

	if(!reset_n)
	begin	
	
		x_reg <= 0;
		i <= 0;
		
	end
	else
	begin

		x_reg <= x;		
		
		mem[i] <= x_reg;
		
		i <= (i == M-1)? 0: i+1;

	
	end
end

// T fetch seria con el clk2
always @ (posedge clk2 or negedge reset_n)
begin

	if(!reset_n)
	begin	
	
		y <= 0;
		j <= 0;
		
	end
	else
	begin
		
		j <= (j == M-1) ? 0: j+1;
	
		y <= mem[j];
	
	end
end



endmodule
