module conf_int_mul__noFF__arch_agnos__apx ( clk, rst, a, b, d);
   parameter OP_BITWIDTH = 16; 
   parameter DATA_PATH_BITWIDTH = 24;
   
   input clk;
   input rst;
   input [DATA_PATH_BITWIDTH -1: 0] a;
   input [DATA_PATH_BITWIDTH -1 : 0] b;
   //output [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH ) - 1 - 11 : 0] d;
   output [(DATA_PATH_BITWIDTH - 8 + DATA_PATH_BITWIDTH - 8) - 1 : 0] d;
   assign d = $signed(a[DATA_PATH_BITWIDTH - 1:8]) * $signed(b[DATA_PATH_BITWIDTH -1 :8]);
endmodule





module conf_int_mul__noFF__arch_agnos__acc( clk, rst, a, b, d
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
output [2*DATA_PATH_BITWIDTH -1:0] d;


//--- no flop design
assign  d = (a * b);

endmodule


module conf_int_mul__noFF__arch_agnos__w_wrapper( clk, rst, a, b, d
,acc__sel);

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width


//--- input,outputs
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input acc__sel;
output [2*DATA_PATH_BITWIDTH-1:0] d;
input clk;
input rst;

   wire [2*(DATA_PATH_BITWIDTH) - 1 : 0] d_internal__acc;
   wire [2*(DATA_PATH_BITWIDTH) - 2*(8) - 1 : 0] d_internal__apx;


// synopsys dc_script_begin
   //set_dont_touch d_internal__apx
   //set_dont_touch d_internal__acc
 //set_dont_touch d
 // synopsys dc_script_end


conf_int_mul__noFF__arch_agnos__acc #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst__acc(.clk(clk), .rst(rst), .a(a), .b(b), 
    .d(d_internal__acc));

conf_int_mul__noFF__arch_agnos__apx #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst__apx(.clk(clk), .rst(rst), .a(a), .b(b), .d(d_internal__apx));

   assign d [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 : 2*8] = acc__sel ? d_internal__acc[(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 : 2*8] : d_internal__apx;
   assign  d[2*8- 1: 0] = acc__sel ? d_internal__acc[2*8-1: 0]:{(2*8){1'b0}};




endmodule 
