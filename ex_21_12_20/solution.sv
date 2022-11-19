module multAdd(
input logic clk,
input logic rstn_n,
input logic [7:0]in_A,
input logic [7:0]in_B,
input logic [7:0]in_C,
input logic shift_in,
output logic [7:0] result
);

   logic [7:0]     a_q, b_q, c_q;
   logic [7:0]     res_d, res_q;
   logic [15:0]    mul_result;

   assign mul_result =  shift_in ? ( (a_q>>3) * (b_q>>3) ) : (a*b);
   assign res_d = (mul_result>128) ? 8'd128 : (mul_result[6:0] + c_q);
   assign result = res_q;
   
   always_ff @(posedge clk, negedge rst) begin
      if(~rst) begin
         a_q <= '0;
         b_q <= '0; 
         c_q <= '0;
         res_q <= '0;
      end else begin
        a_q <= in_A;
        b_q <= in_B;
        c_q <= in_C;
        res_q <= res_d;
      end // else: !if(~rst)
   end // always_ff @ (posedge clk, negedge rst)

endmodule // multAdd


      
     
     
     
