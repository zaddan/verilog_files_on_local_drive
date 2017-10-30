
module conf_int_mac__noFF__truncated( clk, rst, a, b, c, d
 );
//--- parameters
//parameter NAB_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width
parameter NAB = 12; //flip flop Bit width

//--- input,outputs
input clk;
input rst;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [DATA_PATH_BITWIDTH-1:0] c;
output [DATA_PATH_BITWIDTH-1:0] d;


//--- no flop design
wire [2*(DATA_PATH_BITWIDTH - NAB): 0]  d_temp ;
assign d_temp = (a[DATA_PATH_BITWIDTH-1: NAB] * b[DATA_PATH_BITWIDTH-1:NAB]);
assign  d[DATA_PATH_BITWIDTH-1: 0] = (d_temp << 2*NAB) + c[DATA_PATH_BITWIDTH-1: 0];
//assign d[2*NAB - 1: 0] = {{2*NAB}{1'b0}};

endmodule
