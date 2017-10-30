//////////////////////////////////////////////////////////////
// Lower-bit OR Adder
// Author : Seogoo Lee
// Date : 2014-10-30
// Function : Lower-bit OR Adder
// Revision : v0.1 (2014-10-30) : Initial version
//////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module acc_int_add(
  a,
  b,
  c
);


parameter BWOP = 32; //operand width

input  [BWOP-1:0]                                   a;
input  [BWOP-1:0]                                   b;
output [BWOP-1:0]                                   c;
wire   [BWOP- 1:0]                           c_pre;

assign c_pre = a + b;
assign c = c_pre[BWOP-1:0];
endmodule
