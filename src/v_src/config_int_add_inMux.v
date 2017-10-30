`timescale 1ns/1ps

//--- the following configuratble adder uses input Mux
//for the purpose of truncation
module config_int_add_inMux_truncation(
 clk,
 rst,
 apx_ctl,  
 a,
 b,
 c
);

//parameter BT_RND = 0
//--- parameters
parameter DATA_PATH_BITWIDTH = 32; //data path width
parameter HRDWIRED_BITWIDTH = 0; //number of hardwired zeros

//--- input output
input clk;
input rst;
input [DATA_PATH_BITWIDTH-1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
output [DATA_PATH_BITWIDTH-1:0] c;
input apx_ctl;

//--- regs, wires
reg [DATA_PATH_BITWIDTH-1:0]  reg_c;
wire [DATA_PATH_BITWIDTH-1:0]  w_c;
wire [DATA_PATH_BITWIDTH-1:0] a_apx;
wire [DATA_PATH_BITWIDTH-1:0] b_apx;
reg [DATA_PATH_BITWIDTH-1:0]  reg_a;
reg [DATA_PATH_BITWIDTH-1:0]  reg_b;

//--- the design
assign a_apx = apx_ctl ? {reg_a[DATA_PATH_BITWIDTH-1: HRDWIRED_BITWIDTH], {{HRDWIRED_BITWIDTH}{1'b0}}} : reg_a;
assign b_apx = apx_ctl ? {reg_b[DATA_PATH_BITWIDTH-1: HRDWIRED_BITWIDTH], {{HRDWIRED_BITWIDTH}{1'b0}}} : reg_b;
acc_int_add #(DATA_PATH_BITWIDTH) u0_ac (a_apx, b_apx, w_c);

always @(posedge clk or negedge rst)
begin
  if (~rst)
  begin
    reg_a <= #0.3 0;
    reg_b <= #0.3 0;
  end
  else 
  begin
      reg_a <= #0.1 a;
      reg_b <= #0.1 b;
  end
end

always @(posedge clk or negedge rst)
begin
  if (~rst)
  begin
    reg_c <= #0.3 0;
  end
  else 
  begin
    reg_c <= w_c;
  end
end

assign c = reg_c;


endmodule

