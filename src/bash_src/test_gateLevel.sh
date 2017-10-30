#!/bin/bash

#ncverilog -v /home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/verilog_files/*.v  -v /home/polaris/behzad/behzad_local/verilog_files/synthesis/results/config_int_add_inMux_truncation_16_synthesized.v tb_config_int_add_inMux.v +access+rw 

#ncverilog -v /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib/stdcell_lvt/verilog/*.v -v /home/polaris/behzad/behzad_local/verilog_files/synthesis/results/config_int_add_inMux_truncation_16_synthesized.v tb_config_int_add_inMux.v +access+rw 



#--- unconfig
ncverilog -v /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib/stdcell_lvt/verilog/*.v -v /home/polaris/behzad/behzad_local/verilog_files/synthesis/results/unconfig_int_add_16Bit_16Bit_synthesized.v tb_unconfig_int_add.v +access+rw 

