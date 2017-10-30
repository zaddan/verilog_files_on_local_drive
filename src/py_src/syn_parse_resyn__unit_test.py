#----------------------------------------------------
# --- use this file for sweeping the clock and also imposing of different
# constrains on various bits 
#----------------------------------------------------
import os
import pylab


#----------------------------------------------------
#----------------------------------------------------
#*** F:DN reponsible for syntheszing the design of interest with the clk of 
#          interest. The only constraint (on all paths) is the clk itself
def synth_design_with_only_clk_constraint(design_name, clk_period, \
        DATA_PATH_WIDTH, CLKGATED_BITWIDTH):
    
    #----------------------------------------------------
    #--- F:DN Variables
    #----------------------------------------------------
    tcl_parametrs = "set clk_period " + str(clk_period) + ";set DATA_PATH_WIDTH \
            "+str(DATA_PATH_WIDTH) + ";set CLKGATED_BITWIDTH "
    
    synthesis__output__file__na = design_name + "_" + \
            str(clk_period) + "_"+ \
            str(DATA_PATH_WIDTH) +"_"+ \
            str(CLKGATED_BITWIDTH) + \
            "__only_clk_contraint__synth_log.txt"

    only_clk_cons_syn__log__addr = "only_clk_cons_syn__log.txt"
    #----------------------------------------------------
    #--- F:DN Body
    #----------------------------------------------------
    tcl_file_name =  design_name+"__only_clk_cons__RTL_to_gate.tcl"
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >" + synthesis__output__file__na)
    os.system("cp " + synthesis__output__file__na + " " +\
            only_clk_cons_syn__log__addr)


#*** F:DN hardwire the bits that will be approimxated (by modifying the 
#         synthesized design
def hardwire_apx_bits_to_zero(sourceFileAddr, module_name, DATA_PATH_WIDTH, precision):
   
    #*** F:DN Variables 
    modified_syn__file__addr = sourceFileAddr
    original_syn_copy__file__addr = sourceFileAddr+"_temp"
    os.system("cp " + sourceFileAddr + " " + original_syn_copy__file__addr) 
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False]
    done_modifiying = False
    next_line_modify = False 
   

    #*** F:DN Body
    #*** F:DN parse the file 
    try:
        f = open(original_syn_copy__file__addr)
    except IOError:
        handleIOError(original_syn_copy__file__addr, "csource file")
        exit()
    else:
        f = open(original_syn_copy__file__addr)
        with f:
            for line in f:
                #*** F:AN this is very specific to the module itself and will
                #         change for other modules (e.g an adder)
                if module_name in line \
                        in line and not("module" in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False 
                    apx_bit__c = DATA_PATH_WIDTH - precision 
                    modified__line = ".clk(clk), .rst(n1)," + \
                            ".a("+ "{a["+str(DATA_PATH_WIDTH-1)+":"+ str(32 - \
                            precision)+ "],"+ str(apx_bit__c)+"\'b0})," + \
                            ".b("+ "{b["+str(DATA_PATH_WIDTH-1)+":"+ str(32 - \
                            precision)+ "],"+ str(apx_bit__c)+"\'b0})," + \
                            ".c("+ "{c["+str(DATA_PATH_WIDTH-1)+":"+ str(2*apx_bit__c)\
                                    + "],"+ str(2*apx_bit__c)+"\'b0})," + \
                            ".d(d) );"
                    condition[0] = True 
                else:
                    modified__line = line
                

                if (done_modifiying): 
                    modified_syn__file__handle.write(line)
                else:
                    modified_syn__file__handle.write(modified__line)
                
                if (condition[0] and (not(done_modifiying))):
                    done_modifiying = True

    
    modified_syn__file__handle.close()


#*** F:DN find all the cells and find the delay "-though" them. This allows
#          us to identify those cells that actually contribute to the non_apx
#          part of the result (this is b/c the paths that don't transition
#          generat a "no path" signal in the timing report
def find_delay_through_each_cell(timing_per_cell__log__addr, syn__file__na, wrapper_module__na, \
        clk_period, DATA_PATH_WIDTH, CLKGATED_BITWIDTH, precision):
    
    #*** F:DN Parameters 
    tcl_file__na =  "../tcl_src/find_delay_through_each_cell.tcl"
    
    #*** F:DN Variables 
    tcl_parametrs = "set clk_period " + str(clk_period) + ";" + \
            "set DATA_PATH_WIDTH "+str(DATA_PATH_WIDTH) + ";" + \
            "set CLKGATED_BITWIDTH " + str(CLKGATED_BITWIDTH) + ";" + \
            "set DESIGN_NAME " + wrapper_module__na + ";" + \
            "set synth_file__na " + syn__file__na + ";" + \
            "set output__timing__log__na " + timing_per_cell__log__addr + ";"
    
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file__na +" >" + \
            "find_delay_through_each_cell__log.txt") 


#*** F:DN same as the name 
def find_transitioning_cells(timing_per_cell__log__addr,\
        transitioning_cells__log__addr, none_transitioning_cells__log__addr):
    #*** F:DN Variables 
    transitioning_cell__log__file_handle = open(transitioning_cells__log__addr, "w")
    none_transitioning_cell__log__file_handle = open(none_transitioning_cells__log__addr, "w")
    look_for_delay__p = False
    all_cells__l = []
    transitioning_cells__l = []
    none_transitioning_cells__l = []

    #*** F:DN Body
    #*** F:DN parse the file 
    try:
        f = open(timing_per_cell__log__addr)
    except IOError:
        handleIOError(timing_per_cell__log__addr, "csource file")
        exit()
    else:
        with f:
            for line in f:
                word_list =   line.strip().replace(',', ' ').replace(';', ' ').split(' ') 
                if "No paths." in line:
                    transitioning_cells__l.remove(current_cell_to_work_on) 
                    none_transitioning_cells__l.append(current_cell_to_work_on)
                if "cell_name:" in word_list:
                    current_cell_to_work_on = word_list[-1]
                    all_cells__l.append(current_cell_to_work_on) 
                    transitioning_cells__l.append(current_cell_to_work_on)
                    
                    
    for cell__na in transitioning_cells__l: 
        transitioning_cell__log__file_handle.write(cell__na + " ")
    
    for cell__na in none_transitioning_cells__l: 
        none_transitioning_cell__log__file_handle.write(cell__na + " ")
    
    transitioning_cell__log__file_handle.close()
    none_transitioning_cell__log__file_handle.close()



#*** F:DN resynthesize the design while constraining the paths that goes
#         through the cells responsible for the non_apx part of the result
def set_const_for_transition_cells_and_resyn_and_time(syn__file__na,\
            wrapper_module__na, transition_cells__base_addr,
            transitioning_cells__log__na, precision, clk_period, \
            DATA_PATH_WIDTH, CLKGATED_BITWIDTH, acc_max_delay):
    
    #*** F:DN variabes 
    tcl_parametrs = "set clk_period " + str(clk_period) + ";" + \
            "set DATA_PATH_WIDTH "+str(DATA_PATH_WIDTH) + ";" + \
            "set CLKGATED_BITWIDTH "  +str(CLKGATED_BITWIDTH) + ";" + \
            "set DESIGN_NAME " + wrapper_module__na + ";" + \
            "set synth_file__na " + syn__file__na  + ";" + \
            "set transition_cells__base_addr  " +  transition_cells__base_addr+ ";" \
            "set transitioning_cells__log__na " +  transitioning_cells__log__na + " ;" \
            "set Pn " + str(precision) + ";" + \
            "set acc_max_delay " + str(acc_max_delay)+ ";" 

    read_and_resyn__log = "read_and_resyn__log.txt"
    
    
    #----------------------------------------------------
    #--- F: Body
    #----------------------------------------------------
    tcl_file_name =  "read_and_resyn.tcl"
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >" + read_and_resyn__log)



#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    
    #---------------------------------------------------- 
    #*** F:DN Parameters 
    #---------------------------------------------------- 
    design_name = "conf_int_mac__noFF__arch_agnos"
    #clk_period = .46; #*** F:AN use the value in the for loop
    clk__upper_limit = .69
    clk__lower_limit = .69
    clk_values__c = 5    #*** F:DN this value determines how many clk values
                          #         you want to have in an equidistance fashion
                          #         between the upper and lower limits
     
    DATA_PATH_WIDTH = 32
    CLKGATED_BITWIDTH = 4; #numebr of apx bits
    apx_optimal = 1
    lsb_bits = 3
    msb_min_delay = 0;#.55;#.59;#.58
    #Pn = 24
    #acc_max_delay__upper_limit = .46;#.57;#.61;#.62;
    #acc_max_delay__lower_limit__delta = .1
    slow_down = .5
    #-----  -----    -----     -----     -----     -----
    acc_max_delay__lower_limit = .55
    #acc_max_delay__upper_limit = clk_period/(1+slow_down); #*** F:DN use for loop
    acc_max_delay__c = 10
    #acc_max_delay__step_size = .01; #*** F:DN use the for loop
    #-----  -----    -----     -----     -----     -----
    precision__lower_limit = 28
    precision__higher_limit = 29
    precision__step_size = 1
    #acc_max_delay__upper_limit  = float("{0:.2f}".format(acc_max_delay__upper_limit)) #up to 2
    #precision = 28 ;#*** F:AN instead use the for loop
    #.................................................... 
    transition_cells__base_addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/src/py_src"
    module__na = "conf_int_mac__noFF__arch_agnos_OP_BITWIDTH32_DATA_PATH_BITWIDTH32"
    syn__file__na = "conf_int_mac__noFF__arch_agnos__w_wrapper_32Bit_32Bit__only_clk_cons_synthesized.v"
    wrapper_module__na = \
    "conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BITWIDTH32" # this the wrapper


    #---------------------------------------------------- 
    #*** F:DN Variables
    #---------------------------------------------------- 
    #clk__step_size = (clk__upper_limit - clk__lower_limit)/clk_values__c
    clk__step_size = .01
    clk__step_size =  float("{0:.2f}".format(clk__step_size)) #up to 2
    base__dir = "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
    syn__file__addr = base__dir + "/" + syn__file__na
    timing_per_cell__log__na = "timing_per_cell__log.txt"
    transitioning_cells__log__na = "transitioning_cells.txt"
    none_transitioning_cells__log__na = "none_transitioning_cells.txt"
    timing_per_cell__log__addr = timing_per_cell__log__na
    transitioning_cells__log__addr = transitioning_cells__log__na
    none_transitioning_cells__log__addr = none_transitioning_cells__log__na


    #---------------------------------------------------- 
    #*** F:DN Body
    #---------------------------------------------------- 
    #*** F:DN synthesize the design with clk constraint
    for clk__el in pylab.frange(clk__lower_limit,\
            clk__upper_limit, clk__step_size):
        #---------------------------------------------------- 
        #****F: DN variables 
        clk_period = clk__el 
        acc_max_delay__upper_limit = .55
#        acc_max_delay__step_size = (acc_max_delay__upper_limit - \
#                acc_max_delay__lower_limit)/acc_max_delay__c
        acc_max_delay__step_size = .01
        acc_max_delay__step_size = \
                float("{0:.2f}".format(acc_max_delay__step_size)) #up to 2
        #----------------------------------------------------
        synth_design_with_only_clk_constraint(design_name, clk_period, \
                DATA_PATH_WIDTH, CLKGATED_BITWIDTH)
        os.system("cp  " + syn__file__addr + " " + syn__file__addr+"_original_synthesis") 

        
        #*** F:DN hardwire to zero 
        for precision in range(precision__lower_limit, precision__higher_limit,\
                precision__step_size):
            os.system("cp  " + syn__file__addr+"_original_synthesis"  + " " + syn__file__addr) 
            hardwire_apx_bits_to_zero(syn__file__addr, module__na, DATA_PATH_WIDTH, precision);
            
            #*** F:DN find cells responsible for the none_apx part of the result
            find_delay_through_each_cell(timing_per_cell__log__addr, syn__file__na, wrapper_module__na, \
                    clk_period, DATA_PATH_WIDTH, CLKGATED_BITWIDTH, precision);
            find_transitioning_cells(timing_per_cell__log__addr,\
                    transitioning_cells__log__addr, none_transitioning_cells__log__addr)
            
            #*** F:DN returning the synthesized file to it's original (un hardwired) 
            os.system("cp  " + syn__file__addr +"_original_synthesis" + " " + syn__file__addr) 
            
            #*** F:DN resynthesize the design while constraining the paths that goes
            #         through the cells responsible for the none_apx part of the result
            for acc_max_delay__el in pylab.frange(acc_max_delay__lower_limit, \
                    acc_max_delay__upper_limit, acc_max_delay__step_size):
                #acc_max_delay = .42
                acc_max_delay = acc_max_delay__el
                set_const_for_transition_cells_and_resyn_and_time(syn__file__na,\
                        wrapper_module__na, transition_cells__base_addr,\
                        transitioning_cells__log__na, precision, clk_period, \
                        DATA_PATH_WIDTH, CLKGATED_BITWIDTH, acc_max_delay)
                
    """
    for precision__el in range(precision_lower_limit, precision_higher_limit):
        for acc_max_delay__el in pylab.frange(acc_max_delay__lower_limit,\
                acc_max_delay__upper_limit, acc_max_delay__step_size):
            run_tool_chain(design_name, clk_period, DATA_PATH_WIDTH, CLKGATED_BITWIDTH,
                    apx_optimal, lsb_bits, acc_max_delay__el, msb_min_delay,
                    precision__el, slow_down)
    """
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
def hardwire_apx_bits_to_zero_old(sourceFileAddr, DATA_PATH_WIDTH, precision):
    #*** F:DN Variables 
    modified_syn__file__addr = sourceFileAddr
    original_syn_copy__file__addr = sourceFileAddr+"_temp"
    os.system("cp " + sourceFileAddr + " " + original_syn_copy__file__addr) 
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False, False, False, False, False] #if satisfied modify the file
    done_modifiying = False
    next_line_modify = False 
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
                    apx_bit__c = DATA_PATH_WIDTH - precision 
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




