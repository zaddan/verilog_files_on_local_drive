#----------------------------------------------------
# *** F:AN pick one of the following tuples
#design_name = "conf_int_mac__noFF__arch_agnos"
#op_type = "mac"

design_name = "conf_int_mul__noFF__arch_agnos"
op_type = "mul"

#design_name = "conf_int_add__noFF__arch_agnos"
#op_type = "add"
#----------------------------------------------------


#ID = "sanity_checks" #sanity checking two level and expanding to 3 level
#ID = "SCBD__1" #best case best sub delay
#ID = "SCBSDN__6" #best case best sub delay naive (only
#ID = "SCBDD__1" #best case best duplicate sub delay
ID = "SCBSD__1" #best case best sub delay
#ID = "SCBD__" #best case best sub delay
#ID = "DFDL__2" #Delay for different libraries
#ID = "DEBUG" #Delay for different libraries

space_search__direction = "forward" #this mens that we go through
                                    #precision_curious__l in from left to right
clk_period = .560#.250;
#long_clk = .85
DATA_PATH_BITWIDTH = 16#8

#-----  -----    -----     -----     -----     -----
acc_max_delay__upper_limit__initial_value = .500#.300#.156
acc_max_delay__lower_limit__initial_value = .450#.063#.050#.050#.152
#acc_max_delay__upper_limit__initial_value = .460#.066#.180#.300#.156
#acc_max_delay__lower_limit__initial_value = .45#.063#.050#.050#.152



#-----  -----    -----     -----     -----     -----
attempt__upper_bound = 10
#-----  -----    -----     -----     -----     -----
#*** F: CN if you want to focuse on one precision, simply pick the
#       higher_limit one about lower limit
#precision__lower_limit = 3;
#precision__higher_limit = 4#7
#precision__step_size = 2
precisions__curious_about__l = [12]
precision__l__order = "incr" #increasing
#precision__l__order = "decr" #decreasing
#*** F:DN if following predicate is true, we propagate the transitional
#         cells found from one proecision to another
propagate_info_regarding_previous_transiontal_cells__p = True
        


