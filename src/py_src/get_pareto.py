import matplotlib.pyplot as plt
import sys
import math
#import settings 
# Copyright (C) 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# 

## 
# @file extract_pareto_set_from_raw_material.py
# @brief this file contains module regarding extracting the pareto set from the raw material
# @author Jamie Bull
# @date 2015-08-03


'''
Method to take two equally-sized lists and return just the elements which lie 
on the Pareto frontier, sorted into order.
Default behaviour is to find the maximum for both X and Y, but the option is
available to specify maxX = False or maxY = False to find the minimum for either
or both of the parameters.
'''
def get_x(point):
    return point[0]
def get_y(point):
    return point[1]


def pareto_frontier(lOfPoints , maxX , maxY):
    
    # Sort the list in either ascending or descending order of X
    Xs = []  
    Ys = []  
    for point in lOfPoints:
        Xs.append(get_x(point))
        Ys.append(get_y(point))

    # ---- now get pareto front by sorting out Y
    myList = sorted([[Xs[i], Ys[i], i] for i in range(len(Xs))], reverse=maxX)
    # Start the Pareto frontier with the first value in the sorted list
    p_front = [myList[0]]    
    # Loop through the sorted list
    for pair in myList[1:]:
        if maxY: 
            if pair[1] > p_front[-1][1]: #Look for higher values of Y 
                if (maxX): 
                    if (p_front[-1][0] == pair[0]):
                        p_front[-1] = pair
                    else: 
                        p_front.append(pair) # and add them to the Pareto frontier
                else: 
                    p_front.append(pair) #and add them to the Pareto frontier
        else:
            if pair[1] < p_front[-1][1]: # Look for lower values of Y
                if (maxX): 
                    if (p_front[-1][0] == pair[0]):
                        p_front[-1] = pair
                    else: 
                        p_front.append(pair) # and add them to the Pareto frontier
                else: 
                    p_front.append(pair) # and add them to the Pareto frontier
    # Turn resulting pairs back into a list of Xs and Ys
     
    p_frontX_Y_sorted = [pair[0] for pair in p_front]
    p_frontY_Y_sorted = [pair[1] for pair in p_front]
    p_index_Y_sorted = [pair[2] for pair in p_front] 
    # return p_frontX, p_frontY
    lOfParetoPoints = [] 
    
    lOfIndex = set(p_index_Y_sorted).intersection(p_index_Y_sorted) 
    #print p_index_Y_sorted
    # print p_index_X_sorted
    #print lOfIndex 
    for index in sorted(lOfIndex):
        lOfParetoPoints.append(lOfPoints[index])
    
    
    
    return lOfParetoPoints

"""
def all_pareto_frontiers(lOfPoints , maxX , maxY, settings_obj) :
    if (len(lOfPoints) ==  0):
        return []
    
    quality_energy_list = []
    for el in lOfPoints:
        quality_energy_list.append((el.get_x(), el.get_y()))
    if (settings_obj.DEBUG): 
        print "points (before pareto extraction): " + str(quality_energy_list)
    
    # Sort the list in either ascending or descending order of X
    Xs = []  
    Ys = []  
    for point in lOfPoints:
        if (point.get_dealing_with_pics()):
            Xs.append(point.get_PSNR())
        else:
            Xs.append(point.get_x())
        Ys.append(point.get_y())

    # ---- now get pareto front by sorting out Y
    myList = sorted([[Xs[i], Ys[i], i] for i in range(len(Xs))], reverse=maxX)
    # Start the Pareto frontier with the first value in the sorted list
    p_front = [myList[0]]    
    # Loop through the sorted list
    for pair in myList[1:]:
        if maxY: 
            if pair[1] > p_front[-1][1]: #Look for higher values of Y 
                if (maxX): 
                    if (p_front[-1][0] == pair[0]):
                        p_front[-1] = pair
                    else: 
                        p_front.append(pair) # and add them to the Pareto frontier
                else: 
                    p_front.append(pair) #and add them to the Pareto frontier
        else:
            if pair[1] < p_front[-1][1]: # Look for lower values of Y
                if (maxX): 
                    if (p_front[-1][0] == pair[0]):
                        p_front[-1] = pair
                    else: 
                        p_front.append(pair) # and add them to the Pareto frontier
                else: 
                    p_front.append(pair) # and add them to the Pareto frontier
    # Turn resulting pairs back into a list of Xs and Ys
    p_frontX_Y_sorted = [pair[0] for pair in p_front]
    p_frontY_Y_sorted = [pair[1] for pair in p_front]
    p_index_Y_sorted = [pair[2] for pair in p_front] 
    # return p_frontX, p_frontY
    lOfParetoPoints = [] 
    lOfIndex = set(p_index_Y_sorted).intersection(p_index_Y_sorted) 
    for index in sorted(lOfIndex):
        lOfParetoPoints.append(lOfPoints[index])
    
    
    for el in lOfParetoPoints:
        lOfPoints.remove(el)
   

    lOfParetoPoints = [lOfParetoPoints] + all_pareto_frontiers(lOfPoints, maxX, maxY, settings_obj)

    return lOfParetoPoints



def pareto_frontier_2(lOfPoints , maxX , maxY ):
    # Sort the list in either ascending or descending order of X
    Xs = []  
    Ys = []  
    for point in lOfPoints:
        
        if (point.get_dealing_with_pics()):
            Xs.append(point.get_PSNR())
        else:
            Xs.append(point.get_x())
        
        Ys.append(point.get_y())

    
    myList = sorted([[Xs[i], Ys[i], i] for i in range(len(Xs))], reverse=maxY)
    # Start the Pareto frontier with the first value in the sorted list
    p_front = [myList[0]]    
    # Loop through the sorted list
    for pair in myList[1:]:
        if maxY: 
            if pair[0] >= p_front[-1][0]: #Look for higher values of Y 
                p_front.append(pair) #and add them to the Pareto frontier
        else:
            if pair[0] <= p_front[-1][0]: # Look for lower values of Y
                p_front.append(pair) # and add them to the Pareto frontier
    # Turn resulting pairs back into a list of Xs and Ys
    p_frontX = [pair[0] for pair in p_front]
    p_frontY = [pair[1] for pair in p_front]
    p_index = [pair[2] for pair in p_front] 
    # return p_frontX, p_frontY
    lOfParetoPoints = [] 
    for index in sorted(p_index):
        lOfParetoPoints.append(lOfPoints[index])
    return lOfParetoPoints



def pareto_frontier_revised(lOfPoints , maxX , maxY):
    # Sort the list in either ascending or descending order of X
    Xs = []  
    Ys = []  
    for point in lOfPoints:
        Xs.append(point.get_error())
        Ys.append(point.get_y())
    
    myList = sorted([[Xs[i], Ys[i], i] for i in range(len(Xs))], reverse=maxX)
    # Start the Pareto frontier with the first value in the sorted list
    numberOfDevisions = 100  
    upperBoundX = myList[-1][0]
    lowerBoundX =  myList[0][0]
    devisionSize = math.fabs(upperBoundX - lowerBoundX)/numberOfDevisions
    rangeList = [[] for i in range(numberOfDevisions)] 
    for devNum in range(numberOfDevisions):
        lowerBoundX = devNum*devisionSize
        upperBoundX = (devNum+1)*devisionSize
        for element in myList:
            if lowerBoundX < element[0] <= upperBoundX:
                rangeList[devNum].append(element)
            if element[0] >  upperBoundX:
                break
    lOfParetoPoints = [] 
    for listValues in rangeList:
        if (listValues):
            lOfParetoPoints.append(lOfPoints[min(listValues, key= lambda x: x[1])[2]])
    print lOfParetoPoints
    print "*******"
    return lOfParetoPoints



def extract_all_pareto_frontier(lOfPoints , maxX , maxY):
    # Sort the list in either ascending or descending order of X
    Xs = []  
    Ys = []  
    for point in lOfPoints:
        
        if (point.get_dealing_with_pics()):
            Xs.append(point.get_PSNR())
        else:
            Xs.append(point.get_x())
        
        Ys.append(point.get_y())

    
    myList = sorted([[Xs[i], Ys[i], i] for i in range(len(Xs))], reverse=earaxX)
    # Start the Pareto frontier with the first value in the sorted list
    lOfAllParetoFronts = [] 
    p_front = [myList[0]]    
    lOfAllParetoFronts.append(p_front)
    # Loop through the sorted list
    for pair in myList[1:]:
        if maxY: 
            for index,paretoFrontEelement in enumerate(lOfAllParetoFronts):
                if pair[1] >= paretoFrontEelement [-1][1]: #Look for higher values of Y 
                    lOfAllParetoFronts[index].append(pair) #and add them to the Pareto frontier
                    continue
            lOfAllParetoFronts.append(pair)      
        else:
            for index,paretoFrontEelement in enumerate(lOfAllParetoFronts):
                if pair[1] <= p_front[-1][1]: # Look for lower values of Y
                    lOfAllParetoFronts.append(pair) # and add them to the Pareto frontier
                    continue
            lOfAllParetoFronts.append(pair)      
    # Turn resulting pairs back into a list of Xs and Ys
    for index,paretoFront in enumerate(lOfAllParetoFronts):
        # p_frontX = [pair[0] for pair in paretoFront]
        # p_frontY = [pair[1] for pair in paretoFront]
        lOfP_index.append([pair[2] for pair in paretoFront])
    # return p_frontX, p_frontY
    lOflOfParetoPoints = [] 
    for p_index in lOfP_index: 
        lOfParetoPoints = []  
        for index in sorted(p_index):
            lOfParetoPoints.append(lOfPoints[index])
        lOflOfParetoPoints.append(lOfParetoPoints) 
    return lOflOfParetoPoints

"""



#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------guide::: testing
def paretoTest():
    x = [1,2,3,4,5,6,7,8]
    y = [100,80,90, 40, 85, 30, 10,15]
    #print zip(x,y)
    maxX = False
    maxY = False
    lOfPoints = pareto_frontier(zip(x,y), maxX , maxY)
    paretoX = list(map(lambda x: get_x(x),lOfPoints))
    paretoY = map(lambda x: get_y(x),lOfPoints)
    plt.plot(x, y, 'rx')
    plt.plot(paretoX, paretoY, 'go')
    plt.show()

#paretoTest()
