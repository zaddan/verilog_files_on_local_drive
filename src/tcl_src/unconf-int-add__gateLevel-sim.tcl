set tb_name unconfig-int-add__tb
set tb_file ${tb_name}.v
set synthesized_design_name "unconfig_int_add_32Bit_32Bit_synthesized"
set synthesized_design_file ${synthesized_design_name}.v 
set std-lib_dir_addr_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib/stdcell_lvt/verilog"
set std-lib_dir_addr_2 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib/stdcell_lvt/verilog"
set syn_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
set tb_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
set sim-res_dir "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/gate_level_sim"

vlib work
vlog  ${std-lib_dir_addr_1}/*.v  ${std-lib_dir_addr_2}/*.v ${syn_dir_addr}/$synthesized_design_file ${tb_dir_addr}/$tb_file
vsim -novopt +neg_tchk  work.test_bench_tb  -sdfnoerror
vcd file ${sim-res_dir}/${tb_name}.vcd
vcd add -r test_bench_tb/*
run 10000ns
vcd checkpoint
vcd off
#exit
