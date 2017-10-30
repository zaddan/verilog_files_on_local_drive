###################################################################

# Created by write_sdc on Tue Apr 18 12:48:59 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_ideal_network -no_propagate  [get_ports clk]
create_clock [get_ports clk]  -period 0.8135  -waveform {0 0.40675}
set_input_delay -clock clk  -max 0  [get_ports clk]
set_input_delay -clock clk  -max 0  [get_ports {din[31]}]
set_input_delay -clock clk  -max 0  [get_ports {din[30]}]
set_input_delay -clock clk  -max 0  [get_ports {din[29]}]
set_input_delay -clock clk  -max 0  [get_ports {din[28]}]
set_input_delay -clock clk  -max 0  [get_ports {din[27]}]
set_input_delay -clock clk  -max 0  [get_ports {din[26]}]
set_input_delay -clock clk  -max 0  [get_ports {din[25]}]
set_input_delay -clock clk  -max 0  [get_ports {din[24]}]
set_input_delay -clock clk  -max 0  [get_ports {din[23]}]
set_input_delay -clock clk  -max 0  [get_ports {din[22]}]
set_input_delay -clock clk  -max 0  [get_ports {din[21]}]
set_input_delay -clock clk  -max 0  [get_ports {din[20]}]
set_input_delay -clock clk  -max 0  [get_ports {din[19]}]
set_input_delay -clock clk  -max 0  [get_ports {din[18]}]
set_input_delay -clock clk  -max 0  [get_ports {din[17]}]
set_input_delay -clock clk  -max 0  [get_ports {din[16]}]
set_input_delay -clock clk  -max 0  [get_ports {din[15]}]
set_input_delay -clock clk  -max 0  [get_ports {din[14]}]
set_input_delay -clock clk  -max 0  [get_ports {din[13]}]
set_input_delay -clock clk  -max 0  [get_ports {din[12]}]
set_input_delay -clock clk  -max 0  [get_ports {din[11]}]
set_input_delay -clock clk  -max 0  [get_ports {din[10]}]
set_input_delay -clock clk  -max 0  [get_ports {din[9]}]
set_input_delay -clock clk  -max 0  [get_ports {din[8]}]
set_input_delay -clock clk  -max 0  [get_ports {din[7]}]
set_input_delay -clock clk  -max 0  [get_ports {din[6]}]
set_input_delay -clock clk  -max 0  [get_ports {din[5]}]
set_input_delay -clock clk  -max 0  [get_ports {din[4]}]
set_input_delay -clock clk  -max 0  [get_ports {din[3]}]
set_input_delay -clock clk  -max 0  [get_ports {din[2]}]
set_input_delay -clock clk  -max 0  [get_ports {din[1]}]
set_input_delay -clock clk  -max 0  [get_ports {din[0]}]
set_input_delay -clock clk  -max 0  [get_ports start]
set_input_delay -clock clk  -max 0  [get_ports racc]
set_input_delay -clock clk  -max 0  [get_ports rapx]
