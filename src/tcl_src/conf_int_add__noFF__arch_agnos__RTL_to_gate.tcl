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
set DATA_PATH_WIDTH 32;
set CLKGATED_BITWIDTH 4; #numebr of apx bits
set clk_period 210;#.220;#.230;#.240
##--- F: apximation
set apx_optimal 1
set apx_optimal_mode(first) 1
set apx_optimal_mode(second) 1
set apx_optimal_mode(third)  1
set apx_optimal_mode(fourth) 1
set msb_1_max_delay .19;#.2;#.209;#.218
set msb_2_max_delay .175;#.183;#.191 ;#.2
set msb_3_max_delay .161;#.169;#.176 ;#.184
set msb_4_max_delay .140;#.149;#.153 ;#.160
#----------------------------------------------------
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


set DESIGN_NAME conf_int_add__noFF__arch_agnos
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
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"
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


#for { set NAB 0}  {$NAB < 1} {incr NAB 1} {

#set enable_keep_signal_dt_net true
#set enable_keep_signal true
#--- read the design 
#analyze -format verilog [list  ${design_dir_addr}/ripple_carry_adder.v ${design_dir_addr}/unconfig_int_add.v ${design_dir_addr}/acc_int_add.v ]
#analyze -format verilog [list  ${design_dir_addr}/unconfig_int_add.v]
analyze -format verilog [list  ${design_dir_addr}/${DESIGN_NAME}.v]
elaborate $my_toplevel -parameters $OP_BITWIDTH,$DATA_PATH_WIDTH
#${design_dir_addr}/ripple_carry_adder.v] ;# this one is for a simple unstructured example
#elaborate $my_toplevel 

check_design


#--- define design environement (setting up the design environment such as external operating conditions (manufacturing process, temperature, and voltage), loads, drives, fanouts, and wire load models)


set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]


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


#set_max_delay .2 -from {reg_b_reg[16] reg_b_reg[17] reg_b_reg[18] reg_b_reg[19] reg_b_reg[20] reg_b_reg[21] reg_b_reg[22] reg_b_reg[23] reg_b_reg[24] reg_b_reg[25] reg_b_reg[26] reg_b_reg[27] reg_b_reg[28] reg_b_reg[29] reg_b_reg[30] reg_b_reg[31] reg_a_reg[16] reg_a_reg[17] reg_a_reg[18] reg_a_reg[19] reg_a_reg[20] reg_a_reg[21] reg_a_reg[22] reg_a_reg[23] reg_a_reg[24] reg_a_reg[25] reg_a_reg[26] reg_a_reg[27] reg_a_reg[28] reg_a_reg[29] reg_a_reg[30] reg_a_reg[31]} -to {reg_c_reg[16] reg_c_reg[17] reg_c_reg[18] reg_c_reg[19] reg_c_reg[20] reg_c_reg[21] reg_c_reg[22] reg_c_reg[23] reg_c_reg[24] reg_c_reg[25] reg_c_reg[26] reg_c_reg[27] reg_c_reg[28] reg_c_reg[29] reg_c_reg[30] reg_c_reg[31]}


#set_max_delay .15 -from {b[16] b[17] b[18] b[19] b[20] b[21] b[22] b[23] b[24] b[25] b[26] b[27] b[28] b[29] b[30] b[31] a[16] a[17] a[18] a[19] a[20] a[21] a[22] a[23] a[24] a[25] a[26] a[27] a[28] a[29] a[30] a[31]} -to {c[16] c[17] c[18] c[19] c[20] c[21] c[22] c[23] c[24] c[25] c[26] c[27] c[28] c[29] c[30] c[31]}

set all_reg_a_l [make-reg_l "a" 0 $DATA_PATH_WIDTH]
set all_reg_b_l [make-reg_l "b" 0 $DATA_PATH_WIDTH]
set all_reg_c_l [make-reg_l "c" 0 $DATA_PATH_WIDTH]
set all_reg_a_b_joined [concat $all_reg_a_l $all_reg_b_l]

set lsb_bits 4
#$CLKGATED_BITWIDTH
set msb_bits [expr $DATA_PATH_WIDTH - $lsb_bits]
#----------------------------------------------------


#----------------------------------------------------
#--- lab_1 ,1 means the superclass
set lsb_1_reg_a_l [make-reg_l "a" 0 $lsb_bits]
set lsb_1_reg_b_l [make-reg_l "b" 0 $lsb_bits]
set lsb_1_reg_c_l [make-reg_l "c" 0 $lsb_bits]
set lsb_1_reg_a_b_joined [concat $lsb_1_reg_a_l $lsb_1_reg_b_l]

set msb_1_reg_a_l [make-reg_l "a" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_b_l [make-reg_l "b" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_c_l [make-reg_l "c" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_a_b_joined [concat $msb_1_reg_a_l $msb_1_reg_b_l]


set lsb_2_reg_a_l [make-reg_l "a" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_b_l [make-reg_l "b" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_c_l [make-reg_l "c" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_a_b_joined [concat $lsb_2_reg_a_l $lsb_2_reg_b_l]

set msb_2_reg_a_l [make-reg_l "a" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_b_l [make-reg_l "b" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_c_l [make-reg_l "c" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_a_b_joined [concat $msb_2_reg_a_l $msb_2_reg_b_l]


set lsb_3_reg_a_l [make-reg_l "a" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_b_l [make-reg_l "b" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_c_l [make-reg_l "c" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_a_b_joined [concat $lsb_3_reg_a_l $lsb_3_reg_b_l]

set msb_3_reg_a_l [make-reg_l "a" [expr $lsb_bits + 8]  $DATA_PATH_WIDTH]
set msb_3_reg_b_l [make-reg_l "b" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_c_l [make-reg_l "c" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_a_b_joined [concat $msb_3_reg_a_l $msb_3_reg_b_l]


set lsb_4_reg_a_l [make-reg_l "a" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_b_l [make-reg_l "b" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_c_l [make-reg_l "c" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_a_b_joined [concat $lsb_4_reg_a_l $lsb_4_reg_b_l]

set msb_4_reg_a_l [make-reg_l "a" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
set msb_4_reg_b_l [make-reg_l "b" [expr $lsb_bits + 12]  $DATA_PATH_WIDTH]
set msb_4_reg_c_l [make-reg_l "c" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
set msb_4_reg_a_b_joined [concat $msb_4_reg_a_l $msb_4_reg_b_l]

puts "^^^^^^^^^^^^^^^^^^^^^"
puts "msb_1_reg_a_b_joined"
puts $msb_1_reg_a_b_joined
puts "--------------"
puts "msb_2_reg_a_b_joined"
puts $msb_2_reg_a_b_joined
puts "--------------"
puts "msb_3_reg_a_b_joined"
puts  "msb_3_reg_a_b_joined"
puts $msb_3_reg_c_l
puts $msb_3_reg_a_b_joined
puts "--------------"
puts "msb_4_reg_a_b_joined"
puts $msb_4_reg_a_b_joined
puts "--------------"

#---    ---      ---       ---       ---       ---
set reg_0_4__a [make-reg_l "a" 0 [expr 0 + $lsb_bits]]
set reg_0_4__b [make-reg_l "b" 0 [expr 0 + $lsb_bits]]
set reg_0_4__a_b_joined [concat $reg_0_4__b $reg_0_4__a]

set reg_4_8__a [make-reg_l "a" $lsb_bits [expr $lsb_bits+4]]
set reg_4_8__b [make-reg_l "b" $lsb_bits [expr $lsb_bits+4]]
set reg_4_8__a_b_joined [concat $reg_4_8__b $reg_4_8__a]

set reg_8_12__a [make-reg_l "a" [expr $lsb_bits+4] [expr $lsb_bits+8]] 
set reg_8_12__b [make-reg_l "b"  [expr $lsb_bits+4] [expr $lsb_bits+8]]
set reg_8_12__a_b_joined [concat $reg_8_12__b $reg_8_12__a]

set reg_12_16__a [make-reg_l "a"  [expr $lsb_bits+8] [expr $lsb_bits+12]]
set reg_12_16__b [make-reg_l "b" [expr $lsb_bits+8] [expr $lsb_bits+12]]
set reg_12_16__a_b_joined [concat $reg_12_16__b $reg_12_16__a]

set reg_16_32__a [make-reg_l "a"  [expr $lsb_bits+12] [expr $lsb_bits+28]]
set reg_16_32__b [make-reg_l "b" [expr $lsb_bits+12] [expr $lsb_bits+28]]
set reg_16_32__a_b_joined [concat $reg_16_32__b $reg_16_32__a]

puts $reg_0_4__a_b_joined
puts $reg_4_8__a_b_joined
puts $reg_8_12__a_b_joined
puts $reg_12_16__a_b_joined
puts $reg_16_32__a_b_joined
#---    ---      ---       ---       ---       ---

set_max_delay $clk_period -from $all_reg_a_b_joined -to $all_reg_c_l 
#----------------------------------------------------
#--- F: 1. enforcing total neg-slack
#------ 2. enforcing priority
#--- N: creating multiple paths usually adds alot 
#------ to the compilation time
#---- if apx design should be optimized for:
#------- set which bits should be optimize for
if {$apx_optimal == 1} {
    #--- F: decide which bits to prioritize 
    if {$apx_optimal_mode(first) == 1} {
       set priority_array  $lsb_1_reg_a_b_joined 
    } elseif { $apx_optimal_mode(second) == 1} {
       set priority_array  $lsb_2_reg_a_b_joined 
    } elseif { $apx_optimal_mode(third) == 1} {
       set priority_array  $lsb_3_reg_a_b_joined 
    } elseif { $apx_optimal_mode(fourth) == 1} {
       set priority_array  $lsb_4_reg_a_b_joined 
    }  
    
    foreach pt $all_reg_a_b_joined { 
        puts $pt   
        if {[lsearch -exact $priority_array $pt] >= 0} {
            group_path -name lsb -from $pt -critical_range 0.5 -priority 2 -weight 2
        } else {
            group_path -name msb -from $pt -critical_range 0.5 -priority 5 -weight 5
        }
    }
} else {
    #group_path -name clk -from clk -critical_range 0.5 -priority 100 -weight 100
    group_path -name clk -from clk
}

#FROM HERE:
#----- TODO: need to set a variabel that activates the following statements
#----- figure out whether the number of clk gated register effect the optimal baseline
#-------- if no, don't have to change the CLKGATED_BITWIDTH
#-------- just need to activate one the followings to impose priority (only the following 
#-------- not the above if statement
if {$apx_optimal == 1} {
    if {$apx_optimal_mode(first) == 1} {
        puts "optimal first" 
        set_max_delay $msb_1_max_delay -from $msb_1_reg_a_b_joined -to $msb_1_reg_c_l
    }
    if {$apx_optimal_mode(second) == 1} {
        puts "optimal second" 
        set_max_delay $msb_2_max_delay -from $msb_2_reg_a_b_joined -to $msb_1_reg_c_l
    }
    if {$apx_optimal_mode(third) == 1} {
        set_max_delay $msb_3_max_delay -from $msb_3_reg_a_b_joined -to $msb_3_reg_c_l
    }
    if {$apx_optimal_mode(fourth) == 1} {
        set_max_delay $msb_4_max_delay -from $msb_4_reg_a_b_joined -to $msb_4_reg_c_l
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
#set_dp_smartgen_options -all_options false -carry_select_adder_cell true
compile_ultra -timing_high_effort_script 
compile_ultra -timing_high_effort_script -incremental
#compile_ultra

#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing.rpt

#---    ---      ---       ---       ---       ---
report_timing -path full -sort_by slack -nworst 20000 -max_paths 20000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing_ref.rpt
report_timing -path full -from $reg_0_4__a_b_joined -to $all_reg_c_l -sort_by slack -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
report_timing -path full -from $reg_4_8__a_b_joined -to $all_reg_c_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
report_timing -path full -from $reg_8_12__a_b_joined -to $all_reg_c_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
report_timing -path full -from $reg_12_16__a_b_joined -to $all_reg_c_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
report_timing -path full -from $reg_16_32__a_b_joined -to $all_reg_c_l -sort_by slack -significant_digits 4 >>  ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_timing.rpt
#---    ---      ---       ---       ---       ---

#report_timing -path full -sort_by slack -from  $input_list -max_path 100 -nworst 2 >  ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing1.rpt
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

write -format ddc -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.ddc
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${syn_name}_synthesized.v
write_sdc ${RESULTS_DIR}/${syn_name}_synthesized.sdc
write_sdf ${RESULTS_DIR}/${syn_name}_synthesized.mapped.sdf; #switching activity file


remove_design -hierarchy
exit

