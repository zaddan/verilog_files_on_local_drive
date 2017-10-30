module conf_int_mul__noFF__arch_agnos( clk, racc, rapx, a, b, d
 );

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width

//--- input,outputs
input clk;
input racc;
input rapx;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
output [DATA_PATH_BITWIDTH-1:0] d;

assign  d = (a * b);

endmodule



module conf_int_mul__noFF__arch_agnos__w_wrapper( clk, racc, rapx, a, b, d
);
//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width


//--- input,outputs
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
output [DATA_PATH_BITWIDTH-1:0] d;
input clk;
input racc;
input rapx;
wire [DATA_PATH_BITWIDTH-1:0] d_internal;

assign d = d_internal;
conf_int_mul__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst(.clk(clk), .racc(racc), .rapx(rapx), .a(a), .b(b), 
    .d(d_internal));


endmodule 
