import os
import sys
import glob

def getNameOfFilesInAFolder(folderAddress):
    if not(os.path.isdir(folderAddress)):
            print "the folder with the name " + folderAddress + " (for which you requested to get the files for does not exist, so we are making it" 
            
    return glob.glob(folderAddress + "/*")


def main():
    lib__dir__addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/db"
    print getNameOfFilesInAFolder(lib__dir__addr)


#main()
