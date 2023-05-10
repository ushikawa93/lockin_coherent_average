
module coherent_average

	#( parameter M = 32,
		parameter Q = 32,
		parameter N = 3,
		parameter simulacion = 0 )

	(	input clk_rapido,
		input clk_lento,
		input reset_n,
	
		input [11:0] x,
		input x_valid,
	
		output reg [31:0] data_out,
		output data_out_valid
	
);

reg [Q-1:0] y [M-1:0];
reg [15:0] n,n_1,n_2,k,h,m;
wire done_calculating , done_transmiting, cleaning;

reg [Q-1:0] y_actual,x_1;
reg [Q-1:0] sum_actual;
reg data_out_valid_reg;


always @ (posedge clk_rapido  or negedge reset_n)
begin

	if(!reset_n)
	begin		
		n <= 0;
		n_1 <= 0;
		n_2 <= 0;
		k <= 0;
		y_actual <= 0;
		sum_actual <= 0;
	end

	else if(x_valid && !done_calculating)
	begin
	
	
		// Fetch
		y_actual <= y[n];
		x_1 <= x;
		n <= (n == M-1)? 0:n+1;
		
		// Sum
		sum_actual <= y_actual + x_1;
		n_1 <= n;
	
		// Save
		y[n_2] <= sum_actual;				
		n_2 <= n_1;		
		
		k <= (n_2 == M-1)? k+1:k;
		
	end
	
end

assign done_calculating = (k == N);
assign done_transmiting = done_calculating && (h == M);
assign cleaning = done_calculating && done_transmiting && (m < M);

assign data_out_valid = data_out_valid_reg;

always @ (posedge clk_lento or negedge reset_n)
begin

	if(!reset_n)
	begin
		h <= 0;
		data_out_valid_reg <= 0;
	end	
	else if(done_calculating && !done_transmiting )
	begin		
		data_out <= y[h];
		h <= h+1; 
		data_out_valid_reg <= 1;
	end
	//else
	//	data_out_valid_reg <= 0;
	
end

reg clean;


// Esta operacion me va a enlentecer las cosa...
always @ (posedge clk_rapido or negedge reset_n)
begin
	if(!reset_n)
	begin
		m <= 0;
		clean <= 1;
	end

	else if(cleaning)
	begin
		if (clean)
			y[m] <= 0;
		else
			m <= m+1;	
			
		clean <= !clean;
	end

end




// Inicializacion de arreglo para la simulacion...
integer j;

generate
if(simulacion)
begin
	initial
	begin
		
		for (j = 0 ; j < M; j=j+1)
			y[j] <= 0;

	end
end
endgenerate


endmodule


