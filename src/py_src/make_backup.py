import os
import sys
import glob
from termcolor import colored

def getNameOfFilesInAFolder(folderAddress):
    if not(os.path.isdir(folderAddress)):
            print "the folder with the name " + folderAddress + " (for which you requested to get the files for does not exist, so we are making it" 
            os.system("mkdir " + folderAddress) 
            
    return glob.glob(folderAddress + "/*")




def comeUpWithNewFolderNameAccordingly(folderToCopyTo):
    fileList = getNameOfFilesInAFolder(folderToCopyTo)
    if not(len(fileList) == 0): 
        newestFolder = max(glob.iglob(folderToCopyTo+"/*") , key=os.path.getctime) #getting the newst folder
        if((newestFolder[-3:]).isdigit()):
            suffix = newestFolder[-3:]
        elif((newestFolder[-2:]).isdigit()):
            suffix = newestFolder[-2:]
        elif((newestFolder[-1:]).isdigit()):
            suffix = newestFolder[-1:]
    else:
        suffix = -1 

    newFolderFullAddress = "backup_" + str(int(suffix) + 1)
    return newFolderFullAddress

#print comeUpWithNewFolderNameAccordingly("test_folder")

def main():
    #tcl_file = "unconfig_int_add.tcl" 
    #tcl_file = "config_int_add_inMux.tcl" 
    tcl_file = "config_int_add_clkGate.tcl" 
    
    print colored("make sure the tcl file is correct:" , 'blue')
    print colored(tcl_file , 'blue')
    base_address = "res_bu/" 
    backup_folder = comeUpWithNewFolderNameAccordingly("res_bu/")
    os.system("mkdir  "+ base_address + backup_folder)
    backup_folder = base_address + backup_folder
    
    #tcl_file = "config_int_add_inMux.tcl"
    #os.system("rm *.rpt ")
     
    #--- note: the following should be uncommented later 
    """ 
    os.system("python parsing_timing_results.py > info_logs.txt") 
    os.system("cp info_logs.txt  " + backup_folder)
    """
    os.system("cp *.rpt  " + backup_folder)
    
    """ 
    os.system("cp int_add_acc_ff_0_timing1.rpt  " + backup_folder)
    os.system("cp int_add_acc_ff_0_area.rpt  " + backup_folder)
    os.system("cp int_add_acc_ff_0_power.rpt  " + backup_folder)
    os.system("cp int_add_acc_ff_0_constrain_violators.rpt  " + backup_folder)
   """ 
    os.system("cp *.png  " + backup_folder)
    os.system("cp /home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/scripts/"+
            tcl_file + " " + backup_folder)
    os.system("rm *.rpt")

main()
