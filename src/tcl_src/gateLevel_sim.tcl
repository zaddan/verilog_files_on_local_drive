set tb_name conf_int_mac__noFF__arch_agnos__tb
set tb_file ${tb_name}.v
set synthesized_design_file mac_to_test.v

vlib work
vlog -v /home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/verilog_files/*.v -v /home/polaris/behzad/behzad_local/verilog_files/synthesis/results/$synthesized_design_file /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/$tb_file
vsim -novopt +neg_tchk  work.test_bench_tb  -sdfnoerror
vcd file ${tb_name}.vcd
vcd add -r test_bench_tb/*
run 10000ns
vcd checkpoint
vcd off
#vcd2saif -input ${tb_name}.vcd -o ${tb_name}.saif
#exit
