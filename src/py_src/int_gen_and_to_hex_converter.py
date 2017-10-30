import random
import struct
import math
import sys
base_folder_address = "../../build/functional"
int_values_file = "int_values_in_hex.txt"
int_values_and_conversion = "int_values_and_conversion.txt"
file_ptr_2 = open(base_folder_address + "/" + int_values_and_conversion, "w")
file_ptr_1  = open(base_folder_address + "/" + int_values_file, "w")

number_of_pairs = 50000
for idx, el in enumerate(range(0,2*number_of_pairs)):
#    if float (idx - 2)%3 == 0:
#        int_to_be_converted = int(random.uniform(16777216, 67108864))
#    else: 
#        int_to_be_converted = int(random.uniform(8096, 64000))
    
    # *** F:AN for 32
    #int_to_be_converted = int(random.uniform(0, 1073741824))
    #---------------------------------------------------- 
    #int_to_be_converted = int(random.uniform(0, 1073741824))
    # *** F:AN for 64
    int_to_be_converted = int(random.uniform(8388600,8388607))
    #---------------------------------------------------- 
    # *** F:AN simple test
#    int_to_be_converted = int(random.uniform(0, 10))
    

#     int_converted_to_hex = (hex(struct.unpack('!i',struct.pack('!f',int_to_be_converted))[0])&0xffffffff) [0:]
    # *** F:AN integers 
    int_converted_to_hex = hex(struct.unpack('!I',struct.pack('>i',int_to_be_converted))[0])[2:]
    # *** XX //
    #int_converted_to_hex = hex(struct.unpack('!Q',struct.pack('>q',int_to_be_converted))[0])[2:]

    file_ptr_1.write(int_converted_to_hex + " ") 
    file_ptr_2.write("int val: " + str(int_to_be_converted) + " hex: " + str(int_converted_to_hex + " \n"))


file_ptr_1.close()
file_ptr_2.close()
