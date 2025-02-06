# Archivo de temporización básico

create_clock -name "clk1" -period 20.000ns [get_ports {clk1}]
create_clock -name "clk2" -period 20.000ns [get_ports {clk2}]

derive_pll_clocks
derive_clock_uncertainty

