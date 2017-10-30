#!/bin/bash


#--- NOTE: modules to load 
#------ NOTE: they won't work in a bash, so do outside
#module load syn/syn/2013
#module load mentor/modelsim/2008
#module load synopsys/primetime/2012


#--- NOTE: RTL-to-gate_synthsis
dc_shell-t -f unconf-int-add__RTL-to-Gate.tcl |tee RTL-to-gate.log
dc_shell-t -f conf-int-add-inMux__RTL-to-gate.tcl |tee RTL-to-gate.log
dc_shell-t -f conf-int-add-clkGate__RTL-to-Gate.tcl |tee RTL-to-gate.log


#--- NOTE: gate level simulation
vsim -c -do unconf-int-add__gateLevel-sim.tcl |tee gateLevel-sim.log
vsim -c -do nt-add-inMux__gateLevel-sim.tcl |tee gateLevel-sim.log
vsim -c -do conf-int-add-clkGate__gateLevel-sim.tcl |tee gateLevel-sim.log


#--- NOTE: vcd2saif
vcd2saif -input /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim/unconfig-int-add__tb.vcd -o /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim/unconfig-int-add__tb.saif 
vcd2saif -input /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim/config-int-add-inMux__tb.vcd -o /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim/config-int-add-inMux__tb.saif 
vcd2saif -input /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim/config-int-add-clkGate__tb.vcd -o /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim/config-int-add-clkGate__tb.saif 


#--- NOTE: power
primetime -f power.tcl

