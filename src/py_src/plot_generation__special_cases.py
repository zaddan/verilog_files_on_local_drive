#*** F:DN generating various plots
from plot_generation import *
# *** F:DN noFF
def acc_vs_full_coverage__noFF():    
    x_gen =  range(0, 100, 5)
   
    # *** F:DN Data for Pn=24 
    acceptable_slowDown__0 = 100*((.454/.454) - 1)
    acceptable_slowDown__1 = 100*((.48/.454) - 1)
    acceptable_slowDown__2 = 100*((.5/.454) - 1)
    acceptable_slowDown__3 = 100*((.525/.454) - 1)
    
    # *** F:DN Data for Pn=28 
    acceptable_slowDown__4 = 100*((.52/.454) - 1)
    acceptable_slowDown__5 = 100*((.54/.454) - 1)

    
    # *** F:DN Data for Pn=24 
    x_24_0 = filter (lambda x: x>= acceptable_slowDown__0, x_gen)
    x_24_1 = filter (lambda x: x>= acceptable_slowDown__1, x_gen)
    x_24_2 = filter (lambda x: x>= acceptable_slowDown__2, x_gen)
    x_24_3 = filter (lambda x: x>= acceptable_slowDown__3, x_gen)

    # *** F:DN Data for Pn=28 
    x_28_1 = filter (lambda x: x>= acceptable_slowDown__4, x_gen)
    x_28_2 = filter (lambda x: x>= acceptable_slowDown__5, x_gen)


    # *** F:DN Data for Pn=24 
    slope_0 = .454/.454 
    slope_1 = .48/.422 
    slope_2 = .50/.409 
    slope_3 = .525/.405 
    
    # *** F:DN Data for Pn=28 
    slope_4 = .52/.443 
    slope_5 = .54/.439 
    
    # *** F:DN Data for Pn=24 
    speedUp__0 = float("{0:.3f}".format(.454/.454)) #up to 2
    speedUp__1 = float("{0:.3f}".format(.454/.422)) #up to 2
    speedUp__2 = float("{0:.3f}".format(.454/.409)) #up to 2
    speedUp__3 = float("{0:.3f}".format(.454/.405)) #up to 2

    # *** F:DN Data for Pn=28 
    speedUp__4 = float("{0:.3f}".format(.454/.443)) #up to 2
    speedUp__5 = float("{0:.3f}".format(.454/.439)) #up to 2

    y_24_0 = map(lambda x: slope_0*(1+x) - 1, x_24_0)
    y_24_1 = map(lambda x: slope_1*(1+x) - 1, x_24_1)
    y_24_2 = map(lambda x: slope_2*(1+x) -1, x_24_2)
    y_24_3 = map(lambda x: slope_3*(1 + x) - 1, x_24_3)
    

    y_28_1 = map(lambda x: slope_4*(1 + x) - 1, x_28_1)
    y_28_2 = map(lambda x: slope_5*(1 + x) - 1, x_28_2)

    fig, ax  = start_up_making_graph()
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_0,y_24_0,
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__0)+ " Pn=" + str(24) , 1, 0)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_1,y_24_1, 
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__1) + " Pn=" + str(24) , 1, 1)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_2,y_24_2, 
            "Accurate SlowDown Coverage Acquired (%)",
            "Full SlowDown Coverage Requested (%)", 
            "speedUp=" + str(speedUp__2) + " Pn=" + str(24), 1, 2 )
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_3,y_24_3,
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__3) + " Pn=" + str(24), 1, 3)
    
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_28_1,y_28_1,
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__4)+ " Pn=" + str(28), 2, 4)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_28_2,y_28_2,
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__5)+ " Pn=" + str(28), 2, 5)
    
    finish_up_making_graph(ax, 
    "Accurate Coverage Vs full Coverage for Precision of 24 and 28", 
    "acc_vs_full_coverage__Pn_24_28__noFF")


# *** F:DN FF
def acc_vs_full_coverage__FF():
    x_gen =  range(0, 100, 5)
   
    # *** F:DN Data for Pn=24 
    acceptable_slowDown__0 = 100*((.602/.602) - 1)
    acceptable_slowDown__1 = 100*((.64/.602) - 1)
    acceptable_slowDown__2 = 100*((.65/.602) - 1)
    acceptable_slowDown__3 = 100*((.67/.602) - 1)
    

    # *** F:DN Data for Pn=24 
    x_24_0 = filter (lambda x: x>= acceptable_slowDown__0, x_gen)
    x_24_1 = filter (lambda x: x>= acceptable_slowDown__1, x_gen)
    x_24_2 = filter (lambda x: x>= acceptable_slowDown__2, x_gen)
    x_24_3 = filter (lambda x: x>= acceptable_slowDown__3, x_gen)



    # *** F:DN Data for Pn=24 
    slope_0 = .602/.602 
    slope_1 = .64/.555 
    slope_2 = .65/.541 
    slope_3 = .67/.503 
    
   # *** F:DN Data for Pn=24 
    speedUp__0 = float("{0:.3f}".format(.602/.602)) #up to 2
    speedUp__1 = float("{0:.3f}".format(.602/.555)) #up to 2
    speedUp__2 = float("{0:.3f}".format(.602/.541)) #up to 2
    speedUp__3 = float("{0:.3f}".format(.602/.503)) #up to 2


    y_24_0 = map(lambda x: slope_0*(1+x) - 1, x_24_0)
    y_24_1 = map(lambda x: slope_1*(1+x) - 1, x_24_1)
    y_24_2 = map(lambda x: slope_2*(1+x) -1, x_24_2)
    y_24_3 = map(lambda x: slope_3*(1 + x) - 1, x_24_3)
    


    fig, ax  = start_up_making_graph()
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_0,y_24_0,
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__0)+ " Pn=" + str(24) , 1, 0)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_1,y_24_1, 
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__1) + " Pn=" + str(24) , 1, 1)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_2,y_24_2, 
            "Accurate SlowDown Coverage Acquired (%)",
            "Full SlowDown Coverage Requested (%)", 
            "speedUp=" + str(speedUp__2) + " Pn=" + str(24), 1, 2 )
    
    generate_graph_2d_for_one_set_of_input(ax, fig, x_24_3,y_24_3,
            "Accurate SlowDown Coverage Acquired (%)", 
            "Full SlowDown Coverage Requested (%)",
            "speedUp=" + str(speedUp__3) + " Pn=" + str(24), 1, 3)
    
   
    finish_up_making_graph(ax, 
    "Accurate Coverage Vs full Coverage for Precision of 24", 
    "acc_vs_full_coverage__Pn_24__FF")


def speedup_vs_power():
    fig, ax  = start_up_making_graph()
    """  
    add_speedup = [(.209/.223 -1), .209/.197 -1, .209/.194-1]
    add_energy =  [.5180/.2858 - 1, .341007/.2858 -1, .3270/.2858 -1]
    
    mul_speedup = [(.743/.686-1), .743/.7075 -1, .743/.732 -1 ]
    mul_energy = [ 17.314/10.962 -1, 14.597/10.962 -1, 15.162/10.962 -1]
    
    idct_speedup =  [(.825/.673-1), .825/.761-1, .825/.758-1]
    idct_energy =  [ 1.732/1.598 -1 , 1.849/1.598 -1 , 1.652/1.598 -1]
    """

    add_speedup = [ .209/.197 -1, .209/.194-1]
    add_energy =  [.341007/.2858 -1, .3270/.2858 -1]
    
    mul_speedup = [ .743/.7075 -1, .743/.732 -1 ]
    mul_energy = [ 14.597/10.962 -1, 15.162/10.962 -1]
    
    idct_speedup =  [.825/.761-1, .825/.758-1]
    idct_energy =  [ 1.849/1.598 -1 , 1.652/1.598 -1]


    generate_graph_2d_for_one_set_of_input(ax, fig,add_speedup,add_energy,
            "Speed-up (%)", 
            "Energy (%)",
            "Adder" , 1, 0)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, mul_speedup,mul_energy, 
            "Speed-up (%)", 
            "Energy (%)",
            "Multiplier" , 1, 1)
    
    generate_graph_2d_for_one_set_of_input(ax, fig, idct_speedup,idct_energy, 
            "Speed-up (%)", 
            "Energy (%)",
            "IDCT" , 1, 2)





    finish_up_making_graph(ax, 
    "Speedup vs Energy Speedup", 
    "Speedup vs Energy Speedup")





#acc_vs_full_coverage__noFF()
speedup_vs_power()


#acc_vs_full_coverage__FF()



