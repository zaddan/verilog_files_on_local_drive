module conf_int_mac__noFF__arch_agnos( clk, rst, a, b, c, d
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


//--- no flop design
assign  d = (a * b) + c;

endmodule


module conf_int_mac__noFF__arch_agnos__w_wrapper( clk, rst, a_wrapper, b_wrapper, c_wrapper, d
);

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width

//--- input,outputs
input clk;
input rst;
input [DATA_PATH_BITWIDTH -1:0] a_wrapper;
input [DATA_PATH_BITWIDTH-1:0] b_wrapper;
input [DATA_PATH_BITWIDTH-1:0] c_wrapper;
output [DATA_PATH_BITWIDTH-1:0] d;


//synopsys keep_signal_name "a_in"
//synopsys keep_signal_name "b_in"
//synopsys keep_signal_name "c_in"
wire [DATA_PATH_BITWIDTH-1:0] a_in;
wire [DATA_PATH_BITWIDTH-1:0] b_in;
wire [DATA_PATH_BITWIDTH-1:0] c_in;

assign a_in = a_wrapper;
assign b_in = b_wrapper;
assign c_in = c_wrapper;

conf_int_mac__noFF__arch_agnos #(DATA_PATH_BITWIDTH, OP_BITWIDTH) mac(.clk(clk), .rst(rst), .a(a_in), .b(b_in), .c(c_in),
    .d(d));

endmodule 
