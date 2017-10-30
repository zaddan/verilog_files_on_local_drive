from params__hardwired import *

prev__targeted_acc_max_delay = -1 #initialized to a none sense value
currentDesignsPrecision_delay__d =  {}
bestDesignsPrecision__delay__d = {}
precision_best_delay__d = {}

#for i in range(precision__lower_limit, precision__higher_limit+1):
#    bestDesignsPrecision__delay__d[i] = 10
#    precision_best_delay__d[i] = 10
#

if (space_search__direction == "forward"):
    precision__to_start_with = precisions__curious_about__l[0]
else:
    precision__to_start_with = precisions__curious_about__l[0]

bestDesignsPrecision__delay__d[precision__to_start_with] = 10
precision_best_delay__d[precision__to_start_with] = 10


best_design_worth_so_far = -10
prev__acc_max_delay = -10
first_time__p = True #this variable allows us to archive the transitional
                     #cells and also the design in the first iteration
                     # this is helpfull when the acc_mac__upper limit 
                     # is chosen lower than what the tool can find

report__timing__f = "starting point"
report__timing__f__prev = "starting point"
report__timing__f__best = "starting point"

#precision_acc_max_delay_resulting_in_best_design__d = {}
delays_striving_for__f__na = "delays_striving_for"+ str(ID) +".txt" #this file
#                           keeps track of the best delays found for each
#                           precision, so it can be retrieved in the tcl

precisions_striving_for__f__na = "precisions_striving_for" + str(ID) +".txt" #this file
#                           keeps track of the best delays found for each
#


#*** F:AN to use a checkpoint follow the steps bellow:
#    1. activate_check_point__P = True
#    2.  cp .v file (that you want to start from) to the resynthesis$(ID).v file
#    3.  cp ...vars__tool_generated.txt (which is in the logs_2 folder) to vars__tool_generated.py (in py_src folder)
#    4.  modify  precisions__curious_about__l  (in params__hardwired.py file)
#    5.  modify acc_max_delay__upper_limit__initial_value (to whatever you want, but not all the values are sane)
#    6.  modify acc_max_delay__lower_limit__initial_value (to whatever you want, but not all the values are sane)

#**** F:AN when using checkpionts
#    All the info, will be overwritten based on the the resynthesized file. this means that bestDesignsPrecision__delay__d,
#   and precision_best_delay__d will acquire the values found from the resynthesized file (which is copied). hence, what
#   we really care about is precisions_best_delay (if we want to know across runs, what is the best). however, what
#   really matter is the keys within these two dictionaries. cause they are used to impose the constraints


