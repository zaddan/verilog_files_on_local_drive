set BWAC 1
#set WDIR /home/unga/sglee/Share/ac_hw_syn
set WDIR ~/behzad_local/verilog_files/synthesis
set RTLDIR ~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports
set DESIGN_NAME add_acc_ff
set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
#/* Top-level Module     */
set my_toplevel ${DESIGN_NAME}
set lib_dir /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib
set search_path [concat  $search_path   $lib_dir/stdcell_rvt/db_nldm]
source ${WDIR}/lib_list.txt
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME add_acc_ff


#--- specifying libraries 
set std_library "saed32rvt_tt1p05v25c.db"
set target_library "$std_library" 
set link_library "$std_library" 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"


set NAB 0    
#for { set NAB 0}  {$NAB < 1} {incr NAB 1} {


#--- read the design 
analyze -format verilog [list add_acc_out_ff.v add_acc.v]
elaborate $my_toplevel -parameters $NAB,32


#--- define design environement (setting up the design environment such as external operating conditions (manufacturing process, temperature, and voltage), loads, drives, fanouts, and wire load models)


set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]


#--- linking to libraries
link


#saif_map -start 


#--- set the optimization constraints 
create_clock -name clk -period .55 [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports b*]     
set_input_delay -max 0 -clock clk [get_ports a*]     
set_dont_touch_network [get_clocks clk]


check_design
#--- design rule constraints 
#set_max_area 0

foreach_in_collection endpt $endpoints { set pin [get_object_name $endpt] 
    group_path -name $pin -to $pin
}


set_max_delay .40 -from {b[16] b[17] b[18] b[19] b[20] b[21] b[22] b[23] b[24] b[25] b[26] b[27] b[28] b[29] b[30] b[31] a[16] a[17] a[18] a[19] a[20] a[21] a[22] a[23] a[24] a[25] a[26] a[27] a[28] a[29] a[30] a[31]} -to {reg_c_reg[16] reg_c_reg[17] reg_c_reg[18] reg_c_reg[19] reg_c_reg[20] reg_c_reg[21] reg_c_reg[22] reg_c_reg[23] reg_c_reg[24] reg_c_reg[25] reg_c_reg[26] reg_c_reg[27] reg_c_reg[28] reg_c_reg[29] reg_c_reg[30] reg_c_reg[31]}



#--- compile (symthesize adn optimize design)
#compile
#compile -area_effort high -power_effort high 
#compile -power_effort high
compile_ultra -area_high_effort_script 
#compile_ultra

#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing.rpt
report_timing -path full -sort_by slack -nworst 1000000 -max_paths 1000000 >  ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing1.rpt
#report_timing -path full -sort_by slack -from  $input_list -max_path 100 -nworst 2 >  ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing1.rpt
report_area -hierarchy -nosplit > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_area.rpt
report_power > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_constrain_violators.rpt
#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_qor.rpt
#report 


#--- save the design
#the following generates ddc files 
write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.ddc 
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.v
write_sdc ${RESULTS_DIR}/${DESIGN_NAME}.sdc





remove_design -hierarchy
#}
