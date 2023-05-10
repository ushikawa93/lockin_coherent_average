	component clocks is
		port (
			clk_clk           : in  std_logic := 'X'; -- clk
			reset_reset_n     : in  std_logic := 'X'; -- reset_n
			clk_rapido_clk    : out std_logic;        -- clk
			clk_lento_clk     : out std_logic;        -- clk
			clk_mas_lento_clk : out std_logic         -- clk
		);
	end component clocks;

	u0 : component clocks
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --           clk.clk
			reset_reset_n     => CONNECTED_TO_reset_reset_n,     --         reset.reset_n
			clk_rapido_clk    => CONNECTED_TO_clk_rapido_clk,    --    clk_rapido.clk
			clk_lento_clk     => CONNECTED_TO_clk_lento_clk,     --     clk_lento.clk
			clk_mas_lento_clk => CONNECTED_TO_clk_mas_lento_clk  -- clk_mas_lento.clk
		);

