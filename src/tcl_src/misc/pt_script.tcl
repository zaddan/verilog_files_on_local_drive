####################################################
# Dongwook Lee, 05/30/2013
####################################################
#gui_start
set power_enable_analysis TRUE
set power_analysis_mode time_based
set_app_var link_library /home/polaris/dlee/.local/synopsys_db/NangateOpenCellLibrary.db 
read_verilog ../synth/gate/first_counter-final.v -hdl_compiler 
current_design first_counter
set design first_counter
link_design -keep_sub_designs
read_vcd -strip_path tb/U_counter counter.vcd
set_power_analysis_options -waveform_interval 5 -waveform_format out -waveform_output pwr1
update_power
report_power -verbose -hierarchy > power_report.rpt
exit
