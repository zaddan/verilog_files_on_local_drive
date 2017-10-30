#*** F:DN this module allows us to only constrain some bits and up (but only
#         one set, as opposed to multiple sets)

#set WDIR /home/unga/sglee/Share/ac_hw_syn
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
#---- Parameters
#----------------------------------------------------
#---- N: the following should be commented out if the tcl file is invoked by 
#-----   a python function
#set DATA_PATH_WIDTH 32;
#set CLKGATED_BITWIDTH 4; #numebr of apx bits
#set clk_period .7;#.55;#.63;#.68;#.7
#set apx_optimal 1
#set lsb_bits 3
#set msb_max_delay .48;#.57;#.61;#.62;
#set msb_min_delay 0;#.55;#.59;#.58
#set Pn 28
#----------------------------------------------------
set apx_optimal_mode(first) 1
set OP_BITWIDTH $DATA_PATH_WIDTH; #operator bitwidth


#--- F: printing the parameters into a file
set result_log__na "result_log.txt"
set result_log [open $result_log__na w]
puts $result_log "--- TCL'S PARAMETER INFO"
puts $result_log [concat "DATA_PATH_WIDTH:" $DATA_PATH_WIDTH]
puts $result_log [concat "clk_period :" $clk_period] 
puts $result_log [concat "apx_optimal:" $apx_optimal] 
puts $result_log [concat "apx_optimal_mode(first):" $apx_optimal_mode(first)]
puts $result_log [concat "msb_max_delay:" $msb_max_delay] 
puts $result_log [concat "Pn:" $Pn] 
puts $result_log [concat "slow_down:"] 
close $result_log
#----------------------------------------------------

#----------------------------------------------------
#--- variables
#----------------------------------------------------
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
set REPORTS_DIR ${WDIR}/reports
set DESIGN_NAME conf_int_mac__noFF__redundant_ports
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
set search_path [concat  $search_path $lib_dir_3]
#--- design dir
set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
set  std_library  "noAging.db" 
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
analyze -format verilog [list  ${design_dir_addr}/${DESIGN_NAME}.v]
elaborate $my_toplevel -parameters $OP_BITWIDTH,$DATA_PATH_WIDTH,[expr 32 - $Pn]
check_design
#--- linking to libraries
link
#--- set the optimization constraints 
create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports b*]     
set_input_delay -max 0 -clock clk [get_ports a*]     
set_dont_touch_network [get_clocks clk]


#----------------------------------------------------
set all_reg_a_l [make-reg_l "a" 0 $DATA_PATH_WIDTH]
set all_reg_b_l [make-reg_l "b" 0 $DATA_PATH_WIDTH]
set all_reg_c_l [make-reg_l "c" 0 $DATA_PATH_WIDTH]
set all_reg_d_l [make-reg_l "d" 0 $DATA_PATH_WIDTH]
set all_reg_a_b_joined [concat $all_reg_a_l $all_reg_b_l]
set all_reg_a_b_c_joined [concat $all_reg_a_b_joined]
#---    ---      ---       ---       ---       ---
set lsb_reg_a_l [make-reg_l "a" 0 $lsb_bits]
set lsb_reg_b_l [make-reg_l "b" 0 $lsb_bits]
set lsb_reg_c_l [make-reg_l "c" 0 $lsb_bits]
set lsb_reg_d_l [make-reg_l "d" 0 $lsb_bits]
set lsb_reg_a_b_joined [concat $lsb_reg_a_l $lsb_reg_b_l]
set lsb_reg_a_b_c_joined [concat $lsb_reg_a_b_joined $lsb_reg_c_l]
#---    ---      ---       ---       ---       ---
set msb_reg_a_l [make-reg_l "a" $lsb_bits $DATA_PATH_WIDTH]
set msb_reg_b_l [make-reg_l "b" $lsb_bits $DATA_PATH_WIDTH]
set msb_reg_c_l [make-reg_l "c" $lsb_bits $DATA_PATH_WIDTH]
set msb_reg_d_l [make-reg_l "d" [expr 2 * $lsb_bits] $DATA_PATH_WIDTH]
set msb_reg_a_b_joined [concat $msb_reg_a_l $msb_reg_b_l]
set msb_reg_a_b_c_joined [concat $msb_reg_a_b_joined $msb_reg_c_l]
#---    ---      ---       ---       ---       ---

#set a_h_n_bits [expr 32  $Pn]]
#set b_h_n_bits [expr 32 - [expr 2 * $Pn]]
set c_h_bit__lower_bound [expr 2 * [expr 32 - $Pn]]
set reg_a_h_l [make-reg_l "a_h" 0 [expr $Pn -1]]
set reg_b_h_l [make-reg_l "b_h" 0 [expr $Pn - 1]]
set reg_c_h_l [make-reg_l "c" $c_h_bit__lower_bound $DATA_PATH_WIDTH]
#set reg_d_l [make-reg_l "d" [expr 2 * [expr $lsb_bits + 8]] $DATA_PATH_WIDTH]
set reg_a_b_h_joined [concat $reg_a_h_l $reg_b_h_l]
set reg_a_b_c_h_joined [concat $reg_a_b_h_joined $reg_c_h_l]
#---    ---      ---       ---       ---       ---
set reg_0_lsb__a [make-reg_l "a" 0 [expr 0 + $lsb_bits]]
set reg_0_lsb__b [make-reg_l "b" 0 [expr 0 + $lsb_bits]]
set reg_0_lsb__c [make-reg_l "c" 0 [expr 0 + $lsb_bits]]
set reg_0_lsb__d [make-reg_l "d" 0 [expr 0 + $lsb_bits]]
set reg_0_lsb__a_b_joined [concat $reg_0_lsb__b $reg_0_lsb__a]
set reg_0_lsb__a_b_c_joined [concat $reg_0_lsb__c $reg_0_lsb__a_b_joined]
puts $lsb_reg_a_b_c_joined 
puts $msb_reg_a_b_c_joined
puts $reg_a_b_c_h_joined
puts $reg_0_lsb__a_b_c_joined 
#----------------------------------------------------


#----------------------------------------------------
#*** F:DN constraints
set_max_delay $clk_period -from $all_reg_a_b_c_joined -to $all_reg_d_l 
if {$apx_optimal == 1} {
    #--- F: decide which bits to prioritize 
    if {$apx_optimal_mode(first) == 1} {
       #set priority_array  $lsb_reg_a_b_c_joined 
       #set priority_array  $lsb_reg_a_b_c_joined 
       set priority_array   $reg_a_b_c_h_joined 
    } 
    set all_input__pt [concat $all_reg_a_b_c_joined $reg_a_b_c_h_joined]
    foreach pt $all_input__pt { 
        puts $pt   
        if {[lsearch -exact $priority_array $pt] >= 0} {
            group_path -name priority -from $pt -critical_range 0.5 -priority 100 -weight 100
        } else {
            group_path -name non_priority -from $pt -critical_range 0.5 -priority 1 -weight 1
        }
    }
} else {
    #group_path -name clk -from clk -critical_range 0.5 -priority 100 -weight 100
    group_path -name clk -from clk
}
if {$apx_optimal == 1} {
    if {$apx_optimal_mode(first) == 1} {
        #set_max_delay $msb_max_delay -from $msb_reg_a_b_c_joined -to $msb_reg_d_l
        set_max_delay $msb_max_delay -from $reg_a_b_c_h_joined -to $msb_reg_d_l
        #set_min_delay $msb_min_delay -from $msb_reg_a_b_c_joined -to $msb_reg_d_l
    }
}
#----------------------------------------------------


#----------------------------------------------------
#*** F:DN compile
#set_flatten true -minimize multiple_output
compile_ultra -timing_high_effort_script  >> $result_log__na
compile_ultra -timing_high_effort_script -incremental >> $result_log__na
compile_ultra -timing_high_effort_script -incremental >> $result_log__na
#set_max_delay $clk_period_2 -from $all_reg_a_b_c_joined -to $all_reg_d_l 
#compile_ultra -timing_high_effort_script -incremental
#----------------------------------------------------


#*** F:DN reports
#----------------------------------------------------
report_timing -path full -from $lsb_reg_a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 
report_timing -path full -from $msb_reg_a_b_c_joined -to $all_reg_d_l -sort_by group -significant_digits 4 
report_timing -path full -from $reg_a_b_c_h_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 

report_timing -path full -from $lsb_reg_a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
report_timing -path full -from $msb_reg_a_b_c_joined -to $all_reg_d_l -sort_by group -significant_digits 4  >> ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
report_timing -path full -from $reg_a_b_c_h_joined -to $all_reg_d_l -sort_by slack -significant_digits 4  >> ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt

report_timing -path full -from $lsb_reg_a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 >> $result_log__na
report_timing -path full -from $msb_reg_a_b_c_joined -to $all_reg_d_l -sort_by group -significant_digits 4  >> $result_log__na
report_timing -path full -from $reg_a_b_c_h_joined -to $all_reg_d_l -sort_by slack -significant_digits 4  >> $result_log__na
report_power >> $result_log__na
report_area -hierarchy -nosplit >> $result_log__na
#---    ---      ---       ---       ---       ---


report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_constrain_violators.rpt
#*** F:AN erase the next two lines
report_path_group > ${REPORTS_DIR}/path_groups__garbage_collect.rpt
report_constraint > ${REPORTS_DIR}/constraint__garbage_collect.rpt
report_cell > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_cells.rpt
report_resources > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_resources.rpt
report_net
#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_qor.rpt
#report 

#--- save the design
#the following generates ddc files 
set syn_name  ${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit

write -format ddc -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.ddc
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.v
write_sdc ${RESULTS_DIR}/${syn_name}_synthesized.sdc
write_sdf ${RESULTS_DIR}/${syn_name}_synthesized.mapped.sdf; #switching activity file


remove_design -hierarchy
exit

