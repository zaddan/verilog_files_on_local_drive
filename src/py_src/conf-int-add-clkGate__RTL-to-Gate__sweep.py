import os
import pylab
#----------------------------------------------------
#--- F: Parameters:
#----------------------------------------------------
DATA_PATH_WIDTH = 32
CLKGATED_BITWIDTH = 1
clk_period  = .283
apx_optimal = 1
global apx_optimal_mode
apx_optimal_mode = {}
apx_optimal_mode[0] = 1
apx_optimal_mode[1] = 1
apx_optimal_mode[2] = 0
apx_optimal_mode[3] =  1
msb_1_max_delay_optimal = .270
msb_2_max_delay_optimal = .265
msb_3_max_delay_optimal = .265
msb_4_max_delay_optimal = .260

global msb_1_max_delay 
global msb_2_max_delay 
global msb_3_max_delay 
global msb_4_max_delay 

msb_1_max_delay = 0
msb_2_max_delay = 1
msb_3_max_delay = 2
msb_4_max_delay = 3

#apx_optimal_mode_l =['1000','1100','1110','1111','0100','0110','0111','0010','0011','0001']
#apx_optimal_mode_l =['0100','0110','0111','0010','0011','0001']
apx_optimal_mode_l =['1000', '0100','0010','0001']
#apx_optimal_mode_l =['0100']
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
def run_tool_chain():
    global msb_1_max_delay 
    global msb_2_max_delay 
    global msb_3_max_delay 
    global msb_4_max_delay 
    global apx_optimal_mode
    #----------------------------------------------------
    #--- F: Variables
    #----------------------------------------------------
    output__file__na="clk_gate_design__clkP"+str(clk_period)+"_apx"+str(apx_optimal)+"_apxM"+ "".join(map(str, apx_optimal_mode.values()))+"_"+str(msb_1_max_delay)+str(msb_2_max_delay)+str(msb_3_max_delay)+str(msb_4_max_delay)+".txt"

    tcl_parametrs = "set clk_period " + str(clk_period) + ";set DATA_PATH_WIDTH "+str(DATA_PATH_WIDTH) + ";set CLKGATED_BITWIDTH "+str(CLKGATED_BITWIDTH) + ";set apx_optimal  "+str(apx_optimal) + ";set apx_optimal_mode(first) " + \
    str(apx_optimal_mode[0]) + ";set apx_optimal_mode(second) " + \
    str(apx_optimal_mode[1]) + ";set apx_optimal_mode(third) " + \
    str(apx_optimal_mode[2]) + ";set apx_optimal_mode(fourth) " \
    +str(apx_optimal_mode[3]) + ";set msb_1_max_delay "+str(msb_1_max_delay) + ";set msb_2_max_delay  "+str(msb_2_max_delay) + ";set msb_3_max_delay "+str(msb_3_max_delay) + ";set msb_4_max_delay "+str(msb_4_max_delay)
    #----------------------------------------------------
    #--- F: Body
    #----------------------------------------------------
    os.system("echo ---- RUN DC >> " + output__file__na)
    #os.system("dc_shell-t  -x \"set DATA_PATH_WIDTH 32; set clk_period 0.01\" -f ../tcl_src/conf-int-add-clkGate__RTL-to-Gate.tcl >>" + output__file__na)
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f ../tcl_src/conf-int-add-clkGate__RTL-to-Gate.tcl >>" + output__file__na)

    #print "dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f ../tcl_src/conf-int-add-clkGate__RTL-to-Gate.tcl" 

    os.system("cat parameter_log.txt >> " + output__file__na)
    os.system("echo ---- REG INFO >> " + output__file__na)
    os.system("python get_reg_info.py >> "+ output__file__na)
    os.system("echo ---- TIMING REPORT >> " + output__file__na)
    os.system("cat ../../build/syn/reports/config_int_add_clkGate_1clkGatedBits_timing.rpt >>" + output__file__na)
    os.system("mv " + output__file__na + " ../../build/syn/reports/data_collected/")

#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    global msb_1_max_delay 
    global msb_2_max_delay 
    global msb_3_max_delay 
    global msb_4_max_delay 
    global apx_optimal_mode

    for apx_optimal_mode_el in apx_optimal_mode_l:
        print "-----------------" 
        temp = list(apx_optimal_mode_el)
        apx_optimal_mode[0] = int(temp[0])
        apx_optimal_mode[1] = int(temp[1])
        apx_optimal_mode[2] = int(temp[2])
        apx_optimal_mode[3] = int(temp[3])
       

        for msb_1_max_delay_el in pylab.frange(msb_1_max_delay_optimal - .1,\
                msb_1_max_delay_optimal + .005, .005):
            msb_1_max_delay = msb_1_max_delay_el
            for msb_2_max_delay_el in pylab.frange(msb_2_max_delay_optimal - \
                    .1, msb_2_max_delay_optimal + .005, .005):
                if (apx_optimal_mode[1] == 0) and not(apx_optimal_mode[0] == 0) :
                    run_tool_chain() 
                    break
                msb_2_max_delay = msb_2_max_delay_el
                for msb_3_max_delay_el in pylab.frange(msb_3_max_delay_optimal \
                        - .1, msb_3_max_delay_optimal + .008, .005):
                    if (apx_optimal_mode[2] == 0) and not(apx_optimal_mode[1] == 0) :
                        run_tool_chain() 
                        break
                    msb_3_max_delay = msb_3_max_delay_el
                    for msb_4_max_delay_el in \
                    pylab.frange(msb_4_max_delay_optimal - .1, \
                            msb_4_max_delay_optimal + .005, .005):
                        if (apx_optimal_mode[3] == 0) and not(apx_optimal_mode[2] == 0) :
                            run_tool_chain() 
                            break
                        msb_4_max_delay = msb_4_max_delay_el
                        run_tool_chain()
                        if(apx_optimal_mode[3] == 0):
                            break
                    if(apx_optimal_mode[2] == 0):
                        break
                if(apx_optimal_mode[1] == 0):
                    break
            if(apx_optimal_mode[0] == 0):
                break

main()
