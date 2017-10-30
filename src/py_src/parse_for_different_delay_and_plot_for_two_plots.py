#----------------------------------------------------
# *** F:DN this module allows us to parse the delays spit out from 
#          get_delays_for_diff_library and turn it in to a graph and csv file
#----------------------------------------------------

import sys
from plot_generation import *
def sort_dic(mydict):
    result__d ={}
    keylist = mydict.keys()
    keylist.sort()
    for key in keylist:
        result__d[key] = mydict[key]

    return result__d

def get_temperature(word):
    return float((word.replace("/", ",").replace(".",
            ",").replace("_",",").replace("/",
                ",").split(",")[-2])[:-1])
def parse_file_to_get_arrival_time(src_file):
    temperature__d = {}
    start_looking = False
    counter = 0
    try:
        f = open(src_file)
    except IOError:
        print "src_file" +src_file + "not found"
        #handleIOError(src_file, "csource file")
        sys.exit()
    else:
        with f:
            for line in f:
                word_list =   line.strip().replace(',', ' ').replace(';', ' ').split(' ')
                if not("typical" in word_list) and \
                        ("T.db" in word_list[-1]):
                            temperature = get_temperature(word_list[-1])
                
                # *** F:DN FF=>noFF 
                             
                if ("arrival" in word_list) and \
                        (float(word_list[-1]) > 0):
                            if (counter == 0):
                                temperature__d[temperature] =\
                                        [float(word_list[-1])]
                                counter +=1
                            else:
                                temperature__d[temperature].append(float(word_list[-1]))
                                counter = 0
                
                # *** F:DN noFF=>FF 
                """ 
                if ("data" in word_list) and \
                        ("arrival" in word_list) and \
                        ("time") in word_list:
                            if (float(word_list[-1]) >=0): #this is b/c arrival time is repeated for the same precision, and the 2nd one is negative
                                design_arrival_time__val = (float(word_list[-1]))

                if ("library" in word_list) and \
                        ("setup" in word_list) and  ("time") in word_list:
                    word_list__filtered = filter(lambda x: not(x==''), word_list) #getting rid of '' to extrat data easier
                    design_arrival_time__val += -1*(float(word_list__filtered[-2]))
                    if (counter == 0):
                        temperature__d[temperature] =\
                                [design_arrival_time__val]
                        counter +=1
                    else:
                        temperature__d[temperature].append(design_arrival_time__val)
                        counter = 0
                """
    return temperature__d


def extract_delay_for_vaiours_temperatures(src__f__addr):
    arrival_time__d = parse_file_to_get_arrival_time(src__f__addr)
    arrival__time__d__sorted = sort_dic(arrival_time__d)

    thirty_two_bit__l = map(lambda x: arrival__time__d__sorted[x][1],
            arrival__time__d__sorted.keys())
    twenty_four_bit__l = map(lambda x: arrival__time__d__sorted[x][1],
            arrival__time__d__sorted.keys())

    #print arrival__time__d__sorted
    return arrival__time__d__sorted
    #print arrival__time__d__sorted
    #print thirty_two_bit__l


# *** F:DN speed up vs temp
def plot_1():
    max_temperature__switching_temp_speed_up__curve = {} 
    sample_rate = 1 #** how often to sample from the list of temperatures
    
    # *** F:DN for mul 
    
    src__f__addr__l =\
            ["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/white_box/diff_delay/optimal__1/2017_08_26__23_30_12/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__2__evol_log.txt",
                    "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/white_box/diff_delay/optimal__2/2017_08_26__23_30_22/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__1__evol_log.txt",
                    "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/white_box/diff_delay/optimal__3/2017_08_26__23_29_15/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__4__evol_log.txt",
             "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/white_box/diff_delay/optimal__5/2017_08_26__23_30_02/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__3__evol_log.txt",
             "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/white_box/diff_delay/optimal__4/2017_08_27__01_36_22/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__4__evol_log.txt",
             "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/black_box/diff_delays/optimal_1/2017_08_26__23_28_09/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__6__evol_log.txt"]       
                    #"/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/white_box/diff_delay/optimal__4/2017_08_26__21_33_59/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__5__evol_log.txt",
            #"/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/mul/delay_profile/32_24/black_box/diff_delays/optimal_1/mul_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__6__evol_log.txt"]
                
    # *** F:DN for add
    src__f__addr__l =\
            ["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/add/delay_profile/32_24/white_box/diff_delays/optimal__1/2017_08_27__00_05_58/add_32__clk_0.63__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__7__evol_log.txt",
            "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/add/delay_profile/32_24/white_box/diff_delays/optimal__2/2017_08_31__22_10_55/add_32__clk_0.166__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__2__evol_log.txt",
            "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/add/delay_profile/32_24/white_box/diff_delays/optimal__3/2017_08_31__22_11_26/add_32__clk_0.166__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__3__evol_log.txt",
            "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/add/delay_profile/32_24/white_box/diff_delays/optimal__4/2017_08_31__22_11_50/add_32__clk_0.166__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__4__evol_log.txt"]
    
    # *** F:DN for idct 
#    src__f__addr__l =\
#            ["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/idct/delay_profile/diff_delays/optimal__1/2017_09_01__02_20_58/mul_26__clk_0.68__acc_max_del_0__Pn_18__atmpt_-1__id_DFDL__1__evol_log.txt",
#             "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/idct/delay_profile/diff_delays/optimal__2/2017_09_01__02_20_49/mul_26__clk_0.68__acc_max_del_0__Pn_18__atmpt_-1__id_DFDL__2__evol_log.txt",
#"/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/idct/delay_profile/diff_delays/optimal__3/2017_09_01__02_20_40/mul_26__clk_0.68__acc_max_del_0__Pn_18__atmpt_-1__id_DFDL__3__evol_log.txt",
#"/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/idct/delay_profile/diff_delays/optimal__4/2017_09_01__02_20_32/mul_26__clk_0.68__acc_max_del_0__Pn_18__atmpt_-1__id_DFDL__4__evol_log.txt",
#"/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/src/v_src/optimals__found_so_far/idct/delay_profile/diff_delays/optimal__5/2017_09_01__02_21_25/mul_26__clk_0.68__acc_max_del_0__Pn_18__atmpt_-1__id_DFDL__5__evol_log.txt"]
#


    # *** F:DN needs to correspond to the src__f__addr__l 
    # *** F:DN for mul 
    #
    speed_up__l =\
    [float(.743)/float(.707),  # *** F:DN for multiplier
            float(.743)/float(.7075),
            float(.743)/float(.709), 
            float(.743)/float(.713),
            float(.743)/float(.714),
            float(.743)/float(.72)]
            #, float(.743)/float(.72)]
    # *** F:DN for add
    speed_up__l = [float(.209)/float(.194),
            float(.209)/float(.195),
            float(.209)/float(.196),
            float(.209)/float(.202)]
    
#    # *** F:DN for idct
#    speed_up__l = [float(.825)/float(.7369),
#            float(.825)/float(.7535),
#            float(.825)/float(.7597),
#            float(.825)/float(.7651),
#             float(.825)/float(.774)]
#    

    # *** F:DN parse each file and get the temp_switching    
    for index,src__f__addr in enumerate(src__f__addr__l):
        max_temperature__switching_temp__el = \
                get_max_temp__switching_temp__per_file(src__f__addr)
        #continue 
        for index2, temp__val in enumerate(max_temperature__switching_temp__el.keys()):
            #if (index2 % sample_rate) == 0: #sample based on the sampling rate
                # *** if exists append 
            if not(temp__val in [66, 75,95, 115]):
                continue
            if temp__val in \
                    max_temperature__switching_temp_speed_up__curve.keys():
                        max_temperature__switching_temp_speed_up__curve[temp__val].append(
                                (speed_up__l[index],
                                    max_temperature__switching_temp__el[temp__val]))
            else: #if not exist add
                max_temperature__switching_temp_speed_up__curve[temp__val] =\
                        [(speed_up__l[index],
                            max_temperature__switching_temp__el[temp__val])]
    n_colors = len(max_temperature__switching_temp_speed_up__curve)

#    for el in max_temperature__switching_temp_speed_up__curve.keys():
#        print str(el) + " " + str(max_temperature__switching_temp_speed_up__curve[el])

    # *** F:DN sort the keys so you can draw based on hotness 
    max_temp_key_list =max_temperature__switching_temp_speed_up__curve.keys()
    max_temp_key_list.sort()
    
    # *** F:DN draw graph 
    counter = 0
    start_up_making_graph_2(1)
    #ax.ticklabel_format(useOffset=False)
    for temp__el in max_temp_key_list:
        switching_temp_speed_up =\
                max_temperature__switching_temp_speed_up__curve[temp__el]
        data_x = map(lambda x: x[0], switching_temp_speed_up)
        data_y = map(lambda x: x[1], switching_temp_speed_up)
        generate_graph_2d_for_one_set_of_input_2(data_x,data_y,"Speed-up",
                "Mode-switch Temperature(Celsius)", str("Max Temp Coverage:") + str(temp__el), 1, counter, n_colors, 1)
        counter +=1
    
    counter = 0
    #start_up_making_graph_2(2)
    #ax2.ticklabel_format(useOffset=False)
    for temp__el in max_temp_key_list:
        switching_temp_speed_up =\
                max_temperature__switching_temp_speed_up__curve[temp__el]
        data_x = map(lambda x: x[0], switching_temp_speed_up)
        data_y = map(lambda x: x[1], switching_temp_speed_up)
        generate_graph_2d_for_one_set_of_input_2(data_x,
                data_y,"Speed-up",
                "Mode-switch Temperature(Celsius)", str("Max Temp Coverage:") + str(temp__el), 1, counter,
                n_colors, 2)
        counter +=1
    
    
    #finish_up_making_graph(ax, "Speed-up vs Mode-Switch Temperature ",\
    #        "Speed-up vs Mode-Switch Temperature")
    finish_up_making_graph_2(" ",\
            "Speed-up_vs_Mode-Switch_Temperature_Multiplier")





#     results__f = open("temp_vs_time__results.txt", "w")
#    for el in data_y:
#        results__f.write(str(el)+ ","+ str(data_1__d[el][0])+ ","+\
#                str(data_1__d[el][1])+","+ str(data_2__d[el][0])+","+\
#                str(data_2__d[el][1]) +"\n")
    
#     results__f.close()





def get_max_temp__switching_temp__per_file(src1__f__addr):
    #src1__f__addr = "blah.txt" 
    temp__delay_tuple__d =  extract_delay_for_vaiours_temperatures(src1__f__addr)
    
    """ 
    for el in temp__delay_tuple__d.keys():
        print str(el) + " " + str(temp__delay_tuple__d[el])
    return
    """
    
    max_temp__switching_temp__delay__d = {} 
    for temp__val in temp__delay_tuple__d.keys():
        max_temp__switching_temp__delay__d[temp__val]  = -1
    
    for temp_1 in temp__delay_tuple__d.keys():
        for temp_2 in temp__delay_tuple__d.keys():
            if (temp_2 < temp_1):
                if (temp__delay_tuple__d[temp_2][1] <\
                        temp__delay_tuple__d[temp_1][0]):
                    max_temp__switching_temp__delay__d[temp_1]  =\
                        max(max_temp__switching_temp__delay__d[temp_1], temp_2)

    return max_temp__switching_temp__delay__d 
    """     
    for el in temp__delay_tuple__d.keys():
        print str(el) + " " + str(temp__delay_tuple__d[el])
    
    print "-------------------" 
    for el in max_temp__switching_temp__delay__d:
        print str(el) + " " + str(max_temp__switching_temp__delay__d[el])
    sys.exit() 
    """

def plot():
    src1__f__addr = "blah.txt"
    src2__f__addr = "blah2.txt"
    data_1__d =  extract_delay_for_vaiours_temperatures(src1__f__addr)
    data_1__24 = map(lambda x: data_1__d[x][0],
            data_1__d.keys())
    data_1__32 = map(lambda x: data_1__d[x][1],
            data_1__d.keys())


    data_2__d =  extract_delay_for_vaiours_temperatures(src2__f__addr)
    data_2__24 = map(lambda x: data_2__d[x][0],
            data_2__d.keys())
    data_2__32 = map(lambda x: data_2__d[x][1],
            data_2__d.keys())
    
    data_y = data_2__d.keys()
    data_y = data_1__d.keys()

    fig, ax  = start_up_making_graph()
    generate_graph_2d_for_one_set_of_input(ax, fig, data_y, data_1__24,"temp",
            "time", "ourDesign, precision=24", 1, 0)
    generate_graph_2d_for_one_set_of_input(ax, fig, data_y, data_1__32,"temp",
            "time", "ourDesign, precision=32", 2, 0)

    generate_graph_2d_for_one_set_of_input(ax, fig, data_y, data_2__24,"temp",
            "time", "best Design, precision=24", 3, 1)
    generate_graph_2d_for_one_set_of_input(ax, fig, data_y, data_2__32,"temp",
            "time", "best Design, precision=32", 4, 1)

    finish_up_making_graph(ax, "temp vs time for various designs", "temp_vs_time")

    results__f = open("temp_vs_time__results.txt", "w")
    for el in data_y:
        results__f.write(str(el)+ ","+ str(data_1__d[el][0])+ ","+\
                str(data_1__d[el][1])+","+ str(data_2__d[el][0])+","+\
                str(data_2__d[el][1]) +"\n")
    
    results__f.close()

#*** F:DN Area
def plot_2():
    adder__x = [float(.149)/float(.133), float(.149)/float(.138),
            float(.149)/float(.140)]
    adder__y = [float(694)/float(549), float(687.61)/float(549),
            float(748)/float(549)]
#    adder__y = [float(1.93)/float(1.799), float(1.9595)/float(1.799),
#            float(2.1844)/float(1.799)]
    
    multiplier__x = [float(.546)/float(.493), float(.546)/float(.499),
            float(.546)/float(.503)]
    multiplier__y = [float(11532)/float(9814), float(11995)/float(9814),
            float(12914)/float(9814)]
#    multiplier__y = [float(17.548)/float(20.38), float(19.776)/float(20.38),
#            float(23.4304)/float(20.38)]

    fig, ax  = start_up_making_graph()
    #generate_graph_2d_for_one_set_of_input(ax, fig, adder__x, adder__y,"Speed-up",
    #        "Normalized Area", "Adder Design Points", 1, 1)
    generate_graph_2d_for_one_set_of_input(ax, fig, multiplier__x,
            multiplier__y,"Speed-up",
            "Normalized Area", "Multiplier Design Points", 1, 8)

    finish_up_making_graph(ax, " ", "Area")



#*** F:DN Power
def plot_3():
    adder__x = [float(.149)/float(.133), float(.149)/float(.138),
            float(.149)/float(.140)]
    
    adder__y = [float(1.93)/float(1.799), float(1.9595)/float(1.799),
            float(2.1844)/float(1.799)]
    
    multiplier__x = [float(.546)/float(.493), float(.546)/float(.499),
            float(.546)/float(.503)]

    multiplier__y = [float(17.548)/float(20.38), float(19.776)/float(20.38),
            float(23.4304)/float(20.38)]

    fig, ax  = start_up_making_graph()
   # generate_graph_2d_for_one_set_of_input(ax, fig, adder__x, adder__y,"Speed-up",
   #         "Normalized Power", "Adder Design Points", 1, 1)
    generate_graph_2d_for_one_set_of_input(ax, fig, multiplier__x,
            multiplier__y,"Speed-up",
            "Normalized Power", "Multiplier Design Points", 1, 8)

    finish_up_making_graph(ax, " ", "Power")




#plot()
plot_1()
#plot_2()
#plot_3()

#----------------------------------------------------
# *** F:HTN  specify the addr of two files you want to parse, and the plot is generated
#            e.g:
#            src_1__addr = mac_32__clk_0.48__acc_max_del_0__Pn_24__atmpt_-1__id_DFDL__evol_log.txt
#----------------------------------------------------
