#----------------------------------------------------
# --- use this file for sweeping the clock and also imposing of different
# constrains on various bits 
#----------------------------------------------------

import os
import pylab


#----------------------------------------------------
#--- F: Parameters:
#----------------------------------------------------
#----------------------------------------------------
#--- F: Helpers
#----------------------------------------------------
def dummy():
    print "".join(map(lambda x: str(x), apx_optimal_mode.values())), "::" , msb_1_max_delay, " ", msb_2_max_delay, " ", msb_3_max_delay, " " ,msb_4_max_delay

#print tcl_parametrs
#----------------------------------------------------

#----------------------------------------------------
#--- F: run_tool_chain
#----------------------------------------------------
#def run_tool_chain():
#    dummy()

 
def run_tool_chain(design_name, clk_period, DATA_PATH_WIDTH, CLKGATED_BITWIDTH,
        apx_optimal, lsb_bits, msb_max_delay, msb_min_delay, Pn, slow_down):
    
    #----------------------------------------------------
    #--- F: Variables
    #----------------------------------------------------
    output__file__na=design_name+"__"+str(DATA_PATH_WIDTH)+"bits_clkP"+str(clk_period)+"_apx"\
            +str(apx_optimal)+ "_" \
            +"msb_max_delay"+str(msb_max_delay)+ "Pn"+str(Pn) +"slow_down"+\
            str(slow_down)+".txt"

    tcl_parametrs = "set clk_period " + str(clk_period) + ";set DATA_PATH_WIDTH \
            "+str(DATA_PATH_WIDTH) + ";set CLKGATED_BITWIDTH "+\
            str(CLKGATED_BITWIDTH) + ";set apx_optimal  "+str(apx_optimal)\
            + ";set msb_max_delay "+ str(msb_max_delay) + ";set lsb_bits  " +\
            str(lsb_bits) + " \
            " +  ";set msb_min_delay " + str(msb_min_delay) + ";set Pn " +\
            str(Pn) 
    
    
    #----------------------------------------------------
    #--- F: Body
    #----------------------------------------------------
    os.system("echo ---- RUN DC >> " + output__file__na)
#    os.system("dc_shell-t  -x \"set DATA_PATH_WIDTH 32; set clk_period 0.01\" \
#            -f ../tcl_src/conf-int-add-clkGate__RTL-to-Gate.tcl >>" + output__file__na)
    
    tcl_file_name =  design_name+"__RTL_to_gate.tcl"
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >>" + output__file__na)
#    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + \
#            " -f ../tcl_src/unconf-test.tcl >>" + output__file__na)
#    print "dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" \
#            + " -f ../tcl_src/conf-int-add-clkGate__RTL-to-Gate.tcl" 
    os.system("cp result_log.txt  " + output__file__na)
    """ 
    os.system("echo ---- REG INFO >> " + output__file__na)
    os.system("python conf__get_reg_info.py " + str(DATA_PATH_WIDTH)+" " + \
    design_name+"__"+str(DATA_PATH_WIDTH)+"Bit_"+str(DATA_PATH_WIDTH)+"Bit_timing.rpt\
    " + " >> "+ output__file__na)
    os.system("echo ---- TIMING REPORT >> " + output__file__na)
    os.system("cat ../../build/syn/reports/"+design_name+"__"+str(DATA_PATH_WIDTH)+"Bit_"+str(DATA_PATH_WIDTH)+"Bit_timing.rpt >> " + output__file__na)
    """
    os.system("mv " + output__file__na + " ../../build/syn/reports/data_collected/")
#----------------------------------------------------
#----------------------------------------------------


#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    design_name = "conf_int_mac__noFF__general"
    clk_period = .65;#.55;#.63;#.68;#.7
    DATA_PATH_WIDTH = 32
    CLKGATED_BITWIDTH = 4; #numebr of apx bits
    apx_optimal = 1
    lsb_bits = 3
    msb_min_delay = 0;#.55;#.59;#.58
    #Pn = 24
    #msb_max_delay__upper_limit = .46;#.57;#.61;#.62;
    #msb_max_delay__lower_limit__delta = .1
    
    slow_down = .5
    #-----  -----    -----     -----     -----     -----
    msb_max_delay__upper_limit = clk_period/(1+slow_down);#.57;#.61;#.62;
    msb_max_delay__lower_limit = .36
    msb_max_delay__step_size = .01;#.57;#.61;#.62;
    #-----  -----    -----     -----     -----     -----
    precision_lower_limit = 25
    precision_higher_limit = 28
    
    msb_max_delay__upper_limit  = float("{0:.2f}".format(msb_max_delay__upper_limit)) #up to 2
    for precision__el in range(precision_lower_limit, precision_higher_limit):
        for msb_max_delay__el in pylab.frange(msb_max_delay__lower_limit,\
                msb_max_delay__upper_limit, msb_max_delay__step_size):
            run_tool_chain(design_name, clk_period, DATA_PATH_WIDTH, CLKGATED_BITWIDTH,
                    apx_optimal, lsb_bits, msb_max_delay__el, msb_min_delay,
                    precision__el, slow_down)
#----------------------------------------------------
#--- F: Main
#----------------------------------------------------
main()
