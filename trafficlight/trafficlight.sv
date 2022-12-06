module trafficlight(
                    input logic clk,
                    input logic rstn,
                    input logic Ta,
                    input logic Tb,
                    output logic LaY,
                    output logic LaR,
                    output logic LaG,
                    output logic LbY,
                    output logic LbR,
                    output logic LbG
                    );
   

   typedef enum logic [1:0] {
                             academic,
                             a2b,
                             bravado,
                             b2a} state_t;

   state_t state_d, state_q;

   logic        fivesec;
   
   always_ff @(posedge clk or negedge rstn) begin
      if(!rstn) begin
         state_q <= academic;
      end else begin
         state_q <= state_d;
      end
   end

   assign LaR = !(LaY ^ LaG);
   assign LbR = !(LbY ^ LbG);

   always_comb begin
      state_d = state_q;
      LaY = 0; 
      LaG = 1; 
      LbY = 0; 
      LbG = 0;
      case(state_q)
        academic: begin
           LaY = 0; 
           LaG = 1; 
           LbY = 0; 
           LbG = 0;
           if(!Ta & fivesec) begin
              state_d = a2b;
           end
        end
        a2b: begin
           LaY = 1; 
           LaG = 0; 
           LbY = 0; 
           LbG = 0;
           if(fivesec) begin
              state_d = bravado;
           end
        end
        bravado: begin
            LaY = 0; 
            LaG = 0; 
            LbY = 0; 
            LbG = 1;
            if(!Tb & fivesec) begin
               state_d = b2a;
            end
        end
        b2a: begin
            LaY = 0; 
            LaG = 0; 
            LbY = 1; 
            LbG = 0;
           if(fivesec) begin
              state_d = academic;
           end
        end
      endcase // case (state_q)
   end // always_comb

   logic [31:0] count_d, count_q;

   always_ff @(posedge clk or negedge rstn) begin
      if(!rstn) begin
         count_q <= '0;
      end else begin
         count_q <= count_d;
      end
   end

   always_comb begin
      fivesec = '0;
      count_d = count_q +1;
      // assuming 2ms clock
      if(count_d==2500) begin
         count_d = '0;
         fivesec = 1'b1;
      end
   end
   
   
endmodule // trafficlight

                    
