
module conf_int_add__noFF__arch_specific( clk, rst, a, b, c
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
output [DATA_PATH_BITWIDTH-1:0] c;
reg [DATA_PATH_BITWIDTH-1:0] c_reg;

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

  //---Note: got the following from the page 34 of "DesignWare Building Block Ip
  //-------  userguide
  
  //--- no flop design
  wire cout;
  // synopsys dc_script_begin 
  // set_implementation rpl U1 
  // synopsys dc_script_end
  // instantiate DW01_add
  // set_dont_use dw_foundation.sldb/DW01_add/apparch
  // set_dont_use dw_foundation.sldb/DW01_add/pparch
  DW01_add #(DATA_PATH_BITWIDTH) U1(.A(a), .B(b), .CI(1'b0), .SUM(c), .CO(cout));
  
  //// set_dont_touch U1 
//  
//  always @(*) begin
//      /* synopsys resource r0: 
//      map_to_module = "DW01_add",
//      implementation = "cla",
//      ops = "a1"; */
//      c_reg <= a + b; //synopsys label a1
//  end
//
assign c = c_reg;  
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
