#import params__hardwired
#import params__tool_generated
import vars__hardwired
import vars__tool_generated

class input__class():
    def __init__(self, activate_check_point__p):
        if not(activate_check_point__p):
            #params__f__addr = params__hardwired
            vars__f__addr = vars__hardwired 
        else:
            #params__f__addr = params__tool_generated
            vars__f__addr = vars__tool_generated

        self.design_name = vars__f__addr.design_name
        self.ID = vars__f__addr.ID
        self.clk_period = vars__f__addr.clk_period
        self.long_clk = vars__f__addr.clk_period
        self.DATA_PATH_BITWIDTH = vars__f__addr.DATA_PATH_BITWIDTH

        #*** F:AN this is a hack that would work for two level configuration, but not more. Fix later
        self.OP_BITWIDTH = vars__f__addr.precisions__curious_about__l[0]; #numebr of apx bits
        assert(2*self.OP_BITWIDTH > self.DATA_PATH_BITWIDTH)

        #-----  -----    -----     -----     -----     -----
        self.attempt__upper_bound = vars__f__addr.attempt__upper_bound
        #-----  -----    -----     -----     -----     -----
        #self.precision__lower_limit = vars__f__addr.precision__lower_limit
        #self.precision__higher_limit = vars__f__addr.precision__higher_limit
        #self.precision__step_size = vars__f__addr.precision__step_size
        #-----  -----    -----     -----     -----     -----
        self.propagate_info_regarding_previous_transiontal_cells__p = \
                vars__f__addr.propagate_info_regarding_previous_transiontal_cells__p
        #-----  -----    -----     -----     -----     -----
        self.op_type = vars__f__addr.op_type

        self.precision__to_start_with =  vars__f__addr.precision__to_start_with

        #---------------------------------------------------- 
        #*** F:DN Derivded Params
        #---------------------------------------------------- 
        self.wrapper_module__na = self.design_name +"__w_wrapper"
        self.CLKGATED_BITWIDTH = 2 # *** F:AN this doesn't matter at the moment
        #self.OP_BITWIDTH = self.DATA_PATH_BITWIDTH
        self.transition_cells__base_addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/src/py_src"

        self.syn__module__na = self.design_name+"_OP_BITWIDTH"+str(self.OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(self.DATA_PATH_BITWIDTH)
        self.syn__wrapper_module__na = self.design_name+"__w_wrapper_OP_BITWIDTH"+str(self.OP_BITWIDTH)+"_DATA_PATH_BITWIDTH"+str(self.DATA_PATH_BITWIDTH)


        self.syn__file__na = self.syn__wrapper_module__na +\
                "__only_clk_cons_resynthesized" + str(vars__f__addr.ID) +".v" # this the wrapper


        #---- this is for get_delay_for_diff_libs
#        self.syn__module__na  = "conf_int_mul__noFF__arch_agnos_OP_BITWIDTH18_DATA_PATH_BITWIDTH26"
#        self.syn__wrapper_module__na = "conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH26"
#        self.syn__file__na = "mul_to_report.v"




        self.delays_striving_for__f__na = vars__f__addr.delays_striving_for__f__na
        #                           keeps track of the best delays found for each
        #                           precision, so it can be retrieved in the tcl
        #                           file for imposing the constraints(best delays)

        self.precisions__curious_about__l = vars__f__addr.precisions__curious_about__l
        self.precisions_striving_for__f__na = vars__f__addr.precisions_striving_for__f__na
        self.precisions__l__order = vars__f__addr.precision__l__order
        self.base__dir = "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
        self.base_to_dump_reports__dir =\
                "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/logs_2"
        self.base_to_dump_results__dir =\
                "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/results"
        self.base_to_dump_reports__dir_temp =\
                "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected"
        self.base_to_dump_reports__dir_original =\
            "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected"

        self.tool_chain__log__f__na = self.op_type+"_" + \
                str(self.DATA_PATH_BITWIDTH)+"__"+\
                "clk" + "_"+ str(self.clk_period) + "__"+ \
                "id"+"_"+str(self.ID)+"__"+\
                "tool_chain__log.txt" 
#        self.tool_chain__log__f__addr = self.base_to_dump_reports__dir_temp +\
#                "/"+self.tool_chain__log__f__na
        #self.tool_chain__log__handle = open(self.tool_chain__log__f__addr, "w")
        self.syn__file__addr = self.base__dir + "/" + self.syn__file__na
        self.timing_per_cell__log__na = "timing_per_cell__log"+str(self.ID)+".txt"
        self.timing_per_cell__log__addr = self.timing_per_cell__log__na
        
        self.transitioning_cells__log__na = \
                "transitioning_cells_after_resyn"+str(self.ID)+".txt"
        self.none_transitioning_cells__log__na =\
                "none_transitioning_cells_after_resyn" + str(self.ID) +".txt"
        self.none_transitioning_cells__log__addr = self.none_transitioning_cells__log__na
        self.transitioning_cells__log__addr = self.transitioning_cells__log__na
#        transitioning_cells__log__na = "transitioning_cells"+str(ID)+".txt"
#        none_transitioning_cells__log__na = "none_transitioning_cells"+str(ID)+".txt"
        
        #---------------------------------------------------- 
        #*** F:DN Variables (initial value for variables)
        #---------------------------------------------------- 
        self.init__prev__targeted_acc_max_delay = vars__f__addr.prev__targeted_acc_max_delay
        self.init__currentDesignsPrecision_delay__d = \
                vars__f__addr.currentDesignsPrecision_delay__d
        self.init__bestDesignsPrecision__delay__d =\
                vars__f__addr.bestDesignsPrecision__delay__d
        self.init__precision_best_delay__d = vars__f__addr.precision_best_delay__d
        self.init__best_design_worth_so_far = vars__f__addr.best_design_worth_so_far
        #-----  -----    -----     -----     -----     -----
        self.init__acc_max_delay__upper_limit__initial_value = \
                vars__f__addr.acc_max_delay__upper_limit__initial_value
        self.init__acc_max_delay__lower_limit__initial_value =\
                vars__f__addr.acc_max_delay__lower_limit__initial_value
        #-----  -----    -----     -----     -----     -----
        self.init_prev__acc_max_delay  = vars__f__addr.prev__acc_max_delay
        self.init__first_time__p = vars__f__addr.first_time__p #this variable allows us to archive the transitional
                             #cells and also the design in the first iteration
                             # this is helpfull when the acc_mac__upper limit 
                             # is chosen lower than what the tool can find
        #-----  -----    -----     -----     -----     -----
        self.init__report__timing__f = vars__f__addr.report__timing__f
        self.init__report__timing__f__prev = vars__f__addr.report__timing__f__prev
        self.init__report__timing__f__best =  vars__f__addr.report__timing__f__best
