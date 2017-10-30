//-----------------------------------------------------------------
//*** F:D this file's RTL is written for the purpose of resource sharing
//        the bits are first add
//-----------------------------------------------------------------


/*
module conf_int_add__noFF__multiple_add__resource_sharing(clk,rst, a, b, c, d, sel, z1, z2); 
input clk;
input rst;
input [7:0] a, b, c, d; 
input sel; output [15:0] z1, z2; 
assign z1 = sel? a * b : a * c; 
//assign z1 = a * b;
//assign z2 = a * c; 
endmodule
*/






module conf_int_add__noFF__multiple_add__resource_sharing( clk, rst, a, b, c, d, e, conf_select
 );
//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width
parameter CONF_SELECT__C_B = 4; //*** F:D determines the number of configurations we
                               //        want to have

//--- input,outputs
input clk;
input rst;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [DATA_PATH_BITWIDTH -1:0] d; //*** F:AN remove if we are not using the simple example
input [DATA_PATH_BITWIDTH-1:0] e;  //*** F:AN remove if we are not using the simple example
input [CONF_SELECT__C_B -1 : 0] conf_select;
output [DATA_PATH_BITWIDTH-1:0] c;


///*
//*** F:D simple example where resource sharing must happen but it's not
reg [31: 0] c__reg;
always @(*)

begin
    if (conf_select[0])
        c__reg = a + b;
    else 
        c__reg = d + e;
end
assign c = c__reg;
//*/




/*
//*** F:D structural verilog where resource sharing is happening, but it's not
wire [31:0]c_0;
wire [27:0]c_1;
wire [23:0] c_2;
wire [19:0] c_3;
wire [15:0] c_4;

//--- no flop design
assign c = (conf_select == 3'd0) ? a + b:
           (conf_select == 3'd1) ? {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -28] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-28], 4'bx} :
           (conf_select == 3'd2) ? {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -24] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-24] , 8'bx}:
           (conf_select == 3'd3) ? {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -20] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-20], 12'bx}: 
           (conf_select == 3'd4) ? {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -16] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-16], 16'bx}:
           a + b;
*/


/*
//*** F:D behavioral verilog where resource sharing is happening, but it's not
reg [31: 0] c__reg;
always @(*)
begin
    if (conf_select == 3'd0)
        c__reg = a + b;
    else if (conf_select == 3'd1)
        c__reg = {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -28] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-28], 4'bx};
    else if (conf_select == 3'd2)
        c__reg =  {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -24] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-24] , 8'bx};
    else if (conf_select == 3'd3)
        c__reg = {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -20] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-20], 12'bx};
    else if (conf_select == 3'd4)
        c__reg = {a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -16] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-16], 16'bx};
    else
        c__reg =  a + b;
end
assign c = c__reg;
*/
endmodule
