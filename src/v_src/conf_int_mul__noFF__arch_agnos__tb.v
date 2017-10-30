`timescale 1ns / 1ps

`define assert(signal, value) \
if (signal !== value) begin \
    $display("@@@@@@@@@@ASSERTION FAILED in %m: signal != value"); \
    //$finish; \
end


module test_bench_tb;
  reg [23:0] input_a; //input_a
  reg [23:0] input_b; //input_b
  wire acc__sel; 
  //reg [24:0] input_c; 
  wire [47:0] d; 
  reg rst;
  reg clk;
  assign acc__sel = 1'b0;
  parameter number_of_input_pairs = 500; 
  parameter OP_BITWIDTH = 32;
  parameter DATA_PATH_BITWIDTH = 32;

  parameter clk_period = 5;
  parameter half_clk_period = clk_period/2;
  //reg [100*8:0] base_folder_str;
  //base_folder_str = "../../build/functional";
  //--- NOTE: couldn't figure out how to concatenate
  //  `define  base_folder_str  "../../build/functional/"
//  `define  input_file_name "int_values_in_hex.txt"
//  `define CONCAT(A, B) A``B  
  `define input_addr "../../build/functional/int_values_in_hex.txt"
  `define output_addr "../../build/functional/results.txt"
  //`define sdf_file_addr "../../build/syn/results/conf_int_add__noFF__arch_agnos_32Bit_32Bit_synthesized.mapped.sdf"
  //variables to read from a file 
  reg [24:0] data [0:2*number_of_input_pairs - 1];
  // initialize the hexadecimal reads from the vectors.txt file
  //initial $readmemh("int_values_in_hex.txt", data);
  
  initial $readmemh(`input_addr, data);
  integer i;


  //reset 
  
  initial
  begin
    rst <= 1'b1;
    #(30*clk_period)
    rst <= 1'b0;
    #(20*clk_period) 
    rst <= 1'b1;
  end

  
  //clk 
  initial
  begin
    clk <= 1'b0;
    while (1) begin
      #(half_clk_period) clk <= ~clk;
    end
  end

  integer f;
initial begin
    //$sdf_annotate(`sdf_file_addr,add); 
    f = $fopen(`output_addr,"w");
end


//sample input, generate results, compare results 
initial
begin
    #(60*clk_period)
    for (i=0; i < number_of_input_pairs; i = i + 1)begin
        input_a <= data[2*i];
        input_b <= data[2*i + 1];
        //input_c <= data[3*i + 2];
        #(clk_period)
        //#(100*clk_period)
        //$display("input_a: %d input_b %d\n", $signed(input_a), $signed(input_b));
        $fwrite(f,"%d %d %d\n",$signed(data[2*i]), $signed(data[2*i + 1 ]), $signed(d));
    end
end


//generate waves, only for ncverilog

initial
begin
     
    $shm_open ("my_waves.shm"); //necessary to dump the signals
    //$Dumpvars(1,test_bench_tb );
    $shm_probe("AC"); //probing for all the signals 
end


//finish
initial
begin
    #20000
    $fclose(f); 
    $finish;
end


//--- behvarioal
/*
conf_int_mul__noFF__arch_agnos__w_wrapper#(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul( 
    .clk(clk),
    .rst(rst),
    .a(input_a),
    .b(input_b),
    .d(d));
*/

//--- synthesized
/*
conf_int_mul__noFF__arch_agnos__w_wrapper #(OP_BITWIDTH, DATA_PATH_BITWIDTH) mul(
    .clk(clk),
    .rst(rst),
    .a(input_a),
    .b(input_b),
    .d(d), 
    .acc__sel(acc__sel));
*/
/*
conf_int_mul__noFF__arch_agnos__w_wrapper_OP_BITWIDTH18_DATA_PATH_BITWIDTH24 mul(
    .clk(clk),
    .rst(rst),
    .a(input_a),
    .b(input_b),
    .d(d));
*/

assign d = input_a * input_b;




/* only for ncverilog
initial begin
    $dumpfile("DUT.vcd");
    //$dumpvars(0,  test_bench_tb);
    $dumpvars(0,  add);
end
*/

//----------------------------------------------------
// *** F:HWN to test, 
//      1) cpy the multiplier you want in the mul_to_test.v file (in this folder)
//      2) run the ncverilog commmand:
//ncverilog -v /home/polaris/behzad/behzad_local/verilog_files/libraries/germany_NanGate/verilog_files/*.v /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src/conf_int_mul__noFF__arch_agnos__tb.v /home/polaris/behzad/behzad_local/verilog_files/apx_operators/int_ops_apx/src/v_src/mul_to_test.v +access+r |tee log 
//      3) make sure results.txt is updated (in the ../../build/functional dir)
//      4) go to test_operators and run test_verilog_vs_c.py (with appropriate parameter values)


//----------------------------------------------------
endmodule


