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


set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#----------------------------------------------------
#---- Parameters
#----------------------------------------------------
set DESIGN_NAME conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BITWIDTH32
set synth__file ${design_dir_addr}/test_mac.v;#the synthesized verilog file
set DATA_PATH_WIDTH 32;
set CLKGATED_BITWIDTH 4; #numebr of apx bits
set clk_period .5
###--- F: apximation
set apx_optimal 1
set apx_optimal_mode(first) 1
set apx_optimal_mode(second) 1
set apx_optimal_mode(third)  1
set apx_optimal_mode(fourth) 1
set msb_1_max_delay .42;#.270 ideally
set msb_2_max_delay .42 ;#.261 ideally
set msb_3_max_delay .42 ;#.249 ideally
set msb_4_max_delay .42 ;#.242 ideally
puts "----------------------------------------------------"
set OP_BITWIDTH $DATA_PATH_WIDTH; #operator bitwidth


#--- F: printing the parameters into a file
set parameter_log [open "parameter_log.txt" w]
puts $parameter_log "--- TCL'S PARAMETER INFO"
puts $parameter_log [concat "DATA_PATH_WIDTH:" $DATA_PATH_WIDTH]
#puts $parameter_log [concat "CLKGATED_BITWIDTH:" $CLKGATED_BITWIDTH] 
puts $parameter_log [concat "clk_period :" $clk_period] 
puts $parameter_log [concat "apx_optimal:" $apx_optimal] 
puts $parameter_log [concat "apx_optimal_mode(first):" $apx_optimal_mode(first)]
puts $parameter_log [concat "apx_optimal_mode(second):" $apx_optimal_mode(second)]
puts $parameter_log [concat "apx_optimal_mode(third):"  $apx_optimal_mode(third)]
puts $parameter_log [concat "apx_optimal_mode(fourth):" $apx_optimal_mode(fourth)]
puts $parameter_log [concat "msb_1_max_delay:" $msb_1_max_delay] 
puts $parameter_log [concat "msb_2_max_delay:" $msb_2_max_delay] 
puts $parameter_log [concat "msb_3_max_delay:" $msb_3_max_delay] 
puts $parameter_log [concat "msb_4_max_delay:" $msb_4_max_delay] 
close $parameter_log
#----------------------------------------------------


#----------------------------------------------------
#--- variables
#----------------------------------------------------
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports


#set DESIGN_NAME conf_int_mac__noFF__arch_specific
#set DESIGN_NAME unconfig_int_add
#set DESIGN_NAME unconfig_int_add


set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
set my_toplevel ${DESIGN_NAME}

#--- libraries
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"

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
#set  std_library  "noAging.db" 
set  std_library  "1.2V_25T.db"
#set std_library "gscl45nm.db"; #PDK45 themselves

set synth_library_1 "/usr/local/packages/synopsys_2016/syn/libraries/syn/standard.sldb"
set synth_library_2 "/usr/local/packages/synopsys_2016/syn/libraries/syn/dw_foundation.sldb"
set target_library $std_library; #std cells for mapping
set synthetic_library [list $synth_library_1 $synth_library_2]

set link_library [list $std_library $synth_library_1 $synth_library_2] 

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
read_file  $synth__file -autoread -top $my_toplevel
check_design

#set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]
#--- linking to libraries
link
#uniquify
#saif_map -start 

#--- set the optimization constraints 
create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports b*]     
set_input_delay -max 0 -clock clk [get_ports a*]     
set_dont_touch_network [get_clocks clk]

#set_dont_touch_network [get_net o_temp_1]
#set_dont_touch_network [get_ports a[0]]
#set_dont_touch_network [get_ports a[1]]
#set_dont_touch_network [get_ports b[0]]
#set_dont_touch_network [get_ports b[1]]
#set_dont_touch_network [get_port c*]
#


#--- use the following rule if you don't want to use the clock and 
#------ you are only having combination logic for the addition
#set_max_delay  -to [all_outputs]

#--- design rule constraints 
#set_max_area 0

#---- don't need this, if we add it the combination logic case would be different
#-------- comparing to the german people
#foreach_in_collection endpt $endpoints { set pin [get_object_name $endpt] 
#    group_path -name $pin -to $pin
#}

set all_reg_a_l [make-reg_l "a" 0 $DATA_PATH_WIDTH]
set all_reg_b_l [make-reg_l "b" 0 $DATA_PATH_WIDTH]
set all_reg_c_l [make-reg_l "c" 0 $DATA_PATH_WIDTH]
set all_reg_d_l [make-reg_l "d" 0 $DATA_PATH_WIDTH]
set all_reg_a_b_joined [concat $all_reg_a_l $all_reg_b_l]
set all_reg_a_b_c_joined [concat $all_reg_a_b_joined]

set lsb_bits 4
#$CLKGATED_BITWIDTH
set msb_bits [expr $DATA_PATH_WIDTH - $lsb_bits]
#----------------------------------------------------

#----------------------------------------------------
#----------------------------------------------------
#--- lab_1 ,[lsb: 0]
set lsb_1_reg_a_l [make-reg_l "a" 0 $lsb_bits]
set lsb_1_reg_b_l [make-reg_l "b" 0 $lsb_bits]
set lsb_1_reg_c_l [make-reg_l "c" 0 $lsb_bits]
set lsb_1_reg_d_l [make-reg_l "d" 0 $lsb_bits]
set lsb_1_reg_a_b_joined [concat $lsb_1_reg_a_l $lsb_1_reg_b_l]
set lsb_1_reg_a_b_c_joined [concat $lsb_1_reg_a_b_joined $lsb_1_reg_c_l]

set msb_1_reg_a_l [make-reg_l "a" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_b_l [make-reg_l "b" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_c_l [make-reg_l "c" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_d_l [make-reg_l "d" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_a_b_joined [concat $msb_1_reg_a_l $msb_1_reg_b_l]
set msb_1_reg_a_b_c_joined [concat $msb_1_reg_a_b_joined $msb_1_reg_c_l]
#-----  -----    -----     -----     -----     -----
set lsb_2_reg_a_l [make-reg_l "a" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_b_l [make-reg_l "b" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_c_l [make-reg_l "c" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_d_l [make-reg_l "d" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_a_b_joined [concat $lsb_2_reg_a_l $lsb_2_reg_b_l]
set lsb_2_reg_a_b_c_joined [concat $lsb_2_reg_a_b_joined $lsb_2_reg_c_l]

set msb_2_reg_a_l [make-reg_l "a" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_b_l [make-reg_l "b" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_c_l [make-reg_l "c" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_d_l [make-reg_l "d" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_a_b_joined [concat $msb_2_reg_a_l $msb_2_reg_b_l]
set msb_2_reg_a_b_c_joined [concat $msb_2_reg_a_b_joined $msb_2_reg_c_l]
#-----  -----    -----     -----     -----     -----
set lsb_3_reg_a_l [make-reg_l "a" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_b_l [make-reg_l "b" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_c_l [make-reg_l "c" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_d_l [make-reg_l "d" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_a_b_joined [concat $lsb_3_reg_a_l $lsb_3_reg_b_l]
set lsb_3_reg_a_b_c_joined [concat $lsb_3_reg_a_b_joined $lsb_3_reg_c_l]

set msb_3_reg_a_l [make-reg_l "a" [expr $lsb_bits + 8]  $DATA_PATH_WIDTH]
set msb_3_reg_b_l [make-reg_l "b" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_c_l [make-reg_l "c" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_d_l [make-reg_l "d" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_a_b_joined [concat $msb_3_reg_a_l $msb_3_reg_b_l]
set msb_3_reg_a_b_c_joined [concat $msb_3_reg_a_b_joined $msb_3_reg_c_l]
#-----  -----    -----     -----     -----     -----
set lsb_4_reg_a_l [make-reg_l "a" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_b_l [make-reg_l "b" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_c_l [make-reg_l "c" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_d_l [make-reg_l "d" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_a_b_joined [concat $lsb_4_reg_a_l $lsb_4_reg_b_l]
set lsb_4_reg_a_b_c_joined [concat $lsb_4_reg_a_b_joined $lsb_4_reg_c_l]

set msb_4_reg_a_l [make-reg_l "a" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
set msb_4_reg_b_l [make-reg_l "b" [expr $lsb_bits + 12]  $DATA_PATH_WIDTH]
set msb_4_reg_c_l [make-reg_l "c" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
set msb_4_reg_d_l [make-reg_l "d" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
set msb_4_reg_a_b_joined [concat $msb_4_reg_a_l $msb_4_reg_b_l]
set msb_4_reg_a_b_c_joined [concat $msb_4_reg_a_b_joined $msb_4_reg_c_l]
#----------------------------------------------------
#----------------------------------------------------
puts "----------------------------------------------------"
puts "----------------------------------------------------"
puts "msb_1_reg_a_b_c_joined"
puts $msb_1_reg_a_b_c_joined
puts "--------------"
puts "msb_2_reg_a_b_c_joined"
puts $msb_2_reg_a_b_c_joined
puts "--------------"
puts "msb_3_reg_a_b_c_joined"
puts $msb_3_reg_a_b_c_joined
puts "--------------"
puts "msb_4_reg_a_b_c_joined"
puts $msb_4_reg_a_b_c_joined
puts "-----  -----    -----     -----     -----     -----"
puts "lsb_1_reg_a_b_c_joined"
puts $lsb_1_reg_a_b_c_joined
puts "--------------"
puts "lsb_2_reg_a_b_c_joined"
puts $lsb_2_reg_a_b_c_joined
puts "--------------"
puts "lsb_3_reg_a_b_c_joined"
puts $lsb_3_reg_a_b_c_joined
puts "--------------"
puts "lsb_4_reg_a_b_c_joined"
puts $lsb_4_reg_a_b_c_joined
puts "-----  -----    -----     -----     -----     -----"
puts "lsb_1_reg_d_l"
puts $lsb_1_reg_d_l 
puts "lsb_2_reg_d_l"
puts $lsb_2_reg_d_l 
puts "lsb_3_reg_d_l"
puts $lsb_3_reg_d_l 
puts "lsb_4_reg_d_l"
puts $lsb_4_reg_d_l 
puts "-----  -----    -----     -----     -----     -----"
puts "msb_1_reg_d_l"
puts $msb_1_reg_d_l 
puts "msb_2_reg_d_l"
puts $msb_2_reg_d_l 
puts "msb_3_reg_d_l"
puts $msb_3_reg_d_l 
puts "msb_4_reg_d_l"
puts $msb_4_reg_d_l 
#---    ---      ---       ---       ---       ---
set reg_0_4__a [make-reg_l "a" 0 [expr 0 + $lsb_bits]]
set reg_0_4__b [make-reg_l "b" 0 [expr 0 + $lsb_bits]]
set reg_0_4__c [make-reg_l "c" 0 [expr 0 + $lsb_bits]]
set reg_0_4__d [make-reg_l "d" 0 [expr 0 + $lsb_bits]]
set reg_0_4__a_b_joined [concat $reg_0_4__b $reg_0_4__a]
set reg_0_4__a_b_c_joined [concat $reg_0_4__c $reg_0_4__a_b_joined]


set reg_4_8__a [make-reg_l "a" $lsb_bits [expr $lsb_bits+4]]
set reg_4_8__b [make-reg_l "b" $lsb_bits [expr $lsb_bits+4]]
set reg_4_8__c [make-reg_l "c" $lsb_bits [expr $lsb_bits+4]]
set reg_4_8__d [make-reg_l "d" $lsb_bits [expr $lsb_bits+4]]
set reg_4_8__a_b_joined [concat $reg_4_8__b $reg_4_8__a]
set reg_4_8__a_b_c_joined [concat $reg_4_8__c $reg_4_8__a_b_joined]

set reg_8_12__a [make-reg_l "a" [expr $lsb_bits+4] [expr $lsb_bits+8]] 
set reg_8_12__b [make-reg_l "b"  [expr $lsb_bits+4] [expr $lsb_bits+8]]
set reg_8_12__c [make-reg_l "c"  [expr $lsb_bits+4] [expr $lsb_bits+8]]
set reg_8_12__d [make-reg_l "d"  [expr $lsb_bits+4] [expr $lsb_bits+8]]
set reg_8_12__a_b_joined [concat $reg_8_12__b $reg_8_12__a]
set reg_8_12__a_b_c_joined [concat $reg_8_12__c $reg_8_12__a_b_joined]

set reg_12_16__a [make-reg_l "a"  [expr $lsb_bits+8] [expr $lsb_bits+12]]
set reg_12_16__b [make-reg_l "b" [expr $lsb_bits+8] [expr $lsb_bits+12]]
set reg_12_16__c [make-reg_l "c" [expr $lsb_bits+8] [expr $lsb_bits+12]]
set reg_12_16__d [make-reg_l "d" [expr $lsb_bits+8] [expr $lsb_bits+12]]
set reg_12_16__a_b_joined [concat $reg_12_16__b $reg_12_16__a]
set reg_12_16__a_b_c_joined [concat $reg_12_16__c $reg_12_16__a_b_joined]

set reg_16_32__a [make-reg_l "a"  [expr $lsb_bits+12] [expr $lsb_bits+28]]
set reg_16_32__b [make-reg_l "b" [expr $lsb_bits+12] [expr $lsb_bits+28]]
set reg_16_32__c [make-reg_l "c" [expr $lsb_bits+12] [expr $lsb_bits+28]]
set reg_16_32__d [make-reg_l "d" [expr $lsb_bits+12] [expr $lsb_bits+28]]
set reg_16_32__a_b_joined [concat $reg_16_32__b $reg_16_32__a]
set reg_16_32__a_b_c_joined [concat $reg_16_32__c $reg_16_32__a_b_joined]

puts "-----  -----    -----     -----     -----     -----"
puts $reg_0_4__a_b_c_joined
puts $reg_4_8__a_b_c_joined
puts $reg_8_12__a_b_c_joined
puts $reg_16_32__a_b_c_joined
puts $all_reg_d_l
#---    ---      ---       ---       ---       ---
puts "----------------------------------------------------"
puts "----------------------------------------------------"

set_max_delay 0 -to [all_outputs]

#----------------------------------------------------
#--- F: 1. enforcing total neg-slack
#------ 2. enforcing priority
#--- N: creating multiple paths usually adds alot 
#------ to the compilation time
#---- if apx design should be optimized for:
#------- set which bits should be optimize for

#FROM HERE:
#----- TODO: need to set a variabel that activates the following statements
#----- figure out whether the number of clk gated register effect the optimal baseline
#-------- if no, don't have to change the CLKGATED_BITWIDTH
#-------- just need to activate one the followings to impose priority (only the following 
#-------- not the above if statement
if {$apx_optimal == 1} {
    if {$apx_optimal_mode(first) == 1} {
        puts "optimal first" 
        set_max_delay $msb_1_max_delay -from $msb_1_reg_a_b_c_joined -to $msb_1_reg_d_l
    }
    if {$apx_optimal_mode(second) == 1} {
        puts "optimal second" 
        set_max_delay $msb_2_max_delay -from $msb_2_reg_a_b_c_joined -to $msb_1_reg_d_l
    }
    if {$apx_optimal_mode(third) == 1} {
        set_max_delay $msb_3_max_delay -from $msb_3_reg_a_b_c_joined -to $msb_3_reg_d_l
    }
    if {$apx_optimal_mode(fourth) == 1} {
        set_max_delay $msb_4_max_delay -from $msb_4_reg_a_b_c_joined -to $msb_4_reg_d_l
    }
}

#group_path -name rst_reg_reg -from rst_reg_reg -priority 11


#set_max_delay .26 -from rst_reg_reg 

#foreach_in_collection endpt $inputpoints { set pin [get_object_name $endpt] 
#    puts "hello" 
#    puts $pin   
#    group_path -name $pin -from $pin
#}




#--- compile (symthesize  to gate level and optimize design)
#compile
#compile -map_effort high -area_effort high -power_effort high 
#compile -power_effort high
#compile_ultra
#compile_ultra -timing_high_effort_script -incremental


#set_dp_smartgen_options -mult_radix4 true; #non_booth
#set_dp_smartgen_options -mult_arch benc_radix8
#set_dp_smartgen_options -mult_arch benc_radix8_mux
#set_dp_smartgen_options -mult_arch benc_radix4
#set_dp_smartgen_options -mult_arch benc_radix8
#set_dp_smartgen_options -mult_arch nand_radix4
#set_dp_smartgen_options -mult_arch and_radix4

#compile_ultra -timing_high_effort_script 
#compile_ultra -timing_high_effort_script -incremental
#compile_ultra

#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing.rpt

#---    ---      ---       ---       ---       ---
#report_timing -path full -sort_by slack -nworst 5000000 -max_paths 5000000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#report_timing -path full -sort_by slack -nworst 20000 -max_paths 20000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing_ref.rpt
#report_timing -path full -from $reg_0_4__a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#report_timing -path full -from $reg_4_8__a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#report_timing -path full -from $reg_8_12__a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#report_timing -path full -from $reg_12_16__a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#report_timing -path full -from $reg_16_32__a_b_c_joined -to $all_reg_d_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#---    ---      ---       ---       ---       ---

report_timing -path full > ${REPORTS_DIR}/timing_result.rpt
report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_constrain_violators.rpt
report_cell > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_cells.rpt
report_resources > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_resources.rpt
report_net
#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_qor.rpt
#report 


#--- save the design
#the following generates ddc files 
set syn_name  ${DESIGN_NAME}_${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit

#write -format ddc -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.ddc
#the following generates the gatelevel netlist 
#write -f verilog -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.v
#write_sdc ${RESULTS_DIR}/${syn_name}_synthesized.sdc
#write_sdf ${RESULTS_DIR}/${syn_name}_synthesized.mapped.sdf; #switching activity file


remove_design -hierarchy
exit

