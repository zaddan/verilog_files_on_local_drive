#!/bin/bash 

########### Design Compiler ########### 

#dc_shell-t -f  DC_commands.tcl 

########### Modelsim ##################

vsim -c -do runms.tcl #>& /dev/null  
   
###########  PSNR   ##################       

perl PSNR.pl
   
###########  Convert  ################

cp idctdata.txt Image/output.txt
octave  image_get_png_from_txt.m    >& /dev/null  

###########  Clean  ##################       
rm -rf *.log
rm -rf *.svf
rm -r work         


