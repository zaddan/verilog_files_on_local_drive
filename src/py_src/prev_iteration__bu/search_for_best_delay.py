#----------------------------------------------------
# --- use this file for sweeping the clock to find the best
#     delay associated with a a design (of different Precision)
#     e.g best delay as/w 32x32 or 30x30 
#----------------------------------------------------
import os
import pylab
from search_for_delay_profile__helpers import *


#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    
    #---------------------------------------------------- 
    #*** F:DN Parameters 
    #---------------------------------------------------- 
    design_name = "conf_int_mac__noFF__arch_agnos"
    wrapper_module__na = design_name +"__w_wrapper"
    #clk_period = .46; #*** F:AN use the value in the for loop
    clk__upper_limit = .455#.450
    clk__lower_limit = .425
    clk__upper_limit__initial_value = clk__upper_limit 
    #clk_values__c = 2    #*** F:DN this value determines how many clk values
                          #         you want to have in an equidistance fashion
                          #         between the upper and lower limits
    DATA_PATH_BITWIDTH__lower_bound = 30
    DATA_PATH_BITWIDTH__upper_bound = 32
    #DATA_PATH_BITWIDTH = 32
    DATA_PATH_BITWIDTH__step_size = 1 
    CLKGATED_BITWIDTH = 4; #numebr of apx bits
    attempt__upper_bound = 4
    ID = "SCBD" #finding base(S) case(C) best(B) delay(D)
    #-----  -----    -----     -----     -----     -----
    
    #---------------------------------------------------- 
    #*** F:DN Variables
    #---------------------------------------------------- 
    #clk__step_size = -(clk__upper_limit - clk__lower_limit)/float(clk_values__c)
    #clk__step_size =  float("{0:.3f}".format(clk__step_size)) #up to 2
    base__dir = "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
    base_to_dump_reports__dir =\
            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/logs_2"
    base_to_dump_results__dir =\
            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"


    #---------------------------------------------------- 
    #*** F:DN Body
    #---------------------------------------------------- 
    #*** F:DN synthesize the design with clk constraint
    for DATA_PATH_BITWIDTH in range (\
            DATA_PATH_BITWIDTH__lower_bound,
            DATA_PATH_BITWIDTH__upper_bound,
            DATA_PATH_BITWIDTH__step_size):
        OP_BITWIDTH = DATA_PATH_BITWIDTH 
        syn__module__na = design_name+"_OP_BITWIDTH"+str(OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(DATA_PATH_BITWIDTH)
        syn__wrapper_module__na = design_name+"__w_wrapper_OP_BITWIDTH"+str(OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(DATA_PATH_BITWIDTH)
        syn__file__na = syn__wrapper_module__na +"__only_clk_cons_synthesized"+str(ID)+".v" # this the wrapper
        syn__file__addr = base__dir + "/" + syn__file__na
        
        clk__el = clk__upper_limit__initial_value
        slack_met = True
        #*** F:DN initial synthesis 
        clk_period = clk__el 
        synth_design_with_only_clk_constraint(\
                wrapper_module__na, 
                syn__file__addr, 
                clk_period, 
                DATA_PATH_BITWIDTH,
                CLKGATED_BITWIDTH,
                base_to_dump_reports__dir, 
                ID)
        
        while (True): 
            if (slack_met):
                clk__upper_limit = clk__el
            else:
                clk__lower_limit = clk__el
                #clk__upper_limit = best_delay_so_far
            prev__clk = clk__el  #recording the previous clk
            clk__el = float(clk__upper_limit + clk__lower_limit)/float(2)
            clk__el =  float("{0:.3f}".format(clk__el)) #up to 2
            #*** F:DN if two clks has reached each other or
            #         the clk hasn't changed in two cycles, break (1)
            if (clk__upper_limit == clk__lower_limit) or (prev__clk == clk__el):
                break
            clk_period = clk__el 
            for attempt__iter__c in range(0, attempt__upper_bound): 
                read_resyn_and_report(\
                        syn__file__na,
                        syn__wrapper_module__na, 
                        clk_period, 
                        DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, 
                        base_to_dump_reports__dir,
                        base_to_dump_results__dir,
                        attempt__iter__c,
                        clk__upper_limit,
                        clk__lower_limit,
                        prev__clk,
                        ID)
                
                my_dir =\
                        "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected"
                #*** F:AN this needs to change to add or something later 
                op_type = "mac" 
                #*** F:DN if slack met break 
                file_to_look_for_slack_in = my_dir + "/"+ str(op_type)+"_"+\
                        str(DATA_PATH_BITWIDTH)+"__clk_"+\
                        str(clk_period)+"__atmpt_"+str(attempt__iter__c)+\
                        "__id_"+str(ID)+ "__evol_log.txt"
                slack_met = parse_file_to_get_slack(file_to_look_for_slack_in)
                if (slack_met):
                    break
                else:
                    best_delay_so_far = parse_file_to_get_best_delay(file_to_look_for_slack_in)
                syn__file__na = syn__wrapper_module__na +\
                        "__only_clk_cons_resynthesized" + str(ID) +".v" # this the wrapper
                syn__file__addr = base__dir + "/" + syn__file__na
            

#----------------------------------------------------
#--- F: Main
#----------------------------------------------------
main()


#----------------------------------------------------
#--- F: Issues
#----------------------------------------------------
# (1) I have notices that sometimes when I am looking for a low clk(T0)
# it won't meet, but it'll meet a clk that is fairly close(T1) and 
# when I change the lower bound and try to look for the new clk(T2) (which 
# say is higher than the "fairly close(T1)" clock, it won't meet the "new
# clk(T2)". This is why, you should look inside all the log files to see
#           whether you can find a clk that was lower than the latest clk found
# **** F:AN: Issue (1) is why, you should look inside all the log files to see
#           whether you can find a clk that was lower than the latest clk found



#----------------------------------------------------
#--- F: Notes
#----------------------------------------------------
#*** (1) the reason that the clks might not ever reach each other
#        is b/c of rounding. Rounding might cause the avg to never
#        actually pull up a clk (or down) to the other
