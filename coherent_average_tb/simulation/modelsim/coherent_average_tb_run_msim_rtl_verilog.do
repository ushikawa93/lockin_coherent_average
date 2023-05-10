transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/segment7.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/descomponer_en_digitos.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/BCD_display.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/coherent_average_tb.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/lockin_amplitude.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/coherent_average_sm.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/data_source.v}
vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/lockin.v}

vlog -vlog01compat -work work +incdir+C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb {C:/Users/MatiOliva/Documents/00-ProyectosQuartus/lia_ca_articulo/coherent_average_tb/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
