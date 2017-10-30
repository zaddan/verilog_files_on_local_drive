import matplotlib.colors as colors
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import os
import itertools
import sys
from math import *
import operator
import pylab
import os
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import sys
import matplotlib.pyplot as plt
from list_all_files_in_a_folder import *
import numpy
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from matplotlib import cm
plt.ioff()
import gen_color_spec 
from termcolor import colored

def source_file__parse(sourceFileName):#, msb_cutOff):
    #---------------------------------------------------- 
    #--- F: Parameters:
    #----------------------------------------------------
    bound_l = [(0,4), (4,8), (8,12), (12,16), (16,32)]
    

    #---------------------------------------------------- 
    #--- F: Variables:
    #----------------------------------------------------
#    line_nu = 0 
#    lib_setup_t = 0
#    found_one = False 
#    line_nu = 0
#    f = open(sourceFileName)
    
    
    #---------------------------------------------------- 
    #--- F: Body:
    #----------------------------------------------------
    for bound in bound_l:
        line_nu = 0 
        lib_setup_t = 0
        found_one = False 
        line_nu = 0
        f = open(sourceFileName)
        lower_bound = bound[0]
        upper_bound = bound[1]
        with f:
            for line in f:
                line_nu +=1
                word_list =   line.strip().replace(',', ' ').replace('/','').replace(';', ' ').split(' ') #find the lines with key word and write it to another file   
                if word_list[0] == "Startpoint:":
                    input_pin = word_list[1]
                    if (input_pin in ["reg_en_reg_reg", "rst_reg_reg", "reg_en" ]):
                        continue
                    #print "before" + str(input_pin) + str(line_nu)
                    input_pin_number = (word_list[1]).replace('[',',').replace(']',',').split(',')[1]
                    if (int(input_pin_number) >= lower_bound and  int(input_pin_number) <
                            upper_bound):
                        if((word_list[1]).replace('[',',').replace(']',',').split(',')[0]\
                                in ["a", "b"]):
                            found_one = True 
                if (found_one):
                    if word_list[0] == "data":
                        if word_list[1] == "arrival":
                            if word_list[2] == "time":
                                arr_t = word_list[-1] 
                
                if (found_one):
                    if word_list[0] == "data":
                        if word_list[1] == "required":
                            if word_list[2] == "time":
                                #found_one = False 
                                req_t = word_list[-1] 
                                break 
        if (found_one): 
            found_one = False 
            print "pin__na:" + str(input_pin) + ",  line__nu:"+str(line_nu) + ",arr_t:"\
                    + str(arr_t) + ", req t:"+str(req_t) +", delay+setup:"+str(float(arr_t)+lib_setup_t)


def main():
    #--- parameters 
    #msb_cutOff = 16
    if len(sys.argv) < 3: 
        print "must provide the DATA_PATH_WIDTH"
        exit()
    DATA_PATH_WIDTH = sys.argv[1] 
    source_file__na = sys.argv[2]
    
    #"unconfig_int_add_" + str(DATA_PATH_WIDTH) + "Bit_" + str(DATA_PATH_WIDTH)\
    #+ "Bit_timing.rpt" 
    base_dir__addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/reports"
    source_file__addr = base_dir__addr + "/" + source_file__na
    source_file__parse(source_file__addr)#, msb_cutOff)
    
main()
