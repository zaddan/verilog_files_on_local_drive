#---- making a list of register using reg_na (regname) and reg_lower_bound and reg_up_bound
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
#---- uncomment the following when you want to set these values manually
set DATA_PATH_WIDTH 20
set CLKGATED_BITWIDTH 1; #numebr of apx bits
set clk_period 0
##
###---- apximation
set apx_optimal 0
set apx_optimal_mode(first) 0
set apx_optimal_mode(second) 1
set apx_optimal_mode(third)  0
set apx_optimal_mode(fourth) 0
set msb_1_max_delay 0;#.270 ideally
set msb_2_max_delay .110 ;#.261 ideally
set msb_3_max_delay .249 ;#.249 ideally
set msb_4_max_delay 0 ;#.242 ideally
#
#
#--- F: printing the parameters
set parameter_log [open "parameter_log.txt" w]
puts $parameter_log "--- TCL'S PARAMETER INFO"
puts $parameter_log [concat "DATA_PATH_WIDTH:" $DATA_PATH_WIDTH]
puts $parameter_log [concat "CLKGATED_BITWIDTH:" $CLKGATED_BITWIDTH] 
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
#---- F: Variables
#----------------------------------------------------
set BWAC 1
#set WDIR /home/unga/sglee/Share/ac_hw_syn
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports
set DESIGN_NAME config_int_add_clkGate
set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
#/* Top-level Module     */
set my_toplevel ${DESIGN_NAME}
#set lib_dir /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/FreePDK45/osu_soc/lib/files"

#--- NOTE: I had to include *_rvt as well, cause ow the compiler was erroring out
set search_path [concat  $search_path $lib_dir_1/stdcell_rvt/db_nldm $lib_dir_1/stdcell_lvt/db_nldm $lib_dir_2/germany_NanGate/db $lib_dir_3]
#set search_path [concat $search_path $lib_dir_2/germany_NanGate/db]

set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"

#source ${WDIR}/lib_list.txt
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false

set AC_NAME config_int_add_clkGate

#--- specifying libraries 
#set std_library "saed32rvt_tt1p05v25c.db"
#set std_library "saed32lvt_tt1p05v25c.db"; #the best(amon lvts)
set  std_library  "noAging.db" 
#set std_library "gscl45nm.db"; #PDK45 themselves


set target_library "$std_library" 
set link_library "$std_library" 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"
#----------------------------------------------------

#----------------------------------------------------
#---- F: Body
#----------------------------------------------------
#--- read the design 
analyze -format verilog [list ${design_dir_addr}/config_int_add_clkGate.v ${design_dir_addr}/acc_int_add.v]
elaborate $my_toplevel -parameters $DATA_PATH_WIDTH,$CLKGATED_BITWIDTH
check_design

#--- define design environement (setting up the design environment such as external operating conditions (manufacturing process, temperature, and voltage), loads, drives, fanouts, and wire load models)


set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]
set inputpoints [add_to_collection [all_inputs] [all_registers -data_pins]]

#--- linking to libraries
link


#saif_map -start 

#--- set the optimization constraints 
create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_input_delay -max 0 -clock clk [get_ports b*]     
set_input_delay -max 0 -clock clk [get_ports a*]     
set_input_delay -max 0 -clock clk [get_ports reg_en]     
set_dont_touch_network [get_clocks clk]

#--- enable clock propagation of the related clocks

#--- design rule constraints 
#set_max_area 0'


#foreach_in_collection endpt $endpoints { set pin [get_object_name $endpt] 
#    puts "hello" 
#    puts $pin   
#    group_path -name $pin -to $pin
#}

set all_reg_a_l [make-reg_l "reg_a_reg" 0 $DATA_PATH_WIDTH]
set all_reg_b_l [make-reg_l "reg_b_reg" 0 $DATA_PATH_WIDTH]
set all_reg_c_l [make-reg_l "reg_c_reg" 0 $DATA_PATH_WIDTH]
set all_reg_a_b_joined [concat $all_reg_a_l $all_reg_b_l]

set lsb_bits 4
#$CLKGATED_BITWIDTH
set msb_bits [expr $DATA_PATH_WIDTH - $lsb_bits]
#----------------------------------------------------


#----------------------------------------------------
#--- lab_1 ,1 means the superclass
set lsb_1_reg_a_l [make-reg_l "reg_a_reg" 0 $lsb_bits]
set lsb_1_reg_b_l [make-reg_l "reg_b_reg" 0 $lsb_bits]
set lsb_1_reg_c_l [make-reg_l "reg_c_reg" 0 $lsb_bits]
set lsb_1_reg_a_b_joined [concat $lsb_1_reg_a_l $lsb_1_reg_b_l]

set msb_1_reg_a_l [make-reg_l "reg_a_reg" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_b_l [make-reg_l "reg_b_reg" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_c_l [make-reg_l "reg_c_reg" $lsb_bits $DATA_PATH_WIDTH]
set msb_1_reg_a_b_joined [concat $msb_1_reg_a_l $msb_1_reg_b_l]


set lsb_2_reg_a_l [make-reg_l "reg_a_reg" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_b_l [make-reg_l "reg_b_reg" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_c_l [make-reg_l "reg_c_reg" 0 [expr $lsb_bits + 4]]
set lsb_2_reg_a_b_joined [concat $lsb_2_reg_a_l $lsb_2_reg_b_l]

set msb_2_reg_a_l [make-reg_l "reg_a_reg" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_b_l [make-reg_l "reg_b_reg" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_c_l [make-reg_l "reg_c_reg" [expr $lsb_bits + 4] $DATA_PATH_WIDTH]
set msb_2_reg_a_b_joined [concat $msb_2_reg_a_l $msb_2_reg_b_l]


set lsb_3_reg_a_l [make-reg_l "reg_a_reg" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_b_l [make-reg_l "reg_b_reg" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_c_l [make-reg_l "reg_c_reg" 0 [expr $lsb_bits + 8]]
set lsb_3_reg_a_b_joined [concat $lsb_3_reg_a_l $lsb_3_reg_b_l]

set msb_3_reg_a_l [make-reg_l "reg_a_reg" [expr $lsb_bits + 8]  $DATA_PATH_WIDTH]
set msb_3_reg_b_l [make-reg_l "reg_b_reg" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_c_l [make-reg_l "reg_c_reg" [expr $lsb_bits + 8] $DATA_PATH_WIDTH]
set msb_3_reg_a_b_joined [concat $msb_3_reg_a_l $msb_3_reg_b_l]


set lsb_4_reg_a_l [make-reg_l "reg_a_reg" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_b_l [make-reg_l "reg_b_reg" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_c_l [make-reg_l "reg_c_reg" 0 [expr $lsb_bits + 12]]
set lsb_4_reg_a_b_joined [concat $lsb_4_reg_a_l $lsb_4_reg_b_l]

set msb_4_reg_a_l [make-reg_l "reg_a_reg" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
set msb_4_reg_b_l [make-reg_l "reg_b_reg" [expr $lsb_bits + 12]  $DATA_PATH_WIDTH]
set msb_4_reg_c_l [make-reg_l "reg_c_reg" [expr $lsb_bits + 12] $DATA_PATH_WIDTH]
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
            group_path -name msb -from $pt -critical_range 0.5 -priority 4 -weight 4
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


#power_cg_derive_related_clock true 
#--- compile (symthesize adn optimize design)
#compile
#compile -area_effort high -power_effort high 
#compile -power_effort high

#clock gating
#compile_ultra -area_high_effort_script
set_clock_gating_style  -sequential_cell none -positive_edge_logic {inv nand inv} -neg {inv nor}
set_host_options -max_cores 5
compile_ultra -timing_high_effort_script -gate_clock 
compile_ultra -timing_high_effort_script -incremental -gate_clock 

#compile_ultra -area_high_effort_script -gate_clock 
#compile_ultra -timing_high_effort_script -gate_clock 

#compile_ultra

check_design
#read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_adder_u -verbose 

#--- analyze adn resolve design problems
#report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${CLKGATED_BITWIDTH}_timing.rpt
report_timing -path full -sort_by slack -nworst 1000000 -max_paths 1000000 -significant_digits 4 >  ${REPORTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_timing.rpt
#report_timing -path full -sort_by slack -from  $input_list -max_path 100 -nworst 2 >  ${REPORTS_DIR}/int_${DESIGN_NAME}_${CLKGATED_BITWIDTH}_timing1.rpt


report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_constrain_violators.rpt
report_path_group > ${REPORTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_path_groups.rpt
report_clock_gating > ${REPORTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_clkGating.rpt


#report_qor > ${REPORTS_DIR}/int_${DESIGN_NAME}_${CLKGATED_BITWIDTH}_qor.rpt
#report 


#--- save the design
#the following generates ddc files 
write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_synthesized.ddc 
#the following generates the gatelevel netlist 
write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}clkGatedBits_synthesized.v
write_sdc ${RESULTS_DIR}/${DESIGN_NAME}_synthesized_${CLKGATED_BITWIDTH}clkGatedBits.sdc
write_sdf ${RESULTS_DIR}/${DESIGN_NAME}_${CLKGATED_BITWIDTH}Bit_synthesized.mapped.sdf; #switching activity file




remove_design -hierarchy 
exit
#}
