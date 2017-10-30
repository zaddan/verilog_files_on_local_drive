`timescale 1ns / 1ps

`define assert(signal, value) \
if (signal !== value) begin \
    $display("@@@@@@@@@@ASSERTION FAILED in %m: signal != value"); \
    //$finish; \
end


module test_bench_tb;
  reg [31:0] input_a; //input_a
  reg [31:0] input_b; //input_b
  reg apx_ctl; 
  wire [31:0] output_c_acc; 
  reg rst;
  reg clk;
  
  parameter number_of_input_pairs = 500; 
  parameter HRDWIRED_BITWIDTH = 16;
  parameter DATA_PATH_BITWIDTH = 32;

  parameter clk_period = 0.6;
  parameter half_clk_period = clk_period/2;


  `define input_addr "../../build/functional/int_values_in_hex.txt"
  `define output_addr "../../build/functional/results.txt"
  `define sdf_file_addr "../../build/syn/results/config_int_add_inMux_truncation_16Bit_synthesized.mapped.sdf"
  
  //variables to read from a file 
  reg [31:0] data [0:2*number_of_input_pairs - 1];
  // initialize the hexadecimal reads from the vectors.txt file
  initial $readmemh(`input_addr, data);
  integer i;


  //reset 
  
  initial
  begin
    rst <= 1'b1;
    #(30*clk_period)
    rst <= 1'b0;
    apx_ctl <= 1'b1; 
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
    $sdf_annotate(`sdf_file_addr, apx_add_truncation);
    f = $fopen(`output_addr,"w");
end


//sample input, generate results, compare results 
initial
begin
    #(60*clk_period)
    for (i=0; i < number_of_input_pairs; i = i + 1)begin
        input_a <= data[2*i];
        input_b <= data[2*i + 1];
        
        #(100*clk_period)
        //$display("input_a: %d input_b %d\n", $signed(input_a), $signed(input_b));
        $fwrite(f,"%d %d %d\n",$signed(input_a), $signed(input_b), $signed(output_c_acc));
    end
end


//generate waves
/*
initial
begin
    $shm_open ("my_waves.shm"); //necessary to dump the signals
    //$Dumpvars(1,test_bench_tb );
    $shm_probe("AS"); //probing for all the signals 
end
*/

//finish
initial
begin
    #20000
    $fclose(f); 
    $finish;
end


config_int_add_inMux_truncation_DATA_PATH_BITWIDTH32_HRDWIRED_BITWIDTH16 apx_add_truncation(
    .clk(clk),
    .rst(rst),
    .apx_ctl(apx_ctl),
    .a(input_a),
    .b(input_b),
    .c(output_c_acc));
//config_int_add_inMux_truncation #(DATA_PATH_BITWIDTH, HRDWIRED_BITWIDTH)apx_add_truncation( 
//    .clk(clk),
//    .rst(rst),
//    .apx_ctl(apx_ctl),
//    .a(input_a),
//    .b(input_b),
//    .c(output_c_acc));
//
//
/*
initial begin
    //$dumpfile("DUT.vcd");
    //$dumpvars(0,  test_bench_tb);
    $dumpvars(0,  apx_add_truncation);
end
*/

endmodule


