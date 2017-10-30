//////////////////////////////////////////////////////////////
// Bio-Inspired Multiplier (BAM)
// Author : Seogoo Lee
// Date : 2014-10-30
// Function : Bio-Inspired Multiplier 
// Revision : v0.1 (2014-10-30) : Initial version
//////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module btm_trunc (
  a,
  b,
  c
);

parameter BWOP = 10;
parameter NAB = 0;

input  [BWOP-1:0]                                   a;
input  [BWOP-1:0]                                   b;
output [BWOP-1:0]                                   c;

wire   [2*BWOP -2*NAB - 1:0]                           c_pre;

assign c_pre = a[BWOP-1:NAB] * b[BWOP-1:NAB];
assign c = (NAB == 0) ? c_pre[BWOP-1: 0]: {c_pre[BWOP- 2*NAB - 1: 0], {{2*NAB}{1'b0}}};

endmodule
