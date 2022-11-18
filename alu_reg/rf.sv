// Copyright 2014-2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module register_file_2r_1w
#(
    parameter ADDR_WIDTH    = 5, // 2^5 registers
    parameter DATA_WIDTH    = 32
)
(
    // Clock and Reset
    input  logic         clk,
    input  logic         rst_n,

    //Read port R1
    input  logic [ADDR_WIDTH-1:0]  raddr_a_i,
    output logic [DATA_WIDTH-1:0]  rdata_a_o,

    //Read port R2
    input  logic [ADDR_WIDTH-1:0]  raddr_b_i,
    output logic [DATA_WIDTH-1:0]  rdata_b_o,

    // Write port W1
    input logic [ADDR_WIDTH-1:0]   waddr_c_i,
    input logic [DATA_WIDTH-1:0]   wdata_c_i,
    input logic                    we_c_i

);

  localparam    NUM_WORDS = 2**ADDR_WIDTH;

  logic [NUM_WORDS-1:0][DATA_WIDTH-1:0] rf_reg;

  logic [NUM_WORDS-1:0]                 we_c_dec;

  always_comb begin : we_c_decoder
    for (int i=0; i<NUM_WORDS; i++) begin
      if (waddr_c_i == i)
        we_c_dec[i] <= we_c_i;
      else
        we_c_dec[i] <= 1'b0;
    end
  end

  genvar i;
  generate 
   for (i=0; i<NUM_WORDS; i++) begin : rf_gen
      always_ff @(posedge clk or negedge rst_n) begin : register_write_behavioral
         if (rst_n==1'b0) begin
            rf_reg[i] <= 'b0;
         end else begin
            if(we_c_dec[i])
              rf_reg[i] <= wdata_c_i;
            else
              rf_reg[i] <= rf_reg[i];
         end
      end
    end 
  endgenerate

  always_comb begin : register_read_a_behavioral
    rdata_a_o <= rf_reg[raddr_a_i];
  end

  always_comb begin : register_read_b_behavioral
    rdata_b_o <= rf_reg[raddr_b_i];
  end

endmodule
