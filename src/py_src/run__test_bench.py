#----------------------------------------------------
# --- F:D This file runs the test bench,
# ---     only need to set DUT__na
#----------------------------------------------------

import os


#----------------------------------------------------
# --- F:D Parameters
#----------------------------------------------------
#DUT__na = "conf_int_add__noFF__arch_agnos"
DUT__na = "conf_int_add__noFF__multiple_add"

#----------------------------------------------------
# --- F:D variables
#----------------------------------------------------
test_bench__na = DUT__na + "__tb"
DUT__f__na = DUT__na+".v"
test_bench__f__na = test_bench__na + ".v"
base_dir__addr = "/home/polaris/behzad/behzad_local/verilog_files/apx_operators/\
int_ops_apx/src/v_src"
test_bench__f__addr = base_dir__addr + "/" + test_bench__f__na
DUT__f__addr = base_dir__addr + "/" + DUT__f__na
#print test_bench__f__addr
#print DUT__f__addr



#----------------------------------------------------
# --- F:D Body
#----------------------------------------------------
os.system("ncverilog -v" + " " + DUT__f__addr + " " + test_bench__f__addr  + " " + \
        "+access+r |tee log")
