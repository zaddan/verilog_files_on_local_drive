vlib work
vlog *.v
#vlog /home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/verilog_files/*.v
vsim -novopt work.topdct_idct -sdfnoerror
#log -r /*
run -all
exit
