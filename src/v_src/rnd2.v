`timescale 1ns/1ps

module rnd (
  i_din,
  o_dout
);

parameter DW_IN = 10;
parameter DW_RND = 2;
parameter DW_OUT = DW_IN-DW_RND;

input  [DW_IN-1:0]           i_din;
output [DW_OUT-1:0]          o_dout;

reg    [DW_IN-1-DW_RND:0]    w_d_rnd;

// rounding
always @(i_din) 
begin
  if (i_din[DW_RND-1])
    w_d_rnd = i_din[DW_IN-1:DW_RND] + 1;
  else 
    w_d_rnd = i_din[DW_IN-1:DW_RND];
end

assign o_dout = w_d_rnd[DW_OUT-1:0];

endmodule
   
