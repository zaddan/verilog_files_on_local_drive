//-----------------------------------------------------------------
// ---- F: This file is to show an example where we prevent DC to modify the 
// -----   The structure of the design. Note that if the structrual description 
    // of the program is in "mapped gate", the DC won't event touch those, otherwise
    // a mapping is picked
//-----------------------------------------------------------------

module unconfig_int_add ( clk, rst, a, b, c
 );
  input [31:0] a; 
  input [31:0] b;
  output [31:0] c;
  input clk, rst;

  wire a_not, b_not; 
  
  // --- F: forces the HDL compiler to not destroy the logic (or rather optimize) 
  // synopsys dc_script_begin
  // set_dont_touch a_not
  // set_dont_touch b_not
  //set_dont_touch a
  //set_dont_touch b
  //set_dont_touch c
  // synopsys dc_script_end
  
  //--- note the following can be structural or behavioral 
  assign a_not = ~a[0];
  assign b_not = ~b[0];
  assign c[0] = a_not & b_not;
  AND2_X2 U3(.A1(a_not), .A2(b_not), .ZN(c[4]));
 
  wire c_out;  
  ripple_adder_4bit rca(.Sum(c[3:0]),  .Cout(c_out), .A(a[3:0]), .B(b[3:0]), .Cin(1'b0));
  
  //  not(a_not, a[0]);
//  not(b_not, b[0]);
//  and(c[0], a_not, b_not);

  endmodule

