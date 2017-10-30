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
    bestDesignsPrecision__delay__d =\
            input__obj.init__bestDesignsPrecision__delay__d
    precision_best_delay__d = input__obj.init__precision_best_delay__d
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
    precisions__curious_about__l = input__obj.precisions__curious_about__l
    prev__acc_max_delay = input__obj.init_prev__acc_max_delay
    report__timing__f__best = input__obj.init__report__timing__f
    propagate_info_regarding_previous_transiontal_cells__p = input__obj.propagate_info_regarding_previous_transiontal_cells__p
    #-----  -----    -----     -----     -----     -----
    precision = input__obj.precision__to_start_with
    assert (2*precision > input__obj.DATA_PATH_BITWIDTH)
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
    #clk__l = [.602, .61, .64, .67]
    clk__l = [.560]
    os.system("cp " + "params__hardwired.py" +  " " + behzad_readMe__addr)
    os.system("echo " + "activate_check_point__p=" + str(activate_check_point__p) + " >> " + behzad_readMe__addr)
    os.system("echo " + "clk__l =" + str(clk__l) + " >> " + behzad_readMe__addr)
    os.system("echo " + "process ID: " + str(os.getpid()) + " >> " + behzad_readMe__addr)
    precision__counter = 0
    #*** F:DN synth design with the clk (only const is the clk)
    for clk in clk__l:
        input__obj.clk_period = clk
        acc_max_delay__upper_limit__hard = acc_max_delay__upper_limit__initial_value
        acc_max_delay__lower_limit__hard = acc_max_delay__lower_limit__initial_value
        if not(activate_check_point__p):
            synth_design_with_only_clk_constraint(input__obj, precision)

        #*** F:DN iterate through precisions and find best delay for each
        #*** F:AN the upper bound can not be higher than 32(hence 32 not included
        #         I believe there are many reasons but at the very least None
        #         transionining cells are 32 is none which would error out
        while(True):
            currently_targetting_acc_max_delay =  acc_max_delay__upper_limit__hard
            #*** F:DN get delays before any tuninig (before design compiler designing)
            #*** F:AN bestDesignsPrecision__delay_d and currently_targetting_acc_max_delay
            #         values don't really mater in the follwing function
            bestDesignsPrecision__delay__d, precision_best_delay__d, best_design_worth_so_far, report__timing__f__best = \
            get_delay__before_tuning_and_archive( #@
                    input__obj, precision, bestDesignsPrecision__delay__d,
                    currently_targetting_acc_max_delay, acc_max_delay__lower_limit__hard,
                    acc_max_delay__upper_limit__hard, prev__acc_max_delay, report__timing__f__best,
                    precision_best_delay__d)

            #*** F:DN find best delay using design compiler
            report__timing__f__best, bestDesignsPrecision__delay__d,\
            acc_max_delay__lower_limit__hard, acc_max_delay__upper_limit__hard, prev__acc_max_delay,\
            precision_best_delay__d = \
            find_best_subdelay__using_binary_search( #@
                    input__obj,
                    precision, currently_targetting_acc_max_delay,
                    acc_max_delay__lower_limit__hard, acc_max_delay__upper_limit__hard,
                    bestDesignsPrecision__delay__d,
                    best_design_worth_so_far,
                    precision_best_delay__d,
                    report__timing__f__best,
                    activate_check_point__p,
                    precision__l__order)



            precision__counter += 1
            if (precision__counter >= len(precisions__curious_about__l)):
                break
            precision = precisions__curious_about__l[precision__counter]
            assert (2*precision > input__obj.DATA_PATH_BITWIDTH)
            precision_best_delay__d[precision]  = 10
            bestDesignsPrecision__delay__d[precision]  = 10
            #*** F:DN need tuo update the lowerlimit so the next precision
            #         start from the best of previous precision
    #        acc_max_delay__lower_limit = bestDesignsPrecision__delay__d[precision -\
    #                precision__step_size]

    #        archive_params(dest__f__addr, design_name, ID, clk_period, DATA_PATH_BITWIDTH,
    #                acc_max_delay__upper_limit__initial_value,
    #                acc_max_delay__lower_limit, attempt__upper_bound,
    #                precision__lower_limit,precision__higher_limit,
    #                precision__step_size,
    #                propagate_info_regarding_previous_transiontal_cells__p,
    #                -1, currentDesignsPrecision_delay__d,
    #                precision_mac_8__clk_0.4__acc_max_del_0.196__Pn_7__atmpt_0__id_SCBSD__evol_log.txtbest_delay__d,
    #                best_design_worth_so_far,
    #                bestDesignsPrecision__delay__d,
    #                False, report__timing__f__prev, report__timing__f__best,
    #                op_type)
    #
                #*** F:DN update the synfile and transition file NAMES
            if not(propagate_info_regarding_previous_transiontal_cells__p):
                print "this needs more work"
                sys.exit()
                restore_design_and_design_info_first_case(input__obj)
                first_time__p = True
                design_worth = 0
                #*** F:DN copy back the original
                restore_design_and_design_info_first_case(input__obj)
                report__timing__f__prev = "starting point"

    """"
    #*** F:DN takinga back up of the results
    backup_dir__n = "batch__"+ strftime("%Y_%m_%d__%H_%M_%S", gmtime())
    backup_dir__addr = input__obj.base_to_dump_reports__dir_original+"/"+input__obj.ID+"/"+backup_dir__n
    os.system("mkdir " + backup_dir__addr)
    os.system("mv " + input__obj.base_to_dump_reports__dir_temp + " " +\
            backup_dir__addr)
    """

#----------------------------------------------------
#--- F: Main
#----------------------------------------------------
main()


#----------------------------------------------------
#--- F:HTN
#----------------------------------------------------
# set the param values and simply run
# Note: to run things in parallel, assign a name (e.g SCBSD_1, SCBSD_2, ...) in the params file.
# Note: you can run SCBSD and SCBD in parallel (they don't interfere with each other)
# Note: params__hardwired.py is shared among SCBSD, SCBD and DFDL. You just need to run the correct .py file
#       (e.g search_for_best_delay.py or search_for_delay_profile.py ,....) with it

# *** F:DN to switch between noFF and FF, simply uncomment the spots that are annoated
#             ass noFF=>FF (and vice versa) for *.py files. Also do the same for tcl files
#             specifically (resyn.tcl and report_timing.tcl)

