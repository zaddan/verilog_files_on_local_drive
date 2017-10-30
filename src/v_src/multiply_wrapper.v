module conf_int_mul__noFF__arch_agnos( clk, racc, rapx, a, b, d);
   parameter OP_BITWIDTH = 16; 
   parameter DATA_PATH_BITWIDTH = 24;
   input clk;
   input racc;
   input rapx;
   input [DATA_PATH_BITWIDTH -1: 0] a;
   input [DATA_PATH_BITWIDTH -1: 0] b;
   output [2*(DATA_PATH_BITWIDTH) - 1 : 0] d;
   assign d = $signed(a) * $signed(b);
endmodule

// *** F:DN multiplier wrapper
//module conf_int_mul__noFF__arch_agnos__w_wrapper( clk, racc, rapx, A_in_to_wrapper, B_in_to_wrapper, d, state, rstP, P, count0);

module conf_int_mul__noFF__arch_agnos__w_wrapper (A_in_to_wrapper, B_in_to_wrapper, state, rstP, clk, racc,rapx, P, count0);
   parameter OP_BITWIDTH = 16; //operator bit width
   parameter DATA_PATH_BITWIDTH = 24; //flip flop Bit width
   
   input [DATA_PATH_BITWIDTH -1: 0] A_in_to_wrapper;
   input [DATA_PATH_BITWIDTH -1: 0] B_in_to_wrapper;
   input [8:0] count0;
   input [2:0] state;      
   input rstP; 
   input clk;
   input racc; //accurate bits reset  
   input rapx; //apx bits reset
   output [31:0] P; 

   wire [DATA_PATH_BITWIDTH -1: 0] A_in;
   wire [DATA_PATH_BITWIDTH -1 : 0] B_in;
   wire [2*(DATA_PATH_BITWIDTH) - 1 : 0] d_out;
   wire [2*(DATA_PATH_BITWIDTH) - 1 : 0] d_internal;
   wire [DATA_PATH_BITWIDTH -1 : 0] A_in_to_multiply;
   wire [DATA_PATH_BITWIDTH -1 : 0] B_in_to_multiply;
   //.................................................... 
   reg [DATA_PATH_BITWIDTH -1 : 0] A;
   reg [DATA_PATH_BITWIDTH -1 : 0] B;
   reg [31: 0] P_tmp;
   reg [31: 0] c_reg;  

   // *** F:DN combination logic 
   assign A_in = A;
   assign B_in = B;
  
//   assign A_in_to_multiply =  (state == 3'b010) ? (A_in << 8): {A_in[DATA_PATH_BITWIDTH: `OP_BITWIDTH], {(`OP_BITWIDTH){1'b0}}};
//   assign B_in_to_multiply =  (state == 3'b010) ? {B_in[DATA_PATH_BITWIDTH:`OP_BITWIDTH], {(`OP_BITWIDTH){1'b0}}} : {B_in[DATA_PATH_BITWIDTH:`OP_BITWIDTH], {(`OP_BITWIDTH){1'b0}}};
  
   assign A_in_to_multiply =  (state == 3'b010) ? (A_in << 8): A_in;
   assign B_in_to_multiply =  B_in;
   assign P = c_reg;
   assign d_out = (state == 3'b010) ? (d_internal>>8) : d_internal;
   
   conf_int_mul__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst(.clk(clk), .racc(racc), .rapx(rapx), .a(A_in_to_multiply), .b(B_in_to_multiply), .d(d_internal));
   //multiply mul(A_in_to_multiply, B_in_to_multiply, d_internal);


   // *** F:DN sequential logic
   always@(posedge clk or negedge racc)
   begin
       if (racc == 1'b1)begin
           A <= 24'h0;
           B <= 24'h0; 
       end
       else if ((state == 3'b001 && count0 == 9'd63) ||
           (state == 3'b010))begin
           A[DATA_PATH_BITWIDTH -1 :0] <= A_in_to_wrapper[DATA_PATH_BITWIDTH -1 : 0];
           B[DATA_PATH_BITWIDTH -1 : DATA_PATH_BITWIDTH - OP_BITWIDTH] <= B_in_to_wrapper[DATA_PATH_BITWIDTH -1 : DATA_PATH_BITWIDTH - OP_BITWIDTH];
       end
       else if 
           ((state == 3'b011) ||
           (state == 3'b100))begin
           A[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= A_in_to_wrapper[DATA_PATH_BITWIDTH -1 : DATA_PATH_BITWIDTH - OP_BITWIDTH];
           B[DATA_PATH_BITWIDTH -1: DATA_PATH_BITWIDTH - OP_BITWIDTH] <= B_in_to_wrapper[DATA_PATH_BITWIDTH -1 : DATA_PATH_BITWIDTH - OP_BITWIDTH];
       end
   end

  always@(posedge clk or negedge rapx)
  begin
      if ((state == 3'b001 && count0 == 9'd63) ||
          (state == 3'b010))begin
          if (rapx == 1'b1)begin  
              //A[DATA_PATH_BITWIDTH:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is set to be zero all the time
              B[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
          end
          else begin
              //A[h:a1_cut] <= A_in_to_wrapper; //commented out since a1_cut is always set to zero
              B[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];
          end       
      end
      else if ((state == 3'b011) ||
          (state == 3'b100))begin
          if (rapx == 1'b1)begin  
              A[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <=  0;// {(OP_BITWIDTH){1'b0}};
              B[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <= 0;//{(OP_BITWIDTH){1'b0}};
          end
          else begin
              A[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0] <=  A_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH - 1: 0];
              B[DATA_PATH_BITWIDTH - OP_BITWIDTH - 1 :0] <= B_in_to_wrapper[DATA_PATH_BITWIDTH - OP_BITWIDTH -1 :0];

          end
      end
  end

   always@(posedge clk or posedge racc)
   begin
       if (rstP == 1'b1) begin
           c_reg <= 32'b0;
       end
       else if (state ==  3'b010)begin
           P_tmp[31:0] = {{3{d_out[31]}}, d_out[31:3]};
           c_reg <= P_tmp;
       end
       else begin
	       c_reg[31:0] <= {{3{d_out[39]}}, d_out[39:11]};
       end
   end

endmodule
