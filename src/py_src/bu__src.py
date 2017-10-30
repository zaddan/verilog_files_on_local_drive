#*** F:DN this module contains the old version of some of the modules
def hardwire_apx_bits_to_zero(input__obj, precision):
    syn__file__addr = input__obj.syn__file__addr
    wrapper_module__na = input__obj.syn__wrapper_module__na
    module_name = input__obj.syn__module__na
    DATA_PATH_BITWIDTH = input__obj.DATA_PATH_BITWIDTH

    #*** F:DN Variables
    modified_syn__file__addr = syn__file__addr
    original_syn_copy__file__addr = syn__file__addr+"_temp"
    os.system("cp " + syn__file__addr + " " + original_syn_copy__file__addr)
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False]
    done_modifiying = False
    next_line_modify = False
    ignore = False #*** F:DN ignoring certain lines
    apx_bit__c = DATA_PATH_BITWIDTH - precision
    op_type = input__obj.op_type

    #*** F:AN switch this manually. if you set it to mac, it'll try to parse and generate
    #         for a design with registers. If you switch this to mac_noFF it does the other obvious thing
    if (op_type == "mac"):
        # *** F:AN noFF=>FF
        modified_op_type = "mac"
        # *** F:AN FF=>noFF
        #modified_op_type = "mac_noFF"
    else:
        modified_op_type = op_type

    #*** F:DN Body
    #*** F:DN parse the file
    saw_minus_1_wrapper__p = False
    minus_1_wrapper   = "conf_int_mac__noFF__arch_agnos__w_wrapper_minus_1_OP_BITWIDTH5_DATA_PATH_BITWIDTH5"
    try:
        f = open(original_syn_copy__file__addr)
    except IOError:
        print "src_file" + original_syn_copy__file__addr+ "not found"
        #handleIOError(original_syn_copy__file__addr, "csource file")
        sys.exit()
    else:
        f = open(original_syn_copy__file__addr)
        with f:
            for line in f:
                #*** F:AN this is very specific to the module itself and will
                #         change for other modules (e.g an adder)
                if (wrapper_module__na in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False
                    if (modified_op_type == "mac_noFF"): #simply skipping this now
                        modified__line = "clk, racc, rapx, a_in, b_in, c_in, d );\n"
                    else:
    ef hardwire_apx_bits_to_zero(input__obj, precision):
    syn__file__addr = input__obj.syn__file__addr
    wrapper_module__na = input__obj.syn__wrapper_module__na
    module_name = input__obj.syn__module__na
    DATA_PATH_BITWIDTH = input__obj.DATA_PATH_BITWIDTH

    #*** F:DN Variables
    modified_syn__file__addr = syn__file__addr
    original_syn_copy__file__addr = syn__file__addr+"_temp"
    os.system("cp " + syn__file__addr + " " + original_syn_copy__file__addr)
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False]
    done_modifiying = False
    next_line_modify = False
    ignore = False #*** F:DN ignoring certain lines
    apx_bit__c = DATA_PATH_BITWIDTH - precision
    op_type = input__obj.op_type

    #*** F:AN switch this manually. if you set it to mac, it'll try to parse and generate
    #         for a design with registers. If you switch this to mac_noFF it does the other obvious thing
    if (op_type == "mac"):
        # *** F:AN noFF=>FF
        modified_op_type = "mac"
        # *** F:AN FF=>noFF
        #modified_op_type = "mac_noFF"
    else:
        modified_op_type = op_type

    #*** F:DN Body
    #*** F:DN parse the file
    saw_minus_1_wrapper__p = False
    minus_1_wrapper   = "conf_int_mac__noFF__arch_agnos__w_wrapper_minus_1_OP_BITWIDTH5_DATA_PATH_BITWIDTH5"
    try:
        f = open(original_syn_copy__file__addr)
    except IOError:
        print "src_file" + original_syn_copy__file__addr+ "not found"
        #handleIOError(original_syn_copy__file__addr, "csource file")
        sys.exit()
    else:
        f = open(original_syn_copy__file__addr)
        with f:
            for line in f:
                #*** F:AN this is very specific to the module itself and will
                #         change for other modules (e.g an adder)
                if (wrapper_module__na in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False
                    if (modified_op_type == "mac_noFF"): #simply skipping this now
                        modified__line = "clk, racc, rapx, a_in, b_in, c_in, d );\n"
                    else:
                        modified__line = "clk, racc, rapx, a_in, b_in, d );\n"
                    modified__line += " input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]a_in;\n"
                    modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]b_in;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                                                        2*apx_bit__c - 1)+":0]c_in;\n"

                    modified__line += "wire ["+str(DATA_PATH_BITWIDTH-1) +":0]a;\n"
                    modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]b;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]c;\n"

                    if (modified_op_type == "mac"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]d_mod;\n"
                        modified__line += """assign d_mod = {d["""+ \
                                          str(DATA_PATH_BITWIDTH - 1) + ":" + str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+\
                                          "],"+ str(2*apx_bit__c)+ """\'""" + "b0};\n"

                    modified__line += "assign a = {a_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    modified__line += "assign b = {b_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "assign c = {c_in["+\
                            str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+":0],"+ str(2*apx_bit__c)\
                            +"\'b0};\n"
                    ignore = True
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("a" in line) and ignore :
   ef hardwire_apx_bits_to_zero(input__obj, precision):
    syn__file__addr = input__obj.syn__file__addr
    wrapper_module__na = input__obj.syn__wrapper_module__na
    module_name = input__obj.syn__module__na
    DATA_PATH_BITWIDTH = input__obj.DATA_PATH_BITWIDTH

    #*** F:DN Variables
    modified_syn__file__addr = syn__file__addr
    original_syn_copy__file__addr = syn__file__addr+"_temp"
    os.system("cp " + syn__file__addr + " " + original_syn_copy__file__addr)
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False]
    done_modifiying = False
    next_line_modify = False
    ignore = False #*** F:DN ignoring certain lines
    apx_bit__c = DATA_PATH_BITWIDTH - precision
    op_type = input__obj.op_type

    #*** F:AN switch this manually. if you set it to mac, it'll try to parse and generate
    #         for a design with registers. If you switch this to mac_noFF it does the other obvious thing
    if (op_type == "mac"):
        # *** F:AN noFF=>FF
        modified_op_type = "mac"
        # *** F:AN FF=>noFF
        #modified_op_type = "mac_noFF"
    else:
        modified_op_type = op_type

    #*** F:DN Body
    #*** F:DN parse the file
    saw_minus_1_wrapper__p = False
    minus_1_wrapper   = "conf_int_mac__noFF__arch_agnos__w_wrapper_minus_1_OP_BITWIDTH5_DATA_PATH_BITWIDTH5"
    try:
        f = open(original_syn_copy__file__addr)
    except IOError:
        print "src_file" + original_syn_copy__file__addr+ "not found"
        #handleIOError(original_syn_copy__file__addr, "csource file")
        sys.exit()
    else:
        f = open(original_syn_copy__file__addr)
        with f:
            for line in f:
                #*** F:AN this is very specific to the module itself and will
                #         change for other modules (e.g an adder)
                if (wrapper_module__na in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False
                    if (modified_op_type == "mac_noFF"): #simply skipping this now
                        modified__line = "clk, racc, rapx, a_in, b_in, c_in, d );\n"
                    else:
                        modified__line = "clk, racc, rapx, a_in, b_in, d );\n"
 ef hardwire_apx_bits_to_zero(input__obj, precision):
    syn__file__addr = input__obj.syn__file__addr
    wrapper_module__na = input__obj.syn__wrapper_module__na
    module_name = input__obj.syn__module__na
    DATA_PATH_BITWIDTH = input__obj.DATA_PATH_BITWIDTH

    #*** F:DN Variables
    modified_syn__file__addr = syn__file__addr
    original_syn_copy__file__addr = syn__file__addr+"_temp"
    os.system("cp " + syn__file__addr + " " + original_syn_copy__file__addr)
    modified_syn__file__handle = open(modified_syn__file__addr, "w")
    condition = [False]
    done_modifiying = False
    next_line_modify = False
    ignore = False #*** F:DN ignoring certain lines
    apx_bit__c = DATA_PATH_BITWIDTH - precision
    op_type = input__obj.op_type

    #*** F:AN switch this manually. if you set it to mac, it'll try to parse and generate
    #         for a design with registers. If you switch this to mac_noFF it does the other obvious thing
    if (op_type == "mac"):
        # *** F:AN noFF=>FF
        modified_op_type = "mac"
        # *** F:AN FF=>noFF
        #modified_op_type = "mac_noFF"
    else:
        modified_op_type = op_type

    #*** F:DN Body
    #*** F:DN parse the file
    saw_minus_1_wrapper__p = False
    minus_1_wrapper   = "conf_int_mac__noFF__arch_agnos__w_wrapper_minus_1_OP_BITWIDTH5_DATA_PATH_BITWIDTH5"
    try:
        f = open(original_syn_copy__file__addr)
    except IOError:
        print "src_file" + original_syn_copy__file__addr+ "not found"
        #handleIOError(original_syn_copy__file__addr, "csource file")
        sys.exit()
    else:
        f = open(original_syn_copy__file__addr)
        with f:
            for line in f:
                #*** F:AN this is very specific to the module itself and will
                #         change for other modules (e.g an adder)
                if (wrapper_module__na in line):
                    next_line_modify = True
                    modified__line = line
                elif next_line_modify:
                    next_line_modify = False
                    if (modified_op_type == "mac_noFF"): #simply skipping this now
                        modified__line = "clk, racc, rapx, a_in, b_in, c_in, d );\n"
                    else:
                        modified__line = "clk, racc, rapx, a_in, b_in, d );\n"
                    modified__line += " input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]a_in;\n"
                    modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]b_in;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                                                        2*apx_bit__c - 1)+":0]c_in;\n"

                    modified__line += "wire ["+str(DATA_PATH_BITWIDTH-1) +":0]a;\n"
                    modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]b;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]c;\n"

                    if (modified_op_type == "mac"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]d_mod;\n"
                        modified__line += """assign d_mod = {d["""+ \
                                          str(DATA_PATH_BITWIDTH - 1) + ":" + str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+\
                                          "],"+ str(2*apx_bit__c)+ """\'""" + "b0};\n"

                    modified__line += "assign a = {a_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    modified__line += "assign b = {b_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "assign c = {c_in["+\
                            str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+":0],"+ str(2*apx_bit__c)\
                            +"\'b0};\n"
                    ignore = True
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("a" in line) and ignore :
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("b" in line) and ignore:
                            if not((modified_op_type == "mac") or (modified_op_type == "mac_noFF")):
                                ignore = False
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("c" in line) and ignore:
                            ignore = False
                            continue
                elif (modified_op_type =="mac" and saw_minus_1_wrapper__p ):
                        if("c(" in line):
                            modified__line = modify_line_with_c(line, input__obj, precision)
                            print line
                            saw_minus_1_wrapper__p = False
                        else:
                            modified__line = line
                elif (modified_op_type == "mac" and "my_mac" in line):
                        modified__line = line
                        saw_minus_1_wrapper__p = True
                else:
                    modified__line = line


                modified_syn__file__handle.write(modified__line)
#                if (done_modifiying):
#                    modified_syn__file__handle.write(line)
#                else:
#                    modified_syn__file__handle.write(modified__line)
#
#                if (condition[0] and (not(done_modifiying))):
#                    done_modifiying = True


    modified_syn__file__handle.close()                   modified__line += " input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]a_in;\n"
                    modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]b_in;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                                                        2*apx_bit__c - 1)+":0]c_in;\n"

                    modified__line += "wire ["+str(DATA_PATH_BITWIDTH-1) +":0]a;\n"
                    modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]b;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]c;\n"

                    if (modified_op_type == "mac"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]d_mod;\n"
                        modified__line += """assign d_mod = {d["""+ \
                                          str(DATA_PATH_BITWIDTH - 1) + ":" + str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+\
                                          "],"+ str(2*apx_bit__c)+ """\'""" + "b0};\n"

                    modified__line += "assign a = {a_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    modified__line += "assign b = {b_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "assign c = {c_in["+\
                            str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+":0],"+ str(2*apx_bit__c)\
                            +"\'b0};\n"
                    ignore = True
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("a" in line) and ignore :
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("b" in line) and ignore:
                            if not((modified_op_type == "mac") or (modified_op_type == "mac_noFF")):
                                ignore = False
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("c" in line) and ignore:
                            ignore = False
                            continue
                elif (modified_op_type =="mac" and saw_minus_1_wrapper__p ):
                        if("c(" in line):
                            modified__line = modify_line_with_c(line, input__obj, precision)
                            print line
                            saw_minus_1_wrapper__p = False
                        else:
                            modified__line = line
                elif (modified_op_type == "mac" and "my_mac" in line):
                        modified__line = line
                        saw_minus_1_wrapper__p = True
                else:
                    modified__line = line


                modified_syn__file__handle.write(modified__line)
#                if (done_modifiying):
#                    modified_syn__file__handle.write(line)
#                else:
#                    modified_syn__file__handle.write(modified__line)
#
#                if (condition[0] and (not(done_modifiying))):
#                    done_modifiying = True


    modified_syn__file__handle.close()                         continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("b" in line) and ignore:
                            if not((modified_op_type == "mac") or (modified_op_type == "mac_noFF")):
                                ignore = False
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("c" in line) and ignore:
                            ignore = False
                            continue
                elif (modified_op_type =="mac" and saw_minus_1_wrapper__p ):
                        if("c(" in line):
                            modified__line = modify_line_with_c(line, input__obj, precision)
                            print line
                            saw_minus_1_wrapper__p = False
                        else:
                            modified__line = line
                elif (modified_op_type == "mac" and "my_mac" in line):
                        modified__line = line
                        saw_minus_1_wrapper__p = True
                else:
                    modified__line = line


                modified_syn__file__handle.write(modified__line)
#                if (done_modifiying):
#                    modified_syn__file__handle.write(line)
#                else:
#                    modified_syn__file__handle.write(modified__line)
#
#                if (condition[0] and (not(done_modifiying))):
#                    done_modifiying = True


    modified_syn__file__handle.close()                    modified__line = "clk, racc, rapx, a_in, b_in, d );\n"
                    modified__line += " input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]a_in;\n"
                    modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                            apx_bit__c-1)+":0]b_in;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "input ["+str(DATA_PATH_BITWIDTH- \
                                                        2*apx_bit__c - 1)+":0]c_in;\n"

                    modified__line += "wire ["+str(DATA_PATH_BITWIDTH-1) +":0]a;\n"
                    modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]b;\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]c;\n"

                    if (modified_op_type == "mac"):
                        modified__line += " wire ["+str(DATA_PATH_BITWIDTH-1) +":0]d_mod;\n"
                        modified__line += """assign d_mod = {d["""+ \
                                          str(DATA_PATH_BITWIDTH - 1) + ":" + str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+\
                                          "],"+ str(2*apx_bit__c)+ """\'""" + "b0};\n"

                    modified__line += "assign a = {a_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    modified__line += "assign b = {b_in["+\
                            str(DATA_PATH_BITWIDTH - apx_bit__c - 1)+":0],"+ str(apx_bit__c)\
                            +"\'b0};\n"
                    if (modified_op_type == "mac_noFF"):
                        modified__line += "assign c = {c_in["+\
                            str(DATA_PATH_BITWIDTH - 2*apx_bit__c - 1)+":0],"+ str(2*apx_bit__c)\
                            +"\'b0};\n"
                    ignore = True
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("a" in line) and ignore :
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("b" in line) and ignore:
                            if not((modified_op_type == "mac") or (modified_op_type == "mac_noFF")):
                                ignore = False
                            continue
                elif ("input" in line) and ("["+str(DATA_PATH_BITWIDTH-1)+":0]" in line) and \
                        ("c" in line) and ignore:
                            ignore = False
                            continue
                elif (modified_op_type =="mac" and saw_minus_1_wrapper__p ):
                        if("c(" in line):
                            modified__line = modify_line_with_c(line, input__obj, precision)
                            print line
                            saw_minus_1_wrapper__p = False
                        else:
                            modified__line = line
                elif (modified_op_type == "mac" and "my_mac" in line):
                        modified__line = line
                        saw_minus_1_wrapper__p = True
                else:
                    modified__line = line


                modified_syn__file__handle.write(modified__line)
#                if (done_modifiying):
#                    modified_syn__file__handle.write(line)
#                else:
#                    modified_syn__file__handle.write(modified__line)
#
#                if (condition[0] and (not(done_modifiying))):
#                    done_modifiying = True


    modified_syn__file__handle.close()