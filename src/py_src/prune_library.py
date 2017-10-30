#----------------------------------------------------#
#--- F: this module allow us to prune the library (.lib)
#----------------------------------------------------



def source_file__parse(sourceFileName):
    #----------------------------------------------------
    # ---- F: Variables
    #----------------------------------------------------
    open_brace__c = 0
    pray_found = False
    writing_state = "do_write"
    #eliminate__pre_processed__l = ["AND2_X1"]
    #eliminate__l = ["AND2_X1"],   
    all_cells = ['AND2_X1', 'AND2_X2', 'AND2_X4', 'AND3_X1', 'AND4_X1', 'AOI211_X1', 'AOI21_X1',
        'AOI21_X2', 'AOI221_X1', 'AOI222_X1', 'AOI22_X1', 'AOI22_X2', 'BUF_X1',
        'BUF_X2', 'BUF_X4', 'BUF_X8', 'CLKBUF_X1', 'DFFRS_X1', 'DFFR_X1',
        'DFFR_X2', 'DFF_X1', 'DFF_X2', 'DLH_X1', 'DLH_X2', 'DLL_X1', 'FA_X1',
        'HA_X1', 'INV_X1', 'INV_X2', 'INV_X4', 'INV_X8', 'LOGIC0_X1',
        'LOGIC1_X1', 'MUX2_X1', 'MUX2_X2', 'NAND2_X1', 'NAND2_X2', 'NAND2_X4',
        'NAND3_X1', 'NAND3_X2', 'NAND3_X4', 'NAND4_X1', 'NOR2_X1', 'NOR2_X2',
        'NOR2_X4', 'NOR3_X1', 'NOR3_X2', 'NOR3_X4', 'NOR4_X1', 'OAI211_X1',
        'OAI21_X1', 'OAI21_X2', 'OAI221_X1', 'OAI222_X1', 'OAI22_X1',
        'OAI22_X2', 'OR2_X1', 'OR2_X2', 'OR2_X4', 'OR3_X1', 'OR4_X1', 'TBUF_X1',
        'TBUF_X2', 'TINV_X1', 'XNOR2_X1', 'XNOR2_X2', 'XOR2_X1', 'XOR2_X2']


    cells_to_keep__l = ['AND2_X4', 'AND3_X1', 'AND4_X1', 'AOI211_X1', \
        'AOI21_X2', 'AOI221_X1', 'AOI222_X1', 'AOI22_X2', 'BUF_X8', 'CLKBUF_X1',\
        'DFFRS_X1', 'DFFR_X2', 'DFF_X2', 'DLH_X2', 'DLL_X1', 'FA_X1','HA_X1', \
        'INV_X8', 'LOGIC0_X1', 'LOGIC1_X1', 'MUX2_X2', 'NAND2_X4', \
        'NAND3_X4', 'NAND4_X1', 'NOR2_X4', 'NOR3_X4', 'NOR4_X1', 'OAI211_X1', \
        'OAI21_X2', 'OAI221_X1', 'OAI222_X1', 'OAI22_X2', 'OR2_X4', 'OR3_X1', \
        'OR4_X1', 'TBUF_X2', 'TINV_X1', 'XNOR2_X2', 'XOR2_X2']


    
    #eliminate__l = map(lambda x: "Cell("+x+")", eliminate__pre_processed__l)
    modified_lib__na = "noAging.lib__modified" 
    modified_lib__base_dir__addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/lib" 
    modified_lib__addr = modified_lib__base_dir__addr + "/" + modified_lib__na  
    modified_lib__handle = open(modified_lib__addr, "w")
    line_nu = 0 
    #----------------------------------------------------
    # ---- F: Body
    #----------------------------------------------------
    try:
        f = open(sourceFileName)
    except IOError:
        handleIOError(sourceFileName, "csource file")
        exit()
    else:
        found_one = False
        line_nu = 0
        f = open(sourceFileName)
        with f:
            for line in f:
                line_nu +=1
                word_list =   line.strip().replace(',', ' ').replace('/','').replace(';', ' ').split(' ') #find the lines with key word and write it to another file   
                #---  finding the body a certain cell
                if (writing_state in ["start_body", "in_body"]):                
                    writing_state = "in_body"
                    for el in word_list:
                        if el == '{':
                            open_brace__c +=1
                        if el == '}':
                            open_brace__c -=1

                #--- founding the right cell
                if ("cell(" in word_list[0]):
                    cell__na = word_list[0][5:-1]
                    if not(cell__na in cells_to_keep__l):
                        writing_state = "start_body"
                        #pray_found = True
                        for el in word_list:
                            if el == '{':
                                open_brace__c +=1
                            if el == '}':
                                open_brace__c -=1
            
                
                #--- F: writing state 
                if not(writing_state in ["in_body", "start_body", "end_body"]):
                    modified_lib__handle.write(line)

                
                #--- F: resetting pray_found  
                if (open_brace__c == 0):
                    if(writing_state == "in_body"):
                        writing_state = "end_body" 
                    else:
                        writing_state = "do_write"
                
                

    modified_lib__handle.close()

def find_all_cells(sourceFileName):
    cell__l = [] 
    try:
        f = open(sourceFileName)
    except IOError:
        handleIOError(sourceFileName, "csource file")
        exit()
    else:
        found_one = False
        line_nu = 0
        f = open(sourceFileName)
        with f:
            for line in f:
                line_nu +=1
                word_list =   line.strip().replace(',', ' ').\
                        replace('/','').replace(';', ' ').split(' ') \
                        #find the lines with key word and write it to another file   

                #--- founding the right cell
                if ("cell(" in word_list[0]):
                    cell__na = word_list[0][5:-1]
                    cell__l.append(cell__na) 
    
    return cell__l
     

def main():
    #--- parameters 
    source_file__na = "noAging.lib1"
    base_dir__addr = "/home/local/bulkhead/behzad/usr/local/verilog_files/libraries/germany_NanGate/lib" 
    source_file__addr = base_dir__addr + "/" + source_file__na
    
    #--- activate this if you want to find all the cells
    #---- then parse them
    #all_cells = find_all_cells(source_file__addr) 
    #print all_cells
    source_file__parse(source_file__addr)
    
main()
