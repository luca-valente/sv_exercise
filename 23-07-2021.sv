module thermostat (
  input logic clk_i,
  input logic rst_i,
  input logic program_i,
  input logic [7:0] data_i,
  input logic valid_i,
  input logic [7:0] temp_i,
  input logic active_i,
  output logic heater_on_o
);

   typedef enum logic[1:0] {
                            IDLE,
                            PROG,
                            ACTIVE,
                            HEAT_ON } state_t;
   
   state_t state_d, state_q;

   logic [1:0]  count_d, count_q;

   logic [7:0]  hysteresis_d, hysteresis_q;
   logic [7:0]  target_temp_d, target_temp_q;

   always_ff @(posedge clk_i or negedge rst_i) begin
      if(~rst_i) begin
         count_q <= '0;
         target_temp_q <= '0;
         hysteresis_q <= '0;
         state_q <= IDLE;
      end else begin
         count_q       <= count_d      ;
         target_temp_q <= target_temp_d;
         hysteresis_q  <= hysteresis_d ;
         state_q       <= state_d      ;
      end // else: !if(~rst_i)
   end // always_ff @ (posedge clk_i or negedge rst_i)

   always_comb begin
      count_d = count_q;
      
      if( (state_q == PROGRAM) & valid_i ) begin
         count_d = count_q + 1;
      end
      if (state_q == IDLE ) begin
         count_d = 0;
      end
   end

   always_comb begin
      state_d = state_q;
      heater_on_o = 1'b0;
      target_temp_d = target_temp_q;
      hysteresis_d = hysteresis_q ;
      
      case(state_q) begin

         IDLE: begin
            if(active_i)
              state_d = ACTIVE;
            else if (program_i & ~active_i) begin
               state_d = PROG;
            end
         end
         
         PROG: begin
            if (valid_i & (count_q==0)) begin
               target_temp_d = data_i;
            end
            if (valid_i & (count_q==1)) begin
               hysteresis_d = data_i;
               state_d = IDLE;
            end
         end

        ACTIVE: begin
           if ( temp_i < (temp_target_q - hysteresis_q) ) begin
              state_d = HEAT_ON;
           end else if (active_i) begin
              state_d = IDLE;
           end
        end
        
        HEAT_ON: begin
           heater_on_o = 1'b1;
           if ( temp_i > (temp_target_q - hysteresis_q) ) begin
              state_d = ACTIVE;
           end else if (active_i) begin
              state_d = IDLE;
           end
        end

      endcase // case (state_q)
   end // always_comb

endmodule // thermostat
