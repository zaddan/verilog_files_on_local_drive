# *** F:DN this file is only for synthesizing idct

#----------------------------------------------------
#--- Parameters
#----------------------------------------------------
set clk_period  .9

#----------------------------------------------------
#--- variables
#----------------------------------------------------
set WDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src/DAC_17_idct_code/approximated/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src/DAC_17_idct_code/approximated" 
set REPORTS_DIR ${WDIR}/reports

set DESIGN_NAME idct_BitWidth31_BitWidth130

set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
set my_toplevel ${DESIGN_NAME}

#--- libraries
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"


#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/FreePDK45/osu_soc/lib/files"
#--- NOTE: I had to include *_rvt as well, cause ow the compiler was erroring out
#set search_path [concat  $search_path $lib_dir_1/stdcell_rvt/db_nldm $lib_dir_1/stdcell_lvt/db_nldm $lib_dir_2/germany_NanGate/db $lib_dir_3]
set search_path [concat  $search_path $lib_dir_3]
#--- design dir
set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src/DAC_17_idct_code/approximated"

#--- library
#set std_library "saed32rvt_tt1p05v25c.db"
#set std_library "saed32lvt_tt1p05v25c.db"; #the best(amon lvts)
#set std_library "saed32lvt_tt1p05vn40c.db"; #did the same as 25c 
#set std_library "saed32lvt_tt0p85v25c.db"; #did worst that 1.05
#set  std_library  "saed32lvt_ulvl_ff1p16v25c_i0p85v.db" 

#set  std_library  "noAging.db" 
set  std_library  "1.2V_75T.db"
#set std_library "gscl45nm.db"; #PDK45 themselves

set target_library $std_library; #$std_library_2" 
set link_library $std_library; #$std_library_2"

set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME $DESIGN_NAME

#--- specifying libraries 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"

#set enable_keep_signal_dt_net true
#set enable_keep_signal true
#--- read the design 
#analyze -format verilog [list  ${design_dir_addr}/ripple_carry_adder.v ${design_dir_addr}/unconfig_int_add.v ${design_dir_addr}/acc_int_add.v ]
#analyze -format verilog [list  ${design_dir_addr}/unconfig_int_add.v]
#analyze -format verilog [list  ${design_dir_addr}/conf_int_mul__noFF__arch_agnos__w_wrapper.v ${design_dir_addr}/idct_synthesized.v]

#analyze -format verilog [list ${design_dir_addr}/idct_synthesized.v ${design_dir_addr}/conf_int_mul__noFF__arch_agnos__w_wrapper.v]
analyze -format verilog [list ${design_dir_addr}/idct_synthesized.v] 

elaborate $my_toplevel -parameters 31,30
#${design_dir_addr}/ripple_carry_adder.v] ;# this one is for a simple unstructured example
#elaborate $my_toplevel 

check_design

#set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]
#--- linking to libraries
link
#uniquify
#saif_map -start 


#--- set the optimization constraints 
create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports * -filter "direction == in"]     
set_dont_touch_network [get_clocks clk]
#set_dont_touch_network [get_rst rst]


#set RST reset
#remove_driving_cell $RST
#set_drive 0 $RST
#set_dont_touch_network $RST


#--- compile (symthesize  to gate level and optimize design)
#compile
#compile -map_effort high -area_effort high -power_effort high 
#compile -power_effort high
#compile_ultra
#compile_ultra -timing_high_effort_script -incremental
#set_dp_smartgen_options -carry_select_adder_cell true
#compile_ultra -timing_high_effort_script 
#compile_ultra -timing_high_effort_script -incremental
#compile_ultra -timing_high_effort_script -incremental
#compile_ultra -timing_high_effort_script -incremental

#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing.rpt

#---    ---      ---       ---       ---       ---
#report_timing -path full -sort_by slack -nworst 5000000 -max_paths 5000000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#report_timing -path full -sort_by slack -nworst 20000 -max_paths 20000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing_ref.rpt
#---    ---      ---       ---       ---       ---
report_timing -path full -sort_by slack  -significant_digits 4 > ${REPORTS_DIR}/${DESIGN_NAME}__timing.rpt
report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}__area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}__power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}__constrain_violators.rpt
#*** F:AN erase the next two lines
report_path_group > ${REPORTS_DIR}/path_groups__garbage_collect.rpt
report_constraint > ${REPORTS_DIR}/constraint__garbage_collect.rpt
report_cell > ${REPORTS_DIR}/${DESIGN_NAME}__cells.rpt
report_resources > ${REPORTS_DIR}/${DESIGN_NAME}_resources.rpt
report_design > ${REPORTS_DIR}/${DESIGN_NAME}_design.rpt
report_net
#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_qor.rpt
#report 
set bus_inference_style {%s[%d]} 
set bus_naming_style {%s[%d]} 
set hdlout_internal_busses true 
change_names -hierarchy -rule verilog 
define_name_rules name_rule -allowed "A-Z a-z 0-9 _" -max_length 255 -type cell 
define_name_rules name_rule -allowed "A-Z a-z 0-9 _[]" -max_length 255 -type net 
define_name_rules name_rule -map {{"\\*cell\\*" "cell" }}  
define_name_rules name_rule -case_insensitive 
change_names -hierarchy -rules name_rule

#--- save the design
#the following generates ddc files 
set syn_name  ${DESIGN_NAME}

write -format ddc -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.ddc
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.v
write_sdc ${RESULTS_DIR}/${syn_name}_synthesized.sdc
write_sdf ${RESULTS_DIR}/${syn_name}_synthesized.mapped.sdf; #switching activity file


remove_design -hierarchy
exit

