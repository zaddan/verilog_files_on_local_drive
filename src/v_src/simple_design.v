`timescale 1ns/1ps

//--- the following configuratble adder uses input Mux
//for the purpose of truncation
module unconfig_int_add(
 clk,
 rst,
 a,
 b,
 c
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


assign c = a * b;

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

