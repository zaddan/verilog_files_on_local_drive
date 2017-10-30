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

def sourceFileParse(sourceFileName, clk_period):
    
    number_of_paths = 0 
    data = {}
    # if not(os.path.isfile(sourceFileName)):
        # print "the source file doesn't exist"
        # exit();
    adjust = False 
    try:
        f = open(sourceFileName)
    except IOError:
        handleIOError(sourceFileName, "csource file")
        exit()
    else:
        with f:
            for line in f:
                word_list =   line.strip().replace(',', ' ').replace('/','').replace(';', ' ').split(' ') #find the lines with key word and write it to another file   
                if word_list[0] == "Startpoint:":
                    input_pin = word_list[1]
                    print word_list 
                    input_pin_number = (word_list[1]).replace('[',',').replace(']',',').split(',')[1]
                if word_list[0] == "Endpoint:":
                    output_pin = word_list[1] 
                    output_pin_number = (word_list[1]).replace('[',',').replace(']',',').split(',')[1]
                if (word_list[0] == "data") and (word_list[1] == "required") and word_list[2] == "time":
                    offset = clk_period - float(word_list[-1])
#                    if (float(word_list[-1]) in [1.46, 1.47]):
#                        adjust = True 
                if word_list[0] == "slack":
                    #print output_pin_number, input_pin_number,  word_list[-1]
                    number_of_paths +=1 
                    if  (int(input_pin_number), int(output_pin_number)) in data:
                        data[(int(input_pin_number),
                            int(output_pin_number))].append(float(word_list[-1])
                                    + offset)
                    else:
                        
                        data[(int(input_pin_number), int(output_pin_number))] = [(float(word_list[-1])) + offset] 
    #print data
    print "number_of_paths:" + str(number_of_paths)
    return data


def main():
    
    os.system("rm *.png")
    #--- parameters to set
    #result_type = "slack"
    result_type = "delay"
    
    clk_period = .55 #clk period that we ran the DC with
    num_of_bins = 10  #number of bins for the histogram
    lower_bound = 28 #lower bound for the bit you want to make histogram for
    upper_bound = 32 #upper bound for the bit you want to make histogram for
    histogram_type = "2d"   #2d
                            #3d histogram will be generated regardless
    
    histogram_var = "input" #if input, slack of ass/w  input pins are shown
    #histogram_type = "ouput"
    bit_to_make_histogram_for = 0 #only for 2d histogram

    print "clk_period:" +str(clk_period)
    print "number_of_bins for histogram:" +str(num_of_bins)
    data_2 = {}
    #--- parse the results and collect slacks   
    #data = sourceFileParse("int_add_acc_ff_0_timing1.rpt", clk_period)
    #file_to_parse =  "unconfig_int_add_32Bit_timing.rpt"
    file_to_parse =  "config_int_add_inMux_truncation_16_timing.rpt"
    print colored ("ensure clk_period validity" + str(clk_period), 'blue')
    print colored ("ensure parsed timing file " + file_to_parse, "blue")
    data = sourceFileParse(file_to_parse, clk_period)
    if (result_type == "delay"):
        for el in data.keys():
            temporary_list = data[el]
            temporary_list_2 = []
            for value in temporary_list:
                temporary_list_2.append(clk_period - value)
            data[el] = temporary_list_2
    
    """ 
    for el in data.keys():
        print data[el]
        print data_2[el]
        sys.exit()
    """

    #sorting for printing purposes
    my_list = data.keys()
    my_list.sort(key=lambda x: x[0])
    my_list.sort(key=lambda x: x[1])
    for key in my_list:
        print str("pin_tuple:")+str(key) + " ---- " + result_type + "_values" + str(data[key])


    #--- preparing to draw a histogram 
    result_dic = {}
    for i in range(0, 32): 
        result_dic[i] = []

    for key in data.keys():
        if histogram_var == "input":
            result_dic[key[0]].append(data[key]) 
        elif histogram_var  == "output":
            result_dic[key[1]].append(data[key]) 
        else:
            print "This histogram_var not defined"
            sys.exit()
    
    ##--- flattening
    for key in result_dic.keys():
        result_dic[key] = list(itertools.chain.from_iterable(result_dic[key]))

    
    #--- draw a 2d histogram of  
    #--- the folowing is if we want to have a cumulitive histogram
    all_results= []
    for i in range(0 ,32): #which bits to show histogram for
        all_results += result_dic[i]
    print all_results

    if (histogram_type == "2d"): 
#        plt.hist(result_dic[bit_to_make_histogram_for], 30,
#                range=[0, clk_period])
        plt.hist(all_results, 30,
                range=[0, clk_period])
#
        
        print result_dic[bit_to_make_histogram_for]
        plt.title(result_type + " Histogram Associated With the " +
                str(bit_to_make_histogram_for) + "th bit (and lower) of the " + histogram_var)
        plt.xlabel(result_type +"Value")
        plt.ylabel("Frequency")
        pylab.savefig(result_type +"_histogram_"+histogram_var + str(bit_to_make_histogram_for) +"th_bit.png") #saving the figure generated by generateGraph
        #plt.show()
    
    
    #--- draw a 3d histogram
    fig = plt.figure()
    ax1 = fig.add_subplot(111, projection='3d')
    x = [] #list of bits (stamped to the number of result value)
    y = [] #list of result value
    for key in result_dic.keys():
        x += len(result_dic[key])*[key]
        y += result_dic[key]
    xedges = []
    for i in range(0,33):
        xedges.append(i)
    yedges = [] 
    for el in range(num_of_bins):
        yedges.append((el+1)*float(clk_period)/float(num_of_bins))
    H, xedges, yedges = np.histogram2d(x, y, bins=(xedges, yedges))
    
    new_yedges = []
    for i in range(0, len(xedges[:-1])):
        for el in yedges[:-1]:
            new_yedges.append(float(el))

    new_xedges = []
    for j in range (0, len(xedges[:-1])):
        for i in range(0, len(yedges[:-1])):
            new_xedges.append(j)

    dx = np.ones(len(new_xedges))
    dy = np.ones(len(new_xedges))*.1

    colors = gen_color_spec.gen_color(33, 'prism')
    for x in range(lower_bound, upper_bound):
        ax1.bar3d([x]*len(yedges[:-1]), yedges[:-1], np.zeros(len(yedges[:-1])), dx,
                dy,H[x], alpha =.5, color=colors[x])
    
    
        print "x and y for hisogram:"
        print "y:" + str(np.array(yedges))
        print "x " + str(xedges)
        print  "histogram:"
        print H
    
        """ 
        H_list = (H.tolist())
        H_list_flattened = list(itertools.chain.from_iterable(H_list))
        dz = H_list_flattened
        zpos =[0]*len(H_list_flattened)
        ax1.bar3d(new_xedges, new_yedges, zpos, dx, dy, dz, alpha =.1, color='#00ceaa')
        """ 
        pylab.savefig("3d_"+result_type+"_histogram.png") #saving the figure generated by generateGraph


main()
