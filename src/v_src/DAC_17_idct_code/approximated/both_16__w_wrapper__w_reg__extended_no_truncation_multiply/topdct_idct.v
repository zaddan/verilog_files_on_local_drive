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
        
  reg rapx;
  reg [31:0]count__cycles;  
  
  initial 
  begin
      //fpr = $fopen("gray.txt", "r");
    //fpr = $fopen("input_images_for_idct/images/txt/gray.txt", "r"); //(47.7,32.71)
    fpr = $fopen("input_images_for_idct/images/txt/mobile_qcif.txt", "r"); //(35,30.08) 
    //fpr = $fopen("input_images_for_idct/images/txt/grandma_qcif.txt", "r"); //(47.8, 30.45)
    //fpr = $fopen("input_images_for_idct/images/txt/akiyo_qcif.txt", "r"); //(45,31) 
    //fpr = $fopen("input_images_for_idct/images/txt/salesman_qcif.txt", "r");//(47.8,33)
    //fpr = $fopen("input_images_for_idct/images/txt/foreman_qcif.txt", "r");//(47, 32)
    //fpr = $fopen("input_images_for_idct/images/txt/hall_qcif.txt", "r"); //(39DB, 24DB)
    
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
    count__cycles <=32'b0;
   

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
                      
                       //$fwrite(fpwi, "%d\n", dout_idct[31:10]);
                      $fwrite(fpwi, "%d\n", dout_idct[17:10]);
                      
                      //  end
                  //else
                  //  begin
                  //    $fwrite(fpwi, "%d\n", dout_idct[22:16]);
                  //  end
                  $fwrite(fpw, "%x\n", dout_dct[31:18]);
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
                  $fwrite(fpw, "%x\n", dout_dct[31:18]);
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
                      
                        //$fwrite(fpwi, "%d\n", dout_idct[31:10]);
                      $fwrite(fpwi, "%d\n", dout_idct[17:10]);
                      
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
      
      
      // *** F:DN toggling between different precision 
      count__cycles <= count__cycles +1;
      // *** FDN the following a simple range based reseting 
      if (count__cycles > 500000 && count__cycles < 2*500000) begin 
          rapx <=1'b1;
          //$display ("count__cycles %d\n", count__cycles); 
      end
      else begin
          rapx <=1'b1;
      end
  
  end            
                   
  end              
                   
  assign din_dct[13:0] = dout_dct[31:18];
  assign din_dct[31:14] = {18{dout_dct[31]}};
  
  dct  dctblock(.clk(clk), .start(start), .reset(reset), .din(din), .done(done1), .dout(dout_dct), .reading(reading), .state_out(state_dct));
  idct idctblock(.clk(clk), .start(done1), .racc(reset), .rapx(rapx), .din(din_dct), .done(done2), .dout(dout_idct), .reading(reading_idct), .state_out(state_idct));


endmodule          

