#----------------------------------------------------
#*** F:DN finds the delay as/w each cell
#----------------------------------------------------


#----------------------------------------------------
#*** F:DN Parameters
#----------------------------------------------------
#---- N: the following should be commented out if the tcl file is invoked by 
#-----   a python function
#set DATA_PATH_BITWIDTH 32;
#set CLKGATED_BITWIDTH 4; #numebr of apx bits
#set clk_period .65;#.63;#.68;#.7
#set DESIGN_NAME conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BITWIDTH32
#set synth_file__na conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BITWIDTH32__only_clk_cons_synthesized.v
#set output__timing__log__na "test log"
##----------------------------------------------------
set OP_BITWIDTH $DATA_PATH_BITWIDTH; #operator bitwidth
puts $clk_period


#----------------------------------------------------
#*** F:DN Variables
#----------------------------------------------------
set WDIR "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports
#set DESIGN_NAME conf_int_mac__noFF__arch_agnospper
set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
set my_toplevel ${DESIGN_NAME}

#--- design dir
set design_dir_addr "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/results" 
set synth__file ${design_dir_addr}/$synth_file__na

#--- libraries
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries"
set lib_dir_3 "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"

#set lib_dir_3 "/home/local/pow/behzad/verilog_files/libraries/germany_NanGate/db"
set search_path [concat  $search_path $lib_dir_3]
#set  std_library  "noAging.db" 
set target_library $std_library; #$std_library_2" 
set link_library $std_library; #$std_library_2"
define_design_lib WORK -path ./WORK_1_${ID}
set verilogout_show_unconnected_pins "true"


#*** F:DN read the design
read_file  $synth__file -autoread -top $my_toplevel -library WORK_1_${ID}
check_design

#*** F:DN  set the optimization constraints 
create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports * -filter "direction == in"] 
#set_input_delay -max 0 -clock clk [get_ports *]     
set_dont_touch_network [get_clocks clk]
#set enable_keep_signal_dt_net true
#set enable_keep_signal true
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME $DESIGN_NAME
#...   ...    ..  ...  ..    ..    ...      ..
set_max_delay $clk_period -to [all_outputs]
group_path -name clk -from clk


#*** F:DN report the results
set report_file__prefix  ${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_BITWIDTH}Bit__only_clk_cons
set timing_log [open $output__timing__log__na w]
close $timing_log

#*** non_transitional cells identifier
foreach_in_collection my_el [get_cells -hierarchical] {
    set cell_name [get_object_name $my_el] 
    #*** F:AN make sure you set the limit properly 
    echo "cell_name: " $cell_name >> $output__timing__log__na
    report_timing -through $cell_name/* -path end >> $output__timing__log__na
}


#**** F:DN an attempt to see whether writing the result to a string
#          will accelerate the process; The answer is negative
#set timing_log [open $output__timing__log__na w]
#set result ""
#set counter 0
#foreach_in_collection my_el [get_cells -hierarchical] {
#    set cell_name [get_object_name $my_el] 
#    #*** F:AN make sure you set the limit properly 
#    append result [concat "cell_name " $cell_name "\n"] 
#    redirect -variable ret__v {report_timing -through $cell_name/* -path end}
#    append result $ret__v
#    if {[expr $counter % 1000] == 0} {
#        puts $timing_log $result
#        set result ""
#    }
#    incr counter
#}
#
#puts $timing_log $result
#close $timing_log

#report_timing -sort_by slack -nworst 1000 -significant_digits 4 >  ${REPORTS_DIR}/${report_file__prefix}__timing.rpt
#report_area -hierarchy -nosplit > ${REPORTS_DIR}/${report_file__prefix}__area.rpt
#report_power > ${REPORTS_DIR}/${report_file__prefix}__power.rpt
#report_constraint -all_violators > ${REPORTS_DIR}/${report_file__prefix}__constraint_violators.rpt
##report_path_group > ${REPORTS_DIR}/path_groups__garbage_collect.rpt
##report_constraint > ${REPORTS_DIR}/constraint__garbage_collect.rpt
#report_cell > ${REPORTS_DIR}/${report_file__prefix}__cells.rpt
#report_resources > ${REPORTS_DIR}/${report_file__prefix}__resources.rpt
#report_net
##
#
exit

