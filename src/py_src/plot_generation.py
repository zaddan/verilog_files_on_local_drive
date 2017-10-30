#from goto import goto, comefrom, label
from math import *
from reminder import *
import operator
import pylab
import os
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import sys
import matplotlib.pyplot as plt
import numpy
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from matplotlib import cm

import numpy
#from pylab import *
import pylab
import matplotlib.pyplot as plt

cmaps = [('Perceptually Uniform Sequential',
                            ['viridis', 'inferno', 'plasma', 'magma']),
         ('Sequential',     ['Blues', 'BuGn', 'BuPu',
                             'GnBu', 'Greens', 'Greys', 'Oranges', 'OrRd',
                             'PuBu', 'PuBuGn', 'PuRd', 'Purples', 'RdPu',
                             'Reds', 'YlGn', 'YlGnBu', 'YlOrBr', 'YlOrRd']),
         ('Sequential (2)', ['afmhot', 'autumn', 'bone', 'cool',
                             'copper', 'gist_heat', 'gray', 'hot',
                             'pink', 'spring', 'summer', 'winter']),
         ('Diverging',      ['BrBG', 'bwr', 'coolwarm', 'PiYG', 'PRGn', 'PuOr',
                             'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn', 'Spectral',
                             'seismic']),
         ('Qualitative',    ['Accent', 'Dark2', 'Paired', 'Pastel1',
                             'Pastel2', 'Set1', 'Set2', 'Set3']),
         ('Miscellaneous',  ['gist_earth', 'terrain', 'ocean', 'gist_stern',
                             'brg', 'CMRmap', 'cubehelix',
                             'gnuplot', 'gnuplot2', 'gist_ncar',
                             'nipy_spectral', 'jet', 'rainbow',
                             'gist_rainbow', 'hsv', 'flag', 'prism'])]

def start_up_making_graph():
    fig, ax = plt.subplots(figsize=(7,5.5))
    fig.subplots_adjust(left=.2) 
    return fig, ax


def start_up_making_graph_2(counter):
    fig, axarr = plt.subplots(2, sharex=False , sharey=True, figsize=(11,5))
    return fig, axarr
#        fig = plt.subplot(1,2,counter)
#        fig.set_figheight(3)
#        fig.set_figwidth(3)
    #else:
    #    plt.subplot(1,2,counter)
    #plt.subplots(counter,1)
    #plt.subplots(figsize=(5.5,5.5))
    #return fig, ax

def gen_color(n_colors, cmap_name):
    """ 
    for i in range(n_colors):
        cmap = pylab.get_cmap(cmap_name)
        color = cmap(1.*i/n_colors)  # color will now be an RGBA tuple
    """ 
    cmap = pylab.get_cmap(cmap_name)
    cgen = [cmap(.04+1.*i/n_colors) for i in range(n_colors)]

    return cgen



def generate_graph_2d_for_one_set_of_input_2( xValues, yValues, xName,
        yName, label_name, symbol__counter, color_counter, n_colors =9,
        counter=1):
    #plt.yscale('log')
    #plt.xscale('log')
    if (counter <2): 
        plt.ylabel(yName)
    plt.xlabel(xName)
    symbolsToChooseFrom = ['*', 'x', "o", "+","^"] #symbols to draw the plots with
    symbolsToChooseFrom += ['1', '2', "3"] #symbols to draw the plots with
    #color =['b','g', 'r', 'c', 'm', 'y', 'k', 'w']
    #n_colors = 120 
    color = gen_color(n_colors, 'seismic')

#    ax.plot(xValues, yValues, symbolsToChooseFrom[symbol__counter]+color[color_counter],
#            label=label_name, markersize=3, linestyle=':')
    if (counter <2): 
        plt.plot(xValues, yValues, c = color[color_counter],
                label=label_name, markersize=6, marker = "*", linestyle='-')
        plt.rc('font', size=15)                # controls default text sizes
        #plt.rc('legend', fontsize=25, ncol = 4)          # legend fontsize
        plt.legend(loc='center left', bbox_to_anchor=(1.3, .7), prop={'size':15}, ncol=2)
        #plt.legend(loc =3, prop={'size':15})
        plt.title("ok") 
    else:
        plt.plot(xValues, yValues, c = color[color_counter],
           markersize=6, marker = "*", linestyle='-')
        #plt.legend(loc='center left', bbox_to_anchor=(1, .9), prop={'size':8}, ncol=2)
        #plt.rc('legend', fontsize=20)          # legend fontsize
        #plt.legend(loc =2, prop={'size':6})
        #plt.title("blah") 
    print "ok"

    """
    file_name = "blah2" 
    graph_title = "blah" 
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.85, box.height])
    ax.legend(loc='center left', bbox_to_anchor=(1, .9), prop={'size':8})
    plt.title(graph_title)
    pylab.savefig(file_name)
    sys.exit() 
    """


def generate_graph_2d_for_one_set_of_input(ax, fig, xValues, yValues, xName,
        yName, label_name, symbol__counter, color_counter, n_colors =9,
        done_printing=True):
    #plt.yscale('log')
    #plt.xscale('log')
    #plt.ylabel(yName)
    #plt.xlabel(xName)
    
    symbolsToChooseFrom = ['*', 'x', "o", "+","^"] #symbols to draw the plots with
    symbolsToChooseFrom += ['1', '2', "3"] #symbols to draw the plots with
    #color =['b','g', 'r', 'c', 'm', 'y', 'k', 'w']
    #n_colors = 120 
    color = gen_color(n_colors, 'seismic')

#    ax.plot(xValues, yValues, symbolsToChooseFrom[symbol__counter]+color[color_counter],
#            label=label_name, markersize=3, linestyle=':')
    
    if (done_printing):
        ax.annotate("Multiplier", xy=(1.0305, 100), fontsize=22, fontname="Arial") 
    
    if not(done_printing): 
        #-- for idct 
        #ax.annotate("IDCT", xy=(1.070, 100), fontsize=22, fontname="Arial") 
        
        if (label_name == "66.0"):
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.07, 38), fontsize=19, fontname="Arial") 
        
        if (label_name == "75.0"): 
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.07, 53), fontsize=19, fontname="Arial") 
        

        if (label_name == "95.0") :
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.07, 72), fontsize=19, fontname="Arial") 

        if (label_name == "115.0") :
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.07, 90.5), fontsize=19, fontname="Arial") 

        """
        #-- for adders and multiplier 
        ax.annotate("Adder", xy=(1.063, 100), fontsize=22, fontname="Arial") 
        if (label_name == "66.0"):
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.048, 34), fontsize=21, fontname="Arial") 
        
        if (label_name == "75.0"): 
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.048, 55), fontsize=21, fontname="Arial") 
        

        if (label_name == "95.0") :
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.048, 73), fontsize=21, fontname="Arial") 

        if (label_name == "115.0") :
            ax.annotate("$\\alpha_{max}$ = " + str(int(float(label_name))) +
                    "$^\circ$C", xy=(1.048, 91), fontsize=21, fontname="Arial") 
        
        """
    ax.plot(xValues, yValues, c = color[color_counter],
            label="$\\alpha_{max}$ = " + str(int(float(label_name))) +
            "$^\circ$C", markersize=9, marker = "*", linestyle='-')

    """
    file_name = "blah2" 
    graph_title = "blah" 
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.85, box.height])
    ax.legend(loc='center left', bbox_to_anchor=(1, .9), prop={'size':8})
    plt.title(graph_title)
    pylab.savefig(file_name)
    sys.exit() 
    """


def finish_up_making_graph_2(axarr, graph_title, img_name):
    #--- wrapping up making the graph 
    box_1 = axarr[0].get_position()
    box_2 = axarr[1].get_position()
    fig_1_x =  box_1.x0 -.031
    fig_1_y =  box_2.y0 +.05 
    fig_1_width =  box_1.width*.54
    fig_1_height = box_2.height*2.2
    
    fig_2_x = fig_1_x + fig_1_width + .06
    fig_2_y =  fig_1_y
    fig_2_width =  fig_1_width
    fig_2_height = fig_1_height
    
    axarr[0].set_position([fig_1_x, fig_1_y, fig_1_width , fig_1_height ])
    axarr[1].set_position([fig_2_x, fig_2_y, fig_2_width , fig_2_height ])
    
    # Put a legend to the right of the current axis (note: prop changes the fontsize)
#    axarr[0].legend(loc='center left', bbox_to_anchor=(( fig_2_x+fig_2_width +
#        fig_1_x + fig_1_width 
#        -.25)/2 - .21, fig_1_height+ .43), ncol = 2, fontsize = 16)
#    axarr[0].legend(loc='center top')
    
    
    axarr[0].ticklabel_format(useOffset=False)
    axarr[1].ticklabel_format(useOffset=False)
    
    
    #axarr[0].set_xlabel('Speedup', font_properties)
    #plt.yticks(fontname = "Helvetica")
    #hfont = {'fontname':'Helvetica'}

    #plt.xlabel('xlabel', **hfont)
    axarr[0].set_xlabel('Speedup', fontsize = 23, fontname="Arial")
    axarr[1].set_xlabel('Speedup', fontsize = 23, fontname="Arial")
    #plt.tick_params(labelsize=20) 
    axarr[0].xaxis.set_tick_params(labelsize=21) 
    axarr[1].xaxis.set_tick_params(labelsize=21) 
    axarr[0].yaxis.set_tick_params(labelsize=21) 
    axarr[1].yaxis.set_tick_params(labelsize=21) 
    
    #axarr[0].set_ylabel('common ylabel')
    axarr[0].set_ylabel("Switching Point"+ " $\\alpha_s$" + " [$^\circ$C]",
            fontsize = 21, fontname="Arial")
    
    #axarr[1].set_ylabel('common2 ylabel')
    
    
    #axarr[0].legend(loc='center left', bbox_to_anchor=(-.25, box.height*1.6), ncol = 4)

# --- having control over all the sized
    #plt.rc('font', size=14)                # controls default text sizes
#    plt.rc('axes', titlesize=SIZE)           # fontsize of the axes title
#    plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
#    plt.rc('xtick', labelsize=SIZE)          # fontsize of the tick labels
#    plt.rc('ytick', labelsize=SIZE)          # fontsize of the tick labels
#    plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title
     
    #plt.rc('legend', fontsize=20)          # legend fontsize
    #plt.legend(loc =2, prop={'size':6})
    #plt.text(5, 3, 'slsdfjlasdjfkin') 
    #axarr[0].text(fig_1_x, fig_1_y, r'an equation: $E=mc^2$', fontsize=15)
    #plt.show() 
    #axarr[1].text(fig_1_x, fig_1_y, r'an equation: $E=mc^2$', fontsize=15)
    #axarr[0].set_xlim(-.4,.4)
    #axarr[0].set_xlim(-.4,.4)
    plt.title(graph_title) 
    #fig, ax = plt.subplots()
    #plt.savefig(img_name+".pdf") #saving the figure generated by generateGraph
    
    plt.savefig('expl.pdf', format='pdf', dpi=1200) 
    plt.show() 
    #pylab.savefig(img_name)


    
    #--- wrapping up making the graph 
    #box = ax.get_position()
    #plt.set_position([box.x0, box.y0, box.width*.64 ,  box.height])
    # Put a legend to the right of the current axis (note: prop changes the fontsize)
    #ax1.legend(loc='center left', bbox_to_anchor=(1, .9))

# --- having control over all the sized
    #plt.rc('font', size=15)                # controls default text sizes
#    plt.rc('axes', titlesize=SIZE)           # fontsize of the axes title
#    plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
    #plt.rc('xtick', labelsize=SIZE)          # fontsize of the tick labels
    #plt.rc('ytick', labelsize=SIZE)          # fontsize of the tick labels
#    plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title
     
    #plt.rc('legend', fontsize=20)          # legend fontsize
    #plt.legend(loc =2, prop={'size':6})
        
    #plt.title(graph_title) 
    #fig, ax = plt.subplots()
    #pylab.savefig(img_name+".png") #saving the figure generated by generateGraph
    #plt.subplot(2,1,1) 
    
    #plt.plot()  
    #plt.show() 
    #pylab.savefig(img_name)


#--- finishing up
def finish_up_making_graph(ax, graph_title, img_name):
    #--- wrapping up making the graph 
    box = ax.get_position()
    ax.set_position([box.x0-.08, box.y0+.03, box.width*1.15 ,  box.height])
    # Put a legend to the right of the current axis (note: prop changes the fontsize)
    #ax.legend(loc='center left', bbox_to_anchor=(-.05, box.height*1.5), ncol =
    #        2, fontsize = 12)

    ax.xaxis.set_tick_params(labelsize=19) 
    ax.yaxis.set_tick_params(labelsize=19) 

    ax.set_ylabel("Switching Point"+ " $\\alpha_s$" + " [$^\circ$C]", fontsize
            =20, fontname="Arial")
    #plt.tick_params(labelsize=24) 
    ax.set_xlabel('Speedup', fontsize = 20, fontname="Arial")


# --- having control over all the sized
    #plt.rc('font', size=14)                # controls default text sizes
#    plt.rc('axes', titlesize=SIZE)           # fontsize of the axes title
#    plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
#    plt.rc('xtick', labelsize=SIZE)          # fontsize of the tick labels
#    plt.rc('ytick', labelsize=SIZE)          # fontsize of the tick labels
#    plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title
     
    #plt.rc('legend', fontsize=20)          # legend fontsize
    #plt.legend(loc =2, prop={'size':6})
        
    plt.title(graph_title) 
    #fig, ax = plt.subplots()
   
    plt.savefig('expl.pdf', format='pdf', dpi=1200) 
    #pylab.savefig(img_name+".png") #saving the figure generated by generateGraph
    plt.show() 
    #pylab.savefig(img_name)

#--- example
"""
def example():
    x_1 = [ 2, 4, 8]
    y_1 = [ 20,40, 80 ]
    x_2 = [3 , 6, 12]
    y_2 = [30, 60,120]

    fig, ax  = start_up_making_graph()
    generate_graph_2d_for_one_set_of_input(ax, fig, x_1,y_1, "x_vals", "y_vals",
    "label1", 0)
    generate_graph_2d_for_one_set_of_input(ax, fig, x_2,y_2, "x_vals", "y_vals",
    "label2", 2)

    finish_up_making_graph(ax, "graph title", "image_name")

example()
"""
