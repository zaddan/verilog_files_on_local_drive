# *** F:DN parse through the prog_flow files and print/plot the pareto front

import matplotlib.pyplot as plt
from get_pareto import *
def parse_for_data(sourceFileName):
    result = []
    try:                                                                        
        f = open(sourceFileName)                                                
    except IOError:                                                             
        print sourceFileName + " file not found"
        sys.exit(0); 
        #exit()                                                                  
    else:                                                                       
        with f:                                                                 
            for line in f:                                                      
                word = line.rstrip().replace("{", ",").replace(":",
            ",").replace("}", ",").replace("'",",")
                word = word.split(",") 
                if (len(word)>0): 
                    if (word[0] == "currentDesignsPrecision_delay__d"):
                        x = word[-2] 
                    if (word[0] == "clk__aqcuired"):
                        result.append((float(x), float(word[-1])))
                    """ 
                    if ("attempt" in word):
                        result__meta_data.append((word[-3], word[-1]))
                    """
    return result

def main():
#    source__f__na = sys.argv[1] 
    #--- for multiplier 
    source__f__na__l = \
                    ["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__1/delay_profile_design__full_width/mul/delay_profile_naive/32_24/2017_08_18__17_33_11/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__1.v_32__clk_0.57__id_SCBSD__1__progress_flow_chart.txt",
                   "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__1/delay_profile_design__full_width/mul/delay_profile_naive/32_24/2017_08_21__20_02_02/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__1.v_32__clk_0.55__id_SCBSD__1__progress_flow_chart.txt"]
                    #["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__1/delay_profile_design__full_width/mul/delay_profile_naive/32_24/2017_08_10__23_39_17/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__1.v_32__clk_0.57__id_SCBSD__1__progress_flow_chart.txt",
                    #        "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__3/delay_profile_design__full_width/mul/delay_profile__naive/32/2017_08_10__23_39_53/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__2.v_32__clk_0.59__id_SCBSD__2__progress_flow_chart.txt","/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__2/delay_profile_design__full_width/mul/delay_profile__naive/32/2017_08_10__23_41_06/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__3.v_32__clk_0.61__id_SCBSD__3__progress_flow_chart.txt" ]
                   
    #--- for add 
    """ 
    source__f__na__l = \
            ["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__3/delay_profile_design__full_width/add/32_24/2017_06_09__13_37_41/details/conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__3.v_32__clk_0.18__id_SCBSD__3__progress_flow_chart.txt","/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__1/delay_profile_design__full_width/add/32_24/2017_06_09__13_37_09/details/cont_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__1.v_32__clk_0.16__id_SCBSD__1__progress_flow_chart.txt",
                    "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__2/delay_profile_design__full_width/add/32_24/2017_06_09__13_37_21/details/conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__2.v_32__clk_0.17__id_SCBSD__2__progress_flow_chart.txt"]
    
    """ 
    result = [] 
    for source__f__el in source__f__na__l:
        result += parse_for_data(source__f__el)
    
    plt.xlabel("inaccurate delay")
    plt.ylabel("accurate delay")
    result__PF = pareto_frontier(result, False, False)
    paretoX = map(lambda x: get_x(x),result__PF)
    paretoY = map(lambda x: get_y(x),result__PF)
    
    allPointsX = map(lambda x: get_x(x),result)
    allPointsY = map(lambda x: get_y(x),result)
    print result__PF
    plt.plot(paretoX, paretoY, c="blue", label="white-box Pareto", marker="o", linestyle ="")
    plt.plot(allPointsX, allPointsY, c="r", label="white-box", marker="x", linestyle ="")
    #plt.plot([.499,.516], [.618,.587], 'ro', "all in one, more complex")
   
     
    #--- for multiply
    source__f__na__l = \
                    ["/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__1/delay_profile_design__full_width/mul/all_the_way/32_24/2017_06_01__04_00_00/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__1.v_32__clk_0.55__id_SCBSD__1__progress_flow_chart.txt",
                            "/home/local/pow/behzad/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/SCBSD__2/delay_profile_design__full_width/mul/all_the_way/32_24/2017_06_01__04_01_07/details/conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH24_DATA_PATH_BITWIDTH32__only_clk_cons_resynthesizedSCBSD__2.v_32__clk_0.58__id_SCBSD__2__progress_flow_chart.txt"]
    result = [] 
    for source__f__el in source__f__na__l:
        result += parse_for_data(source__f__el)
    
    result__PF = pareto_frontier(result, False, False)
    paretoX = map(lambda x: get_x(x),result__PF)
    paretoY = map(lambda x: get_y(x),result__PF)
    
    allPointsX = map(lambda x: get_x(x),result)
    allPointsY = map(lambda x: get_y(x),result)
    print result__PF
    plt.plot(paretoX, paretoY, c="g", label="all in one Pareto", marker="o", linestyle ="")
    plt.plot(allPointsX, allPointsY, c="y", label="all in one", marker="x", linestyle ="")
    #plt.plot([.499,.516], [.618,.587], 'ro', "all in one, more complex")
    #plt.plot([.499,.516], [.618,.587], c="r", label="all in one,more complex", marker="x", linestyle ="")
     
    plt.legend(loc='center left', bbox_to_anchor=(.5, .8))
    plt.savefig("accurate_inaccurate_PF")
#    plt.show()
main()
