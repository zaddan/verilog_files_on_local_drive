#----------------------------------------------------
# --- use this file for sweeping the clock and also imposing of different
# constrains on various bits 
#----------------------------------------------------
import os
import pylab
from search_for_delay_profile__helpers import *
import copy
from time import gmtime, strftime
from input__file import *
#----------------------------------------------------
#---- F: Main 
#----------------------------------------------------
def main():
    
    #---------------------------------------------------- 
    #*** F:DN Parameters
    #---------------------------------------------------- 
    activate_check_point__p = False

    #---------------------------------------------------- 
    #*** F:DN initializing the variables
    #---------------------------------------------------- 
    input__obj = input__class(activate_check_point__p) # this also includes params
                                                   # for now
    prev__targeted_acc_max_delay = input__obj.init__prev__targeted_acc_max_delay
    currentDesignsPrecision_delay__d = \
            input__obj.init__currentDesignsPrecision_delay__d

    best_design_worth_so_far = input__obj.init__best_design_worth_so_far
    #-----  -----    -----     -----     -----     -----
    first_time__p = input__obj.init__first_time__p #this variable allows us to archive the transitional
                         #cells and also the design in the first iteration
                         # this is helpfull when the acc_max__upper limit
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
    DATA_PATH_BITWIDTH = input__obj.DATA_PATH_BITWIDTH

    bestDesignsPrecision__delay__d = {}
    bestDesignsPrecision__delay__d[input__obj.precisions__curious_about__l[0]] = 1000
    precision_best_delay__d = {}
    precision_best_delay__d [input__obj.precisions__curious_about__l[0]] =  10000

    prev__acc_max_delay = input__obj.init_prev__acc_max_delay
    report__timing__f__best = input__obj.init__report__timing__f
    propagate_info_regarding_previous_transiontal_cells__p = input__obj.propagate_info_regarding_previous_transiontal_cells__p
    #-----  -----    -----     -----     -----     -----
    precision =  input__obj.precisions__curious_about__l[0]
    #-----  -----    -----     -----     -----     -----
    remove__progress_flow_chart(input__obj) #removing the previous flow chart
    
    
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
    os.system("echo " + "process ID: " + str(os.getpid()) + " >> " + behzad_readMe__addr)

    precision__counter = 0
    #*** F:DN synth design with the clk (only const is the clk)
    
    currently_targetting_acc_max_delay =  acc_max_delay__upper_limit__hard
    input__obj.clk_period = currently_targetting_acc_max_delay
    activate_check_point__p = False
    if not(activate_check_point__p):
        synth_design_with_only_clk_constraint(input__obj, precision)
    else:
        bestDesignsPrecision__delay__d, precision_best_delay__d, best_design_worth_so_far, report__timing__f__best = \
                get_delay__before_tuning_and_archive( #@
                        input__obj, precision, bestDesignsPrecision__delay__d,
                        currently_targetting_acc_max_delay, acc_max_delay__lower_limit__hard,
                        acc_max_delay__upper_limit__hard, prev__acc_max_delay, report__timing__f__best,
                        precision_best_delay__d)

    report__timing__f__best, bestDesignsPrecision__delay__d,\
    acc_max_delay__lower_limit__hard, acc_max_delay__upper_limit__hard, prev__acc_max_delay,\
    precision_best_delay__d = \
    find_best_delay__using_binary_search( #@
            input__obj, 
            precision, currently_targetting_acc_max_delay,
            acc_max_delay__lower_limit__hard, acc_max_delay__upper_limit__hard,
            bestDesignsPrecision__delay__d,
            best_design_worth_so_far,
            precision_best_delay__d,
            report__timing__f__best,
            activate_check_point__p,
            precision__l__order)
            

#tool_chain__log__handle.close()
#----------------------------------------------------
#--- F: Main
#----------------------------------------------------
main()



