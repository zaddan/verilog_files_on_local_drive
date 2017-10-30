module conf_int_mac__noFF__arch_agnos( clk, rst, a, b, c_in, d
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
input [2*DATA_PATH_BITWIDTH-1:0] c_in;
output [2*DATA_PATH_BITWIDTH-1:0] d;


//--- no flop design
assign  d = (a * b) + c_in;

endmodule


module conf_int_mac__noFF__arch_agnos__w_wrapper( clk, rst, a, b, c_in, d
);

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width


//--- input,outputs
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [2*DATA_PATH_BITWIDTH-1:0] c_in;
output [2*DATA_PATH_BITWIDTH-1:0] d;
input clk;
input rst;

// synopsys dc_script_begin
//set_dont_touch d
// synopsys dc_script_end

conf_int_mac__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mac__inst(.clk(clk), .rst(rst), .a(a), .b(b), .c_in(c_in),
    .d(d));

endmodule 
