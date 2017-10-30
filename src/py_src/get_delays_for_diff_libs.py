#----------------------------------------------------
# --- use this file for sweeping the clock and also imposing of different
# constrains on various bits 
#----------------------------------------------------
import os
import pylab
from get_delays_for_diff_libs__helpers import *
import copy
from time import gmtime, strftime
from input__file import *
from misc__helpers import *
#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    
    #---------------------------------------------------- 
    #*** F:DN Parameters
    #---------------------------------------------------- 
#    libs__l =\
#            ["/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/aging_and_no_aging__db/noAging.db"] 
    #*** F:AN if you want to get all the libs in a directory, provide it bellow
    #lib__dir__addr = "/home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/db/various_temps__db__selected"
   
    lib__dir__addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values"
    libs__l = getNameOfFilesInAFolder(lib__dir__addr)
    #libs__l = ["/home/local/pow/behzad/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values/1.2V_25T.db", "/home/local/pow/behzad/verilog_files/libraries/germany_NanGate/db/various_temps__db__all_values/1.2V_75T.db"]
    
    #*** F:AN don't touch. It should be false 
    activate_check_point__p = False
    #---------------------------------------------------- 
    #*** F:DN initializing the variables
    #---------------------------------------------------- 
    input__obj = input__class(activate_check_point__p) # this also includes params
                                                   # for now
    prev__targeted_acc_max_delay = input__obj.init__prev__targeted_acc_max_delay
    currentDesignsPrecision_delay__d = \
            input__obj.init__currentDesignsPrecision_delay__d
    bestDesignsPrecision__delay__d =\
            input__obj.init__bestDesignsPrecision__delay__d
    precision_best_delay__d = input__obj.init__precision_best_delay__d
    best_design_worth_so_far = input__obj.init__best_design_worth_so_far 
    #-----  -----    -----     -----     -----     -----
    first_time__p = input__obj.init__first_time__p #this variable allows us to archive the transitional
                         #cells and also the design in the first iteration
                         # this is helpfull when the acc_mac__upper limit 
                         # is chosen lower than what the tool can find
    #-----  -----    -----     -----     -----     -----
#    report__timing__f__prev = input__obj.init__report__timing__f__prev
#    report__timing__f__best =  input__obj.init__report__timing__f__best
#
    precision__l__order = input__obj.precisions__l__order
    #-----  -----    -----     -----     -----     -----
    acc_max_delay__upper_limit__initial_value = input__obj.init__acc_max_delay__upper_limit__initial_value
    acc_max_delay__lower_limit__initial_value = input__obj.init__acc_max_delay__lower_limit__initial_value
    #-----  -----    -----     -----     -----     -----
    acc_max_delay__upper_limit__hard = acc_max_delay__upper_limit__initial_value
    acc_max_delay__lower_limit__hard = acc_max_delay__lower_limit__initial_value
    #-----  -----    -----     -----     -----     -----
    #precision__step_size = input__obj.precision__step_size
    #precision__higher_limit = input__obj.precision__higher_limit
    #precision__lower_limit = input__obj.precision__higher_limit
    precisions__curious_about__l = input__obj.precisions__curious_about__l
    prev__acc_max_delay = input__obj.init_prev__acc_max_delay
    report__timing__f__best = input__obj.init__report__timing__f
    propagate_info_regarding_previous_transiontal_cells__p = input__obj.propagate_info_regarding_previous_transiontal_cells__p
    #-----  -----    -----     -----     -----     -----
    precision = input__obj.precision__to_start_with
    #-----  -----    -----     -----     -----     -----
    remove__progress_flow_chart(input__obj) #removing the previous flow chart

    #input__obj.syn__file__addr = "mul_to_report.v"
    if not(os.path.isdir(input__obj.base_to_dump_reports__dir_temp+"/" +\
            input__obj.ID)):
        print "this directory doesn't exist"
        sys.exit
    input__obj.base_to_dump_reports__dir_temp =\
            input__obj.base_to_dump_reports__dir_temp+"/" +\
            input__obj.ID+"/"+strftime("%Y_%m_%d__%H_%M_%S", gmtime())
    input__obj.base_to_dump_reports__dir = input__obj.base_to_dump_reports__dir_temp+"/details"
    #----------------------------------------------------
    #*** F:DN Body
    #---------------------------------------------------- 
    #*** F:DN take a backup (move to a new folder) of previous results 
    """"
    if (os.path.isdir(input__obj.base_to_dump_reports__dir_temp)):
        backup_dir__n = "batch__"+ strftime("%Y_%m_%d__%H_%M_%S", gmtime())
        backup_dir__addr = input__obj.base_to_dump_reports__dir_original+"/"+input__obj.ID+"/"+backup_dir__n
        os.system("mkdir " + backup_dir__addr)
        os.system("mv " + input__obj.base_to_dump_reports__dir_temp + " " +\
                backup_dir__addr)
    """

    #*** F:DN make a temporary directory for results
    os.system("mkdir " + input__obj.base_to_dump_reports__dir_temp)
    os.system("mkdir " + input__obj.base_to_dump_reports__dir)
    behzad_readMe__addr =  input__obj.base_to_dump_reports__dir_temp+"/"+"behzad_readME"
    os.system("cp " + "params__hardwired.py" +  " " + behzad_readMe__addr)
    os.system("echo " + "activate_check_point__p=" + str(activate_check_point__p) + " >> " + behzad_readMe__addr)

    #*** F:DN this forces the get_delay__before_tuning_and_archive func
    #         to go through all the precisions mentioned in precisions__curi..
    for Pn in precisions__curious_about__l:
        bestDesignsPrecision__delay__d[Pn] = 0
    
    #*** iterate through libraries and get the delay (for Pns)
    iteration_count = 0 
    for lib__n in libs__l:
        currently_targetting_acc_max_delay =  acc_max_delay__upper_limit__hard
        bestDesignsPrecision__delay__d, precision_best_delay__d, best_design_worth_so_far, report__timing__f__best = \
        get_delay__before_tuning_and_archive( #@
                input__obj, precision, bestDesignsPrecision__delay__d,
                currently_targetting_acc_max_delay, acc_max_delay__lower_limit__hard,
                acc_max_delay__upper_limit__hard, prev__acc_max_delay, report__timing__f__best,
                precision_best_delay__d, lib__n, iteration_count)
        iteration_count +=1
            

#----------------------------------------------------
#--- F: Main
#----------------------------------------------------
main()


#----------------------------------------------------
#*** F:HTN: instructions on how to use this module
#----------------------------------------------------
#**** F: precisions__curious_about__l determine which precisions we will show
#        the delay for
#1. cpy the .v file that you are interested in getting the delay from. obviously
#              you should copy it to the file that is read by the python
#              submodule. e.g:
#  cp best_mac_32_by_32.v conf_int_mac__noFF__arch_agnos__w_wrapper_OP_BITWIDTH32_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD.v
#              run the python file
#   note that we don't need to use params__tool_generated at all b/c the 
#   precisions__curious_about__l would be explored


