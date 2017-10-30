//-----------------------------------------------------------------
//*** F:D this file is RTL for multiple_add where the default for 
//        the bits are first add (note that there is no sharing at the moment
//        . Now, that can be b/c of the way I wrote the RTL (or the tcl script)
//        . hence, I started conf_int_add__noFF__multiple_add__resource_sharing to
//        investigate this
//-----------------------------------------------------------------

module conf_int_add__noFF__multiple_add( clk, rst, a, b, c, conf_select
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
input [CONF_SELECT__C_B -1 : 0] conf_select;
output [DATA_PATH_BITWIDTH-1:0] c;


////---F: Ripple Cary Adder deisng
////module test ripple_adder_4bit; 
//wire Cout;
// // Instantiate the Unit Under Test (UUT)
//ripple_adder_4bit uut (
//  .Sum(c[3:0]), 
//  .Cout(Cout), 
//  .A(a[3:0]), 
//  .B(b[3:0]), 
//  .Cin(a[0])
// );


wire [31:0]c_0;
wire [27:0]c_1;
wire [23:0] c_2;
wire [19:0] c_3;
wire [15:0] c_4;

//--- no flop design
assign c_0 = a + b;
assign c_1 = a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -28] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-28];
assign c_2 = a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -24] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-24];
assign c_3= a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -20] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-20];
assign c_4  = a[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH -16] + b[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-16];

assign c[3:0] = c_0[3:0];
assign c[7:4] = (conf_select == 3'd0) ? c_0[7:4] : 
                (conf_select == 3'd1) ? c_1[3:0] :
                c_0[7:4]; //*** F:AN I set the default to c_0, not sure if this
                          //         has consequences

assign c[11:8] = (conf_select == 3'd0) ? c_0[11:8] : 
                 (conf_select == 3'd1) ? c_1[7:4] :
                 (conf_select == 3'd2) ? c_2[3:0] :
                 c_0[11:8];
 

assign c[15:12] = (conf_select == 3'd0) ? c_0[15:12] : 
                  (conf_select == 3'd1) ? c_1[11:8] :
                  (conf_select == 3'd2) ? c_2[7:4] :
                  (conf_select == 3'd3) ? c_3[3:0] :
                  c_0[15:12];
 
assign c[31:16] = (conf_select == 3'd0) ? c_0[31:16] : 
                  (conf_select == 3'd1) ? c_1[27:12] :
                  (conf_select == 3'd2) ? c_1[23:8] :
                  (conf_select == 3'd3) ? c_1[19:4] :
                  (conf_select == 3'd4) ? c_1[15:0] :
                  c_0[31:16];
 

/*
//--- regs, wires
reg [DATA_PATH_BITWIDTH-1:0]  reg_c;
wire [OP_BITWIDTH -1 : 0]w_c;
reg [DATA_PATH_BITWIDTH -1:0]  reg_a;
reg [DATA_PATH_BITWIDTH -1:0]  reg_b;


//--- design
acc_int_add #(OP_BITWIDTH) u0_ac (reg_a[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH], reg_b[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH], w_c);

always @(posedge clk or negedge rst)
begin
  if (~rst)
  begin
    reg_a <= 0;
    reg_b <= 0;
  end
  else 
  begin
      reg_a <= a;
      reg_b <= b;
  end
end

always @(posedge clk or negedge rst)
begin
  if (~rst)
  begin
    reg_c <= #0.1 0;
  end
  else 
  begin
    reg_c[DATA_PATH_BITWIDTH-1: DATA_PATH_BITWIDTH-OP_BITWIDTH] <= w_c;
  end
end

assign c = reg_c; 

*/
endmodule
