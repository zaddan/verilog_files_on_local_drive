//////////////////////////////////////////////////////////////
// Bio-Inspired Multiplier (BAM)
// Author : Seogoo Lee
// Date : 2014-10-30
// Function : Bio-Inspired Multiplier 
// Revision : v0.1 (2014-10-30) : Initial version
//////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mul_acc(
  a,
  b,
  c
);

parameter BWOP = 32; //operand width
parameter NAB = 1;  //Number of Apx Bits

input  [BWOP-1:0]                                   a;
input  [BWOP-1:0]                                   b;
output [BWOP-1:0]                                   c;
wire   [2*BWOP-2*NAB - 1:0]                           c_pre;

assign c_pre = a * b;
assign c = c_pre[BWOP-1: 0];
endmodule
