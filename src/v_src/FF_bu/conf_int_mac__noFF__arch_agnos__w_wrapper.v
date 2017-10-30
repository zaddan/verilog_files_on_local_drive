module conf_int_mac__noFF__arch_agnos( clk, racc, rapx, a, b, c_in, d
 );

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width

//--- input,outputs
input clk;
input rapx;
input racc;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [DATA_PATH_BITWIDTH-1:0] c_in; //*** F:DN change the name to c_in for parsing purposes
output [DATA_PATH_BITWIDTH-1:0] d;

//--- no flop design
assign  d = (a * b) + c_in;

endmodule



module conf_int_mac__noFF__arch_agnos__w_wrapper ( clk, racc, rapx, a, b, d
);

//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width


//--- input,outputs
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
output [DATA_PATH_BITWIDTH-1:0] d;
input clk;
input racc;
input rapx;

wire [DATA_PATH_BITWIDTH-1:0] d_internal;
reg [DATA_PATH_BITWIDTH-1:0] c_reg;
reg [DATA_PATH_BITWIDTH -1:0] a_reg;
reg [DATA_PATH_BITWIDTH-1:0] b_reg;


always @(posedge clk or negedge racc) 
begin
  if (~racc)
  begin
      a_reg[DATA_PATH_BITWIDTH - 1: DATA_PATH_BITWIDTH- OP_BITWIDTH]<= 0;
      b_reg[DATA_PATH_BITWIDTH - 1: DATA_PATH_BITWIDTH- OP_BITWIDTH]<= 0;
  end
  else
  begin
      a_reg[DATA_PATH_BITWIDTH - 1: DATA_PATH_BITWIDTH- OP_BITWIDTH]<= a[DATA_PATH_BITWIDTH - 1: DATA_PATH_BITWIDTH- OP_BITWIDTH];
      b_reg[DATA_PATH_BITWIDTH - 1: DATA_PATH_BITWIDTH- OP_BITWIDTH]<= b[DATA_PATH_BITWIDTH - 1: DATA_PATH_BITWIDTH- OP_BITWIDTH];
  end
end

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

always @(posedge clk or negedge racc) 
begin
  if (~racc)
  begin
      c_reg[DATA_PATH_BITWIDTH - 1: 2*(DATA_PATH_BITWIDTH- OP_BITWIDTH)]<= 0;
  end
  else
  begin
      c_reg[DATA_PATH_BITWIDTH - 1: 2*(DATA_PATH_BITWIDTH- OP_BITWIDTH)]<= d_internal[DATA_PATH_BITWIDTH - 1: 2*(DATA_PATH_BITWIDTH- OP_BITWIDTH)];
  end
end

always @(posedge clk or negedge rapx) 
begin
  if (~rapx)
  begin
      c_reg[2*(DATA_PATH_BITWIDTH- OP_BITWIDTH) - 1 : 0]<= 0;
  end
  else
  begin
      c_reg[2*(DATA_PATH_BITWIDTH- OP_BITWIDTH) - 1: 0]<= d_internal[2*(DATA_PATH_BITWIDTH- OP_BITWIDTH) - 1: 0];
  end
end

assign d = c_reg;



conf_int_mac__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mac__inst(.clk(clk), .racc(racc),.rapx(rapx), .a(a_reg), .b(b_reg), .c_in(d), .d(d_internal));

endmodule 





