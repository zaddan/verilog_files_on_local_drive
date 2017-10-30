module multiply(A, B, d);
   parameter BitWidth = 23;
   input [BitWidth : 0] A;
   input [BitWidth : 0] B;
   output [2*(BitWidth+1) - 1 : 0] d;
   assign d = $signed(A) * $signed(B);
endmodule

// *** F:DN multiplier wrapper
module multiply__wrapper (A_in_to_wrapper, B_in_to_wrapper, state, rstP, clk, racc,rapx, P, count0);
   parameter BitWidth = 23;
   
   input [BitWidth : 0] A_in_to_wrapper;
   input [BitWidth : 0] B_in_to_wrapper;
   input [8:0] count0;
   input [2:0] state;      
   input rstP; 
   input clk;
   input racc; //accurate bits reset  
   input rapx; //apx bits reset
   output [31:0] P; 

   wire [BitWidth : 0] A_in;
   wire [BitWidth : 0] B_in;
   wire [2*(BitWidth+1) - 1 : 0] d_out;
   wire [2*(BitWidth+1) - 1 : 0] d_out_temp;
   wire [BitWidth : 0] A_in_to_multiply;
   wire [BitWidth : 0] B_in_to_multiply;
   //.................................................... 
   reg [BitWidth : 0] A;
   reg [BitWidth : 0] B;
   reg [31: 0] P_tmp;
   reg [31: 0] P_reg;  

   // *** F:DN combination logic 
   assign A_in = A;
   assign B_in = B;
  
//   assign A_in_to_multiply =  (state == 3'b010) ? (A_in << 8): {A_in[BitWidth: `a2_cut], {(`a2_cut){1'b0}}};
//   assign B_in_to_multiply =  (state == 3'b010) ? {B_in[BitWidth:`b1_cut], {(`b1_cut){1'b0}}} : {B_in[BitWidth:`b2_cut], {(`b2_cut){1'b0}}};
  
   assign A_in_to_multiply =  (state == 3'b010) ? (A_in << 8): A_in;
   assign B_in_to_multiply =  B_in;

   assign P = P_reg;
   multiply mul(A_in_to_multiply, B_in_to_multiply, d_out_temp);
   assign d_out = (state == 3'b010) ? (d_out_temp>>8) : d_out_temp;

   // *** F:DN sequential logic
   always@(posedge clk or negedge racc)
   begin
       if (racc == 1'b1)begin
           A <= 24'h0;
           B <= 24'h0; 
       end
       else if ((state == 3'b001 && count0 == 9'd63) ||
           (state == 3'b010))begin
           A[BitWidth:`a1_cut] <= A_in_to_wrapper[BitWidth: `a1_cut];
           B[BitWidth: `b1_cut] <= B_in_to_wrapper[BitWidth: `b1_cut];
       end
       else if 
           ((state == 3'b011) ||
           (state == 3'b100))begin
           A[BitWidth:`a2_cut] <= A_in_to_wrapper[BitWidth:`a2_cut];
           B[BitWidth: `b2_cut] <= B_in_to_wrapper[BitWidth:`b2_cut];
       end
   end

  always@(posedge clk or negedge rapx)
  begin
      if ((state == 3'b001 && count0 == 9'd63) ||
          (state == 3'b010))begin
          if (rapx == 1'b1)begin  
              //A[BitWidth:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is set to be zero all the time
              B[`b1_cut -1 :0] <= {(`b1_cut){1'b0}};
          end
          else begin
              //A[h:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is always set to zero
              B[`b1_cut -1 :0] <= B_in_to_wrapper[`b1_cut -1 :0];
          end       
      end
      else if ((state == 3'b011) ||
          (state == 3'b100))begin
          if (rapx == 1'b1)begin  
              A[`a2_cut -1 :0] <=  {(`a2_cut){1'b0}};
              B[`b2_cut -1 :0] <= {(`b2_cut){1'b0}};
          end
          else begin
              A[`a2_cut -1 :0] <=  A_in_to_wrapper[`a2_cut - 1: 0];
              B[`b2_cut - 1 :0] <= B_in_to_wrapper[`b2_cut -1 :0];

          end
      end
  end


   /*
   always @(posedge clk or negedge rapx)                                               
   begin                                                                               
   if (~rapx)                                                                        
   begin                                                                             
   a_reg[DATA_PATH_BITWIDTH- OP_BITWIDTH - 1 : 0]<= 0;                           
   b_reg[DATA_PATH_BITWIDTH- OP_BITWIDTH - 1 : 0]<= 0;                           
  end                                                                               
  else                                                                                                                                                        
  begin                                                                             
  a_reg[DATA_PATH_BITWIDTH- OP_BITWIDTH - 1: 0]<= a[DATA_PATH_BITWIDTH- OP_BITWIDTH - 1: 0];                                                              
  b_reg[DATA_PATH_BITWIDTH- OP_BITWIDTH - 1: 0]<= b[DATA_PATH_BITWIDTH- OP_BITWIDTH - 1: 0];    
  end                                                                               
  end

  */


   always@(posedge clk or posedge racc)
   begin
       if (rstP == 1'b1) begin
           P_reg <= 32'b0;
       end
       else if (state ==  3'b010)begin
           P_tmp[31:0] = {{3{d_out[31]}}, d_out[31:3]};
           P_reg <= P_tmp;
       end
       else begin
	       P_reg[31:0] <= {{3{d_out[39]}}, d_out[39:11]};
       end
   end

endmodule


