
module coherent_average_tb(

////////// CLK /////////
	input CLOCK_50,
	
	 ///////// SW /////////
   input       [9:0]  SW,
	
	///////// KEYS ////////
	input 		[3:0] KEY,
	
	///////// LED /////////
	output		[9:0] LEDR,
	
	///////// HEX0 /////////
   output      [0:6]  HEX0,

   ///////// HEX1 /////////
   output      [0:6]  HEX1,

   ///////// HEX2 /////////
   output      [0:6]  HEX2,

   ///////// HEX3 /////////
   output      [0:6]  HEX3,

   ///////// HEX4 /////////
   output      [0:6]  HEX4,

   ///////// HEX5 /////////
   output      [0:6]  HEX5,
	
	output 		[15:0] A_li,	
	output		[15:0] A_ca_li


);

parameter compile_LI = 0;
parameter compile_CA_LI = 1;
parameter simulacion = 0;

parameter N_ma = 1;
parameter N_ca = 8192;
parameter M = 32;
parameter Q_signal = 14;

parameter N = N_ma * N_ca ;

/////////////////////////////////////////////////
// ================ Salidas ===========
/////////////////////////////////////////////////

// Lockin tradicional...
parameter Q_in_li = Q_signal;
parameter Q_productos_li = Q_signal + 16;
parameter Q_sumas_li = Q_signal + 16 + 20;

wire data_li_valid;
wire [Q_sumas_li-1:0] data_li_fase;
wire [Q_sumas_li-1:0] data_li_cuad;


// CA + LIA...
parameter Q_in_ca = Q_signal;
parameter Q_out_ca = Q_signal + 13;

parameter Q_in_li_ca = Q_signal + 13;
parameter Q_productos_li_ca = Q_signal + 13 + 16;	// Este esta sobrado, con 41 alcanzaría 
parameter Q_sumas_li_ca = Q_signal + 13 + 16 + 7;			// Este tambien, con 48 alcanza


wire data_ca_valid;
wire [Q_out_ca-1:0] data_ca;

wire data_ca_li_valid;
wire [Q_sumas_li_ca-1:0] data_ca_li_fase;
wire [Q_sumas_li_ca-1:0] data_ca_li_cuad;


// Salidas de calculo de amplitud (offline)
wire [15:0] amplitud_li;
wire [15:0] amplitud_ca_li;


/////////////////////////////////////////////////
// ====== Cosas para sintesis real ===========
/////////////////////////////////////////////////

wire clk_lockin_clasico;
wire clk_ca;
wire clk_ma;
wire clk_calc_finales;

wire reset_n = KEY[0];
wire enable = SW[8];


generate 
	if(!simulacion)
		clocks u0 (
			 .clk_clk           		 (CLOCK_50),           //           clk.clk
			 .reset_reset_n     		 (reset_n),     //         reset.reset_n
			 .clk_lockin_clasico_clk (clk_lockin_clasico),    //    clk_rapido.clk
			 .clk_ca_clk     			 (clk_ca),     //     clk_lento.clk
			 .clk_ma_clk 				 (clk_ma),
			 .clk_calc_finales_clk   (clk_calc_finales)  // clk_mas_lento.clk
		);
	else
	begin
		assign clk_lockin_clasico = CLOCK_50;
		assign clk_ca = CLOCK_50;
		assign clk_ma = CLOCK_50;
		assign clk_calc_finales = CLOCK_50;
		
	end
endgenerate


/////////////////////////////////////////////////
// ========== Origen de datos ===========
/////////////////////////////////////////////////

wire [Q_signal-1:0] x_rapido;
wire x_rapido_valid;

wire [Q_signal-1:0] x_lento;
wire x_lento_valid;


generate
	if(compile_CA_LI)
	begin
		data_source data_sim_rapida(

			// Entradas de control
			.clk(clk_ca),
			.reset_n(reset_n),
			.enable(enable),
			
			// Salida avalon streaming
			.data_valid(x_rapido_valid),
			.data(x_rapido)			
		);
		defparam data_sim_rapida.M = M;
		defparam data_sim_rapida.Q = Q_signal;
	end
	
	if(compile_LI)
	begin

		data_source data_sim_lenta(

			// Entradas de control
			.clk(clk_lockin_clasico),
			.reset_n(reset_n),
			.enable(enable),
			
			// Salida avalon streaming
			.data_valid(x_lento_valid),
			.data(x_lento)			
		);
		defparam data_sim_lenta.M = M;
		defparam data_sim_lenta.Q = Q_signal;
	end
endgenerate


/////////////////////////////////////////////////
// ========== Lockin ===========
/////////////////////////////////////////////////

// Para calcular aproximadamente la amplitud del resultado:
wire amplitud_li_done;

wire [63:0] fase_li =  {14'b0 , data_li_fase};		//14 = 64-Q_sumas_li
wire [63:0] cuad_li =  {14'b0 , data_li_cuad};


generate
	if(compile_LI)
	begin
		lockin lockin_simple(

			.clk(clk_lockin_clasico),
			.reset_n(reset_n),
			
			.x(x_lento),
			.x_valid(x_lento_valid),
			
			.data_out_fase(data_li_fase),
			.data_out_cuad(data_li_cuad),
			.data_out_valid(data_li_valid)
		);

		defparam lockin_simple.N = N;
		defparam lockin_simple.M = M;

		defparam lockin_simple.Q_in = Q_in_li;
		defparam lockin_simple.Q_productos = Q_productos_li;
		defparam lockin_simple.Q_sumas = Q_sumas_li;



		lockin_amplitude amplitud_li_inst(

			.Clock(clk_calc_finales),  //Clock
			.reset_n(reset_n),  //Asynchronous active high reset.      
			.res_fase(fase_li), 
			.res_cuad(cuad_li),
			.done(amplitud_li_done),  
			.amplitud(amplitud_li) 
		);

		defparam amplitud_li_inst.N_lockin = N;
		defparam amplitud_li_inst.M = M;
	end
endgenerate
/////////////////////////////////////////////////
// ========== Promedio coherente + LI ===========
/////////////////////////////////////////////////

// Para calcular aproximadamente la amplitud del resultado:
wire amplitud_ca_li_done;

wire [63:0] fase_ca_li =  {14'b0 , data_ca_li_fase};
wire [63:0] cuad_ca_li =  {14'b0 , data_ca_li_cuad};

generate
	if(compile_CA_LI)
	begin
		coherent_average_sm CA(

			.clk_rapido(clk_ca),
			.clk_lento(clk_ma),
			.reset_n(reset_n),
			.enable(enable),
			
			.x(x_rapido),
			.x_valid(x_rapido_valid),
			
			.data_out(data_ca),
			.data_out_valid(data_ca_valid)

		);

		defparam CA.M = M;
		defparam CA.N = N_ca;

		defparam CA.simulacion = simulacion;
		defparam CA.Q_in = Q_in_ca;
		defparam CA.Q_out = Q_out_ca;


		lockin lockin_corto(

			.clk(clk_ma),
			.reset_n(reset_n),
			
			.x(data_ca),
			.x_valid(data_ca_valid),
			
			.data_out_fase(data_ca_li_fase),
			.data_out_cuad(data_ca_li_cuad),
			.data_out_valid(data_ca_li_valid)
		);

		defparam lockin_corto.M = M;
		defparam lockin_corto.N = N_ma;

		defparam lockin_corto.Q_in = Q_in_li_ca;
		defparam lockin_corto.Q_productos = Q_productos_li_ca;	// Este esta sobrado, con 41 alcanzaría 
		defparam lockin_corto.Q_sumas = Q_sumas_li_ca;			// Este tambien, con 48 alcanza




		lockin_amplitude amplitud_ca_li_inst(
			.Clock(clk_calc_finales),  //Clock
			.reset_n(reset_n),  //Asynchronous active high reset.      
			.res_fase(fase_ca_li),   //this is the number for which we want to find square root.
			.res_cuad(cuad_ca_li),
			.done(amplitud_ca_li_done),     //This signal goes high when output is ready
			.amplitud(amplitud_ca_li)  //square root of 'num_in'
		);

		defparam amplitud_ca_li_inst.N_lockin = N;
		defparam amplitud_ca_li_inst.M = M;
		
	end
endgenerate

/////////////////////////////////////////////////
// ========== Display resultados ===========
/////////////////////////////////////////////////

wire seleccion_display = SW[0];

wire [15:0] numero_a_mostrar = (seleccion_display)? amplitud_li:amplitud_ca_li;
wire [3:0] bcd0,bcd1,bcd2,bcd3,bcd4,bcd5;

descomponer_en_digitos desc_li(

	.numero(numero_a_mostrar),
	
	.digit0(bcd0),	.digit1(bcd1),	.digit2(bcd2),	.digit3(bcd3),	.digit4(bcd4),	.digit5(bcd5)	
	
);

BCD_display display(

	.bcd0(bcd0),	.bcd1(bcd1),	.bcd2(bcd2),	.bcd3(bcd3),	.bcd4(bcd4),	.bcd5(bcd5),
	
	.HEX0(HEX0),	.HEX1(HEX1),	.HEX2(HEX2),	.HEX3(HEX3),	.HEX4(HEX4),	.HEX5(HEX5)
	
);

assign A_li = amplitud_li;
assign A_ca_li = amplitud_ca_li;


endmodule
