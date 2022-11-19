module fsm (
            input logic clk,
            input logic rst,
            input logic in,
            input logic out );

   typedef enum logic [1:0] {
                             s0,
                             s1,
                             s2,
                             s3 } state_t;

   state_t state_d, state_q;
   // state d = next state
   // state q = current state
   
   always_ff @(posedge clk, negedge rst) begin: fsm_ff
      if(~rst)
        state_q <= s0;
      else
        state_q <= state_d;
   end

   // NEXT STATE AND OUTPUT COMPUTATION
   always_comb begin : datapath
      state_d = state_q;
      out = 1'b0;
      case(state_q)
        s0: begin
           if (~in) state_d = s1;
        end
        s1: begin
           if (in) state_d = s2;
        end
        s2: begin
           if (~in) state_d = s3;
           else state_d = s0
        end
        s3: begin
           if(in) begin
              state_d = s2;
              out = 1'b1;
           end else begin
              state_d = s1;
           end
        end
      endcase // case (state_q)
   end // block: datapath
 
endmodule  
