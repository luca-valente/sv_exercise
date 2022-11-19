module arith_lite(
   input logic clk_i,
   input logic rst_ni,
   input logic [31:0] inp_a,
   input logic [31:0] inp_b,
   input logic [1:0] op,
   output logic [31:0] sum_o,
   output logic [31:0] mult_o,
   output logic eq_o
);

   logic [1:0]  op_q;
   logic [2:0]  op_onehot;

   always_comb begin
      op_onehot = '0;
      for(int i=0; i<3; i++) begin
         if(op_q==i) begin
            op_onehot[i] = 1'b1;
         end
      end
   end

   logic [31:0] sum_res, sum_q;
   logic [31:0] mul_res, mul_q;
   logic        eq_res, eq_q;
   
   assign sum_res = op_onehot[0] ? (a_q + b_q) : '0;
   assign mul_res = op_onehot[1] ? (a_q * b_q) : '0;
   assign eq_res  = op_onehot[2] ? (a_q == b_q) : 1'b0;   

   assign sum_o = sum_q;
   assign mult_o = mult_q;
   assign eq_o = eq_q;
   
   always_ff @(posedge clk, negedge rst) begin
      if(~rst) begin
         sum_q <= '0;
         mul_q <= '0;
         eq_q  <= '0;
         a_q   <= '0;
         b_q   <= '0;
         op_q  <= '0;
      end else begin
         sum_q <= sum_res;
         mul_q <= mul_res;
         eq_q  <= eq_res;
         op_q  <= op;
         a_q   <= inp_a;
         b_q   <= inp_b;
      end // else: !if(~rst)
   end // always_ff @ (posedge clk, negedge rst)
   
endmodule // arith_lite
