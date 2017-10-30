#set WDIR /home/unga/sglee/Share/ac_hw_syn


#--- variables
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports

set DESIGN_NAME unconfig_int_add
set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
set my_toplevel ${DESIGN_NAME}

#--- libraries
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/FreePDK45/osu_soc/lib/files"
#--- NOTE: I had to include *_rvt as well, cause ow the compiler was erroring out
#set search_path [concat  $search_path $lib_dir_1/stdcell_rvt/db_nldm $lib_dir_1/stdcell_lvt/db_nldm $lib_dir_2/germany_NanGate/db $lib_dir_3]
set search_path [concat  $search_path $lib_dir_3]
#--- design dir
set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"

#--- library
#set std_library "saed32rvt_tt1p05v25c.db"
#set std_library "saed32lvt_tt1p05v25c.db"; #the best(amon lvts)
#set std_library "saed32lvt_tt1p05vn40c.db"; #did the same as 25c 
#set std_library "saed32lvt_tt0p85v25c.db"; #did worst that 1.05
#set  std_library  "saed32lvt_ulvl_ff1p16v25c_i0p85v.db" 
set  std_library  "noAging.db" 
#set std_library "gscl45nm.db"; #PDK45 themselves

set target_library $std_library; #$std_library_2" 
set link_library $std_library; #$std_library_2"

set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME unconfig_int_add

#--- specifying libraries 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"


#--- parameters
set OP_BITWIDTH 28; #operator bitwidth
set DATA_PATH_BITWIDTH 28; #flipflop bitwidth

#for { set NAB 0}  {$NAB < 1} {incr NAB 1} {


#--- read the design 
analyze -format verilog [list ${design_dir_addr}/unconfig_int_add.v ${design_dir_addr}/acc_int_add.v]
elaborate $my_toplevel -parameters $OP_BITWIDTH,$DATA_PATH_BITWIDTH
check_design


#--- define design environement (setting up the design environment such as external operating conditions (manufacturing process, temperature, and voltage), loads, drives, fanouts, and wire load models)


set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]


#--- linking to libraries
link


#saif_map -start 


#--- set the optimization constraints 
create_clock -name clk -period 0 [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports b*]     
set_input_delay -max 0 -clock clk [get_ports a*]     
set_dont_touch_network [get_clocks clk]

#--- use the following rule if you don't want to use the clock and 
#------ you are only having combination logic for the addition
set_max_delay 0 -to [all_outputs]

#--- design rule constraints 
#set_max_area 0

#---- don't need this, if we add it the combination logic case would be different
#-------- comparing to the german people
#foreach_in_collection endpt $endpoints { set pin [get_object_name $endpt] 
#    group_path -name $pin -to $pin
#}


#set_max_delay .2 -from {reg_b_reg[16] reg_b_reg[17] reg_b_reg[18] reg_b_reg[19] reg_b_reg[20] reg_b_reg[21] reg_b_reg[22] reg_b_reg[23] reg_b_reg[24] reg_b_reg[25] reg_b_reg[26] reg_b_reg[27] reg_b_reg[28] reg_b_reg[29] reg_b_reg[30] reg_b_reg[31] reg_a_reg[16] reg_a_reg[17] reg_a_reg[18] reg_a_reg[19] reg_a_reg[20] reg_a_reg[21] reg_a_reg[22] reg_a_reg[23] reg_a_reg[24] reg_a_reg[25] reg_a_reg[26] reg_a_reg[27] reg_a_reg[28] reg_a_reg[29] reg_a_reg[30] reg_a_reg[31]} -to {reg_c_reg[16] reg_c_reg[17] reg_c_reg[18] reg_c_reg[19] reg_c_reg[20] reg_c_reg[21] reg_c_reg[22] reg_c_reg[23] reg_c_reg[24] reg_c_reg[25] reg_c_reg[26] reg_c_reg[27] reg_c_reg[28] reg_c_reg[29] reg_c_reg[30] reg_c_reg[31]}


#set_max_delay .15 -from {b[16] b[17] b[18] b[19] b[20] b[21] b[22] b[23] b[24] b[25] b[26] b[27] b[28] b[29] b[30] b[31] a[16] a[17] a[18] a[19] a[20] a[21] a[22] a[23] a[24] a[25] a[26] a[27] a[28] a[29] a[30] a[31]} -to {c[16] c[17] c[18] c[19] c[20] c[21] c[22] c[23] c[24] c[25] c[26] c[27] c[28] c[29] c[30] c[31]}


#--- compile (symthesize  to gate level and optimize design)
#compile
#compile -map_effort high -area_effort high -power_effort high 
#compile -power_effort high
#compile_ultra
#compile_ultra -timing_high_effort_script -incremental
compile_ultra -timing_high_effort_script 
#compile_ultra

#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing.rpt
report_timing -path full -sort_by slack -nworst 10000 -max_paths 10000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_timing.rpt
#report_timing -path full -sort_by slack -from  $input_list -max_path 100 -nworst 2 >  ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing1.rpt
report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_constrain_violators.rpt
#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_qor.rpt
#report 


#--- save the design
#the following generates ddc files 
write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_synthesized.ddc 
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_synthesized.v
write_sdc ${RESULTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_synthesized.sdc; #constraint file
write_sdf ${RESULTS_DIR}/${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit_synthesized.mapped.sdf; #switching activity file


remove_design -hierarchy
exit

