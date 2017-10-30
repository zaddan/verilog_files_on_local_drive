`timescale 1ns / 1ps

`define cycle 2

module topdct_idct;  
  parameter BitWidth = 31;
  
  reg clk;
  reg start;
  reg reset;
  //reg [7:0] din;    
  reg [BitWidth:0] din;    
        
  wire done1, done2;
  wire reading;
  //wire [7:0] dout;
  wire [BitWidth:0] dout_dct;
  wire [BitWidth:0] dout_idct;
  wire [BitWidth:0] din_dct;
  wire reading_idct;
  wire [4:0] state_idct;
  wire [4:0] state_dct;
  
  integer fpr, fpw, fpwi, eof, ext_cnt, flag_0, cnt, cnt1, cnt2, cnt3, cnt4, cnt5;
  integer idx;
        
  initial 
  begin
    fpr = $fopen("gray.txt", "r");
    fpw = $fopen("dctdata.txt", "w");
    fpwi = $fopen("idctdata.txt", "w");
    ext_cnt = 16384;
    flag_0 = 0;
    cnt = 0;
    cnt1 = 0;
    cnt2 = 0;
    cnt3 = 0;
    cnt4 = 0;
    eof = 0;
    reset <= 1;
    start <= 0;    
    idx = 0;
    clk <= 0;
    #(`cycle/2)
    clk <= 0;
    #(`cycle/2)
    clk <= 0;
    forever
    begin 
      if(idx >= 127)
        begin
          reset <= 0;
          start <= 1;
        end
      if(idx % 2 == 0 && idx >= 127)
        begin 
       	  if(reading == 1 && cnt2 < 65536)
       	  //if(reading == 1 && cnt2 < 64)
            begin
              $fscanf(fpr, "%d\n", din);
              cnt2 = cnt2 + 1;
              //$display("%d", din); 
            end

          if(cnt2 >= 65536)
          //if(cnt2 >= 64)
            begin
              eof = 1;
            end
          if(eof != 0)
            begin
              if(reading != 1)
                begin
                  start <= 0;
                end
              ext_cnt = ext_cnt - 1;
              if(ext_cnt == 0)
            	begin
                  //if(dout_idct[24] == 0)
                  //  begin
                      $fwrite(fpwi, "%d\n", dout_idct[31:10]);
                  //  end
                  //else
                  //  begin
                  //    $fwrite(fpwi, "%d\n", dout_idct[22:16]);
                  //  end
                  $fwrite(fpw, "%d\n", dout_dct[31:16]);
                  //$display("dct num = %d", cnt4);
                  //$display("state idct = %d", state_idct);
                  $fclose(fpr);
                  $fclose(fpw);
                  $fclose(fpwi);
                  $finish;
                  $stop;                  
                end
            end            

          if(done1 == 1) 
            begin
              if(flag_0 == 0) 
                begin
                  cnt4 = cnt4 + 1;
                  flag_0 = 1;
                end
              if(cnt3 < 64)
                begin 
                  $fwrite(fpw, "%d\n", dout_dct[31:16]);
                  //$display("dct_out=%d, din_dct=%d, state=%d, reading=%d", dout_dct, din_dct, state_idct, reading_idct); 
                  cnt3 = cnt3 + 1;
                end
            end    
          else
            begin
              flag_0 = 0;
              cnt3 = 0;
            end

          if(done2 == 1) 
            begin 
              if(cnt < 64) 
                begin        
                  //if(dout_idct[24] == 0)
                  //  begin
                      $fwrite(fpwi, "%d\n", dout_idct[31:10]);
                  //  end
                  //else
                  //  begin
                  //    $fwrite(fpwi, "%d\n", dout_idct[22:16]);
                  //  end
                  cnt = cnt + 1;
                  //$display("dout = %d", dout_idct);
                end
            end 
          else
            begin
              cnt = 0;
            end   
        end        
      idx = idx + 1;  
      #(`cycle/2) clk = ~clk;
    end            
                   
  end              
                   
  assign din_dct[15:0] = dout_dct[31:16];
  assign din_dct[31:16] = {16{dout_dct[31]}};
  
  dct  dctblock(.clk(clk), .start(start), .reset(reset), .din(din), .done(done1), .dout(dout_dct), .reading(reading), .state_out(state_dct));
  idct idctblock(.clk(clk), .start(done1), .reset(reset), .din(din_dct), .done(done2), .dout(dout_idct), .reading(reading_idct), .state_out(state_idct));


endmodule          

