`timescale 1ns / 1ps
`define a2_cut_prime 0
`define b2_cut_prime 0




module dct(clk, start, reset, din, done, dout, state_out, reading);

   parameter BitWidth = 31;
   parameter BitWidth1 = 32;
   
   input clk, start;
   input reset;  
   output done;
   output reading;
   output [2:0] state_out;  
   
   input [BitWidth:0] din;
   output [BitWidth:0] dout;
   
   wire clk, start;
   wire reset;  
   reg done;
   reg reading;
   wire[2:0] state_out;  
   
   wire [BitWidth:0] din;
   reg [BitWidth:0] dout;
   
   reg [8:0] count0, count1, count2, count3;
   
   reg [BitWidth:0] B;
   reg [BitWidth:0] A;
   reg [BitWidth+3:0] Sum; 
   reg [BitWidth:0] P; 
   
   reg [BitWidth:0] P_tmp;
   
   //wire [BitWidth:0] Sum_tmp;
   wire [BitWidth:0] COSBlock[0:7][0:7];
   reg [BitWidth:0] InBlock[0:7][0:7];  
   reg [BitWidth:0] TempBlock[0:7][0:7];
   reg [BitWidth:0] OutBlock[0:7][0:7];
   
   reg [2:0] state;      
   wire[2:0] i0, j0, k0, k2, i3, j3, k3;
   
   assign i0 = count0[8:6];
   assign j0 = count0[5:3];
   assign k0 = count0[2:0];    
   assign k2 = count2[2:0];    
   assign i3 = count3[8:6];
   assign j3 = count3[5:3];
   assign k3 = count3[2:0];    
   
   assign state_out = state;  
   
   /*      
   assign COSBlock[0][0][7:0] = 8'd91;   assign COSBlock[0][0][BitWidth:8] = {(BitWidth1-8){COSBlock[0][0][7]}};                  //8'd125;
   assign COSBlock[1][0][7:0] = 8'd126;  assign COSBlock[1][0][BitWidth:8] = {(BitWidth1-8){COSBlock[1][0][7]}};                  //8'd122;
   assign COSBlock[2][0][7:0] = 8'd118;  assign COSBlock[2][0][BitWidth:8] = {(BitWidth1-8){COSBlock[2][0][7]}};                  //8'd115;
   assign COSBlock[3][0][7:0] = 8'd106;  assign COSBlock[3][0][BitWidth:8] = {(BitWidth1-8){COSBlock[3][0][7]}};                  //8'd103;
   assign COSBlock[4][0][7:0] = 8'd91;   assign COSBlock[4][0][BitWidth:8] = {(BitWidth1-8){COSBlock[4][0][7]}};                  //8'd88; 
   assign COSBlock[5][0][7:0] = 8'd71;   assign COSBlock[5][0][BitWidth:8] = {(BitWidth1-8){COSBlock[5][0][7]}};                  //8'd69; 
   assign COSBlock[6][0][7:0] = 8'd49;   assign COSBlock[6][0][BitWidth:8] = {(BitWidth1-8){COSBlock[6][0][7]}};                  //8'd47; 
   assign COSBlock[7][0][7:0] = 8'd25;   assign COSBlock[7][0][BitWidth:8] = {(BitWidth1-8){COSBlock[7][0][7]}};                  //8'd24; 
                                                                                                                                  //       
   assign COSBlock[0][1][7:0] = 8'd91;   assign COSBlock[0][1][BitWidth:8] = {(BitWidth1-8){COSBlock[0][1][7]}};                  //8'd125;
   assign COSBlock[1][1][7:0] = 8'd106;  assign COSBlock[1][1][BitWidth:8] = {(BitWidth1-8){COSBlock[1][1][7]}};                  //8'd103;
   assign COSBlock[2][1][7:0] = 8'd49;   assign COSBlock[2][1][BitWidth:8] = {(BitWidth1-8){COSBlock[2][1][7]}};                  //8'd47; 
   assign COSBlock[3][1][7:0] = 8'd231;  assign COSBlock[3][1][BitWidth:8] = {(BitWidth1-8){COSBlock[3][1][7]}}; //232  //-24     //8'd232;
   assign COSBlock[4][1][7:0] = 8'd165;  assign COSBlock[4][1][BitWidth:8] = {(BitWidth1-8){COSBlock[4][1][7]}}; //168  //-88     //8'd168;
   assign COSBlock[5][1][7:0] = 8'd130;  assign COSBlock[5][1][BitWidth:8] = {(BitWidth1-8){COSBlock[5][1][7]}}; //134  //-122    //8'd134;
   assign COSBlock[6][1][7:0] = 8'd138;  assign COSBlock[6][1][BitWidth:8] = {(BitWidth1-8){COSBlock[6][1][7]}}; //141  //-115    //8'd141;
   assign COSBlock[7][1][7:0] = 8'd185;  assign COSBlock[7][1][BitWidth:8] = {(BitWidth1-8){COSBlock[7][1][7]}}; //187  //-69     //8'd187;
                                                                                                                                  //       
   assign COSBlock[0][2][7:0] = 8'd91;   assign COSBlock[0][2][BitWidth:8] = {(BitWidth1-8){COSBlock[0][2][7]}};                  //8'd125;
   assign COSBlock[1][2][7:0] = 8'd71;   assign COSBlock[1][2][BitWidth:8] = {(BitWidth1-8){COSBlock[1][2][7]}};                  //8'd69; 
   assign COSBlock[2][2][7:0] = 8'd207;  assign COSBlock[2][2][BitWidth:8] = {(BitWidth1-8){COSBlock[2][2][7]}}; //209  //-47     //8'd209;
   assign COSBlock[3][2][7:0] = 8'd130;  assign COSBlock[3][2][BitWidth:8] = {(BitWidth1-8){COSBlock[3][2][7]}}; //134  //-122    //8'd134;
   assign COSBlock[4][2][7:0] = 8'd165;  assign COSBlock[4][2][BitWidth:8] = {(BitWidth1-8){COSBlock[4][2][7]}}; //168  //-88     //8'd168;
   assign COSBlock[5][2][7:0] = 8'd25;   assign COSBlock[5][2][BitWidth:8] = {(BitWidth1-8){COSBlock[5][2][7]}};                  //8'd24; 
   assign COSBlock[6][2][7:0] = 8'd118;  assign COSBlock[6][2][BitWidth:8] = {(BitWidth1-8){COSBlock[6][2][7]}};                  //8'd115;
   assign COSBlock[7][2][7:0] = 8'd106;  assign COSBlock[7][2][BitWidth:8] = {(BitWidth1-8){COSBlock[7][2][7]}};                  //8'd103;
                                                                                                                                  //       
   assign COSBlock[0][3][7:0] = 8'd91;   assign COSBlock[0][3][BitWidth:8] = {(BitWidth1-8){COSBlock[0][3][7]}};                  //8'd125;
   assign COSBlock[1][3][7:0] = 8'd25;   assign COSBlock[1][3][BitWidth:8] = {(BitWidth1-8){COSBlock[1][3][7]}};                  //8'd24; 
   assign COSBlock[2][3][7:0] = 8'd138;  assign COSBlock[2][3][BitWidth:8] = {(BitWidth1-8){COSBlock[2][3][7]}}; //141  //-115    //8'd141;
   assign COSBlock[3][3][7:0] = 8'd185;  assign COSBlock[3][3][BitWidth:8] = {(BitWidth1-8){COSBlock[3][3][7]}}; //187  //-69     //8'd187;
   assign COSBlock[4][3][7:0] = 8'd91;   assign COSBlock[4][3][BitWidth:8] = {(BitWidth1-8){COSBlock[4][3][7]}};                  //8'd88; 
   assign COSBlock[5][3][7:0] = 8'd106;  assign COSBlock[5][3][BitWidth:8] = {(BitWidth1-8){COSBlock[5][3][7]}};                  //8'd103;
   assign COSBlock[6][3][7:0] = 8'd207;  assign COSBlock[6][3][BitWidth:8] = {(BitWidth1-8){COSBlock[6][3][7]}}; //209  //-47     //8'd209;
   assign COSBlock[7][3][7:0] = 8'd130;  assign COSBlock[7][3][BitWidth:8] = {(BitWidth1-8){COSBlock[7][3][7]}}; //134  //-122    //8'd134;
                                                                                                                                  //       
   assign COSBlock[0][4][7:0] = 8'd91;   assign COSBlock[0][4][BitWidth:8] = {(BitWidth1-8){COSBlock[0][4][7]}};                  //8'd125;
   assign COSBlock[1][4][7:0] = 8'd231;  assign COSBlock[1][4][BitWidth:8] = {(BitWidth1-8){COSBlock[1][4][7]}}; //232  //-24     //8'd232;
   assign COSBlock[2][4][7:0] = 8'd138;  assign COSBlock[2][4][BitWidth:8] = {(BitWidth1-8){COSBlock[2][4][7]}}; //141  //-115    //8'd141;
   assign COSBlock[3][4][7:0] = 8'd71;   assign COSBlock[3][4][BitWidth:8] = {(BitWidth1-8){COSBlock[3][4][7]}};                  //8'd69; 
   assign COSBlock[4][4][7:0] = 8'd91;   assign COSBlock[4][4][BitWidth:8] = {(BitWidth1-8){COSBlock[4][4][7]}};                  //8'd88; 
   assign COSBlock[5][4][7:0] = 8'd150;  assign COSBlock[5][4][BitWidth:8] = {(BitWidth1-8){COSBlock[5][4][7]}}; //153  //-103    //8'd153;
   assign COSBlock[6][4][7:0] = 8'd207;  assign COSBlock[6][4][BitWidth:8] = {(BitWidth1-8){COSBlock[6][4][7]}}; //209  //-47     //8'd209;
   assign COSBlock[7][4][7:0] = 8'd126;  assign COSBlock[7][4][BitWidth:8] = {(BitWidth1-8){COSBlock[7][4][7]}};                  //8'd122;
                                                                                                                                  //       
   assign COSBlock[0][5][7:0] = 8'd91;   assign COSBlock[0][5][BitWidth:8] = {(BitWidth1-8){COSBlock[0][5][7]}};                  //8'd125;
   assign COSBlock[1][5][7:0] = 8'd185;  assign COSBlock[1][5][BitWidth:8] = {(BitWidth1-8){COSBlock[1][5][7]}}; //187  //-69     //8'd187;
   assign COSBlock[2][5][7:0] = 8'd207;  assign COSBlock[2][5][BitWidth:8] = {(BitWidth1-8){COSBlock[2][5][7]}}; //209  //-47     //8'd209;
   assign COSBlock[3][5][7:0] = 8'd126;  assign COSBlock[3][5][BitWidth:8] = {(BitWidth1-8){COSBlock[3][5][7]}};                  //8'd122;
   assign COSBlock[4][5][7:0] = 8'd165;  assign COSBlock[4][5][BitWidth:8] = {(BitWidth1-8){COSBlock[4][5][7]}}; //168  //-88     //8'd168;
   assign COSBlock[5][5][7:0] = 8'd231;  assign COSBlock[5][5][BitWidth:8] = {(BitWidth1-8){COSBlock[5][5][7]}}; //232  //-24     //8'd232;
   assign COSBlock[6][5][7:0] = 8'd118;  assign COSBlock[6][5][BitWidth:8] = {(BitWidth1-8){COSBlock[6][5][7]}};                  //8'd115;
   assign COSBlock[7][5][7:0] = 8'd150;  assign COSBlock[7][5][BitWidth:8] = {(BitWidth1-8){COSBlock[7][5][7]}}; //153  //-103    //8'd153;
                                                                                                                                  //       
   assign COSBlock[0][6][7:0] = 8'd91;   assign COSBlock[0][6][BitWidth:8] = {(BitWidth1-8){COSBlock[0][6][7]}};                  //8'd125;
   assign COSBlock[1][6][7:0] = 8'd150;  assign COSBlock[1][6][BitWidth:8] = {(BitWidth1-8){COSBlock[1][6][7]}}; //153  //-103    //8'd153;
   assign COSBlock[2][6][7:0] = 8'd49;   assign COSBlock[2][6][BitWidth:8] = {(BitWidth1-8){COSBlock[2][6][7]}};                  //8'd47; 
   assign COSBlock[3][6][7:0] = 8'd25;   assign COSBlock[3][6][BitWidth:8] = {(BitWidth1-8){COSBlock[3][6][7]}};                  //8'd24; 
   assign COSBlock[4][6][7:0] = 8'd165;  assign COSBlock[4][6][BitWidth:8] = {(BitWidth1-8){COSBlock[4][6][7]}}; //168  //-88     //8'd168;
   assign COSBlock[5][6][7:0] = 8'd126;  assign COSBlock[5][6][BitWidth:8] = {(BitWidth1-8){COSBlock[5][6][7]}};                  //8'd122;
   assign COSBlock[6][6][7:0] = 8'd138;  assign COSBlock[6][6][BitWidth:8] = {(BitWidth1-8){COSBlock[6][6][7]}}; //141  //-115    //8'd141;
   assign COSBlock[7][6][7:0] = 8'd71;   assign COSBlock[7][6][BitWidth:8] = {(BitWidth1-8){COSBlock[7][6][7]}};                  //8'd69; 
                                                                                                                                  //       
   assign COSBlock[0][7][7:0] = 8'd91;   assign COSBlock[0][7][BitWidth:8] = {(BitWidth1-8){COSBlock[0][7][7]}};                  //8'd125;
   assign COSBlock[1][7][7:0] = 8'd130;  assign COSBlock[1][7][BitWidth:8] = {(BitWidth1-8){COSBlock[1][7][7]}}; //134  //-122    //8'd134;
   assign COSBlock[2][7][7:0] = 8'd118;  assign COSBlock[2][7][BitWidth:8] = {(BitWidth1-8){COSBlock[2][7][7]}};                  //8'd115;
   assign COSBlock[3][7][7:0] = 8'd150;  assign COSBlock[3][7][BitWidth:8] = {(BitWidth1-8){COSBlock[3][7][7]}}; //153  //-103    //8'd153;
   assign COSBlock[4][7][7:0] = 8'd91;   assign COSBlock[4][7][BitWidth:8] = {(BitWidth1-8){COSBlock[4][7][7]}};                  //8'd88; 
   assign COSBlock[5][7][7:0] = 8'd185;  assign COSBlock[5][7][BitWidth:8] = {(BitWidth1-8){COSBlock[5][7][7]}}; //187  //-69     //8'd187;
   assign COSBlock[6][7][7:0] = 8'd49;   assign COSBlock[6][7][BitWidth:8] = {(BitWidth1-8){COSBlock[6][7][7]}};                  //8'd47; 
   assign COSBlock[7][7][7:0] = 8'd231;  assign COSBlock[7][7][BitWidth:8] = {(BitWidth1-8){COSBlock[7][7][7]}}; //232  //-24     //8'd232;
   */
    
   assign COSBlock[0][0][15:0] = 16'd23170;   assign COSBlock[0][0][BitWidth:16] = {(BitWidth1-16){COSBlock[0][0][15]}};
   assign COSBlock[1][0][15:0] = 16'd32138;   assign COSBlock[1][0][BitWidth:16] = {(BitWidth1-16){COSBlock[1][0][15]}};
   assign COSBlock[2][0][15:0] = 16'd30274;   assign COSBlock[2][0][BitWidth:16] = {(BitWidth1-16){COSBlock[2][0][15]}};
   assign COSBlock[3][0][15:0] = 16'd27246;   assign COSBlock[3][0][BitWidth:16] = {(BitWidth1-16){COSBlock[3][0][15]}};
   assign COSBlock[4][0][15:0] = 16'd23170;   assign COSBlock[4][0][BitWidth:16] = {(BitWidth1-16){COSBlock[4][0][15]}};
   assign COSBlock[5][0][15:0] = 16'd18205;   assign COSBlock[5][0][BitWidth:16] = {(BitWidth1-16){COSBlock[5][0][15]}};
   assign COSBlock[6][0][15:0] = 16'd12540;   assign COSBlock[6][0][BitWidth:16] = {(BitWidth1-16){COSBlock[6][0][15]}};
   assign COSBlock[7][0][15:0] = 16'd6393;    assign COSBlock[7][0][BitWidth:16] = {(BitWidth1-16){COSBlock[7][0][15]}};
                                                                                                               
   assign COSBlock[0][1][15:0] = 16'd23170;   assign COSBlock[0][1][BitWidth:16] = {(BitWidth1-16){COSBlock[0][1][15]}};
   assign COSBlock[1][1][15:0] = 16'd27246;   assign COSBlock[1][1][BitWidth:16] = {(BitWidth1-16){COSBlock[1][1][15]}};
   assign COSBlock[2][1][15:0] = 16'd12540;   assign COSBlock[2][1][BitWidth:16] = {(BitWidth1-16){COSBlock[2][1][15]}};
   assign COSBlock[3][1][15:0] = 16'd59143;   assign COSBlock[3][1][BitWidth:16] = {(BitWidth1-16){COSBlock[3][1][15]}};
   assign COSBlock[4][1][15:0] = 16'd42366;   assign COSBlock[4][1][BitWidth:16] = {(BitWidth1-16){COSBlock[4][1][15]}};
   assign COSBlock[5][1][15:0] = 16'd33398;   assign COSBlock[5][1][BitWidth:16] = {(BitWidth1-16){COSBlock[5][1][15]}};
   assign COSBlock[6][1][15:0] = 16'd35262;   assign COSBlock[6][1][BitWidth:16] = {(BitWidth1-16){COSBlock[6][1][15]}};
   assign COSBlock[7][1][15:0] = 16'd47331;   assign COSBlock[7][1][BitWidth:16] = {(BitWidth1-16){COSBlock[7][1][15]}};
                                                                                                               
   assign COSBlock[0][2][15:0] = 16'd23170;   assign COSBlock[0][2][BitWidth:16] = {(BitWidth1-16){COSBlock[0][2][15]}};
   assign COSBlock[1][2][15:0] = 16'd18205;   assign COSBlock[1][2][BitWidth:16] = {(BitWidth1-16){COSBlock[1][2][15]}};
   assign COSBlock[2][2][15:0] = 16'd52996;   assign COSBlock[2][2][BitWidth:16] = {(BitWidth1-16){COSBlock[2][2][15]}};
   assign COSBlock[3][2][15:0] = 16'd33398;   assign COSBlock[3][2][BitWidth:16] = {(BitWidth1-16){COSBlock[3][2][15]}};
   assign COSBlock[4][2][15:0] = 16'd42366;   assign COSBlock[4][2][BitWidth:16] = {(BitWidth1-16){COSBlock[4][2][15]}};
   assign COSBlock[5][2][15:0] = 16'd6393;    assign COSBlock[5][2][BitWidth:16] = {(BitWidth1-16){COSBlock[5][2][15]}};
   assign COSBlock[6][2][15:0] = 16'd30274;   assign COSBlock[6][2][BitWidth:16] = {(BitWidth1-16){COSBlock[6][2][15]}};
   assign COSBlock[7][2][15:0] = 16'd27246;   assign COSBlock[7][2][BitWidth:16] = {(BitWidth1-16){COSBlock[7][2][15]}};
                                                                                                               
   assign COSBlock[0][3][15:0] = 16'd23170;   assign COSBlock[0][3][BitWidth:16] = {(BitWidth1-16){COSBlock[0][3][15]}};
   assign COSBlock[1][3][15:0] = 16'd6393;    assign COSBlock[1][3][BitWidth:16] = {(BitWidth1-16){COSBlock[1][3][15]}};
   assign COSBlock[2][3][15:0] = 16'd35262;   assign COSBlock[2][3][BitWidth:16] = {(BitWidth1-16){COSBlock[2][3][15]}};
   assign COSBlock[3][3][15:0] = 16'd47331;   assign COSBlock[3][3][BitWidth:16] = {(BitWidth1-16){COSBlock[3][3][15]}};
   assign COSBlock[4][3][15:0] = 16'd23170;   assign COSBlock[4][3][BitWidth:16] = {(BitWidth1-16){COSBlock[4][3][15]}};
   assign COSBlock[5][3][15:0] = 16'd27246;   assign COSBlock[5][3][BitWidth:16] = {(BitWidth1-16){COSBlock[5][3][15]}};
   assign COSBlock[6][3][15:0] = 16'd52996;   assign COSBlock[6][3][BitWidth:16] = {(BitWidth1-16){COSBlock[6][3][15]}};
   assign COSBlock[7][3][15:0] = 16'd33398;   assign COSBlock[7][3][BitWidth:16] = {(BitWidth1-16){COSBlock[7][3][15]}};
                                                                                                               
   assign COSBlock[0][4][15:0] = 16'd23170;   assign COSBlock[0][4][BitWidth:16] = {(BitWidth1-16){COSBlock[0][4][15]}};
   assign COSBlock[1][4][15:0] = 16'd59143;   assign COSBlock[1][4][BitWidth:16] = {(BitWidth1-16){COSBlock[1][4][15]}};
   assign COSBlock[2][4][15:0] = 16'd35262;   assign COSBlock[2][4][BitWidth:16] = {(BitWidth1-16){COSBlock[2][4][15]}};
   assign COSBlock[3][4][15:0] = 16'd18205;   assign COSBlock[3][4][BitWidth:16] = {(BitWidth1-16){COSBlock[3][4][15]}};
   assign COSBlock[4][4][15:0] = 16'd23170;   assign COSBlock[4][4][BitWidth:16] = {(BitWidth1-16){COSBlock[4][4][15]}};
   assign COSBlock[5][4][15:0] = 16'd38290;   assign COSBlock[5][4][BitWidth:16] = {(BitWidth1-16){COSBlock[5][4][15]}};
   assign COSBlock[6][4][15:0] = 16'd52996;   assign COSBlock[6][4][BitWidth:16] = {(BitWidth1-16){COSBlock[6][4][15]}};
   assign COSBlock[7][4][15:0] = 16'd32138;   assign COSBlock[7][4][BitWidth:16] = {(BitWidth1-16){COSBlock[7][4][15]}};
                                                                                                               
   assign COSBlock[0][5][15:0] = 16'd23170;   assign COSBlock[0][5][BitWidth:16] = {(BitWidth1-16){COSBlock[0][5][15]}};
   assign COSBlock[1][5][15:0] = 16'd47331;   assign COSBlock[1][5][BitWidth:16] = {(BitWidth1-16){COSBlock[1][5][15]}};
   assign COSBlock[2][5][15:0] = 16'd52996;   assign COSBlock[2][5][BitWidth:16] = {(BitWidth1-16){COSBlock[2][5][15]}};
   assign COSBlock[3][5][15:0] = 16'd32138;   assign COSBlock[3][5][BitWidth:16] = {(BitWidth1-16){COSBlock[3][5][15]}};
   assign COSBlock[4][5][15:0] = 16'd42366;   assign COSBlock[4][5][BitWidth:16] = {(BitWidth1-16){COSBlock[4][5][15]}};
   assign COSBlock[5][5][15:0] = 16'd59143;   assign COSBlock[5][5][BitWidth:16] = {(BitWidth1-16){COSBlock[5][5][15]}};
   assign COSBlock[6][5][15:0] = 16'd30274;   assign COSBlock[6][5][BitWidth:16] = {(BitWidth1-16){COSBlock[6][5][15]}};
   assign COSBlock[7][5][15:0] = 16'd38290;   assign COSBlock[7][5][BitWidth:16] = {(BitWidth1-16){COSBlock[7][5][15]}};
                                                                                                               
   assign COSBlock[0][6][15:0] = 16'd23170;   assign COSBlock[0][6][BitWidth:16] = {(BitWidth1-16){COSBlock[0][6][15]}};
   assign COSBlock[1][6][15:0] = 16'd38290;   assign COSBlock[1][6][BitWidth:16] = {(BitWidth1-16){COSBlock[1][6][15]}};
   assign COSBlock[2][6][15:0] = 16'd12540;   assign COSBlock[2][6][BitWidth:16] = {(BitWidth1-16){COSBlock[2][6][15]}};
   assign COSBlock[3][6][15:0] = 16'd6393;    assign COSBlock[3][6][BitWidth:16] = {(BitWidth1-16){COSBlock[3][6][15]}};
   assign COSBlock[4][6][15:0] = 16'd42366;   assign COSBlock[4][6][BitWidth:16] = {(BitWidth1-16){COSBlock[4][6][15]}};
   assign COSBlock[5][6][15:0] = 16'd32138;   assign COSBlock[5][6][BitWidth:16] = {(BitWidth1-16){COSBlock[5][6][15]}};
   assign COSBlock[6][6][15:0] = 16'd35262;   assign COSBlock[6][6][BitWidth:16] = {(BitWidth1-16){COSBlock[6][6][15]}};
   assign COSBlock[7][6][15:0] = 16'd18205;   assign COSBlock[7][6][BitWidth:16] = {(BitWidth1-16){COSBlock[7][6][15]}};
                                                                                                               
   assign COSBlock[0][7][15:0] = 16'd23170;   assign COSBlock[0][7][BitWidth:16] = {(BitWidth1-16){COSBlock[0][7][15]}};
   assign COSBlock[1][7][15:0] = 16'd33398;   assign COSBlock[1][7][BitWidth:16] = {(BitWidth1-16){COSBlock[1][7][15]}};
   assign COSBlock[2][7][15:0] = 16'd30274;   assign COSBlock[2][7][BitWidth:16] = {(BitWidth1-16){COSBlock[2][7][15]}};
   assign COSBlock[3][7][15:0] = 16'd38290;   assign COSBlock[3][7][BitWidth:16] = {(BitWidth1-16){COSBlock[3][7][15]}};
   assign COSBlock[4][7][15:0] = 16'd23170;   assign COSBlock[4][7][BitWidth:16] = {(BitWidth1-16){COSBlock[4][7][15]}};
   assign COSBlock[5][7][15:0] = 16'd47331;   assign COSBlock[5][7][BitWidth:16] = {(BitWidth1-16){COSBlock[5][7][15]}};
   assign COSBlock[6][7][15:0] = 16'd12540;   assign COSBlock[6][7][BitWidth:16] = {(BitWidth1-16){COSBlock[6][7][15]}};
   assign COSBlock[7][7][15:0] = 16'd59143;   assign COSBlock[7][7][BitWidth:16] = {(BitWidth1-16){COSBlock[7][7][15]}};

   wire [63: 0] mul_res;
   assign mul_res[63:`a2_cut_prime + `b2_cut_prime] = $signed(A[31:`a2_cut_prime]) * $signed(B[31:`b2_cut_prime]); //changed
   //assign mul_res [(`a2_cut_prime + `b2_cut_prime - 1):0] = {(`a2_cut_prime + `b2_cut_prime){1'b0}}; //changed
   //assign mul_res[63:0] = $signed(A) * $signed(B); //changed
   //wire [31:0]mul_res__0; 
   //assign mul_res__0[31:0] = A * B; //changed



   wire [BitWidth+3:0] Sum_tmp;
   assign Sum_tmp = Sum + {{3{P[31]}}, P};    

   always@(posedge clk or posedge reset)
   begin
      if(reset == 1)
         begin
            done <= 0;            
            dout <= 32'h0;
            state <= 3'b000;        
            reading <= 0;
            
            InBlock[0][0] <= 32'h0; InBlock[0][1] <= 32'h0; InBlock[0][2] <= 32'h0; InBlock[0][3] <= 32'h0; InBlock[0][4] <= 32'h0; InBlock[0][5] <= 32'h0; InBlock[0][6] <= 32'h0; InBlock[0][7] <= 32'h0;
            InBlock[1][0] <= 32'h0; InBlock[1][1] <= 32'h0; InBlock[1][2] <= 32'h0; InBlock[1][3] <= 32'h0; InBlock[1][4] <= 32'h0; InBlock[1][5] <= 32'h0; InBlock[1][6] <= 32'h0; InBlock[1][7] <= 32'h0;
            InBlock[2][0] <= 32'h0; InBlock[2][1] <= 32'h0; InBlock[2][2] <= 32'h0; InBlock[2][3] <= 32'h0; InBlock[2][4] <= 32'h0; InBlock[2][5] <= 32'h0; InBlock[2][6] <= 32'h0; InBlock[2][7] <= 32'h0;
            InBlock[3][0] <= 32'h0; InBlock[3][1] <= 32'h0; InBlock[3][2] <= 32'h0; InBlock[3][3] <= 32'h0; InBlock[3][4] <= 32'h0; InBlock[3][5] <= 32'h0; InBlock[3][6] <= 32'h0; InBlock[3][7] <= 32'h0;
            InBlock[4][0] <= 32'h0; InBlock[4][1] <= 32'h0; InBlock[4][2] <= 32'h0; InBlock[4][3] <= 32'h0; InBlock[4][4] <= 32'h0; InBlock[4][5] <= 32'h0; InBlock[4][6] <= 32'h0; InBlock[4][7] <= 32'h0;
            InBlock[5][0] <= 32'h0; InBlock[5][1] <= 32'h0; InBlock[5][2] <= 32'h0; InBlock[5][3] <= 32'h0; InBlock[5][4] <= 32'h0; InBlock[5][5] <= 32'h0; InBlock[5][6] <= 32'h0; InBlock[5][7] <= 32'h0;
            InBlock[6][0] <= 32'h0; InBlock[6][1] <= 32'h0; InBlock[6][2] <= 32'h0; InBlock[6][3] <= 32'h0; InBlock[6][4] <= 32'h0; InBlock[6][5] <= 32'h0; InBlock[6][6] <= 32'h0; InBlock[6][7] <= 32'h0;
            InBlock[7][0] <= 32'h0; InBlock[7][1] <= 32'h0; InBlock[7][2] <= 32'h0; InBlock[7][3] <= 32'h0; InBlock[7][4] <= 32'h0; InBlock[7][5] <= 32'h0; InBlock[7][6] <= 32'h0; InBlock[7][7] <= 32'h0;
            
            TempBlock[0][0] <= 32'h0; TempBlock[0][1] <= 32'h0; TempBlock[0][2] <= 32'h0; TempBlock[0][3] <= 32'h0; TempBlock[0][4] <= 32'h0; TempBlock[0][5] <= 32'h0; TempBlock[0][6] <= 32'h0; TempBlock[0][7] <= 32'h0;
            TempBlock[1][0] <= 32'h0; TempBlock[1][1] <= 32'h0; TempBlock[1][2] <= 32'h0; TempBlock[1][3] <= 32'h0; TempBlock[1][4] <= 32'h0; TempBlock[1][5] <= 32'h0; TempBlock[1][6] <= 32'h0; TempBlock[1][7] <= 32'h0;
            TempBlock[2][0] <= 32'h0; TempBlock[2][1] <= 32'h0; TempBlock[2][2] <= 32'h0; TempBlock[2][3] <= 32'h0; TempBlock[2][4] <= 32'h0; TempBlock[2][5] <= 32'h0; TempBlock[2][6] <= 32'h0; TempBlock[2][7] <= 32'h0;
            TempBlock[3][0] <= 32'h0; TempBlock[3][1] <= 32'h0; TempBlock[3][2] <= 32'h0; TempBlock[3][3] <= 32'h0; TempBlock[3][4] <= 32'h0; TempBlock[3][5] <= 32'h0; TempBlock[3][6] <= 32'h0; TempBlock[3][7] <= 32'h0;
            TempBlock[4][0] <= 32'h0; TempBlock[4][1] <= 32'h0; TempBlock[4][2] <= 32'h0; TempBlock[4][3] <= 32'h0; TempBlock[4][4] <= 32'h0; TempBlock[4][5] <= 32'h0; TempBlock[4][6] <= 32'h0; TempBlock[4][7] <= 32'h0;
            TempBlock[5][0] <= 32'h0; TempBlock[5][1] <= 32'h0; TempBlock[5][2] <= 32'h0; TempBlock[5][3] <= 32'h0; TempBlock[5][4] <= 32'h0; TempBlock[5][5] <= 32'h0; TempBlock[5][6] <= 32'h0; TempBlock[5][7] <= 32'h0;
            TempBlock[6][0] <= 32'h0; TempBlock[6][1] <= 32'h0; TempBlock[6][2] <= 32'h0; TempBlock[6][3] <= 32'h0; TempBlock[6][4] <= 32'h0; TempBlock[6][5] <= 32'h0; TempBlock[6][6] <= 32'h0; TempBlock[6][7] <= 32'h0;
            TempBlock[7][0] <= 32'h0; TempBlock[7][1] <= 32'h0; TempBlock[7][2] <= 32'h0; TempBlock[7][3] <= 32'h0; TempBlock[7][4] <= 32'h0; TempBlock[7][5] <= 32'h0; TempBlock[7][6] <= 32'h0; TempBlock[7][7] <= 32'h0;        
            
            OutBlock[0][0] <= 32'h0; OutBlock[0][1] <= 32'h0; OutBlock[0][2] <= 32'h0; OutBlock[0][3] <= 32'h0; OutBlock[0][4] <= 32'h0; OutBlock[0][5] <= 32'h0; OutBlock[0][6] <= 32'h0; OutBlock[0][7] <= 32'h0;
            OutBlock[1][0] <= 32'h0; OutBlock[1][1] <= 32'h0; OutBlock[1][2] <= 32'h0; OutBlock[1][3] <= 32'h0; OutBlock[1][4] <= 32'h0; OutBlock[1][5] <= 32'h0; OutBlock[1][6] <= 32'h0; OutBlock[1][7] <= 32'h0;
            OutBlock[2][0] <= 32'h0; OutBlock[2][1] <= 32'h0; OutBlock[2][2] <= 32'h0; OutBlock[2][3] <= 32'h0; OutBlock[2][4] <= 32'h0; OutBlock[2][5] <= 32'h0; OutBlock[2][6] <= 32'h0; OutBlock[2][7] <= 32'h0;
            OutBlock[3][0] <= 32'h0; OutBlock[3][1] <= 32'h0; OutBlock[3][2] <= 32'h0; OutBlock[3][3] <= 32'h0; OutBlock[3][4] <= 32'h0; OutBlock[3][5] <= 32'h0; OutBlock[3][6] <= 32'h0; OutBlock[3][7] <= 32'h0;
            OutBlock[4][0] <= 32'h0; OutBlock[4][1] <= 32'h0; OutBlock[4][2] <= 32'h0; OutBlock[4][3] <= 32'h0; OutBlock[4][4] <= 32'h0; OutBlock[4][5] <= 32'h0; OutBlock[4][6] <= 32'h0; OutBlock[4][7] <= 32'h0;
            OutBlock[5][0] <= 32'h0; OutBlock[5][1] <= 32'h0; OutBlock[5][2] <= 32'h0; OutBlock[5][3] <= 32'h0; OutBlock[5][4] <= 32'h0; OutBlock[5][5] <= 32'h0; OutBlock[5][6] <= 32'h0; OutBlock[5][7] <= 32'h0;
            OutBlock[6][0] <= 32'h0; OutBlock[6][1] <= 32'h0; OutBlock[6][2] <= 32'h0; OutBlock[6][3] <= 32'h0; OutBlock[6][4] <= 32'h0; OutBlock[6][5] <= 32'h0; OutBlock[6][6] <= 32'h0; OutBlock[6][7] <= 32'h0;
            OutBlock[7][0] <= 32'h0; OutBlock[7][1] <= 32'h0; OutBlock[7][2] <= 32'h0; OutBlock[7][3] <= 32'h0; OutBlock[7][4] <= 32'h0; OutBlock[7][5] <= 32'h0; OutBlock[7][6] <= 32'h0; OutBlock[7][7] <= 32'h0;
            
            count0 <= 9'h0;
            count1 <= 9'h0;
            count2 <= 9'h0;
            count3 <= 9'h0;
            
            A <= 32'h0;
            B <= 32'h0;
            P <= 32'h0;
            Sum <= 35'h0;
         end
      else
         begin
            case (state)
            3'b000:
            begin
               done <= 0;
               count0 <= 0;
               count1 <= 0;
               count2 <= 0;
               count3 <= 0;
               if(start == 1) 
                  begin
                     reading <= 1;
                     state <= 3'b001;
                  end
               else
                  begin
                     state <= 3'b000;
                  end
            end
            3'b001:
            begin
               if(count0 == 9'd63) 
                  begin
                     A <= InBlock[0][0]; B <= COSBlock[0][0];                     
                     P_tmp = InBlock[0][0] * COSBlock[0][0];
                     Sum <= 35'd0; 
                     P <= 32'd0;
                     reading <= 0;
                     count0 <= 9'd1;
                     state <= 3'b010;
                  end
               else
                  begin
                     count0 <= count0 + 1;
                     state <= 3'b001;
                  end
               InBlock[j0][k0] <= din;               
            end
            3'b010:
            begin  
               A <= InBlock[j0][k0]; B <= COSBlock[i0][k0];
               P <= $signed(A) * $signed(B);
               //P[31:(`a1_cut + `b1_cut)] <= {{3{mul_res__0[31]}}, mul_res__0[31:3]};
               
               count0 <= count0 + 1;
               count1 <= count0;
               count2 <= count1;
               count3 <= count2;
            	                            
               if(k3 == 3'd7)
                  begin
                     //TempBlock[j3][i3] <= Sum;
                     TempBlock[j3][i3] <= Sum[31:0];                     
                     Sum <= {{3{P[31]}}, P};    
                     //Sum <= P;
                  end
               else
                  begin                     
                  Sum = Sum + {{3{P[31]}}, P};    
                  //Sum <= Sum + P;                     
                  end        
                            
               //if(count0 == 9'd511)
               if(count0 == 9'd0)
                  begin
                     state <= 3'b011; 
                  end
            end
            3'b011:
            begin
               TempBlock[j3][i3] <= Sum_tmp[31:0];
               //TempBlock[j3][i3] <= Sum + P;               
               Sum <= 35'd0;
               P <= 32'd0;
               count0 <= 1;
               count1 <= 0;
               count2 <= 0;
               count3 <= 0;                 
                                 
               state <= 3'b100;
               
               A <= TempBlock[0][0]; B <= COSBlock[0][0];
               P_tmp = TempBlock[0][0] * COSBlock[0][0];
               
               
            end
            3'b100:
            begin 
               A <= TempBlock[k0][i0]; B <= COSBlock[j0][k0];
               //P <= A * B;
	           //P[31:0] <= mul_res[39:8];
	           //P[31:0] <= mul_res[40:9];
	           //P[31:0] <= mul_res[41:10];
	           P[31:0] <= {{3{mul_res[42]}}, mul_res[42:14]};
               count0 <= count0 + 1;
               count1 <= count0;
               count2 <= count1;
               count3 <= count2;  
                                          
               if(k3 == 3'd7)
                  begin
                     //OutBlock[j3][i3] <= Sum[34:3];
                     OutBlock[j3][i3] <= Sum[31:0];
                     //OutBlock[j3][i3] <= Sum;               
                     Sum <= {{3{P[31]}},P};  
                     //Sum <= P;
                  end
               else
                  begin                     
                    Sum = Sum + {{3{P[31]}}, P};    
                    //Sum <= Sum + P;
                     //Sum <= Sum_tmp;
                  end
                  
               //if(count0 == 9'd511)
               if(count0 == 9'd0)
                  begin
                     state <= 3'b101; 
                  end
            end
            3'b101:
            begin                              
               //OutBlock[j3][i3] <= Sum + P;
               OutBlock[j3][i3] <= Sum_tmp[34:3];               
               state <= 3'b110;
               count0 <= 9'b0;
               done <= 1;
            end
            3'b110:
            begin
               if(count0 == 9'd63)
                  begin
                     count0 <= 9'b0;
                     state <= 3'b000;
                  end
               else
                  begin
                     count0 <= count0 + 1;
                     state <= 3'b110;
                  end
               dout <= OutBlock[j0][k0];   
            end
            default:
               state <= 3'b000;
            endcase
         end
   end
                       
endmodule
