puts "doesn' make sense to have no flip flop b/c of timing"
exit

set BWAC 1

#set WDIR /home/unga/sglee/Share/ac_hw_syn
set WDIR ~/behzad_local/verilog_files/synthesis
set RTLDIR ~/behzad_local/verilog_files/apx_operators/int_ops_apx
set REPORTS_DIR ${WDIR}/reports
set DESIGN_NAME mul_acc_ff

set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt

set search_path "${RTLDIR}"

#/* Top-level Module     */
set my_toplevel mul_acc_ff

set lib_dir /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib
set search_path [concat  $search_path   $lib_dir/stdcell_rvt/db_nldm]

source ${WDIR}/lib_list.txt

# Added on 4/20/2015
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false

set AC_NAME mul_acc_ff
#if {$m == 0} {
#  set AC_NAME float_mul
#} elseif {$m == 1} {
#  set AC_NAME btm
#} elseif {$m == 2} {
#  set AC_NAME etm
#} else {
#  set AC_NAME btm_trunc
#}

set std_library "saed32rvt_tt1p05v25c.db"
set target_library "$std_library" 
set link_library "$std_library" 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"
#set hdlin_enable_vpp true

#read_file -format verilog loa.v 
#read_file -format verilog -define DC_PARAM${BWAC} ${DESIGN_NAME}.v 
#analyze -format verilog ${AC_NAME}.v 

#WARNING: NAB should always be only zero
for { set NAB 0}  {$NAB <1 } {incr NAB 1} {
    analyze -format verilog [list mul_acc_out_ff.v mul_acc.v] 
    elaborate $my_toplevel 
    #current_design $my_toplevel
    link
    check_design
    #create_clock -name clk -period .1 -waveform {0 0.5} [get_ports clk]
    create_clock -name clk -period 4.5 [get_ports clk]
    set_ideal_network -no_propagate [get_ports clk]
    set_ideal_network -no_propagate [get_ports clk]
    set_input_delay -max 0 -clock clk [get_ports a*]                                          
    set_input_delay -max 0 -clock clk [get_ports b*]     
    set_dont_touch_network [get_clocks clk]

    #compile -area_effort low -power_effort low -map_effort low -exact_map
    #compile_ultra 
    saif_map -start                                                                
    read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/int_ops_apx/DUT.saif -instance test_bench_tb/acc_mul -verbose 
    compile -power_effort high


    write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.ddc
    write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.v
    write_sdc ${RESULTS_DIR}/${DESIGN_NAME}.sdc
    #
    report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_timing.rpt
    report_area -hierarchy -nosplit > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_area.rpt
    
    report_power -analysis_effort high 
    report_power > ${REPORTS_DIR}/int_${DESIGN_NAME}_${NAB}_power.rpt

    remove_design -hierarchy
}
