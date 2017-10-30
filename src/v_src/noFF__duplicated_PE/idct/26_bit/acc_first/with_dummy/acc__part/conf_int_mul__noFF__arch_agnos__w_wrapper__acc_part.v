// *** F:DN accurate part starts
module conf_int_mul__noFF__arch_agnos( clk, racc, rapx, a, b, d);
   parameter OP_BITWIDTH = 16; 
   parameter DATA_PATH_BITWIDTH = 24;
   
   input clk;
   input racc;
   input rapx;
   input [DATA_PATH_BITWIDTH -1: 0] a;
   input [DATA_PATH_BITWIDTH -1 - 11: 0] b;
   //output [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH ) - 1 - 11 : 0] d;
   output [(DATA_PATH_BITWIDTH +  DATA_PATH_BITWIDTH ) - 1 - 11 : 0] d;
   assign d = $signed(a) * $signed(b);
endmodule
// *** F:DN multiplier wrapper
//module conf_int_mul__noFF__arch_agnos__w_wrapper( clk, racc, rapx, A_in_to_wrapper, B_in_to_wrapper, d, state, rstP, P, count0);

module dummy_load(A_out, B_out, A_out_proc);
    parameter OP_BITWIDTH = 16; 
   parameter DATA_PATH_BITWIDTH = 26;
   
  
   input [DATA_PATH_BITWIDTH -1: 0] A_out;
   input [DATA_PATH_BITWIDTH -1 - 11: 0] B_out;
   output [(DATA_PATH_BITWIDTH - 8+ DATA_PATH_BITWIDTH - 8) - 1 - 11 : 0] A_out_proc;
   assign A_out_proc = $signed(A_out[25:8]) * $signed(B_out[14:8]);

   
   /*
   input [DATA_PATH_BITWIDTH -1: 0] A_out;
   input [DATA_PATH_BITWIDTH -1 - 11: 0] B_out;
   output [DATA_PATH_BITWIDTH -1: 0] A_out_proc;
   assign    A_out_proc[0] = A_out[0] & B_out[0];
assign    A_out_proc[1] = A_out[1] & B_out[1];
assign    A_out_proc[2] = A_out[2] & B_out[2];
assign    A_out_proc[3] = A_out[3] & B_out[3];
assign    A_out_proc[4] = A_out[4] & B_out[4];
assign    A_out_proc[5] = A_out[5] & B_out[5];
assign    A_out_proc[6] = A_out[6] & B_out[6];
assign    A_out_proc[7] = A_out[7] & B_out[7];
assign    A_out_proc[8] = A_out[8] & B_out[8];
assign    A_out_proc[9] = A_out[9] & B_out[9];
assign    A_out_proc[10] = A_out[10] & B_out[10];
assign    A_out_proc[11] = A_out[11] & B_out[11];
assign    A_out_proc[12] = A_out[12] & B_out[12];
assign    A_out_proc[13] = A_out[13] & B_out[13];
assign    A_out_proc[14] = A_out[14] & B_out[14];
assign    A_out_proc[15] = A_out[15] & B_out[15];
assign    A_out_proc[16] = A_out[16] & B_out[1];
assign    A_out_proc[17] = A_out[17] & B_out[2];
assign    A_out_proc[18] = A_out[18] & B_out[3];
assign    A_out_proc[19] = A_out[19] & B_out[4];
assign    A_out_proc[20] = A_out[20] & B_out[5];
assign    A_out_proc[21] = A_out[21] & B_out[6];
assign    A_out_proc[22] = A_out[22] & B_out[7];
assign    A_out_proc[23] = A_out[23] & B_out[8];
assign    A_out_proc[24] = A_out[24] & B_out[9];
assign    A_out_proc[25] = A_out[25] & B_out[10];
*/
   //output [DATA_PATH_BITWIDTH -1 - 11: 0] B_out_proc;
endmodule

module conf_int_mul__noFF__arch_agnos__w_wrapper (A_in_to_wrapper, B_in_to_wrapper, state_in_to_wrapper, rstP, clk, racc,rapx, P, count0, state_out_of_wrapper, d_internal__apx, acc__sel, A_out, B_out, A_out_proc);
   parameter OP_BITWIDTH = 16; //operator bit width
   parameter DATA_PATH_BITWIDTH = 26; //flip flop Bit width
   
   input [DATA_PATH_BITWIDTH -1: 0] A_in_to_wrapper;
   input [DATA_PATH_BITWIDTH -1 - 11: 0] B_in_to_wrapper;
   input [8:0] count0;
   input [2:0] state_in_to_wrapper;      
   output [2:0] state_out_of_wrapper;      
   input acc__sel;
   input rstP; 
   input clk;
   input racc; //accurate bits reset  
   input rapx; //apx bits reset
   output [31:0] P; 
   output [DATA_PATH_BITWIDTH -1: 0] A_out;
   output [DATA_PATH_BITWIDTH -1 - 11: 0] B_out;

   output [(DATA_PATH_BITWIDTH - 8+ DATA_PATH_BITWIDTH - 8) - 1 - 11 : 0] A_out_proc;
   dummy_load my_dummy(A_out, B_out, A_out_proc);

   
   wire [DATA_PATH_BITWIDTH -1: 0] A_in;
   wire [DATA_PATH_BITWIDTH -1 -11: 0] B_in;
   //wire [2*(DATA_PATH_BITWIDTH) - 1 : 0] d_;
   input [(DATA_PATH_BITWIDTH -8 + DATA_PATH_BITWIDTH - 8) - 1 -11: 0] d_internal__apx;
   
   wire [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 -11: 0] d_internal__acc;
   wire [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 -11: 0] d_internal;
   wire [DATA_PATH_BITWIDTH -1 : 0] A_in_to_multiply;
   wire [DATA_PATH_BITWIDTH -1 - 11 : 0] B_in_to_multiply;
   //.................................................... 
   reg [DATA_PATH_BITWIDTH -1 : 0] a_reg;
   reg [DATA_PATH_BITWIDTH -1 -11: 0] b_reg;
   reg [31: 0] P_tmp;
   reg [31: 0] c_reg;  
   reg [2:0] state;      
   // *** F:DN combination logic 
   assign A_in = a_reg;
   assign B_in = b_reg;
  
//   assign A_in_to_multiply =  (state == 3'b010) ? (A_in << 8): {A_in[DATA_PATH_BITWIDTH: `OP_BITWIDTH], {(`OP_BITWIDTH){1'b0}}};
//   assign B_in_to_multiply =  (state == 3'b010) ? {B_in[DATA_PATH_BITWIDTH:`OP_BITWIDTH], {(`OP_BITWIDTH){1'b0}}} : {B_in[DATA_PATH_BITWIDTH:`OP_BITWIDTH], {(`OP_BITWIDTH){1'b0}}};
  
   //assign A_in_to_multiply =  (state == 3'b010) ? (A_in << 8): A_in;
   assign A_in_to_multiply =  A_in;
   assign B_in_to_multiply =  B_in;
   assign P = c_reg;
   assign A_out = A_in_to_multiply;
   assign B_out = B_in_to_multiply;
   
   //assign d_internal = (state == 3'b010) ? (d_internal>>8) : d_internal;
 
   // synopsys dc_script_begin
   //set_dont_touch d_internal__apx
   //set_dont_touch d_internal__acc
   //set_dont_touch d_internal
   // synopsys dc_script_end
   //assign d_internal = d_internal;

   conf_int_mul__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst(.clk(clk), .racc(racc), .rapx(rapx), .a(A_in_to_multiply), .b(B_in_to_multiply), .d(d_internal__acc));

   assign d_internal [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 - 11 : 16] = acc__sel ? d_internal__acc[(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 - 11: 16] : d_internal__apx;
   assign  d_internal[15: 0] = acc__sel ? d_internal__acc[15: 0]:{(16){1'b0}};



   //multiply mul(A_in_to_multiply, B_in_to_multiply, d_internal);

   assign state_out_of_wrapper = state;
   // *** F:DN sequential logic
   always@(posedge clk or posedge racc)
   begin 
       if (racc == 1'b1)begin
           state <= 0;
       end
       else begin
          state <= state_in_to_wrapper; 
       end
   end
   
   always@(posedge clk or posedge racc)
   begin
       if (racc == 1'b1)begin
//           a_reg[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= 0;
//           b_reg[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= 0;
           a_reg <= 0;
           b_reg <= 0;
       end
       else begin 
           //** lower chunk 
           if ((state == 3'b001 && count0 == 9'd63) || (state == 3'b010)) begin
               if (rapx == 1'b1 && ~(racc)) begin  
                   //A[DATA_PATH_BITWIDTH:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is set to be zero all the time
                   a_reg[DATA_PATH_BITWIDTH - 1 :0] <= ({A_in_to_wrapper[DATA_PATH_BITWIDTH - 1 -8:0], 8'b0});
                   b_reg[DATA_PATH_BITWIDTH -1 - 11: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= B_in_to_wrapper[DATA_PATH_BITWIDTH -1 -11: DATA_PATH_BITWIDTH - OP_BITWIDTH  -1];
                   //b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
                   b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;
               end
               else begin
                   //A[h:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is always set to zero
                   a_reg[DATA_PATH_BITWIDTH -1 :0] <= {A_in_to_wrapper[DATA_PATH_BITWIDTH - 1 - 8:0], 8'b0};
                   b_reg[DATA_PATH_BITWIDTH -1 -11 :0] <= {B_in_to_wrapper[DATA_PATH_BITWIDTH -1 -11:0], 1'b0};
               end       
           end
           else if ((state == 3'b011) || (state == 3'b100))begin
               if (rapx == 1'b1 && ~(racc))begin  
                   a_reg[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= A_in_to_wrapper[DATA_PATH_BITWIDTH -1 : DATA_PATH_BITWIDTH - OP_BITWIDTH];
                   a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <=  0;// {(OP_BITWIDTH){1'b0}};
                   b_reg[DATA_PATH_BITWIDTH -1 - 11: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= B_in_to_wrapper[DATA_PATH_BITWIDTH -1 -11 : DATA_PATH_BITWIDTH - OP_BITWIDTH];
                   b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
               end
               else begin
                   a_reg[DATA_PATH_BITWIDTH - 1 :0] <=  A_in_to_wrapper[DATA_PATH_BITWIDTH - 1: 0];
                   b_reg[DATA_PATH_BITWIDTH - 1 -11:0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - 1 -11:0];
               end
           end
       end
   end
  /*
  always@(posedge clk)
  begin
       if (racc == 1'b1)begin
           a_reg [DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0]<= 0;
           b_reg [DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0]<= 0;
       end
       else  if ((state == 3'b001 && count0 == 9'd63))
          begin
          if (rapx == 1'b1 && ~(racc))begin  
              //A[DATA_PATH_BITWIDTH:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is set to be zero all the time
              a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 + 8 :0] <= ({A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0], 8'b0});
              b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
          end
          else begin
              //A[h:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is always set to zero
              a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 + 8 :0] <= {A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0], 8'b0};
              b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
          end       
      end
      else if (state == 3'b010) begin
          if (state_in_to_wrapper != 3'b011) begin 
              if (rapx == 1'b1 && ~(racc))begin  
                  //A[DATA_PATH_BITWIDTH:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is set to be zero all the time
                  a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 + 8 :0] <= ({A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0],  8'b0});
                  b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
              end
              else begin
                  //A[h:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is always set to zero
                  a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 + 8 :0] <= {A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0], 8'b0};
                  b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
              end
          end
          else begin 
              if (rapx == 1'b1 && ~(racc))begin  
                  //A[DATA_PATH_BITWIDTH:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is set to be zero all the time
                  a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1  :0] <= A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
                  b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
              end
              else begin
                  //A[h:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is always set to zero
                  a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
                  b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
              end
          end
      end
      else if ((state == 3'b011) ||
          (state == 3'b100))begin
          if (rapx == 1'b1 && ~(racc))begin  
              a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <=  0;// {(OP_BITWIDTH){1'b0}};
              b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
          end
          else begin
              a_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <=  A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH - 1: 0];
              b_reg[DATA_PATH_BITWIDTH - OP_BITWIDTH - 1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];

          end
      end
  end
*/
   always@(posedge clk)
   begin
       if (rstP == 1'b1) begin
           c_reg <= 32'b0;
       end
       else if (state ==  3'b010)begin
           //P_tmp[31:0] = ({{3{d_internal[31+8]}}, d_internal[31+8:3+8]});
           //P_tmp[31:0] = d_internal[31+8:8];
           
           P_tmp[31:0] = {d_internal[25+8+1:8+1], 6'b0}; //14 bit
           //P_tmp[31:0] = {d_internal[24+8:8], 7'b0}; //13 bit, 26 or 24 bit mul
           //P_tmp[31:0] = {d_internal[23+8:8], 8'b0}; //11 bit, 26 or 24 bit mul
           //P_tmp[31:0] = {d_internal[22+8:8], 9'b0}; //11 bit, 26 or 24 bit mul
           //P_tmp[31:0] = {d_internal[21+8:8], 10'b0}; //10 bit, 26 or 24 bit mul
           
           c_reg <= P_tmp;
       end
       else begin
           //c_reg[31:0] <= d_internal[39:8];
           
           c_reg[31:0] <= d_internal[39:8];  //14 bit, 26 bit mul
           //c_reg[31:0] <= d_internal[37:6];  //13 bit, 26 bit mul 
           //c_reg[31:0] <= d_internal[35:4];  //11 bit, 26 bit mul
           //c_reg[31:0] <= d_internal[33:2];  //11 bit, 26 bit mul
           //c_reg[31:0] <= d_internal[31:0];  //10 bit, 26 bit mul
           
           //c_reg[31:0] <= d_internal[37:6];  //14 bit
           
           
           //c_reg[31:0] <= d_internal[39:8];  //16 bit
           //c_reg[31:0] <= {{3{d_internal[39]}}, d_internal[39:11]};
       end
   end

endmodule

