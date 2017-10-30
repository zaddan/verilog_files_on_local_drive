//////////////////////////////////////////////////////////////
// Lower-bit OR Adder
// Author : Seogoo Lee
// Date : 2014-10-30
// Function : Lower-bit OR Adder
// Revision : v0.1 (2014-10-30) : Initial version
//////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module bta (
  a,
  b,
  c
);


parameter BWOP = 32; //operand width
parameter NAB = 1;  //Number of Apx Bits

input  [BWOP-1:0]                                   a;
input  [BWOP-1:0]                                   b;
output [BWOP-1:0]                                   c;
wire   [BWOP-NAB-1:0]                               a_rc;
wire   [BWOP-NAB-1:0]                               b_rc;
wire   [BWOP- NAB :0]                           c_pre;
wire overflow;
rnd #(BWOP,  NAB) u0_rnd(
  .i_din                   (a),
  .o_dout                  (a_rc              )
);

rnd #(BWOP, NAB) u1_rnd(
  .i_din                   (b),
  .o_dout                  (b_rc              )
);

assign c_pre = a_rc + b_rc;
assign c = (NAB == 0) ? c_pre[BWOP-1: 0]: {c_pre[BWOP-NAB - 1:0], {{NAB}{1'b0}}};
endmodule
