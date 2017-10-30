
module conf_int_mac__noFF__designWare_mac( clk, rst, a, b, c, d
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
output [2*(DATA_PATH_BITWIDTH)-1:0] d;

  DW02_mac #(DATA_PATH_BITWIDTH, DATA_PATH_BITWIDTH) U1(.A(a), .B(b), .C({32'b0, c}), .TC(1'b1), .MAC(d));

endmodule
