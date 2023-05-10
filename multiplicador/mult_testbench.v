
module mult_testbench(

);

reg clk,reset_n;

parameter Q1 = 14;
parameter Q2 = 16;

reg [Q1-1:0] x1;
reg [Q2-1:0] x2;
wire [Q1+Q2-1:0] y;

always begin
  #(10) clk = 1'b0;
  #(10) clk = 1'b1;
end

initial 
begin
	reset_n <= 1;
	
	x1 <= 32;
	x2 <= 16;
	
	#60
	
	x1 <= 64;
	x2 <= 128;
	
end
	
	
multiplicador mult_instance(
	
	.clk(clk),
	.reset_n(reset_n),
	.x1(x1),
	.x2(x2),
	.y(y)

);

defparam mult_instance.Q1 = Q1;
defparam mult_instance.Q2 = Q2;


endmodule

