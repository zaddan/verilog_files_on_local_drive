
module conf_int_mac__noFF__arch_specific( clk, rst, a, b, c, d
 );
//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width


//--- input,outputs
input clk;
input rst;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [DATA_PATH_BITWIDTH-1:0] c;
output [DATA_PATH_BITWIDTH-1:0] d;

wire [2*DATA_PATH_BITWIDTH-1:0] d_mult;
//--- no flop design
DW02_mult #(DATA_PATH_BITWIDTH, DATA_PATH_BITWIDTH) U1(a, b, 1'b1, d_mult);
assign d = d_mult[DATA_PATH_BITWIDTH -1: 0] + c;

endmodule
