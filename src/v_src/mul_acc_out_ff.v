`timescale 1ns/1ps

module mul_acc_ff(
 clk,
 rst,
 a,
 b,
 c
);

//parameter BT_RND = 0
parameter NAB = 0;
parameter BWOP = 32;

input clk;
input rst;
input [BWOP-1:0] a;
input [BWOP-1:0] b;
output [BWOP-1:0] c;

reg [BWOP-1:0]  reg_c;
wire [BWOP-1:0]  w_c;
mul_acc #(BWOP, NAB) u0_ac (a, b, w_c);

always @(posedge clk or negedge rst)
begin
  if (~rst)
  begin
    reg_c <= #1 0;
  end
  else 
  begin
    reg_c <= #1 w_c;
  end
end

assign c = reg_c;

endmodule

