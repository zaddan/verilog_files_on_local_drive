import numpy as np
from matplotlib.ticker import FuncFormatter
import matplotlib.pyplot as plt
import math 
from matplotlib.ticker import FormatStrFormatter
def gen_speedup_bar_plot():
    # data to plot
    n_groups = 3
    #Traditional_delay = (1, 1, 1, 1)
    """ 
    duplicated = ((.209/.223-1), (.743/.686-1), (.825/.673-1))
    delay_profile = (.209/.197 -1,.743/.7075 -1 ,.825/.761-1)
    delay_profile_2 = (.209/.194-1,.743/.732 -1 , .825/.758-1)
    """

    duplicated = ((.209/.223-1), (.743/.686-1), (.825/.673-1))
    delay_profile = (.209/.194-1, .743/.7075 -1 ,.825/.758-1)




    # create plot
    fig, ax = plt.subplots()
    index = np.arange(n_groups)
    bar_width = 0.15
    opacity = 0.8
     
    #rects1 = plt.bar(index, Traditional, bar_width,
    #                 alpha=opacity,
    #                 color='b',
    #                 label='Traditional')
     
    rects2 = plt.bar(index , duplicated, bar_width,
                     alpha=opacity,
                     color='b',
                     label='Duplicated')
     
    rects3 = plt.bar(index + bar_width, delay_profile, bar_width,
                     alpha=opacity,
                     color='g',
                     label='All in One')
     
    """ 
    rects3 = plt.bar(index + 2*bar_width, delay_profile_2, bar_width,
                     alpha=opacity,
                     color='y',
                     label='Delay Profile 2')
     
    """

    plt.xlabel('Hardware Module')
    plt.ylabel('Speed-up (%)')
    plt.title('Speed-up of Different Guardbanding Methods')
    plt.xticks(index + bar_width, ('Add', 'Mul', 'IDCT'))
    plt.legend()
     
    plt.tight_layout()
    plt.savefig("./results_for_paper/method_speedup.png")
    plt.show()


def gen_energy_bar_plot():
    # data to plot
    n_groups = 3
    #Traditional_delay = (1, 1, 1, 1)
    """ 
    duplicated = (.5180/.2858 - 1,17.314/10.962 -1,1.732/1.598 -1)
    delay_profile = (.341007/.2858 -1,14.597/10.962 -1,1.849/1.598 -1)
    delay_profile_2 = (.3270/.2858 -1,15.162/10.962 -1,1.652/1.598 -1)
    """
    duplicated = (.5180/.2858 - 1,17.314/10.962 -1,1.732/1.598 -1)
    delay_profile = (.3270/.2858 -1, 14.597/10.962 -1,1.652/1.598 -1)

    # create plot
    fig, ax = plt.subplots()
    index = np.arange(n_groups)
    bar_width = 0.15
    opacity = 0.8
     
    #rects1 = plt.bar(index, Traditional, bar_width,
    #                 alpha=opacity,
    #                 color='b',
    #                 label='Traditional')
     
    rects2 = plt.bar(index , duplicated, bar_width,
                     alpha=opacity,
                     color='b',
                     label='Duplicated')
     
    rects3 = plt.bar(index + bar_width, delay_profile, bar_width,
                     alpha=opacity,
                     color='g',
                     label='All in One')
     
    """ 
    rects3 = plt.bar(index + 2*bar_width, delay_profile_2, bar_width,
                     alpha=opacity,
                     color='y',
                     label='Delay Profile 2')
    """


    plt.xlabel('Hardware Module')
    plt.ylabel('Energy (%)')
    plt.title('Energy Overhead of Different Guardbanding Methods')
    plt.xticks(index + bar_width, ('Adder', 'Multiplier', 'IDCT'))
    plt.legend()
     
    plt.tight_layout()
    plt.savefig("./results_for_paper/method_energyOverhead.png")
    plt.show()


def gen_idct():
    #--- add
    # data to plot
    n_groups = 3
    #Traditional_delay = (1, 1, 1, 1)
    """ 
    duplicated = (.5180/.2858 - 1,17.314/10.962 -1,1.732/1.598 -1)
    delay_profile = (.341007/.2858 -1,14.597/10.962 -1,1.849/1.598 -1)
    delay_profile_2 = (.3270/.2858 -1,15.162/10.962 -1,1.652/1.598 -1)
    """
    duplicated__cl = (22, 13, 25)
    AIO__cl = (9, 8, 20)
    duplicated__ED = (21, 0.1, 2)
    AIO__ED = (9, 0.1, 4)
    #lower_bound__acc = (572)
    #lower_bound__apx = (431)

    #duplicated = (14203)
    #lower_bound__acc = (8776.1379)
    #lower_bound__apx = (5443.42)



    # create plot
    fig, ax = plt.subplots()
    figsize=(7,5.5)
    box = ax.get_position()
    ax.set_position([box.x0+.01, box.y0, box.width ,  box.height*.9])
    index = np.arange(n_groups)
    bar_width = 0.15
    opacity = 0.8
    plt.rc('font', size='14')
    #rects1 = plt.bar(index, Traditional, bar_width,
    #                 alpha=opacity,
    #                 color='b',
    #                 label='Traditional')
     
    rects2 = plt.bar(index -bar_width, duplicated__cl, bar_width,
                     alpha=opacity,
                     color="plum",
                     label='Duplicate (Multiplier)')
     
    rects3 = plt.bar(index + bar_width - bar_width, AIO__cl, bar_width,
                     alpha=opacity,
                     color="purple",
                     #hatch="////", 
                     label='Standalone (Multiplier)')
    

    rects4 = plt.bar(index+2*bar_width -bar_width, duplicated__ED, bar_width,
                     alpha=opacity,
                     color='palegreen',
                     label='Duplicate (IDCT)')
     
    rects5 = plt.bar(index + 3*bar_width -bar_width, AIO__ED, bar_width,
                     alpha=opacity,
                     color='darkgreen',
                     #hatch="////",
                     label='Standalone (IDCT)')
 


    """ 
    rects3 = plt.bar(index + 2*bar_width, delay_profile_2, bar_width,
                     alpha=opacity,
                     color='y',
                     label='Delay Profile 2')
    """


    #plt.xlabel('Metric')
    #plt.ylabel('Increase (%)', fontname="Arial", fontsize=18)
    #plt.ylabel('Increase (%)',  fontsize=18)
    ax.set_ylabel("Increase", fontsize = 18, fontname="Arial")
    #plt.title("Duplicated Design's Area Overhead normalized to a Stand-alone Static Design")
    plt.xticks(index + bar_width, ('Speed', 'Energy', 'Area'), fontname="Arial",
            fontsize=18)
    
    #plt.legend()
    #plt.tight_layout()
    plt.legend(loc='upper center', bbox_to_anchor=(box.width*.64,
        box.height*1.63), ncol = 2, fontsize=15)
    plt.gca().yaxis.set_major_formatter(FuncFormatter(lambda y,
        _:'{:.0%}'.format(y/100)))
            #FormatStrFormatter('{%d}%'))
    plt.ylim([0, 25.5])
    plt.savefig('idct_all_metrics.pdf', format='pdf', dpi=1200) 
    plt.show()

    
    """
    #--- mul
    # data to plot
    n_groups = 1
    #Traditional_delay = (1, 1, 1, 1)
    duplicated = (.5180/.2858 - 1,17.314/10.962 -1,1.732/1.598 -1)
    delay_profile = (.341007/.2858 -1,14.597/10.962 -1,1.849/1.598 -1)
    delay_profile_2 = (.3270/.2858 -1,15.162/10.962 -1,1.652/1.598 -1)
    duplicated = (14203)
    lower_bound__acc = (8776.1379)
    lower_bound__apx = (5443.42)

    # create plot
    fig, ax = plt.subplots()
    index = np.arange(n_groups)
    bar_width = 0.01
    opacity = 0.8
     
    #rects1 = plt.bar(index, Traditional, bar_width,
    #                 alpha=opacity,
    #                 color='b',
    #                 label='Traditional')
     
    rects2 = plt.bar(index , duplicated, bar_width,
                     alpha=opacity,
                     color='b',
                     label='Duplicated')
     
    rects3 = plt.bar(index + 6*bar_width, lower_bound__acc, bar_width,
                     alpha=opacity,
                     color='g',
                     label='stand alone approximate')
    
    rects4 = plt.bar(index + 12*bar_width, lower_bound__apx, bar_width,
                     alpha=opacity,
                     color='r',
                     label='stand alone accurate')
     

    rects3 = plt.bar(index + 2*bar_width, delay_profile_2, bar_width,
                     alpha=opacity,
                     color='y',
                     label='Delay Profile 2')


    plt.xlabel('Hardware Module')
    plt.ylabel('Area(area unit, need to be figured out)')
    plt.title('Area For Various Modules')
    plt.xticks(index + 15*bar_width, (''))#, 'Multiplier', 'IDCT'))
    plt.legend()
     
    plt.tight_layout()
    plt.savefig("./results_for_paper/duplicate_stand_alone__mul_area.png")
    plt.show()
    """

    

def gen_delay_bar_plot_duplicated_standalone():
    #--- add 
    # data to plot
    n_groups = 2
    #Traditional_delay = (1, 1, 1, 1)
    """ 
    duplicated = (.5180/.2858 - 1,17.314/10.962 -1,1.732/1.598 -1)
    delay_profile = (.341007/.2858 -1,14.597/10.962 -1,1.849/1.598 -1)
    delay_profile_2 = (.3270/.2858 -1,15.162/10.962 -1,1.652/1.598 -1)
    """
    duplicated = (.175, .167)
    stand_alone = (.147, .137)

    # create plot
    fig, ax = plt.subplots()
    index = np.arange(n_groups)
    bar_width = 0.3
    opacity = 0.8
    plt.rc('font', size='15')
    #rects1 = plt.bar(index, Traditional, bar_width,
    #                 alpha=opacity,
    #                 color='b',
    #                 label='Traditional')
     
    rects2 = plt.bar(index , duplicated, bar_width,
                     alpha=opacity,
                     color='b',
                     label='Duplicated')
     
    rects3 = plt.bar(index + bar_width, stand_alone, bar_width,
                     alpha=opacity,
                     color='g',
                     label='stand alone')
    
    

    """ 
    rects3 = plt.bar(index + 2*bar_width, delay_profile_2, bar_width,
                     alpha=opacity,
                     color='y',
                     label='Delay Profile 2')
    """

    plt.xlabel('Quality Level')
    plt.ylabel('Delay(ns)')
    #plt.title("Adder's Delay for Various Quality Levels")
    plt.xticks(index + 1*bar_width, ('32x32', '24x24'))
    #plt.xticks(index + 4*bar_width, ("approximate"))#, 'Multiplier', 'IDCT'))
    plt.legend(loc='upper center', bbox_to_anchor=(.5, 1))
     
    plt.tight_layout()
    plt.ylim([0, .22])
    plt.savefig("./results_for_paper/duplicated_vs_standalone__add_delay.png")
    plt.show()


    #sys.exit()
    #--- mul 
    # data to plot
    n_groups = 2
    #Traditional_delay = (1, 1, 1, 1)
    """ 
    duplicated = (.5180/.2858 - 1,17.314/10.962 -1,1.732/1.598 -1)
    delay_profile = (.341007/.2858 -1,14.597/10.962 -1,1.849/1.598 -1)
    delay_profile_2 = (.3270/.2858 -1,15.162/10.962 -1,1.652/1.598 -1)
    """
    duplicated = (.552, .484)
    stand_alone = (.522, .470)

    # create plot
    fig, ax = plt.subplots()
    index = np.arange(n_groups)
    bar_width = 0.3
    opacity = 0.8
     
    #rects1 = plt.bar(index, Traditional, bar_width,
    #                 alpha=opacity,
    #                 color='b',
    #                 label='Traditional')
     
    rects2 = plt.bar(index , duplicated, bar_width,
                     alpha=opacity,
                     color='b',
                     label='Duplicated')
     
    rects3 = plt.bar(index + bar_width, stand_alone, bar_width,
                     alpha=opacity,
                     color='g',
                     label='stand alone')
    
    

    """ 
    rects3 = plt.bar(index + 2*bar_width, delay_profile_2, bar_width,
                     alpha=opacity,
                     color='y',
                     label='Delay Profile 2')
    """


    plt.xlabel('Quality Level')
    plt.ylabel('Delay(ns)')
    #plt.title("Multiplier's Delay for Various Quality Levels")
    plt.xticks(index + 1*bar_width, ('Speed-up', 'Energy Overhead', 'Area Overhead'))
    #plt.xticks(index + 15*bar_width, (''))#, 'Multiplier', 'IDCT'))
    plt.legend(loc='upper center', bbox_to_anchor=(.1, 1))
    plt.tight_layout()
    plt.ylim([0, .65])
    plt.savefig("./results_for_paper/duplicated_vs_standalone__mul_delay.png")
    plt.show()





#gen_speedup_bar_plot()
#gen_energy_bar_plot()

gen_idct()
#gen_delay_bar_plot_duplicated_standalone()




