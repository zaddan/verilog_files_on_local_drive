#----------------------------------------------------
#---- Parameters
#----------------------------------------------------
#---- N: the following should be commented out if the tcl file is invoked by 
#-----   a python function
set DATA_PATH_WIDTH 32;
set CLKGATED_BITWIDTH 4; #numebr of apx bits
set clk_period .400
##--- F: apximation
set apx_optimal 0
set apx_optimal_mode(first) 1
set apx_optimal_mode(second) 1
set apx_optimal_mode(third)  1
set apx_optimal_mode(fourth) 1
set msb_1_max_delay .46;#.270 ideally
set msb_2_max_delay .46 ;#.261 ideally
set msb_3_max_delay .46 ;#.249 ideally
set msb_4_max_delay .46 ;#.242 ideally
#----------------------------------------------------
set OP_BITWIDTH $DATA_PATH_WIDTH; #operator bitwidth


#----------------------------------------------------
#--- variables
#----------------------------------------------------
set WDIR "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn"
#~/behzad_local/verilog_files/synthesis
set RTLDIR  "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
#~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports

set DESIGN_NAME conf_int_add__noFF__arch_specific
#set DESIGN_NAME unconfig_int_add

set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
set my_toplevel ${DESIGN_NAME}

#--- libraries
#set lib_dir_1 "/usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib"
#set lib_dir_2 "/home/polaris/behzad/behzad_local/verilog_files/libraries"
set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db"; #technology library
set synth_lib "/usr/local/packages/synopsys_2016/syn/libraries/syn"
set synth_lib_ver "/usr/local/packages/synopsys_2016/syn/dw/sim_ver"
#set lib_dir_3 "/home/polaris/behzad/behzad_local/verilog_files/libraries/FreePDK45/osu_soc/lib/files"
#--- NOTE: I had to include *_rvt as well, cause ow the compiler was erroring out
#set search_path [concat  $search_path $lib_dir_1/stdcell_rvt/db_nldm $lib_dir_1/stdcell_lvt/db_nldm $lib_dir_2/germany_NanGate/db $lib_dir_3]
set search_path [concat  $search_path $lib_dir_3 $synth_lib $synth_lib_ver] 
#--- design dir
set design_dir_addr "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src"
set  std_library  "noAging.db" 
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


#report_synlib dw_foundation.sldb DW01_add > reported_modules_withing_lib.txt 
report_synlib dw_foundation.sldb DW02_mult > reported_modules_withing_lib.txt 
report_synlib dw_foundation.sldb DW02_mac >> reported_modules_withing_lib.txt 
exit

