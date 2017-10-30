// *** FDN this application is optimized for a system with one multiplier
//         with the configurability of accurate (24 bit) and in accurate (set by
//         a2_cut, b2_cut and b1_cut. Note that both multiplication uses the same
//         multiplier, but the first one is shifted properly
`timescale 1ns / 1ps

`define a1_cut 0
`define b1_cut 8
`define a2_cut 8
`define b2_cut 8


module idct(clk, start, racc, rapx, din, done, dout, state_out, reading);
   

//   integer ftw;
//   ftw = $fopen("behzads__dubuging_output.txt", "w");
   
   parameter BitWidth = 31;
   parameter BitWidth1 = 32;
	
   input clk, start;
   input racc;  
   input rapx; 
   output done;
   output reading;
   output [2:0] state_out;  
   
   input [BitWidth:0] din;
   output [BitWidth:0] dout;
   
   wire clk, start;
   wire racc;  
   reg done;
   reg reading;
   wire[2:0] state_out;  
   
   wire [BitWidth:0] din;
   reg [BitWidth:0] dout;
   
   reg [8:0] count0, count1, count2, count3;
   reg [23:0] B;
   reg [23:0] A;
   
   

   
   wire [BitWidth:0] P;
   reg [BitWidth+3:0] Sum; 
 


   wire [BitWidth:0] Sum_tmp;
   
   wire [BitWidth:0] COSBlock[0:7][0:7];
   reg [BitWidth:0] InBlock[0:7][0:7];  
   reg [BitWidth:0] TempBlock[0:7][0:7];
   reg [BitWidth:0] OutBlock[0:7][0:7];
   
   reg [2:0] state;      
   wire[2:0] i0, j0, k0, k2, i3, j3, k3;
   integer fpa;
   
   assign i0 = count0[8:6];
   assign j0 = count0[5:3];
   assign k0 = count0[2:0];    
   assign k2 = count2[2:0];    
   assign i3 = count3[8:6];
   assign j3 = count3[5:3];
   assign k3 = count3[2:0];    
   
   assign state_out = state;  
         
   //assign Sum_tmp = P + Sum;
         
   assign COSBlock[0][0][15:0] = 16'd23170;   assign COSBlock[0][0][BitWidth:16] = {(BitWidth1-16){COSBlock[0][0][15]}};
   assign COSBlock[0][1][15:0] = 16'd32138;   assign COSBlock[0][1][BitWidth:16] = {(BitWidth1-16){COSBlock[0][1][15]}};
   assign COSBlock[0][2][15:0] = 16'd30274;   assign COSBlock[0][2][BitWidth:16] = {(BitWidth1-16){COSBlock[0][2][15]}};
   assign COSBlock[0][3][15:0] = 16'd27246;   assign COSBlock[0][3][BitWidth:16] = {(BitWidth1-16){COSBlock[0][3][15]}};
   assign COSBlock[0][4][15:0] = 16'd23170;   assign COSBlock[0][4][BitWidth:16] = {(BitWidth1-16){COSBlock[0][4][15]}};
   assign COSBlock[0][5][15:0] = 16'd18205;   assign COSBlock[0][5][BitWidth:16] = {(BitWidth1-16){COSBlock[0][5][15]}};
   assign COSBlock[0][6][15:0] = 16'd12540;   assign COSBlock[0][6][BitWidth:16] = {(BitWidth1-16){COSBlock[0][6][15]}};
   assign COSBlock[0][7][15:0] = 16'd6393;   assign COSBlock[0][7][BitWidth:16] = {(BitWidth1-16){COSBlock[0][7][15]}};

   assign COSBlock[1][0][15:0] = 16'd23170;   assign COSBlock[1][0][BitWidth:16] = {(BitWidth1-16){COSBlock[1][0][15]}};
   assign COSBlock[1][1][15:0] = 16'd27246;   assign COSBlock[1][1][BitWidth:16] = {(BitWidth1-16){COSBlock[1][1][15]}};
   assign COSBlock[1][2][15:0] = 16'd12540;   assign COSBlock[1][2][BitWidth:16] = {(BitWidth1-16){COSBlock[1][2][15]}};
   assign COSBlock[1][3][15:0] = 16'd59143;   assign COSBlock[1][3][BitWidth:16] = {(BitWidth1-16){COSBlock[1][3][15]}};
   assign COSBlock[1][4][15:0] = 16'd42366;   assign COSBlock[1][4][BitWidth:16] = {(BitWidth1-16){COSBlock[1][4][15]}};
   assign COSBlock[1][5][15:0] = 16'd33398;   assign COSBlock[1][5][BitWidth:16] = {(BitWidth1-16){COSBlock[1][5][15]}};
   assign COSBlock[1][6][15:0] = 16'd35262;   assign COSBlock[1][6][BitWidth:16] = {(BitWidth1-16){COSBlock[1][6][15]}};
   assign COSBlock[1][7][15:0] = 16'd47331;   assign COSBlock[1][7][BitWidth:16] = {(BitWidth1-16){COSBlock[1][7][15]}};

   assign COSBlock[2][0][15:0] = 16'd23170;   assign COSBlock[2][0][BitWidth:16] = {(BitWidth1-16){COSBlock[2][0][15]}};
   assign COSBlock[2][1][15:0] = 16'd18205;   assign COSBlock[2][1][BitWidth:16] = {(BitWidth1-16){COSBlock[2][1][15]}};
   assign COSBlock[2][2][15:0] = 16'd52996;   assign COSBlock[2][2][BitWidth:16] = {(BitWidth1-16){COSBlock[2][2][15]}};
   assign COSBlock[2][3][15:0] = 16'd33398;   assign COSBlock[2][3][BitWidth:16] = {(BitWidth1-16){COSBlock[2][3][15]}};
   assign COSBlock[2][4][15:0] = 16'd42366;   assign COSBlock[2][4][BitWidth:16] = {(BitWidth1-16){COSBlock[2][4][15]}};
   assign COSBlock[2][5][15:0] = 16'd6393;   assign COSBlock[2][5][BitWidth:16] = {(BitWidth1-16){COSBlock[2][5][15]}};
   assign COSBlock[2][6][15:0] = 16'd30274;   assign COSBlock[2][6][BitWidth:16] = {(BitWidth1-16){COSBlock[2][6][15]}};
   assign COSBlock[2][7][15:0] = 16'd27246;   assign COSBlock[2][7][BitWidth:16] = {(BitWidth1-16){COSBlock[2][7][15]}};

   assign COSBlock[3][0][15:0] = 16'd23170;   assign COSBlock[3][0][BitWidth:16] = {(BitWidth1-16){COSBlock[3][0][15]}};
   assign COSBlock[3][1][15:0] = 16'd6393;   assign COSBlock[3][1][BitWidth:16] = {(BitWidth1-16){COSBlock[3][1][15]}};
   assign COSBlock[3][2][15:0] = 16'd35262;   assign COSBlock[3][2][BitWidth:16] = {(BitWidth1-16){COSBlock[3][2][15]}};
   assign COSBlock[3][3][15:0] = 16'd47331;   assign COSBlock[3][3][BitWidth:16] = {(BitWidth1-16){COSBlock[3][3][15]}};
   assign COSBlock[3][4][15:0] = 16'd23170;   assign COSBlock[3][4][BitWidth:16] = {(BitWidth1-16){COSBlock[3][4][15]}};
   assign COSBlock[3][5][15:0] = 16'd27246;   assign COSBlock[3][5][BitWidth:16] = {(BitWidth1-16){COSBlock[3][5][15]}};
   assign COSBlock[3][6][15:0] = 16'd52996;   assign COSBlock[3][6][BitWidth:16] = {(BitWidth1-16){COSBlock[3][6][15]}};
   assign COSBlock[3][7][15:0] = 16'd33398;   assign COSBlock[3][7][BitWidth:16] = {(BitWidth1-16){COSBlock[3][7][15]}};

   assign COSBlock[4][0][15:0] = 16'd23170;   assign COSBlock[4][0][BitWidth:16] = {(BitWidth1-16){COSBlock[4][0][15]}};
   assign COSBlock[4][1][15:0] = 16'd59143;   assign COSBlock[4][1][BitWidth:16] = {(BitWidth1-16){COSBlock[4][1][15]}};
   assign COSBlock[4][2][15:0] = 16'd35262;   assign COSBlock[4][2][BitWidth:16] = {(BitWidth1-16){COSBlock[4][2][15]}};
   assign COSBlock[4][3][15:0] = 16'd18205;   assign COSBlock[4][3][BitWidth:16] = {(BitWidth1-16){COSBlock[4][3][15]}};
   assign COSBlock[4][4][15:0] = 16'd23170;   assign COSBlock[4][4][BitWidth:16] = {(BitWidth1-16){COSBlock[4][4][15]}};
   assign COSBlock[4][5][15:0] = 16'd38290;   assign COSBlock[4][5][BitWidth:16] = {(BitWidth1-16){COSBlock[4][5][15]}};
   assign COSBlock[4][6][15:0] = 16'd52996;   assign COSBlock[4][6][BitWidth:16] = {(BitWidth1-16){COSBlock[4][6][15]}};
   assign COSBlock[4][7][15:0] = 16'd32138;   assign COSBlock[4][7][BitWidth:16] = {(BitWidth1-16){COSBlock[4][7][15]}};

   assign COSBlock[5][0][15:0] = 16'd23170;   assign COSBlock[5][0][BitWidth:16] = {(BitWidth1-16){COSBlock[5][0][15]}};
   assign COSBlock[5][1][15:0] = 16'd47331;   assign COSBlock[5][1][BitWidth:16] = {(BitWidth1-16){COSBlock[5][1][15]}};
   assign COSBlock[5][2][15:0] = 16'd52996;   assign COSBlock[5][2][BitWidth:16] = {(BitWidth1-16){COSBlock[5][2][15]}};
   assign COSBlock[5][3][15:0] = 16'd32138;   assign COSBlock[5][3][BitWidth:16] = {(BitWidth1-16){COSBlock[5][3][15]}};
   assign COSBlock[5][4][15:0] = 16'd42366;   assign COSBlock[5][4][BitWidth:16] = {(BitWidth1-16){COSBlock[5][4][15]}};
   assign COSBlock[5][5][15:0] = 16'd59143;   assign COSBlock[5][5][BitWidth:16] = {(BitWidth1-16){COSBlock[5][5][15]}};
   assign COSBlock[5][6][15:0] = 16'd30274;   assign COSBlock[5][6][BitWidth:16] = {(BitWidth1-16){COSBlock[5][6][15]}};
   assign COSBlock[5][7][15:0] = 16'd38290;   assign COSBlock[5][7][BitWidth:16] = {(BitWidth1-16){COSBlock[5][7][15]}};

   assign COSBlock[6][0][15:0] = 16'd23170;   assign COSBlock[6][0][BitWidth:16] = {(BitWidth1-16){COSBlock[6][0][15]}};
   assign COSBlock[6][1][15:0] = 16'd38290;   assign COSBlock[6][1][BitWidth:16] = {(BitWidth1-16){COSBlock[6][1][15]}};
   assign COSBlock[6][2][15:0] = 16'd12540;   assign COSBlock[6][2][BitWidth:16] = {(BitWidth1-16){COSBlock[6][2][15]}};
   assign COSBlock[6][3][15:0] = 16'd6393;   assign COSBlock[6][3][BitWidth:16] = {(BitWidth1-16){COSBlock[6][3][15]}};
   assign COSBlock[6][4][15:0] = 16'd42366;   assign COSBlock[6][4][BitWidth:16] = {(BitWidth1-16){COSBlock[6][4][15]}};
   assign COSBlock[6][5][15:0] = 16'd32138;   assign COSBlock[6][5][BitWidth:16] = {(BitWidth1-16){COSBlock[6][5][15]}};
   assign COSBlock[6][6][15:0] = 16'd35262;   assign COSBlock[6][6][BitWidth:16] = {(BitWidth1-16){COSBlock[6][6][15]}};
   assign COSBlock[6][7][15:0] = 16'd18205;   assign COSBlock[6][7][BitWidth:16] = {(BitWidth1-16){COSBlock[6][7][15]}};

   assign COSBlock[7][0][15:0] = 16'd23170;   assign COSBlock[7][0][BitWidth:16] = {(BitWidth1-16){COSBlock[7][0][15]}};
   assign COSBlock[7][1][15:0] = 16'd33398;   assign COSBlock[7][1][BitWidth:16] = {(BitWidth1-16){COSBlock[7][1][15]}};
   assign COSBlock[7][2][15:0] = 16'd30274;   assign COSBlock[7][2][BitWidth:16] = {(BitWidth1-16){COSBlock[7][2][15]}};
   assign COSBlock[7][3][15:0] = 16'd38290;   assign COSBlock[7][3][BitWidth:16] = {(BitWidth1-16){COSBlock[7][3][15]}};
   assign COSBlock[7][4][15:0] = 16'd23170;   assign COSBlock[7][4][BitWidth:16] = {(BitWidth1-16){COSBlock[7][4][15]}};
   assign COSBlock[7][5][15:0] = 16'd47331;   assign COSBlock[7][5][BitWidth:16] = {(BitWidth1-16){COSBlock[7][5][15]}};
   assign COSBlock[7][6][15:0] = 16'd12540;   assign COSBlock[7][6][BitWidth:16] = {(BitWidth1-16){COSBlock[7][6][15]}};
   assign COSBlock[7][7][15:0] = 16'd59143;   assign COSBlock[7][7][BitWidth:16] = {(BitWidth1-16){COSBlock[7][7][15]}};

   
//   wire [31: 0] mul_res;
   //wire [63: 0] mul_res;
   //assign mul_res[63:0] = $signed(A) * $signed(B); //changed
   
   //assign mul_res[63:`a2_cut + `b2_cut] = $signed(A[31:`a2_cut]) * $signed(B[31:`b2_cut]); //changed
   //assign mul_res [(`a2_cut + `b2_cut - 1):0] = {(`a2_cut + `b2_cut){1'b0}}; //changed
   //wire [31:0]mul_res__0; 
   //assign mul_res__0[31:0] = A * B; //changed


    wire rstP; 
    wire [23: 0] A_in;
    wire [23: 0] B_in;
    assign A_in = A;
    assign B_in = B;
      
    wire [34:0] Sum_stuff;
    assign Sum_stuff = Sum + {{3{P[31]}}, P};

    assign rstP = ((racc == 1) || (( state ==  3'b001) && count0 == 9'd63) || (state == 3'b011)) ? 1'b1: 1'b0;
    
    wire [23:0] A_in_to_wrapper;
    wire [23:0] B_in_to_wrapper;
    assign A_in_to_wrapper = (state == 3'b001)? InBlock[0][0][23:0]:
        ((state == 3'b010)? InBlock[j0][k0][23:0]:
        ((state == 3'b011)? TempBlock[0][0][31:8]: 
        ((state == 3'b100) ? TempBlock[k0][i0][31:8]:
        24'b1)));
    assign B_in_to_wrapper = (state == 3'b001) ? COSBlock[0][0][23:0]:
        ((state == 3'b010)? COSBlock[i0][k0][23:0]:
        ((state == 3'b011)? COSBlock[0][0][23:0]: 
        ((state == 3'b100) ? COSBlock[j0][k0][23:0]:
        24'b1)));

    
    conf_int_mul__noFF__arch_agnos__w_wrapper #(24 - `b2_cut, 24)mult(A_in_to_wrapper, B_in_to_wrapper, state, rstP, clk, racc,rapx, P, count0);
   
    // synopsys dc_script_begin
    //set_dont_touch mul__inst
    // synopsys dc_script_end
//    conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH16_DATA_PATH_BITWIDTH24 mul__inst( 
//        A_in_to_wrapper, B_in_to_wrapper, state, rstP, clk, racc, rapx, P, 
//        count0 );
//
   
   always@(posedge clk or posedge racc)
   begin
      if(racc == 1)
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
            
            //A <= 24'h0;
            //B <= 24'h0;
            //P <= 32'h0;
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
                     //A <= InBlock[0][0][23:0]; B <= COSBlock[0][0][23:0];
                     //A <= A_in_to_wrapper ; B <= B_in_to_wrapper;
                     Sum <= 35'd0; 
                     //P <= 32'd0;
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
               //A <= InBlock[j0][k0][23:0]; B <= COSBlock[i0][k0][23:0];
               //A <= A_in_to_wrapper ; B <= B_in_to_wrapper;
               //P_tmp[31:(`a1_cut + `b1_cut)] = A[31:`a1_cut] * B[31:`b1_cut]; //changed
               //P_tmp[31:(`a1_cut + `b1_cut)] = {{3{mul_res__0[31]}}, mul_res__0[31:3]};
            //P_tmp[31:24] = {8{P_tmp[23]}};  // changed
	       //P_tmp[(`a1_cut + `b1_cut - 1):0] = {(`a1_cut + `b1_cut){1'b0}}; //changed
               //P <= P_tmp;
	       count0 <= count0 + 1;
               count1 <= count0;
               count2 <= count1;
               count3 <= count2;
            	                            
               if(k3 == 3'd7)
                  begin
                     TempBlock[j3][i3] <= Sum[34:3];                     
                     Sum <= {{3{P[31]}},P};
                  end
               else
                  begin                     
                     Sum <= {{3{P[31]}},P} + Sum;
                     //Sum <= Sum + P;                     
                     //Sum <= Sum_tmp;
                  end        
                            
               if(count0 == 9'd0)
                  begin
                     state <= 3'b011; 
                  end
            end
            3'b011:
            begin
               //TempBlock[j3][i3] <= Sum + {{3{P[31]}}, P};
               TempBlock[j3][i3] <= Sum_stuff[34:3];
               //TempBlock[j3][i3] <= Sum_tmp;
               
               Sum <= 35'd0;
               //P <= 32'd0;
               count0 <= 1;
               count1 <= 0;
               count2 <= 0;
               count3 <= 0;                 
                  
               state <= 3'b100;
               
               //A <= TempBlock[0][0][31:8]; B <= COSBlock[0][0][23:0];
               //A <= A_in_to_wrapper ; B <= B_in_to_wrapper;
           end
            3'b100:
            begin 
               //A <= TempBlock[k0][i0][31:8]; B <= COSBlock[j0][k0][23:0];
               //A <= A_in_to_wrapper ; B <= B_in_to_wrapper;
               //P[31:0] <= mul_res[47:16];
	       //P[31:0] <= {{3{mul_res[47]}}, mul_res[47:19]};
           //P[31:0] <= (mul_res>>16);
           //P[31:0] <= ((A[31:`a2_cut] * B[31:`b2_cut])>>16); //changed
           //$fwrite(ftw, "%b %b %b\n", A[31:0] , B[31:0], P[31:0]);
           //P[(`a2_cut + `b2_cut - 1):0] <= {(`a2_cut + `b2_cut){1'b0}}; //changed
               count0 <= count0 + 1;
               count1 <= count0;
               count2 <= count1;
               count3 <= count2;  
                                          
               if(k3 == 3'd7)
                  begin
                     OutBlock[j3][i3] <= Sum[34:3];
                    // Sum <= P;
                     Sum <= {{3{P[31]}},P};
                 end
               else
                  begin                     
                     //Sum <= Sum + P;
                     Sum <= {{3{P[31]}},P} + Sum;
                     //Sum <= Sum_tmp;
                  end
                  
               if(count0 == 9'd0)
                  begin
                     state <= 3'b101; 
                  end
            end
            3'b101:
            begin
               //OutBlock[j3][i3] <= Sum_tmp;
               //OutBlock[j3][i3] <= Sum + P;
               OutBlock[j3][i3] <= Sum_stuff[34:3];
               
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
                       
//$fclose(ftw);
//end
endmodule

