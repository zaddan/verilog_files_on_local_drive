# *** F:DN for getting reports  of a module
# **** F:DN need to copy the file that you are intrested in to mul_to_report.v
# ***  F:DN  make sure the set the design name (in DESIGN_NAME variable)

#----------------------------------------------------
#---- Parameters
#----------------------------------------------------
#set DESIGN_NAME conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32
#set DESIGN_NAME conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH22_DATA_PATH_BITWIDTH32
#set DESIGN_NAME conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32
set DESIGN_NAME idct_BitWidth31_BitWidth130 
#set DESIGN_NAME conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH22_DATA_PATH_BITWIDTH32
#set DESIGN_NAME conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH22_DATA_PATH_BITWIDTH32
#set DESIGN_NAME conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH22_DATA_PATH_BITWIDTH24
#set DESIGN_NAME conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32 
#set DESIGN_NAME  conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH26
#conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32 
#conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH26
#conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH24

set my_toplevel ${DESIGN_NAME}
set design_dir_addr "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/src/v_src"
set synth__file ${design_dir_addr}/mul_to_report.v;#the synthesized verilog file
set DATA_PATH_WIDTH 26;
set clk_period .758
###--- F: apximation
set OP_BITWIDTH $DATA_PATH_WIDTH; #operator bitwidth

#----------------------------------------------------
#--- variables
#----------------------------------------------------
set WDIR "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn"
set RTLDIR  "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/src/v_src"
set REPORTS_DIR ${WDIR}/reports


set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"

#--- libraries
set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
set lib_dir_2 "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries"
set lib_dir_3 "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/"
set search_path [concat  $search_path $lib_dir_3]
#--- design dir
set  std_library  "1.2V_75T.db"
#set  std_library  "noAging.db"

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

read_file  $synth__file -autoread -top $my_toplevel
check_design

#set endpoints [add_to_collection [all_outputs] [all_registers -data_pins]]
#--- linking to libraries
link

create_clock -name clk -period $clk_period [get_ports clk]
set_ideal_network -no_propagate [get_ports clk]
set_dont_touch_network [get_clocks clk]
#set_input_delay  -max  .55 -clock clk  [get_ports d_internal__acc*]
set_input_delay -max 0 -clock clk [get_ports * -filter "direction == in"] 
#echo "helo"

foreach_in_collection my_el [get_cells -hierarchical] {
    set cell_name [get_object_name $my_el] 
    #*** F:AN make sure you set the limit properly 
    echo "cell_name: " $cell_name >> "cell__na.txt"
    #report_timing -through $cell_name/* -path end >> $output__timing__log__na
}
set_max_delay .758 -to [all_outputs]
report_timing -path full -significant_digits 4 > ${REPORTS_DIR}/timing_result.rpt
#report_timing -sort_by slack -through [get_object_name [get_pins -of_objects [get_object_name [get_cells -hierarchical -filter "full_name == mul__inst__apx"]]  -filter "direction == in"]]  -significant_digits 4 >> ${REPORTS_DIR}/timing_result.rpt
#report_timing -path full -through d_internal__apx* -significant_digits 4 > ${REPORTS_DIR}/timing_result.rpt
report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_area.rpt
report_power > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_power.rpt
report_constraint -all_violators > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_constrain_violators.rpt
report_cell > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_cells.rpt
report_resources > ${REPORTS_DIR}/${DESIGN_NAME}__${OP_BITWIDTH}Bit_${DATA_PATH_WIDTH}Bit_resources.rpt
write -f verilog -hierarchy -output ${REPORTS_DIR}/dot.v
report_net

remove_design -hierarchy
exit

