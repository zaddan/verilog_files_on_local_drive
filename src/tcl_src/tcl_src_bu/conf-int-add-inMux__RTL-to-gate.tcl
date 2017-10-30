set BWAC 1
#set WDIR /home/unga/sglee/Share/ac_hw_syn
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports
set DESIGN_NAME config_int_add_inMux_truncation
set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"

#/* Top-level Module     */
set my_toplevel ${DESIGN_NAME}
#--- ACTION:set my_toplevel ${DESIGN_NAME}
set lib_dir_1 /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib
set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"

#--- NOTE: I had to include *_rvt as well, cause ow the compiler was erroring out
set search_path [concat  $search_path $lib_dir_1/stdcell_rvt/db_nldm $lib_dir_1/stdcell_lvt/db_nldm $lib_dir_2/germany_NanGate/db]


set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"

#source ${WDIR}/lib_list.txt
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME config_int_add_inMux_truncation


#--- specifying libraries 
set std_library "saed32rvt_tt1p05v25c.db"
#set std_library "saed32lvt_tt1p05v25c.db"; #the best(amon lvts)
#set  std_library  "noAging.db" 

set target_library "$std_library" 
set link_library "$std_library" 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"


#DATA_PATH_BITWIDTH should most likely stay 32
set DATA_PATH_BITWIDTH 32 
#--- numebr of apx bits
set HRDWIRED_BITWIDTH 16    
#for { set HRDWIRED_BITWIDTH 0}  {$HRDWIRED_BITWIDTH < 1} {incr HRDWIRED_BITWIDTH 1} {


#--- read the design 
analyze -format verilog [list ${design_dir_addr}/config_int_add_inMux.v ${design_dir_addr}/acc_int_add.v]
elaborate $my_toplevel -parameters 32,$HRDWIRED_BITWIDTH
check_design

#--- define design environement (setting up the design environment such as external operating conditions (manufacturing process, temperature, and voltage), loads, drives, fanouts, and wire load models)


#set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]


#--- linking to libraries
link


#saif_map -start 


#--- set the optimization constraints 
create_clock -name clk -period .6 [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports b*]     
set_input_delay -max 0 -clock clk [get_ports a*]     
set_input_delay -max 0 -clock clk [get_ports apx*]     
set_dont_touch_network [get_clocks clk]


#--- design rule constraints 
#set_max_area 0

#foreach_in_collection endpt $endpoints { set pin [get_object_name $endpt] 
#    group_path -name $pin -to $pin
#}


set_max_delay .55 -from {reg_b_reg[16] reg_b_reg[17] reg_b_reg[18] reg_b_reg[19] reg_b_reg[20] reg_b_reg[21] reg_b_reg[22] reg_b_reg[23] reg_b_reg[24] reg_b_reg[25] reg_b_reg[26] reg_b_reg[27] reg_b_reg[28] reg_b_reg[29] reg_b_reg[30] reg_b_reg[31] reg_a_reg[16] reg_a_reg[17] reg_a_reg[18] reg_a_reg[19] reg_a_reg[20] reg_a_reg[21] reg_a_reg[22] reg_a_reg[23] reg_a_reg[24] reg_a_reg[25] reg_a_reg[26] reg_a_reg[27] reg_a_reg[28] reg_a_reg[29] reg_a_reg[30] reg_a_reg[31]} -to {reg_c_reg[16] reg_c_reg[17] reg_c_reg[18] reg_c_reg[19] reg_c_reg[20] reg_c_reg[21] reg_c_reg[22] reg_c_reg[23] reg_c_reg[24] reg_c_reg[25] reg_c_reg[26] reg_c_reg[27] reg_c_reg[28] reg_c_reg[29] reg_c_reg[30] reg_c_reg[31]}



#--- compile (symthesize adn optimize design)
#compile
#compile -area_effort high -power_effort high 
#compile -power_effort high
#compile_ultra 
compile_ultra -timing_high_effort_script -incremental
#compile_ultra

#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_timing.rpt
report_timing -path full -sort_by slack -nworst 1000000 -max_paths 1000000 >  ${REPORTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_timing.rpt
#report_timing -path full -sort_by slack -from  $input_list -max_path 100 -nworst 2 >  ${REPORTS_DIR}/int_${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_timing1.rpt
report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_constrain_violators.rpt
#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_qor.rpt
#report 


#--- save the design
#the following generates ddc files 
write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_synthesized.ddc 
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_synthesized.v
write_sdc ${RESULTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}_synthesized.sdc
write_sdf ${RESULTS_DIR}/${DESIGN_NAME}_${HRDWIRED_BITWIDTH}Bit_synthesized.mapped.sdf; #switching activity file




remove_design -hierarchy
exit
#}
