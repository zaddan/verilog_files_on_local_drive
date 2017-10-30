module conf_int_add__noFF__arch_agnos( clk, rst, a, b, d
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
output [DATA_PATH_BITWIDTH :0] d;


//--- no flop design
assign  d = (a + b);

endmodule


module conf_int_add__noFF__arch_agnos__w_wrapper( clk, rst, a, b, d
,acc__sel);

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width


//--- input,outputs
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input acc__sel;
output [32:0] d;
input clk;
input rst;

wire [DATA_PATH_BITWIDTH:0] d__acc;
// synopsys dc_script_begin
 //set_dont_touch add__inst__apx
 // synopsys dc_script_end
conf_int_add__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) add__inst__acc(.clk(clk), .rst(rst), .a(a), .b(b), 
    .d(d__acc));

conf_int_add__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH24  add__inst__apx ( clk, rst, a[31:8], b[31:8], d
,d__acc, acc__sel);


//--- for testing purposes
//--- duplicate
//assign d = d__ignore;
/*
// ---- non duplicates
//--- F:DN acc
//assign d = a*b; 

//-- F:DN apx
assign d[63:16] = a[31:8]*b[31:8]; //apx
assign d[15:0] = 16'b0;
*/

endmodule 
