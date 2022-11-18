// Copyright 2014-2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module alu
#(
    parameter DATA_WIDTH    = 32
)
(
    // Clock and Reset
    input logic                   clk,
    input logic                   rst_n,
    input logic [1:0]             op_i,
    input logic [DATA_WIDTH-1:0]  data_a_i,
    input logic [DATA_WIDTH-1:0]  data_b_i,
    output logic [DATA_WIDTH-1:0] data_c_o

);

  logic                           carry;
   
  always_comb begin
     carry = 1'b0;
     case(op_i) begin
        2'b00: {carry,data_c_o} = data_a_i + data_b_i;
        2'b01: {carry,data_c_o} = data_a_i - data_b_i;        
        2'b10: data_c_o         = data_a_i ^ data_b_i;        
        2'b11: data_c_o         = data_a_i & data_b_i;        
     endcase // case (op_i)
  end
   
endmodule
