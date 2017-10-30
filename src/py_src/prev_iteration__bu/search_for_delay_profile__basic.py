#----------------------------------------------------
# --- use this file for sweeping the clock and also imposing of different
# constrains on various bits 
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
    ID = "SWB" #basic sweeper
    #clk_period = .46; #*** F:AN use the value in the for loop
    clk__upper_limit = .48
    clk__lower_limit = .675
    clk_values__c = 20    #*** F:DN this value determines how many clk values
                          #         you want to have in an equidistance fashion
                          #         between the upper and lower limits
    DATA_PATH_BITWIDTH = 32
    OP_BITWIDTH = DATA_PATH_BITWIDTH 
    CLKGATED_BITWIDTH = 4; #numebr of apx bits
    apx_optimal = 1
    lsb_bits = 3
    msb_min_delay = 0;#.55;#.59;#.58
    #Pn = 24
    #acc_max_delay__upper_limit = .46;#.57;#.61;#.62;
    #acc_max_delay__lower_limit__delta = .1
    slow_down = .5
    #-----  -----    -----     -----     -----     -----
    acc_max_delay__lower_limit = .6
    #acc_max_delay__upper_limit = clk_period/(1+slow_down); #*** F:DN use for loop
    acc_max_delay__c = 10
    #acc_max_delay__step_size = .01; #*** F:DN use the for loop
    attempt__upper_bound = 4
    #-----  -----    -----     -----     -----     -----
    precision__lower_limit = 26
    precision__higher_limit = 32
    precision__step_size = 2
    #acc_max_delay__upper_limit  = float("{0:.2f}".format(acc_max_delay__upper_limit)) #up to 2
    #precision = 28 ;#*** F:AN instead use the for loop
    #.................................................... 
    transition_cells__base_addr = "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/py_src"
    syn__module__na = design_name+"_OP_BITWIDTH"+str(OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(DATA_PATH_BITWIDTH)
    syn__wrapper_module__na = design_name+"__w_wrapper_OP_BITWIDTH"+str(OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(DATA_PATH_BITWIDTH)
    syn__file__na = syn__wrapper_module__na +"__only_clk_cons_synthesized"+str(ID)+".v" # this the wrapper


    #---------------------------------------------------- 
    #*** F:DN Variables
    #---------------------------------------------------- 
    clk__step_size = (clk__upper_limit - clk__lower_limit)/float(clk_values__c)
    clk__step_size =  float("{0:.3f}".format(clk__step_size)) #up to 2
    base__dir = "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
    base_to_dump_reports__dir =\
            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/logs_2"
    base_to_dump_results__dir =\
            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
    syn__file__addr = base__dir + "/" + syn__file__na
    timing_per_cell__log__na = "timing_per_cell__log"+str(ID)+".txt"
    transitioning_cells__log__na = "transitioning_cells"+str(ID)+".txt"
    none_transitioning_cells__log__na = "none_transitioning_cells"+str(ID)+".txt"
    timing_per_cell__log__addr = timing_per_cell__log__na
    #transitioning_cells__log__addr = transitioning_cells__log__na
    #none_transitioning_cells__log__addr = none_transitioning_cells__log__na


    #---------------------------------------------------- 
    #*** F:DN Body
    #---------------------------------------------------- 
    for clk__el in pylab.frange(clk__lower_limit,\
            clk__upper_limit, clk__step_size):
        #****F: DN variables 
        clk_period = clk__el 
        acc_max_delay__upper_limit = clk_period
#        acc_max_delay__step_size = (acc_max_delay__upper_limit - \
#                acc_max_delay__lower_limit)/float(acc_max_delay__c)
        acc_max_delay__step_size = .001
        acc_max_delay__step_size = \
                float("{0:.3f}".format(acc_max_delay__step_size)) #up to 2
        
        #*** F:DN synthesize the design with clk constraint
        synth_design_with_only_clk_constraint(wrapper_module__na, syn__file__addr, clk_period, \
                DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH,
                base_to_dump_reports__dir, ID)
#        
        precision__step_size = 1
        for precision in range(precision__lower_limit, precision__higher_limit,\
                precision__step_size):
            #*** F:DN hardwire to zero 
            grep_for_transitional_cells(syn__file__na, syn__file__addr, timing_per_cell__log__addr,\
                    none_transitioning_cells__log__na,\
                    transitioning_cells__log__na,\
                    syn__wrapper_module__na, syn__module__na, clk_period, DATA_PATH_BITWIDTH,\
                    CLKGATED_BITWIDTH, precision, base_to_dump_reports__dir, ID)
            #*** F:DN resynthesize the design while constraining the paths that goes
            #         through the cells responsible for the none_apx part of the result
            acc_max_delay__step_size = .001
            for acc_max_delay__el in pylab.frange(acc_max_delay__lower_limit, \
                    acc_max_delay__upper_limit, acc_max_delay__step_size):
                acc_max_delay = acc_max_delay__el
                #*** F:DN iterate for multiple time to see if we achieve 
                #         the desired acc_max_delay
                for attempt__iter__c in range(0,
                        attempt__upper_bound): 
                    read_and_cons_transitional_cells_and_resyn(\
                            syn__file__na,
                            syn__wrapper_module__na, transition_cells__base_addr,
                            transitioning_cells__log__na, precision, clk_period, 
                            DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, acc_max_delay,
                            base_to_dump_reports__dir,
                            base_to_dump_results__dir,
                            attempt__iter__c,
                            ID)
                    #*** F:DN hardwire to zero 
                    syn__file__na = syn__wrapper_module__na +\
                            "__only_clk_cons_resynthesized" + str(ID) +".v" # this the wrapper
                    syn__file__addr = base__dir + "/" + syn__file__na
                    transitioning_cells__log__na = \
                            "transitioning_cells_after_resyn"+str(ID)+".txt"
                    none_transitioning_cells__log__na =\
                            "none_transitioning_cells_after_resyn" + str(ID) +".txt"
                    grep_for_transitional_cells(\
                            syn__file__na, syn__file__addr,
                            timing_per_cell__log__addr,
                            none_transitioning_cells__log__na,
                            transitioning_cells__log__na,
                            syn__wrapper_module__na, 
                            syn__module__na, clk_period, 
                            DATA_PATH_BITWIDTH,
                            CLKGATED_BITWIDTH, 
                            precision, base_to_dump_reports__dir,
                            ID)
                    read_and_cons_transitional_cells_and_report_timing(\
                            syn__file__na,
                            syn__wrapper_module__na, 
                            transition_cells__base_addr,
                            transitioning_cells__log__na,
                            precision, clk_period, 
                            DATA_PATH_BITWIDTH, 
                            CLKGATED_BITWIDTH, 
                            acc_max_delay,
                            base_to_dump_reports__dir,
                            attempt__iter__c, 
                            ID)
                #*** F:DN returning files to original 
                transitioning_cells__log__na = "transitioning_cells"+str(ID)+".txt"
                none_transitioning_cells__log__na = "none_transitioning_cells"+str(ID)+".txt"
                syn__file__na = syn__wrapper_module__na + \
                        "__only_clk_cons_synthesized"+str(ID)+".v" # this the wrapper
                syn__file__addr = base__dir + "/" + syn__file__na
    
#----------------------------------------------------
#--- F: Main
#----------------------------------------------------
main()



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
#*** F:DN hardwire the bits that will be approimxated (by modifying the 
#         synthesized design
def hardwire_apx_bits_to_zero_old(sourceFileAddr, DATA_PATH_BITWIDTH, precision):
    #*** F:DN Variables 
    modified_syn__file__addr = sourceFileAddr
    original_syn_copy__file__addr = sourceFileAddr+"_temp"
    os.system("cp " + sourceFileAddr + " " + original_syn_copy__file__addr) 
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False, False, False, False, False] #if satisfied modify the file
    done_modifiying = False
    next_line_modify = False 
    apx_bit__c = DATA_PATH_BITWIDTH - precision 
    #*** F:DN Body
    #*** F:DN parse the file 
    try:
        f = open(original_syn_copy__file__addr)
    except IOError:
        handleIOError(original_syn_copy__file__addr, "csource file")
        exit()
    else:
        found_one = False
        line_nu = 0
        f = open(original_syn_copy__file__addr)
        with f:
            for line in f:
                line_nu +=1
                word_list =   line.strip().replace(',', ' ').replace('/','').replace(';', ' ').split(' ') 
                if "module conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BITWIDTH32" in line:
                    condition[0] = True
                if ("input" in line) and ("[31:0]" in line)  and \
                        ("a" in line) and condition[0] == True:
                            modified__line = "input [" + str(precision - 1)+":0] a; \n"
                            condition[1] = True
                elif ("input" in line) and ("[31:0]" in line) and \
                        ("b" in line) and (condition[0] == True):
                            modified__line = "input [" + str(precision - 1)+":0] b;\n" 
                            condition[2] = True
                elif ("input" in line) and ("[31:0]" in line) and \
                        ("c" in line) and (condition[0] == True):
                            c_length = 32 - (2 * (32 - precision)) 
                            modified__line = "input [" + str(c_length - 1)+":0] c;\n" 
                            condition[3] = True
                elif "conf_int_mac__noFF__arch_agnos_OP_BITWIDTH32_DATA_PATH_BITWIDTH32_1"\
                        in line and not("module" in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False 
                    apx_bit__c = DATA_PATH_BITWIDTH - precision 
                    modified__line = ".clk(clk), .rst(n1)," + \
                            ".a("+ "{a,"+str(apx_bit__c)+"\'b0})," + \
                            ".b("+ "{b,"+ str(apx_bit__c)+"\'b0})," + \
                            ".c("+ "{c,"+ str(2*apx_bit__c)+"\'b0})," + \
                            ".d(d) );"
                    condition[4] = True 
                else:
                    modified__line = line
                
               
                if (done_modifiying): 
                    modified_syn__file__handle.write(line)
                else:
                    modified_syn__file__handle.write(modified__line)
                
                if (condition[0] and condition[1] and condition[2] and \
                        condition[3] and condition[4] and \
                        (not(done_modifiying))):
                    done_modifiying = True

    
    modified_syn__file__handle.close()




