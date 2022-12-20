module value_checker (
  input logic clk_i,
  input logic rstn_i,
  input logic prog_i,
  input logic prog_valid _i,
  input logic [7:0] prog_data_i,
  input logic valid_i,
  input logic [7:0] data_i,
  output logic valid_o,
  output logic [1:0] check_o
);

   typedef enum logic[2:0] {
                            IDLE,
                            PROG,
                            CHECK_1,
                            CHECK_2,
                            CHECK_3,
                            OUT } state_t;

   state_t state_d, state_q;

   logic [1:0]  count_d, count_q;
   logic [1:0]  idfail_d, idfail_q;

   logic [7:0]  PROG1_D, PROG1_Q;
   logic [7:0]  PROG2_D, PROG2_Q;

   always_ff @(posedge clk_i or negedge rst_i) begin
      if(~rst_i) begin
         count_q <= '0;
         state_q <= IDLE;
         PROG1_Q <= '0;
         PROG2_Q <= '0;
         idfail_q <= '0;         
      end else begin
         count_q       <= count_d      ;
         state_q <= state_d;
         PROG1_Q <= PROG1_D;
         PROG2_Q <= PROG2_D;
         idfail_q <= idfail_d;         
      end
   end // always_ff @ (posedge clk_i or negedge rst_i)

   always_comb begin
      count_d = count_q;
      
      if( (state_q == PROG) & valid_i ) begin
         count_d = count_q + 1;
      end
      if (state_q == IDLE ) begin
         count_d = 0;
      end
   end

   always_comb begin
      idfail_d = idfail_q;         
      state_d = state_q;
      PROG1_D = PROG1_Q;
      PROG2_D = PROG2_Q;

      case(state_q) begin

        IDLE: begin
            if(active_i)
              state_d = PROG;
        end

        PROG: begin
           if(prog_valid_i & (count_q==0) ) begin
              PROG1_D = prog_data_i;
           end else if(prog_valid_i & (count_q==1)) begin
              PROG2_D = prog_data_i;
              state_d = CHECK_1;
           end
        end

        CHECK_1: begin
           if(valid_i) begin
              if( (PROG1_Q && PROG2_Q) == data_i ) begin
                 state_d = CHECK_2;
              end else begin
                 state_d = OUT;
                 idfail_d = 2'b01;
              end
           end
        end
        
        CHECK_2: begin
           if(valid_i) begin
              if( (PROG1_Q || PROG2_Q) == data_i ) begin
                 state_d = CHECK_3;
              end else begin
                 state_d = OUT;
                 idfail_d = 2'b10;
              end
           end
        end
              
        CHECK_3: begin
           if(valid_i) begin
              if( (PROG1_Q ^ PROG2_Q) == data_i ) begin
                 state_d = OUT;
                 idfail_d = 2'b00;
              end else begin
                 state_d = OUT;
                 idfail_d = 2'b11;
              end
           end
        end // case: CHECK_3

        OUT: begin
           valid_o = 1'b1;
           check_o = idfail_q;
        end
      endcase // case (state_q)
   end // always_comb
   
endmodule // value_checker
