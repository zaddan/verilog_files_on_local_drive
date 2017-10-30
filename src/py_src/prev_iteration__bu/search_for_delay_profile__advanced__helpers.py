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
def synth_design_with_only_clk_constraint(wrapper_module__na, syn__file__addr, clk_period, \
        DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, base_to_dump_reports__dir, ID):
    
    #----------------------------------------------------
    #--- F:DN Variables
    #----------------------------------------------------
    tcl_parametrs = "set clk_period " + str(clk_period) + ";set DATA_PATH_BITWIDTH \
            "+str(DATA_PATH_BITWIDTH) + ";set CLKGATED_BITWIDTH " + \
            str(CLKGATED_BITWIDTH) + "; set ID " + str(ID) + ";"
    
    
    #*** F:AN for now just use mac in the name 
#    synthesis__output__file__na = base_to_dump_reports__dir +\
#            "/"+wrapper_module__na+ "_" + \
#            str(clk_period) + "_"+ \
#            str(DATA_PATH_BITWIDTH) +"_"+ \
#            str(CLKGATED_BITWIDTH) + \
#            "__only_clk_contraint__synth_log.txt"
    
    synthesis__output__file__na = base_to_dump_reports__dir +\
            "/"+"mac"+ "_" + \
            str(DATA_PATH_BITWIDTH)+"__"+\
            "clk" + "_"+ str(clk_period) + "__"+ \
            "id"+"_"+str(ID)+"__"+\
            "only_clk_contraint__synth_log.txt"
    only_clk_cons_syn__log__addr = "only_clk_cons_syn__log.txt"

    #----------------------------------------------------
    #--- F:DN Body (running tcl file and archiving)
    #----------------------------------------------------
    setup_info =  "clk:"+str(clk_period) +"\n"
    setup_info +=  "DATA_PATH_BITWIDTH:"+str(DATA_PATH_BITWIDTH) +"\n"
    os.system("echo \" " + setup_info + " \" > " + synthesis__output__file__na)
    tcl_file_name =  wrapper_module__na+"__only_clk_cons__RTL_to_gate.tcl"
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >> " + synthesis__output__file__na)
    os.system("echo starting dot_v file  >> " + synthesis__output__file__na)
    os.system("cat " + syn__file__addr + " >> " + synthesis__output__file__na)


#*** F:DN hardwire the bits that will be approimxated (by modifying the 
#         synthesized design
def hardwire_apx_bits_to_zero(sourceFileAddr, wrapper_module__na, module_name, DATA_PATH_BITWIDTH, precision):
   
    #*** F:DN Variables 
    modified_syn__file__addr = sourceFileAddr
    original_syn_copy__file__addr = sourceFileAddr+"_temp"
    os.system("cp " + sourceFileAddr + " " + original_syn_copy__file__addr) 
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False]
    done_modifiying = False
    next_line_modify = False 
    ignore = False #*** F:DN ignoring certain lines
    apx_bit__c = DATA_PATH_BITWIDTH - precision 
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
                if (wrapper_module__na in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False 
                    modified__line = "clk, rst, a_in, b_in, c_in, d );\n"
                    modified__line += " input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c)+":0]a_in;\n"
                    modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c)+":0]b_in;\n"
                    modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                            2*apx_bit__c)+":0]c_in;\n"
                    modified__line += "wire ["+str(DATA_PATH_BITWIDTH-1) +":0]a;\n"
                    modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]b;\n"
                    modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]c;\n"
                    modified__line += "assign a = {a_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n" 
                    modified__line += "assign b = {b_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n" 
                    modified__line += "assign c = {c_in["+\
                            str(DATA_PATH_BITWIDTH - 2*apx_bit__c)+":0],"+ str(2*apx_bit__c)\
                            +"\'b0};\n" 
                    ignore = True 
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("a" in line) and ignore :
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("b" in line) and ignore:
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("c" in line) and ignore: 
                            ignore = False 
                            continue
                else:
                    modified__line = line
                    

                modified_syn__file__handle.write(modified__line)
#                if (done_modifiying): 
#                    modified_syn__file__handle.write(line)
#                else:
#                    modified_syn__file__handle.write(modified__line)
#                
#                if (condition[0] and (not(done_modifiying))):
#                    done_modifiying = True

    
    modified_syn__file__handle.close()


#*** F:DN find all the cells and find the delay "-though" them. This allows
#          us to identify those cells that actually contribute to the non_apx
#          part of the result (this is b/c the paths that don't transition
#          generat a "no path" signal in the timing report
def find_delay_through_each_cell(timing_per_cell__log__addr, syn__file__na, syn__wrapper_module__na, \
        clk_period, DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, precision,
        base_to_dump_reports__dir, ID):
    
    #*** F:DN Parameters 
    tcl_file__na =  "../tcl_src/find_delay_through_each_cell.tcl"
    
    #*** F:DN Variables 
    tcl_parametrs = "set clk_period " + str(clk_period) + ";" + \
            "set DATA_PATH_BITWIDTH "+str(DATA_PATH_BITWIDTH) + ";" + \
            "set CLKGATED_BITWIDTH " + str(CLKGATED_BITWIDTH) + ";" + \
            "set DESIGN_NAME " + syn__wrapper_module__na + ";" + \
            "set synth_file__na " + syn__file__na + ";" + \
            "set output__timing__log__na " + timing_per_cell__log__addr + ";"
    
    #*** F:AN for now set the syn__file__na to mac
    syn__file__na = "mac"
    output__file__na = base_to_dump_reports__dir + "/"+syn__file__na+ "_" + \
            str(clk_period) + "_"+ \
            str(DATA_PATH_BITWIDTH) +"__"+ \
            "id"+"_"+str(ID)+"__"+\
            "find_delay_through_each_cell__log.txt"
    
    setup_info =  "clk:"+str(clk_period) +"\n"
    setup_info +=  "DATA_PATH_BITWIDTH:"+str(DATA_PATH_BITWIDTH) +"\n"
    os.system("echo \" " + setup_info + " \" > " + output__file__na)
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file__na +" >>" + \
            output__file__na)


#*** F:DN same as the name 
def find_transitioning_cells(timing_per_cell__log__addr,
        transitioning_cells__log__addr, 
        none_transitioning_cells__log__addr,
        precision,
        acc_max_delay):
    #*** F:DN Variables 
    transitioning_cell__log__file_handle = open(transitioning_cells__log__addr,
            "w")
    none_transitioning_cell__log__file_handle = \
            open(none_transitioning_cells__log__addr, "w")
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
                    
        
    #*** F:DN the reason that I add to_be_ignored b/c
    #         i can't figure out a way to separate {
    #         from the cells, so the first cell is always
    #         ignored (when reading the transitioning and non
    #         tranisition cell files
    transitioning_cell__log__file_handle.write("to_be_ignored ")
    for cell__na in transitioning_cells__l: 
        transitioning_cell__log__file_handle.write(cell__na + " ")
    transitioning_cell__log__file_handle.write(precision + " ")
    transitioning_cell__log__file_handle.write(acc_max_delay)
    
    none_transitioning_cell__log__file_handle.write("to_be_ignored ")
    for cell__na in none_transitioning_cells__l: 
        none_transitioning_cell__log__file_handle.write(cell__na + " ")
    none_transitioning_cell__log__file_handle.write(precision + " ")
    none_transitioning_cell__log__file_handle.write(acc_max_delay)


    transitioning_cell__log__file_handle.close()
    none_transitioning_cell__log__file_handle.close()


def read_resyn_and_report(\
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
        ID):
    
    #*** F:DN variabes 
    tcl_parametrs = "set clk_period " + str(clk_period) + ";" + \
            "set DATA_PATH_BITWIDTH "+str(DATA_PATH_BITWIDTH) + ";" + \
            "set CLKGATED_BITWIDTH "  +str(CLKGATED_BITWIDTH) + ";" + \
            "set DESIGN_NAME " + syn__wrapper_module__na + ";" + \
            "set synth_file__na " + syn__file__na  + ";" + \
            "set attempt__iter__c " + str(attempt__iter__c)+ ";"+\
            "set ID " + str(ID)+ ";"
    
    #*** F:AN for now set the syn__file__na to mac
    syn__file__na = "mac"
    output__file__na = base_to_dump_reports__dir + "/"+syn__file__na+ "_" + \
            str(DATA_PATH_BITWIDTH) +"__"+ \
            "clk" + "_" + str(clk_period) + "__"+ \
            "atmpt"+"_"+str(attempt__iter__c) + "__"+\
            "id"+"_"+str(ID)+"__"+\
            "read_resyn_and_report__log.txt"
    tcl_file_name =  "read_resyn_and_report.tcl"
    
    #----------------------------------------------------
    #--- F: Body
    #----------------------------------------------------
    setup_info =  "clk:"+str(clk_period) +"\n"
    setup_info +=  "prev__clk:"+str(prev__clk) +"\n"
    setup_info +=  "clk__lower_limit:"+str(clk__lower_limit) +"\n"
    setup_info +=  "clk__upper_limit:"+str(clk__upper_limit) +"\n"
    setup_info +=  "DATA_PATH_BITWIDTH:"+str(DATA_PATH_BITWIDTH) +"\n"

    os.system("echo \" " + setup_info + " \" > " + output__file__na)
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >>" + output__file__na)
    resyn__file__na = syn__wrapper_module__na +"__only_clk_cons_resynthesized"+\
            str(ID)+".v" # this the wrapper
    resyn__file__addr = base_to_dump_results__dir + "/" + resyn__file__na 
    os.system("echo starting dot_v file  >> " + output__file__na)
    os.system("cat  " + resyn__file__addr + "  >> " + output__file__na)


def parse_file_to_get_slack(src_file):
    start_looking = False 
    try:
        f = open(src_file)
    except IOError:
        handleIOError(src_file, "csource file")
        exit()
    else:
        with f:
            for line in f:
                word_list =   line.strip().replace(',', ' ').replace(';', ' ').split(' ') 
                if ("after" in word_list) and ("resynthesis" in word_list):
                    start_looking = True 
                if start_looking:
                    if ("slack" in word_list) and \
                            (not("-sort_by") in word_list):
#                                if "(MET)" in word_list:
#                                    return True
                                if (float(word_list[-1]) >= 0):
                                    return True
                                else:
                                    return False


def parse_file_to_get_best_delay(src_file):
    start_looking = False 
    try:
        f = open(src_file)
    except IOError:
        handleIOError(src_file, "csource file")
        exit()
    else:
        with f:
            for line in f:
                word_list =   line.strip().replace(',', ' ').replace(';', ' ').split(' ') 
                if ("after" in word_list) and ("resynthesis" in word_list):
                    start_looking = True 
                if start_looking:
                    if ("data" in word_list) and \
                            ("arrival" in word_list) and \
                            ("time") in word_list:
                                return word_list[-1]




#*** F:DN resynthesize the design while constraining the paths that goes
#         through the cells responsible for the non_apx part of the result
def read_and_cons_transitional_cells_and_resyn(syn__file__na,\
            syn__wrapper_module__na, transition_cells__base_addr,
            transitioning_cells__log__na, precision, clk_period, \
            DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, acc_max_delay,
            base_to_dump_reports__dir, base_to_dump_results__dir,
            attempt__iter__c, ID):
    
    #*** F:DN variabes 
    tcl_parametrs = "set clk_period " + str(clk_period) + ";" + \
            "set DATA_PATH_BITWIDTH "+str(DATA_PATH_BITWIDTH) + ";" + \
            "set CLKGATED_BITWIDTH "  +str(CLKGATED_BITWIDTH) + ";" + \
            "set DESIGN_NAME " + syn__wrapper_module__na + ";" + \
            "set synth_file__na " + syn__file__na  + ";" + \
            "set transition_cells__base_addr  " +  transition_cells__base_addr+ ";" \
            "set transitioning_cells__log__na " +  transitioning_cells__log__na + " ;" \
            "set Pn " + str(precision) + ";" + \
            "set acc_max_delay " + str(acc_max_delay)+ ";" \
            "set attempt__iter__c " + str(attempt__iter__c)+ ";"+\
            "set ID " + str(ID)+ ";"
    
    #*** F:AN for now set the syn__file__na to mac
    syn__file__na = "mac"
    output__file__na = base_to_dump_reports__dir + "/"+syn__file__na+ "_" + \
            str(DATA_PATH_BITWIDTH) +"__"+ \
            "clk" + "_" + str(clk_period) + "__"+ \
            "acc_max_del" + "_" + str(acc_max_delay)+"__"+\
            "Pn"+ "_" + str(precision)+"__"+\
            "atmpt"+"_"+str(attempt__iter__c) + "__"+\
            "id"+"_"+str(ID)+"__"+\
            "read_cons_and_resyn__log.txt"
    tcl_file_name =  "read_and_cons_transitional_cells_and_resyn.tcl"
    
    #----------------------------------------------------
    #--- F: Body
    #----------------------------------------------------
    setup_info =  "clk:"+str(clk_period) +"\n"
    setup_info +=  "DATA_PATH_BITWIDTH:"+str(DATA_PATH_BITWIDTH) +"\n"
    setup_info +=  "precision:"+str(precision) +"\n"
    setup_info +=  "acc_max_delay:"+str(acc_max_delay) +"\n"
    os.system("echo \" " + setup_info + " \" > " + output__file__na)
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >>" + output__file__na)
    resyn__file__na = syn__wrapper_module__na +"__only_clk_cons_resynthesized"+\
            str(ID)+".v" # this the wrapper
    resyn__file__addr = base_to_dump_results__dir + "/" + resyn__file__na 
    os.system("echo starting dot_v file  >> " + output__file__na)
    os.system("cat  " + resyn__file__addr + "  >> " + output__file__na)


#*** F:DN const transitonal cells and report time
def read_and_cons_transitional_cells_and_report_timing(syn__file__na,\
            syn__wrapper_module__na, transition_cells__base_addr,
            transitioning_cells__log__na, precision, clk_period, \
            DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, acc_max_delay,
            base_to_dump_reports__dir,
            attempt__iter__c, ID,
            acc_max_delay__lower_limit,
            acc_max_delay__upper_limit,
            prev__acc_max_delay):
    
    #*** F:DN variabes 
    tcl_parametrs = "set clk_period " + str(clk_period) + ";" + \
            "set DATA_PATH_BITWIDTH "+str(DATA_PATH_BITWIDTH) + ";" + \
            "set CLKGATED_BITWIDTH "  +str(CLKGATED_BITWIDTH) + ";" + \
            "set DESIGN_NAME " + syn__wrapper_module__na + ";" + \
            "set synth_file__na " + syn__file__na  + ";" + \
            "set transition_cells__base_addr  " +  transition_cells__base_addr+ ";" \
            "set transitioning_cells__log__na " +  transitioning_cells__log__na + " ;" \
            "set Pn " + str(precision) + ";" + \
            "set acc_max_delay " + str(acc_max_delay)+ ";"\
            "set attempt__iter__c " + str(attempt__iter__c)+ ";"+\
            "set ID " + str(ID)+ ";"


    
    #*** F:AN for now set the syn__file__na to mac
    syn__file__na = "mac"
    output__file__na = base_to_dump_reports__dir + "/"+syn__file__na+ "_" + \
            str(DATA_PATH_BITWIDTH) +"__"+ \
            "clk" + "_" + str(clk_period) + "__"+ \
            "acc_max_del" + "_" + str(acc_max_delay)+"__"+\
            "Pn"+ "_" + str(precision)+"__"+\
            "atmpt"+"_"+str(attempt__iter__c) + "__"+\
            "id"+"_"+str(ID)+"__"+\
            "read_cons_and_report_t__log.txt"
    tcl_file_name =  "read_and_cons_transitional_cells_and_report_timing.tcl"
    
    
    #----------------------------------------------------
    #--- F: Body
    #----------------------------------------------------
    setup_info =  "clk:"+str(clk_period) +"\n"
    setup_info +=  "DATA_PATH_BITWIDTH:"+str(DATA_PATH_BITWIDTH) +"\n"
    setup_info +=  "precision:"+str(precision) +"\n"
    setup_info +=  "acc_max_delay:"+str(acc_max_delay) +"\n"
    setup_info +=  "acc_max_delay__lower_limit:"+str(acc_max_delay__lower_limit) +"\n"
    setup_info +=  "acc_max_delay__upper_limit:"+str(acc_max_delay__upper_limit) +"\n"
    setup_info +=  "prev__acc_max_delay:"+str(prev__acc_max_delay) +"\n"
    os.system("echo \" " + setup_info + " \" > " + output__file__na)
    os.system("dc_shell-t  -x " + "\"" + tcl_parametrs + "\"" + " -f \
            ../tcl_src/"+tcl_file_name +" >> " + output__file__na)



def update_transitional_cells(old_transitional_cells__log__na,
        transitioning_cells__log__na) :
    os.system("cp " + transitioning_cells__log__addr + " " +
            old_transitional_cells__log__na) 


def append_one_file_to_another(old_transitional_cells__log__na,
        transitioning_cells__log__na):
    fin = open(transitional_cells__log__na, "r")
    data1 = fin.read()
    fin.close()
    fin = open(old_transitional_cells__log__na, "r")
    data2 = fin.read()
    fin.close()
    combined_data = data1 + data2
    fout = open(transitional_cells__log__na, "w")
    fout.write(combined_data)
    fout.close()


def grep_for_and_update_transitional_cells(syn__file__na, syn__file__addr
        , timing_per_cell__log__addr,
        none_transitioning_cells__log__addr, 
        transitioning_cells__log__addr,
        old_transitional_cells__log__na,
        old_none_transitional_cells__log__na,
        syn__wrapper_module__na, 
        syn__module__na, clk_period, 
        DATA_PATH_BITWIDTH,
        CLKGATED_BITWIDTH,
        precision, 
        base_to_dump_reports__dir, 
        ID,
        acc_max_delay):

    #*** F: DN keep a copy of original synthesized file 
    os.system("cp  " + syn__file__addr + " " +\
            syn__file__addr+"_original_synthesis")
    #*** F:DN hardwire bits to zero 
    hardwire_apx_bits_to_zero(syn__file__addr, syn__wrapper_module__na, syn__module__na, DATA_PATH_BITWIDTH, precision);
    #*** F:DN find cells responsible for the none_apx part of the result
    find_delay_through_each_cell(timing_per_cell__log__addr, syn__file__na, syn__wrapper_module__na, \
            clk_period, DATA_PATH_BITWIDTH, CLKGATED_BITWIDTH, precision,
            base_to_dump_reports__dir, ID);
    #*** F:DN find cells responsible for the apx part of the result
    find_transitioning_cells(timing_per_cell__log__addr,
            transitioning_cells__log__addr,
            none_transitioning_cells__log__addr,
            precision,
            acc_max_delay)
    
    #*** F:DN append to the old transitional cells 
    append_one_file_to_another(old_transitional_cells__log__na,
            transitioning_cells__log__na)
    append_one_file_to_another(old_none_transitional_cells__log__na,
            none_transitioning_cells__log__na)
    
    #*** F:DN returning the synthesized file to it's original (un hardwired) 
    os.system("cp  " + syn__file__addr +"_original_synthesis" + " " + syn__file__addr) 

