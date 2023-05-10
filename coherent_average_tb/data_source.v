
module data_source

#(	parameter M = 32, parameter Q=12)
(

	// Entradas de control
	input clk,
	input reset_n,
	input enable,
	
	
	// Salida avalon streaming
	output data_valid,
	output [Q-1:0] data
	
);


/////////////////////////////////////////////////
// =============== Señal =================
/////////////////////////////////////////////////	

reg [Q-1:0] buffer [0:M-1];
	initial	
	begin	
		if(M == 32)
			$readmemh("LU_tables/x32_12b.mem",buffer);
		else if(M == 128)
			$readmemh("LU_tables/x128_14b.mem",buffer);			
	end


reg [15:0] n;
reg enable_reg;
reg [Q-1:0] data_reg;

always @ (posedge clk or negedge reset_n) enable_reg <= (!reset_n)? 0 : enable; 

always @ (posedge clk or negedge reset_n)
begin

	if(!reset_n)
	begin
		n <= 0;
	end

	else if (enable_reg)
	begin
		n <= (n == M-1) ? 0:n+1;
	end
	
end

/////////////////////////////////////////////////
// =============== Salida =================
/////////////////////////////////////////////////	

assign data = buffer[n];
assign data_valid = enable_reg;


endmodule
