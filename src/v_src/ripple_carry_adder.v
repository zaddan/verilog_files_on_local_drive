module half_adder(
    output S,C,
  input A,B
    );
 
  // synopsys dc_script_begin
 //set_dont_touch S
 //set_dont_touch C
 //set_dont_touch A
 //set_dont_touch B
 // synopsys dc_script_end
    
 xor(S,A,B);
  AND2_X1 U3(.A1(A), .A2(B), .ZN(C));
 //and(C,A,B);
 
endmodule

//Structural Model : Full Adder

module full_adder(
    output S,Cout,
    input A,B,Cin
    );
 
 // synopsys dc_script_begin
 //set_dont_touch S
 //set_dont_touch Cout
 //set_dont_touch A
 //set_dont_touch B
 //set_dont_touch Cin
 //set_dont_touch s1
 //set_dont_touch c1
 //set_dont_touch c2
 // synopsys dc_script_end
   
 wire s1,c1,c2;
 half_adder HA1(s1,c1,A,B);
 half_adder HA2(S,c2,s1,Cin);
 or OG1(Cout,c1,c2);

endmodule

//Structural Model : 4 Bit Ripple Carry Adder

module ripple_adder_4bit(
    output [3:0] Sum,
    output Cout,
    input [3:0] A,B,
    input Cin
    );
 
  // synopsys dc_script_begin
  //set_dont_touch Sum
  //set_dont_touch A
  //set_dont_touch B
  //set_dont_touch Cin
  //set_dont_touch c1
  //set_dont_touch c2
  //set_dont_touch c3
  // synopsys dc_script_end
    
 wire c1,c2,c3;
 full_adder FA1(Sum[0],c1,A[0],B[0],Cin),
    FA2(Sum[1],c2,A[1],B[1],c1),
    FA3(Sum[2],c3,A[2],B[2],c2),
    FA4(Sum[3],Cout,A[3],B[3],c3);

endmodule

