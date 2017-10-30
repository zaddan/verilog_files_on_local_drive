#----------------------------------------------------
# --- F: use this to read timing.rpt files within a directory and collect reg
# information
#--- set the folder_addr (the folder you want the module to go through to
#--- collect ino
#----------------------------------------------------


import os
import glob
def getNameOfFilesInAFolder(folderAddress):
    if not(os.path.isdir(folderAddress)):
            print "the folder (for which you requested to get the files for does not exist" 
            print folderAddress 
            exit()
    else:
        return glob.glob(folderAddress + "/*")


def parse_for_data(sourceFileName):
    start_sampling = False
    stop_sampling = False
   

    print "----------------------------------------------------"
    print "----------------------------------------------------"
    try:                                                                        
        f = open(sourceFileName)                                                
    except IOError:                                                             
        print sourceFileName + " file not found"
        sys.exit(0); 
        #exit()                                                                  
    else:                                                                       
        with f:                                                                 
            for line in f:                                                      
                word = line.rstrip().split()
                if (len(word)>2): 
                    if (word[0] == "---" and word[1] == "TCL'S" and \
                            "PARAMETER"):
                        start_sampling = True
                    if (word[0] == "----" and word[1] == "TIMING" and word[2] == \
                                "REPORT"):
                        stop_sampling = True

                if (stop_sampling):
                    break
                if (start_sampling):
                    print line.rstrip()
    print "----------------------------------------------------"
    print "----------------------------------------------------"


def main():
    #---------------------------------------------------- 
    #--- F: Parameters 
    #---------------------------------------------------- 
    folder_addr = \
    "/home/local/bulkhead/behzad/usr/local/verilog_files/apx_operators/int_ops_apx/build/syn/reports/data_collected/noFF_mac/arch_specific/benc_radix4_mux/1111/" 
    
    #---------------------------------------------------- 
    #--- F: Body
    #---------------------------------------------------- 
    for file_na in getNameOfFilesInAFolder(folder_addr):
        if not("py" in file_na) and not("01_data_collected" in file_na) and \
        not("results_gathered" in file_na):
            parse_for_data(file_na)


main()
