//-----------------------------------------------------------------
// ---- F: This file is to show an example where we prevent DC to modify the 
// -----   The structure of the design. Note that if the structrual description 
    // of the program is in "mapped gate", the DC won't event touch those, otherwise
    // a mapping is picked
//-----------------------------------------------------------------

module conf_int_mul__noFF__arch_agnos( clk, racc, rapx, a, b, d);
   parameter OP_BITWIDTH = 16; 
   parameter DATA_PATH_BITWIDTH = 24;
   input clk;
   input racc;
   input rapx;
   input [DATA_PATH_BITWIDTH -1: 0] a;
   input [DATA_PATH_BITWIDTH -1: 0] b;
   output [(DATA_PATH_BITWIDTH) - 3 : 0] d;
   wire [3:0] x; 
   AND2_X2 U1(.A1(a[0]), .A2(a[1]), .ZN(x[0]));
   OR2_X2 U2(.A1(x[0]), .A2(a[2]), .ZN(x[1]));
   OR2_X2 U3(.A1(x[1]), .A2(a[3]), .ZN(d[0]));

   AND2_X2 U4(.A1(b[0]), .A2(b[1]), .ZN(x[2]));
   OR2_X2 U5(.A1(x[2]), .A2(b[2]), .ZN(x[3]));
   OR2_X2 U6(.A1(x[3]), .A2(b[3]), .ZN(d[1]));

endmodule


module conf_int_mul__noFF__arch_agnos__w_wrapper( clk, rst, a, b, d
);

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width

//--- input,outputs
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
output [DATA_PATH_BITWIDTH-3:0] d;
input clk;
input rst;


// synopsys dc_script_end
// --- F: forces the HDL compiler to not destroy the logic (or rather optimize) 
// synopsys dc_script_begin
//set_dont_touch a
//set_dont_touch b
//set_dont_touch d
//set_dont_touch mul__inst
// synopsys dc_script_end


conf_int_mul__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst(.clk(clk), .rst(rst), .a(a), .b(b), 
    .d(d));

endmodule 
 
