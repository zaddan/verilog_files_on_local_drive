#----------------------------------------------------
# --- use this to find the best delay profile incrementally //TODO finish this
#     b/c this description doesn't make sense
#----------------------------------------------------
import os
import pylab
from search_for_delay_profile__advanced__helpers import *


#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    
    #---------------------------------------------------- 
    #*** F:DN Parameters 
    #---------------------------------------------------- 
    design_name = "conf_int_mac__noFF__arch_agnos"
    wrapper_module__na = design_name +"__w_wrapper"
    ID = "SFDPA" #best case best sub delay
    clk_period = .7; 
    DATA_PATH_BITWIDTH = 8
    OP_BITWIDTH = DATA_PATH_BITWIDTH 
    CLKGATED_BITWIDTH = 4; #numebr of apx bits
    #-----  -----    -----     -----     -----     -----
    acc_max_delay__upper_limit = .46
    acc_max_delay__lower_limit = .40
    acc_max_delay__upper_limit__initial_value = acc_max_delay__upper_limit 
    #acc_max_delay__c = 10
    #acc_max_delay__step_size = .01; #*** F:DN use the for loop
    attempt__upper_bound = 5
    #-----  -----    -----     -----     -----     -----
    #*** F: CN if you want to focuse on one precision, simply pick the
    #       higher_limit one about lower limit
    precision__lower_limit = 4
    precision__higher_limit = 8
    precision__step_size = 2
    #precision = 30 ;#*** F:AN instead use the for loop
    #.................................................... 
    transition_cells__base_addr = "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/py_src"
    syn__module__na = design_name+"_OP_BITWIDTH"+str(OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(DATA_PATH_BITWIDTH)
    syn__wrapper_module__na = design_name+"__w_wrapper_OP_BITWIDTH"+str(OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(DATA_PATH_BITWIDTH)
    syn__file__na = syn__wrapper_module__na +"__only_clk_cons_synthesized"+str(ID)+".v" # this the wrapper


    #---------------------------------------------------- 
    #*** F:DN Variables
    #---------------------------------------------------- 
    base__dir = "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
    base_to_dump_reports__dir =\
            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/logs_2"
    base_to_dump_results__dir =\
            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
    syn__file__addr = base__dir + "/" + syn__file__na
    timing_per_cell__log__na = "timing_per_cell__log"+str(ID)+".txt"
    timing_per_cell__log__addr = timing_per_cell__log__na
    #*** F: removing the values within the previous transitional cells 
    transitioning_cells__log__na = \
            "transitioning_cells_after_resyn"+str(ID)+".txt"
    none_transitioning_cells__log__na =\
            "none_transitioning_cells_after_resyn" + str(ID) +".txt"
    none_transitioning_cell__log__file_handle = \
            open(none_transitioning_cells__log__na, "w")
    none_transitioning_cell__log__file_handle.close()
    transitioning_cell__log__file_handle = \
            open(transitioning_cells__log__na, "w")
    transitioning_cell__log__file_handle.close()
    #...   ...    ..  ...  ..    ..    ...      ..
    transitioning_cells__log__na = "transitioning_cells"+str(ID)+".txt"
    none_transitioning_cells__log__na = "none_transitioning_cells"+str(ID)+".txt"
    none_transitioning_cell__log__file_handle = \
            open(none_transitioning_cells__log__na, "w")
    none_transitioning_cell__log__file_handle.close()
    transitioning_cell__log__file_handle = \
            open(transitioning_cells__log__na, "w")
    transitioning_cell__log__file_handle.close()
    #...   ...    ..  ...  ..    ..    ...      ..
    old_transitioning_cells__log__na = "old_transitioning_cells"+str(ID)+".txt"
    old_none_transitioning_cells__log__na = "old_none_transitioning_cells"+str(ID)+".txt"
    old_none_transitioning_cell__log__file_handle = \
            open(old_none_transitioning_cells__log__na, "w")
    old_transitioning_cell__log__file_handle = \
            open(old_transitioning_cells__log__na, "w")
    old_transitioning_cell__log__file_handle.close()
    old_none_transitioning_cell__log__file_handle.close()
    #transitioning_cells__log__addr = transitioning_cells__log__na
    #none_transitioning_cells__log__addr = none_transitioning_cells__log__na


    #---------------------------------------------------- 
    #*** F:DN Body
    #---------------------------------------------------- 
    synth_design_with_only_clk_constraint(wrapper_module__na, syn__file__addr, clk_period, \
            DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH,
            base_to_dump_reports__dir, ID)
#        
    
    #*** F:DN hardwire to zero 
    for precision in range(precision__lower_limit, 
            precision__higher_limit, 
            precision__step_size):
        update_transitional_cells(old_transitioning_cells__log__na,
                transitioning_cells__log__na) 
        update_transitional_cells(old_none_transitioning_cells__log__na,
                none_transitioning_cells__log__na) 
        grep_for_and_update_transitional_cells(syn__file__na,
                syn__file__addr, 
                timing_per_cell__log__addr,
                none_transitioning_cells__log__na,
                transitioning_cells__log__na,
                old_transitioning_cells__log__na,
                old_none_transitioning_cells__log__na,
                syn__wrapper_module__na, 
                syn__module__na, 
                clk_period, 
                DATA_PATH_BITWIDTH,
                CLKGATED_BITWIDTH, 
                precision, 
                base_to_dump_reports__dir, 
                ID,
                acc_max_delay)
        
        #*** F:DN resynthesize the design while constraining the paths that goes
        #         through the cells responsible for the none_apx part of the result
        acc_max_delay = acc_max_delay__upper_limit__initial_value
        slack_met = True
        while (True): 
            if (slack_met):
                acc_max_delay__upper_limit = acc_max_delay
            else:
                acc_max_delay__lower_limit = acc_max_delay
                acc_max_delay__upper_limit = best_delay_so_far
            prev__acc_max_delay = acc_max_delay 
            acc_max_delay  = float(acc_max_delay__upper_limit + acc_max_delay__lower_limit)/float(2)
            acc_max_delay =  float("{0:.3f}".format(acc_max_delay)) #up to 2
            if (acc_max_delay__upper_limit == acc_max_delay__lower_limit) or\
                    (prev__acc_max_delay == acc_max_delay):
                break
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
                               
                grep_for_and_update_transitional_cells(\
                        syn__file__na, syn__file__addr,
                        timing_per_cell__log__addr,
                        none_transitioning_cells__log__na,
                        transitioning_cells__log__na,
                        old_transitioning_cells__log__na,
                        old_none_transitioning_cells__log__na,
                        syn__wrapper_module__na, 
                        syn__module__na, clk_period, 
                        DATA_PATH_BITWIDTH,
                        CLKGATED_BITWIDTH, 
                        precision, base_to_dump_reports__dir,
                        ID,
                        acc_max_delay)
                
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
                        ID,
                        acc_max_delay__lower_limit,
                        acc_max_delay__upper_limit,
                        prev__acc_max_delay)
                my_dir =\
                            "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected"
                #*** F:AN this needs to change to add or something later 
                op_type = "mac" 
                #*** F:DN if slack met break 
                file_to_look_for_slack_in = my_dir + "/"+ str(op_type)+"_"+\
                        str(DATA_PATH_BITWIDTH)+\
                        "__clk_"+ str(clk_period)+\
                        "__acc_max_del_"+str(acc_max_delay)+\
                        "__Pn_"+str(precision)+\
                        "__atmpt_"+str(attempt__iter__c)+\
                        "__id_"+str(ID)+ "__evol_log.txt"
                slack_met = parse_file_to_get_slack(file_to_look_for_slack_in)
                if (slack_met):
                    break
                else:
                    best_delay_so_far = parse_file_to_get_best_delay(file_to_look_for_slack_in)
#        transitioning_cells__log__na = "transitioning_cells"+str(ID)+".txt"
#        none_transitioning_cells__log__na = "none_transitioning_cells"+str(ID)+".txt"
#        syn__file__na = syn__wrapper_module__na + \
#                "__only_clk_cons_synthesized"+str(ID)+".v" # this the wrapper
#        syn__file__addr = base__dir + "/" + syn__file__na
 
        #*** F:DN returning files to original 
#        transitioning_cells__log__na = "transitioning_cells"+str(ID)+".txt"
#        none_transitioning_cells__log__na = "none_transitioning_cells"+str(ID)+".txt"
#        syn__file__na = syn__wrapper_module__na + \
#                "__only_clk_cons_synthesized"+str(ID)+".v" # this the wrapper
#        syn__file__addr = base__dir + "/" + syn__file__na

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




