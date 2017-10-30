`timescale 1ns/1ps

module adder_acc (
  input [32:0] a,
  input [32:0] b,
  output [32: 0] c
);
assign c = a + b;

endmodule
