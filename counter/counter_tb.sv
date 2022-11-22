module counter_tb();

   logic clk, rst;

   // GENERATE CLOCK AND RESET
   initial begin 
      clk=0;
   end
   always begin
      clk=1'b1;
      #5ns;
      clk=1'b0;
      #5ns;
   end

   initial begin
      rst=1'b0;
      #25ns;
      rst=1'b1;
   end

   
   logic enable, updown;
   logic [7:0] value;

   updown_counter i_dut(
      .clk(clk),
      .rstn(rst),
      .enable(enable),
      .updown(updown),
      .count(value)
   );
             
   initial begin
      enable = 1'b0;
      updown = 1'b0;

      @(posedge rst);

      @(posedge clk);
      enable = 1'b1;
      updown = 1'b1;
      
      repeat (200) @(posedge clk);

      if(value!=199)
        $error("value is %d and not 199", value);
      else
        $display("ok");

      updown = 1'b0;

      repeat (100) @(posedge clk);

      if(value!=99)
        $error("value is %d and not 99", value);
      else
        $display("ok");

      enable = 1'b0;

      repeat (100) @(posedge clk);

      if(value!=99)
        $error("value is %d and not 99", value);
      else
        $display("ok");

      $finish();
   end // initial begin

endmodule // tb

      
      
         
   
   
   
