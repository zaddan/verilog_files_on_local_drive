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

def sourceFileParse(sourceFileName):
    number_of_paths = 0 
    data = {}
    # if not(os.path.isfile(sourceFileName)):
        # print "the source file doesn't exist"
        # exit();
    try:
        f = open(sourceFileName)
    except IOError:
        handleIOError(sourceFileName, "csource file")
        exit()
    else:
        with f:
            for line in f:
                word_list =   line.strip().replace(',', ' ').replace('/','').replace(';', ' ').split(' ') #find the lines with key word and write it to another file   
                return map(lambda x: float(x), word_list)
                

def gen_histo():
    # *** F:DN parameters
    num_of_bins = 10  #number of bins for the histogram
    lower_bound = 28 #lower bound for the bit you want to make histogram for
    upper_bound = 32 #upper bound for the bit you want to make histogram for
    all_results = sourceFileParse("ok.txt");
    
    
    plt.hist(all_results, num_of_bins,
            range=[lower_bound, upper_bound])
    pylab.savefig("results.png")

