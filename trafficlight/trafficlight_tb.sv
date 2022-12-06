module trafficlight_tb( );

   logic clk, rst;
   logic Ta;
   logic Tb;
   logic LaY;
   logic LaR;
   logic LaG;
   logic LbY;
   logic LbR;
   logic LbG;
   

   // GENERATE CLOCK AND RESET
   initial begin 
      clk=0;
   end
   // 2ms clock
   always begin
      clk=1'b1;
      #1ms;
      clk=1'b0;
      #1ms;
   end

   initial begin
      rst=1'b0;
      #5ms;
      rst=1'b1;
   end

   trafficlight i_dut(
                    .clk  ( clk ),
                    .rstn ( rst ),
                    .Ta   ( Ta  ),
                    .Tb   ( Tb  ),
                    .LaY  ( LaY ),
                    .LaR  ( LaR ),
                    .LaG  ( LaG ),
                    .LbY  ( LbY ),
                    .LbR  ( LbR ),
                    .LbG  ( LbG )
                   );
   

   initial begin
      Ta = 1'b0;
      Tb = 1'b0;

      @(posedge rst);

      @(posedge clk);

      if(~(LaG & ~LaY & ~LaR & LbR & ~LbY & ~LbG) )
        $error("Error");
      else
        $display("ok");

      @(posedge clk);

      Ta = 1'b0;
      Tb = 1'b1;

      #5s;

      @(posedge clk);
      
      if(~(~LaG & LaY & ~LaR & LbR & ~LbY & ~LbG) )
        $error("Error");
      else
        $display("ok");
      
      @(posedge clk);
      #5s;

      if(~(~LaG & ~LaY & LaR & ~LbR & ~LbY & LbG) )
        $error("Error");
      else
        $display("ok");
      
      @(posedge clk);

      Ta = 1'b1;
      Tb = 1'b0;
      
      #5s;

      @(posedge clk);

      if(~(~LaG & ~LaY & LaR & ~LbR & LbY & ~LbG) )
        $error("Error");
      else
        $display("ok");
      
      @(posedge clk);
      #5s;
      
      if(~(LaG & ~LaY & ~LaR & LbR & ~LbY & ~LbG) )
        $error("Error");
      else
        $display("ok");

      $finish();
      
   end // initial begin

endmodule // trafficlight_tb

