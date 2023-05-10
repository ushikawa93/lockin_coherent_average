	component clocks is
		port (
			clk_clk                : in  std_logic := 'X'; -- clk
			clk_ca_clk             : out std_logic;        -- clk
			clk_calc_finales_clk   : out std_logic;        -- clk
			clk_lockin_clasico_clk : out std_logic;        -- clk
			clk_ma_clk             : out std_logic;        -- clk
			reset_reset_n          : in  std_logic := 'X'  -- reset_n
		);
	end component clocks;

	u0 : component clocks
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --                clk.clk
			clk_ca_clk             => CONNECTED_TO_clk_ca_clk,             --             clk_ca.clk
			clk_calc_finales_clk   => CONNECTED_TO_clk_calc_finales_clk,   --   clk_calc_finales.clk
			clk_lockin_clasico_clk => CONNECTED_TO_clk_lockin_clasico_clk, -- clk_lockin_clasico.clk
			clk_ma_clk             => CONNECTED_TO_clk_ma_clk,             --             clk_ma.clk
			reset_reset_n          => CONNECTED_TO_reset_reset_n           --              reset.reset_n
		);

