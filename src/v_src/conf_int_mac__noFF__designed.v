//*** F:DN this file contains a mac where the multipliaction is split up to                                                                          
//   inorder to minimize tq-n
module shift(in, out);
parameter Pn = 8; //lowest precision requrested
input [31:0]in;
output [31:0]out;
assign out = in<<(2*Pn);
endmodule

module conf_int_mac__noFF__designed( clk, rst, a, b, c, apx__p, d
 );
//--- parameters
//parameter BT_RND = 0
parameter OP_BITWIDTH = 16; //operator bit width
parameter DATA_PATH_BITWIDTH = 16; //flip flop Bit width

//**** F:AN you should update the Pn in shift module aswell
parameter Pn = 8; //lowest precision requrested

//--- input,outputs
input clk;
input rst;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [DATA_PATH_BITWIDTH-1:0] c;
input apx__p; //predicating whether apx or accurate mode
output [DATA_PATH_BITWIDTH-1:0] d;


//--- no flop design
wire [31:0] L_L;
wire [31:0] H_L;
wire [31:0] L_H;
wire [31:0] H_H;
wire [31:0] H_L_shifted;
wire [31:0] L_H_shifted;
wire [31:0] H_H_shifted;
wire [31:0] top_half;
wire [31:0] bottom_half;
wire [31:0] mul_res;
wire [31:0] mac_res_acc;
wire [31:0] mac_res_apx;



assign L_L = a[Pn-1:0] * b[Pn-1:0];
assign H_L = a[31:Pn] * b[Pn-1:0];
assign L_H = a[Pn-1:0] * b[31:Pn];
assign H_H = a[31:Pn] * b[31:Pn];

assign H_L_shifted = H_L << Pn;
assign L_H_shifted = L_H << Pn;
assign H_H_shifted = H_H << (2*Pn);

assign top_half = H_H_shifted + L_H_shifted;
assign bottom_half = H_L_shifted + L_L;
assign mul_res = bottom_half + top_half;
assign mac_res_acc = mul_res + c; 

//assign mac_res_apx = (H_H + c[31:24])<<24;

// synopsys dc_script_begin 
//set_dont_touch mac_res_apx
// synopsys dc_script_end
shift U_shift(.in((H_H + c[31:(2*Pn)])), .out(mac_res_apx));

assign d = apx__p ? mac_res_apx : mac_res_acc;

endmodule
