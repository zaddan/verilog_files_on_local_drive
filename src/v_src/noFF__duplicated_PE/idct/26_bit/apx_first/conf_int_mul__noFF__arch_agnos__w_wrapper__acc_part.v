



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

module conf_int_mul__noFF__arch_agnos__w_wrapper(A_in_to_wrapper, B_in_to_wrapper, state_in_to_wrapper, rstP, clk, racc,rapx, P, count0, state_out_of_wrapper, acc__sel);
   parameter OP_BITWIDTH = 16; //operator bit width
   parameter DATA_PATH_BITWIDTH = 24; //flip flop Bit width
   
   input [DATA_PATH_BITWIDTH -1: 0] A_in_to_wrapper;
   input [DATA_PATH_BITWIDTH -1 - 11: 0] B_in_to_wrapper;
   input [8:0] count0;
   input [2:0] state_in_to_wrapper;      
   output [2:0] state_out_of_wrapper;      
   input acc__sel;
   wire [(DATA_PATH_BITWIDTH + DATA_PATH_BITWIDTH) - 1 -11:0] d_internal__acc;
   input rstP; 
   input clk;
   input racc; //accurate bits reset  
   input rapx; //apx bits reset
   output [31:0] P; 
   wire [DATA_PATH_BITWIDTH -1: 0] A_out;
   wire [DATA_PATH_BITWIDTH -1 - 11: 0] B_out;

wire [DATA_PATH_BITWIDTH:0] d__acc;
// synopsys dc_script_begin
 //set_dont_touch mul__inst__apx
 // synopsys dc_script_end
conf_int_mul__noFF__arch_agnos #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst__acc(.clk(clk), .racc(racc), .rapx(rapx),.a(A_out), .b(B_out), .d(d_internal__acc));


// *** F:DN replace the following module w/ the syntehsis results
conf_int_mul__noFF__arch_agnos__w_wrapper #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul__inst__apx(A_in_to_wrapper, B_in_to_wrapper, state_in_to_wrapper, rstP, clk, racc,rapx, P, count0, state_out_of_wrapper, d_internal__acc, acc__sel, A_out, B_out);


//--- for testing purposes
//--- duplicate
//assign d = d__ignore;
/*
// ---- non duplicates
//--- F:DN acc
//assign d = a*b; 

//-- F:DN apx
assign d[63:16] = a[23:8]*b[23:8]; //apx
assign d[15:0] = 16'b0;
*/

endmodule 
