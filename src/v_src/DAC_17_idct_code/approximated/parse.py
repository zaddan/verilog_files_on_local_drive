import sys
import numpy
def arithmatic_shift(value_in_hex, shift__amount):
    value = int(value_in_hex, 16) 
    return hex(numpy.uint32((numpy.right_shift(numpy.int32(value),
        shift__amount))))


def convert_to_hex(string_value):
    hex_val = '0x'+string_value
    hex_val = int(hex_val, 16)
    return hex(hex_val)

def parse_file(src_file):
    start_looking = False
    counter = 0
    info__l = [] 
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
                word_list = filter(lambda x: not(x==''), word_list) #getting rid of '' to extrat data easier

                if counter > 6: 
                    time = word_list[0] 
                    P = convert_to_hex(word_list[2])
                    P_tmp = convert_to_hex(word_list[3])
                    state = convert_to_hex(word_list[4])
                    info__l.append((time, P, P_tmp, state))
                    #print hex(int(P_tmp, 16) >> 8)
                counter +=1        
    return info__l

def shift_result(info__l1, info__l2):
    new_info__l1 = [] 
    counter = 0 
    for el in info__l1:
        if (counter >= min(len(info__l1), len(info__l2))):
            break
        modified__el = (el[0], hex(int(el[1], 16) >> 8), hex(int(el[2], 16) >> 8), el[3])
        new_info__l1.append(modified__el)
        counter +=1; 
    return new_info__l1  
# *** F:DN obvious
def main():
    src__f__na = "one_16_P_and_P_tmp_values.txt"
    info_for_one_16 = parse_file(src__f__na)

    src__f__na = "both_8_P_and_P_tmp_values.txt"
    info_for_both_8 = parse_file(src__f__na)

    info_for_one_16 = shift_result(info_for_one_16, info_for_both_8) 

    for index,el in enumerate(info_for_one_16):
        print info_for_both_8[index][1] + " " + info_for_both_8[index][2] + \
        " " + str(info_for_both_8[index][0]) + " ---- "+\
                info_for_one_16[index][1] + " " + info_for_one_16[index][2] +\
                " " +str(info_for_one_16[index][0])


#*** F:DN for comparing ps
def parse_file_2(src_file):
    start_looking = False
    counter = 0
    info__l = [] 
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
                word_list = filter(lambda x: not(x==''), word_list) #getting rid of '' to extrat data easier

                if counter > 5: 
                    time = word_list[0] 
                    state = int(convert_to_hex(word_list[2]), 16)
                    P__one_16 = convert_to_hex(word_list[3])
                    P__both_8 = convert_to_hex(word_list[4])
                    """ 
                    if (state == 2):
                        P__one_16__shifted = arithmatic_shift(P__one_16, 12)
                        P__both_8__shifted = arithmatic_shift(P__both_8, 7)
                        print str(P__both_8__shifted) + " "  + str(P__one_16__shifted)
                    """
                    if (state == 4):
                        P__one_16__shifted = arithmatic_shift(P__one_16, 0)
                        P__both_8__shifted = arithmatic_shift(P__both_8, 6)
                        print str(P__both_8__shifted) + " "  + str(P__one_16__shifted)
                counter +=1        




#*** F:DN for comparing sums
def parse_file_3(src_file):
    start_looking = False
    counter = 0
    info__l = [] 
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
                word_list = filter(lambda x: not(x==''), word_list) #getting rid of '' to extrat data easier

                if counter > 5: 
                    time = word_list[0] 
                    state = int(convert_to_hex(word_list[2]), 16)
                    Sum__one_16 = convert_to_hex(word_list[3])
                    Sum__both_8 = convert_to_hex(word_list[4])
                    k3 = int(convert_to_hex(word_list[5]), 16)
                    """  
                    if (state == 2) and (k3 == 7):
                        Sum__one_16__shifted = arithmatic_shift(Sum__one_16, 12)
                        Sum__both_8__shifted = arithmatic_shift(Sum__both_8, 7)
                        print str(Sum__both_8__shifted) + " "  + str(Sum__one_16__shifted)

                    """
                    if (state == 4) and (k3 == 7):
                        Sum__one_16__shifted = arithmatic_shift(Sum__one_16, 0)
                        Sum__both_8__shifted = arithmatic_shift(Sum__both_8, 6)
                        print str(Sum__both_8__shifted) + " "  + str(Sum__one_16__shifted)
                counter +=1        


# *** F:DN compare values
def parse_file_values(src_file):
    start_looking = False
    counter = 0
    info__l = [] 
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
                word_list = filter(lambda x: not(x==''), word_list) #getting rid of '' to extrat data easier

                if counter > 8: 
                    time = word_list[0] 
                    A__both_8 = convert_to_hex(word_list[2])
                    A__one_16 = convert_to_hex(word_list[3])
                    B__both_8 = convert_to_hex(word_list[4])
                    B__one_16  = convert_to_hex(word_list[5])
                    P__both_8 = convert_to_hex(word_list[6])
                    P__one_16 = convert_to_hex(word_list[7])
                    Sum__both_8 = convert_to_hex(word_list[8])
                    Sum__one_16 = convert_to_hex(word_list[9])
                    
                    state = int(convert_to_hex(word_list[10]), 16)
                    k3 = int(convert_to_hex(word_list[11]), 16)
                   
                    #*** F: fist stage 
                    # *** F:DN for Ps
                    if (state == 2):
                        P__both_8__shifted = arithmatic_shift(P__both_8, 7)
                        P__one_16__shifted = arithmatic_shift(P__one_16, 15)
                        print str(P__both_8__shifted) + " "  +\
                                str(P__one_16__shifted) + " " + \
                                str("----------") + " "+ \
                                str(A__both_8) + " "  + \
                                str(A__one_16) + " "  + \
                                str(B__both_8) + " "  + \
                                str(B__one_16) + " "  + \
                                str(P__both_8) + " "  + \
                                str(P__one_16) + " "


                    # *** F:DN for Sums
#                    if (state == 2) and (k3 == 7):
#                        Sum__one_16__shifted = arithmatic_shift(Sum__one_16, 12)
#                        Sum__both_8__shifted = arithmatic_shift(Sum__both_8, 7)
#                        print str(Sum__both_8__shifted) + " "  + str(Sum__one_16__shifted)
#                    
                    """
                    #*** F: second stage 
                    # *** F:DN for Ps
                    if (state == 4):
                        P__both_8__shifted = arithmatic_shift(P__both_8, 0)
                        P__one_16__shifted = arithmatic_shift(P__one_16, 2)
                        print str(P__both_8__shifted) + " "  +\
                                str(P__one_16__shifted) + " " + \
                                str("----------") + " "+ \
                                str(A__both_8) + " "  + \
                                str(A__one_16) + " "  + \
                                str(B__both_8) + " "  + \
                                str(B__one_16) + " "  + \
                                str(P__both_8) + " "  + \
                                str(P__one_16) + " "

                    # *** F:DN for Sums
#                    if (state == 4) and (k3 == 7):
#                        Sum__one_16__shifted = arithmatic_shift(Sum__one_16, 12)
#                        Sum__both_8__shifted = arithmatic_shift(Sum__both_8, 7)
#                        print str(Sum__both_8__shifted) + " "  + str(Sum__one_16__shifted)
                    
                    
                    
                """
                counter +=1        





#parse_file_2("compare__Ps__modelsimdump.txt")
#parse_file_3("compare__Sums__modelsimdump.txt")
#parse_file_values("compare_values__modelsimDump.txt")
parse_file_values("compare_values__modelsimDump_16vs_16.txt")
#def rshift(val, n): return (val % 0x100000000) >> n




#main()
