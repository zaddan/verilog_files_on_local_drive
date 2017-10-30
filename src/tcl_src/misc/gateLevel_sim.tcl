set tb_name tb_unconfig_int_add
set tb_file ${tb_name}.v
set synthesized_design_name "unconfig_int_add_32Bit_32Bit_synthesized"
set synthesized_design_file ${synthesized_design_name}.v 

vlib work
vlog -v /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib/stdcell_lvt/verilog/*.v -v /home/polaris/behzad/behzad_local/verilog_files/synthesis/results/$synthesized_design_file /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/$tb_file
vsim -novopt +neg_tchk  work.test_bench_tb  -sdfnoerror
vcd file ${tb_name}.vcd
vcd add -r test_bench_tb/*
run 10000ns
vcd checkpoint
vcd off
#vcd2saif -input ${tb_name}.vcd -o ${tb_name}.saif
#exit
