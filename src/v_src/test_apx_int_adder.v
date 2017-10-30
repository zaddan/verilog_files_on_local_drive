`timescale 1ns / 1ps

`define assert(signal, value) \
if (signal !== value) begin \
    $display("@@@@@@@@@@ASSERTION FAILED in %m: signal != value"); \
    //$finish; \
end


module test_bench_tb;
  reg [31:0] input_a; //input_a
  
  reg [31:0] input_b; //input_b
  wire [31:0] output_c_bta_trunc; 
  wire [31:0] output_c_bta_rnd; 
  wire [31:0] output_c_acc; 
  
  parameter number_of_input_pairs = 1; 
  //variables to read from a file 
  reg [31:0] data [0:2*number_of_input_pairs - 1];
  // initialize the hexadecimal reads from the vectors.txt file
  initial $readmemh("int_values_in_hex.txt", data);
  integer i;
  parameter NAB = 0;  
  parameter BT_RND = 0;


  //reset 
 /* 
  initial
  begin
    rst <= 1'b1;
    #50 rst <= 1'b0;
  end
*/
  
  //clk 
  /* 
  initial
  begin
    clk <= 1'b0;
    while (1) begin
      #5 clk <= ~clk;
    end
  end
 */
integer f;
initial begin
    if (BT_RND == 1) begin
        f = $fopen("BT_RND.txt","w");
    end
    else begin
        f = $fopen("TRUNCATION.txt","w");
    end
end



//sample input, generate results, compare results 
  initial
  begin
      for (i=0; i < number_of_input_pairs; i = i + 1)begin
           #10
           input_a <= data[2*i];
           input_b <= data[2*i + 1];
           #20 
           $display("====================================");
           $display("input_a is %x", input_a);
           $display("input_b is %x", input_b);
           $display("bta_trunc adder output is %x", output_c_bta_trunc);
           $display("bta_rnd adder output is %x", output_c_bta_rnd);
           $display("acc adder output is %x", output_c_acc);
           if (BT_RND == 1) begin 
               $fwrite(f,"%d %d %d\n",$signed(input_a), $signed(input_b) , $signed(output_c_bta_rnd));
           end
           else begin
               $fwrite(f,"%d %d %d\n",$signed(input_a), $signed(input_b), $signed(output_c_bta_trunc));
           end
           if (NAB == 0)begin
           `assert(output_c_acc, output_c_bta_trunc)
           `assert(output_c_acc, output_c_bta_rnd)
           end
           $display(" ");
       end
  end
  
  
  //generate waves
  initial
  begin
      $shm_open ("my_waves.shm"); //necessary to dump the signals
      //$Dumpvars(1,test_bench_tb );
      $shm_probe("AS"); //probing for all the signals 
  end
  
  
  //finish
  initial
  begin
      #2000000 
       $fclose(f); 
      $finish;
  end


  bta_trunc #(32,NAB) bta_trunc_u(
    .a(input_a),
    .b(input_b),
    .c(output_c_bta_trunc));

 acc_adder acc_adder_u( 
    .a(input_a),
    .b(input_b),
    .c(output_c_acc));

  bta #(32,NAB) bta_rnd( 
    .a(input_a),
    .b(input_b),
    .c(output_c_bta_rnd));


endmodule
