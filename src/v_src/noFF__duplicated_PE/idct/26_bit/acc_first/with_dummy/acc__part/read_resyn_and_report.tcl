#----------------------------------------------------
#*** F:DN this file syntheizes an arch agnos design for a mac 
#         resyn and report timing
#----------------------------------------------------

proc make-reg_l {reg_na reg_lower_bound reg_up_bound} {
    set reg_l {}
    set num_l {}
    for {set a $reg_lower_bound} {$a < $reg_up_bound} {incr a} {
        lappend num_l $a
    }
    foreach el $num_l {
        #append concat_res reg_a_reg $el 
        lappend reg_l  "${reg_na}\[${el}\]"
        #reg_a_reg[${el}]
    }
    set reg_l_flattened [join $reg_l]
    return $reg_l_flattened
}



#----------------------------------------------------
#*** F:DN Parameters
#----------------------------------------------------
#---- N: the following should be commented out if the tcl file is invoked by 
#-----   a python function
#set DATA_PATH_BITWIDTH 32;
#set CLKGATED_BITWIDTH 4; #numebr of apx bits
#set clk_period .61;#.63;#.68;#.7
#set DESIGN_NAME conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BIT32_3
#set synth_file__na conf_int_mac__noFF__arch_agnos__w_wrapper_32Bit_32Bit__only_clk_cons_synthesized.v 
#set acc_max_delay .43
#set attempt__iter__c 0
#set ID 2
##----------------------------------------------------
                # the log file name and inside the log file for identification
#set OP_BITWIDTH $DATA_PATH_BITWIDTH; #operator bitwidth
puts $clk_period

#----------------------------------------------------
#*** F:DN Variables
#----------------------------------------------------
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
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
set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results" 
set synth__file ${design_dir_addr}/$synth_file__na

#--- libraries
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"
set search_path [concat  $search_path $lib_dir_3]
#set  std_library  "noAging.db" 
set  std_library  "1.2V_25T.db"

set target_library $std_library; #$std_library_2" 
set link_library $std_library; #$std_library_2"
#...   ...    ..  ...  ..    ..    ...      ..
#*** F:AN deleting is necessary otherwise the synthesized design might be renamed
#         which results in problems while reading it (the synth design)
file delete -force WORK_1_${ID} ;#deleting so I won't have to deal with renaming
define_design_lib WORK -path ./WORK_1_${ID}
set verilogout_show_unconnected_pins "true"
#----------------------------------------------------
#*** F:DN read the design
read_file  $synth__file -autoread -top $my_toplevel -library WORK_1_${ID}
check_design


#set_critical_range .6 "conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH26"
#set_critical_range .6 "conf_int_mul__noFF__arch_agnos_OP_BITWIDTH18_DATA_PATH_BITWIDTH26"
group_path -default -from [get_ports * -filter "direction == in"] -critical_range .6

#*** F:DN  set the optimization constraints 
create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports * -filter "direction == in"] 
#set_input_delay  -max  .48 -clock clk  [get_ports d_internal__acc*]
#set_input_delay -max 0 -clock clk [get_ports *]     
set_dont_touch_network [get_clocks clk]
#set enable_keep_signal_dt_net true
#set enable_keep_signal true
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME $DESIGN_NAME

#----------------------------------------------------
#**** F:DN collect data before increasing pressure(time wise) on the design
#----------------------------------------------------
#set all_data__file__addr ${op_type}_${DATA_PATH_BITWIDTH}__clk_${clk_period}__atmpt_${attempt__iter__c}__id_${ID}__evol_log.txt
set_max_delay $clk_period -to [all_outputs] ;#modifying the constraint to makesure
echo "**************** " > ${all_data__file__addr}
echo "*** F:DN before resyntheis " >> ${all_data__file__addr}
echo "**************** " >> ${all_data__file__addr}
#report_timing -sort_by slack -exclude [get_ports d_internal__acc*] -significant_digits 4 >>  ${all_data__file__addr}
report_timing -sort_by slack -significant_digits 4 >>  ${all_data__file__addr}

echo "*** F:DN power report" >> ${all_data__file__addr}
report_power >>  ${all_data__file__addr}
report_area -hierarchy -nosplit >>  ${all_data__file__addr}
#echo "**************** " >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#echo "*** F: after putting pressure " >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#echo "**************** " >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#----------------------------------------------------

set_max_delay $clk_period -to [all_outputs]

#*** F:DN compile
#set_dont_touch mul__inst__apx
#set_dont_touch mul__inst__acc
compile_ultra -timing_high_effort_script -no_autoungroup 
compile_ultra -timing_high_effort_script -incremental -no_autoungroup
compile_ultra -timing_high_effort_script -incremental -no_autoungroup
optimize_netlist -area
#compile_ultra -timing_high_effort_script -incremental -no_autoungroup
#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 


#*** F:DN report the results
set report_file__prefix  ${DESIGN_NAME}__only_clk_cons
report_timing -sort_by group -nworst 1000 -significant_digits 4 >  ${REPORTS_DIR}/${report_file__prefix}__timing.rpt
#report_timing -sort_by group -exclude [get_ports d_internal__acc*] -significant_digits 4 >  ${REPORTS_DIR}/${report_file__prefix}__timing.rpt
#**** change this back
#report_timing -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${report_file__prefix}__timing.rpt
#report_timing -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${report_file__prefix}__timing.rpt

report_area -hierarchy -nosplit > ${REPORTS_DIR}/${report_file__prefix}__area.rpt
report_power > ${REPORTS_DIR}/${report_file__prefix}__power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${report_file__prefix}__constraint_violators.rpt
#report_path_group > ${REPORTS_DIR}/path_groups__garbage_collect.rpt
#report_constraint > ${REPORTS_DIR}/constraint__garbage_collect.rpt
report_cell > ${REPORTS_DIR}/${report_file__prefix}__cells.rpt
report_resources > ${REPORTS_DIR}/${report_file__prefix}__resources.rpt
report_net


#set_max_delay $clk_period -to [all_outputs] ;#modifying the constraint to makesure
echo "**************** " >> ${all_data__file__addr}
echo "*** F:DN after resynthesis " >> ${all_data__file__addr}
echo "**************** " >> ${all_data__file__addr}
#report_timing -sort_by slack -exclude [get_ports d_internal__acc*] -significant_digits 4 >>  ${all_data__file__addr}
#report_timing -sort_by slack -exclude [get_ports d_internal__acc*] -significant_digits 4 >>  ${all_data__file__addr}
report_timing -sort_by slack -significant_digits 4 >>  ${all_data__file__addr} ;#for legacy parsing purposes repeating
report_timing -sort_by slack -significant_digits 4 >>  ${all_data__file__addr} ;#for legacy parsing purposes repeating

echo "*** F:DN power report" >> ${all_data__file__addr}
report_power >>  ${all_data__file__addr}
report_area -hierarchy -nosplit >>  ${all_data__file__addr}



#....................................................
#*** F:DN dumping the result in one log file
#set all_data__file__addr ${op_type}_${DATA_PATH_BITWIDTH}__clk_${clk_period}__acc_max_delay_${acc_max_delay}__Pn_${Pn}__log.txt
#echo $all_data__file__addr >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#echo "*** F:DN transitional cells report" >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#report_timing -sort_by slack -exclude $non_transition_cells__l -significant_digits 4 >>  ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#set_max_delay $clk_period -to [all_outputs] ;#modifying the constraint to makesure
#                                             #all paths meet the clk
#echo "*** F:DN all cells report" >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#report_timing -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#echo "*** F:DN power report" >> ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#report_power >>  ${REPORTS_DIR}/data_collected/${all_data__file__addr}
#

#*** F:DN save the design
set syn_name ${report_file__prefix} ;#syntheiszed file name
write -format ddc -hierarchy -output ${RESULTS_DIR}/${syn_name}_resynthesized${ID}.ddc
write -f verilog -hierarchy -output ${RESULTS_DIR}/${syn_name}_resynthesized${ID}.v
write_sdc ${RESULTS_DIR}/${syn_name}_resynthesized${ID}.sdc
write_sdf ${RESULTS_DIR}/${syn_name}_resynthesized${ID}.mapped.sdf; #switching activity file
remove_design -hierarchy


exit
#
