
module fetch_test_tb(

);

reg clk1,clk2,reset_n;

parameter Q = 32;
parameter M = 128;

reg [Q-1:0] x;
wire [Q-1:0] y;

always begin
  #(10) clk1 = 1'b0;
  #(10) clk1 = 1'b1;
end

always begin
  #(40) clk2 = 1'b0;
  #(40) clk2 = 1'b1;
end

initial 
begin
	reset_n <= 0;
	
	#20 
	
	reset_n <= 1;
	
	x <= 32;
	
	#20
	
	x <= 64;
	
	#20
	
	x <= 128;
	
	#20
	
	x <= 256;
	
end
	
	
fetch_test fetch_test_instance(
	
	.clk1(clk1),
	.clk2(clk2),
	.reset_n(reset_n),
	.x(x),
	.y(y)

);

defparam fetch_test_instance.Q = Q;
defparam fetch_test_instance.M = M;


endmodule

