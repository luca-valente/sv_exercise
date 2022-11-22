module updown_counter
(
input logic clk, // clock
input logic rstn, // reset (active low)
input logic enable, // enable =0 don?t count, enable = 1: count
input logic updown, // updown=1: increment, updown=0: decrement

output logic [7:0] count // output
);

   logic [7:0]     count_d, count_q;

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) begin
         count_q <='0;
      end else begin
         count_q <= count_d;
      end
   end

   always_comb begin
      count_d = count_q;
      if(enable) begin
         if(updown)
           count_d = count_q + 1 ;
         else
           count_d = count_q - 1 ;
      end
   end
   

 endmodule
