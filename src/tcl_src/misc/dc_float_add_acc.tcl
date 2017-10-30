#this file uses the switching activity to get power
set BWAC 1
#set WDIR /home/unga/sglee/Share/ac_hw_syn
set WDIR ~/behzad_local/verilog_files/synthesis
set RTLDIR ~/behzad_local/verilog_files/fpu_dawsongon/adder
set REPORTS_DIR ${WDIR}/reports
set DESIGN_NAME adder
set RESULTS_DIR ${WDIR}/results
set DCRM_FINAL_TIMING_REPORT timing.rpt
set DCRM_FINAL_AREA_REPORT area.rpt
set DCRM_FINAL_POWER_REPORT power.rpt
set search_path "${RTLDIR}"
#/* Top-level Module     */
set my_toplevel ${DESIGN_NAME}
set lib_dir /usr/local/packages/synopsys_32.28_07292013/SAED32_EDK/lib
set search_path [concat  $search_path   $lib_dir/stdcell_rvt/db_nldm]
source ${WDIR}/lib_list.txt
set compile_delete_unloaded_sequential_cells false
set compile_seqmap_propagate_constants false
set compile_enable_register_merging false
set compile_seqmap_enable_output_inversion false
set AC_NAME adder
set std_library "saed32rvt_tt1p05v25c.db"
set target_library "$std_library" 
set link_library "$std_library" 
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"
#set hdlin_enable_vpp true


for { set NAB 0}  {$NAB < 1} {incr NAB 1} {
    analyze -format verilog [list adder.v]
    elaborate $my_toplevel -update
    link
    #enable power calculation 
    saif_map -start 
    #set_power_prediction 
    create_clock -name clk -period 1 -waveform {0 .5} [get_ports clk]
    set_ideal_network -no_propagate [get_ports clk]
    set_input_delay -max 0 -clock clk [get_ports input_a]                                          
    set_input_delay -max 0 -clock clk [get_ports input_b]     
    set_dont_touch_network [get_clocks clk]


    #compile -area_effort low -power_effort low -map_effort low -exact_map
    #compile_ultra  
    #compile_ultra -no_autoungroup 
    compile -power_effort high
    #compile_ultra -gate_clock 
    compile_ultra 
    write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.ddc
    write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.v
    write_sdc ${RESULTS_DIR}/${DESIGN_NAME}.sdc
    
    #
    #read_ddc ${RESULTS_DIR}/${DESIGN_NAME}.ddc
    read_saif -auto_map_names -input ~/behzad_local/verilog_files/apx_operators/float_ops_apx/DUT.saif -instance test_bench_tb/adder_39759952_acc -verbose 
    
    report_timing -sort_by slack -input_pins -capacitance -transition_time -nets -significant_digits 4 -nosplit -nworst 1 -max_paths 1 > ${REPORTS_DIR}/${DESIGN_NAME}_${NAB}_timing.rpt
    report_area -hierarchy -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}_${NAB}_area.rpt
    report_power -analysis_effort high
    report_power > ${REPORTS_DIR}/${DESIGN_NAME}_${NAB}_power.rpt

    remove_design -hierarchy
}
