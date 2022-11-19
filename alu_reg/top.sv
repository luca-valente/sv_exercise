module top
#(
    parameter ADDR_WIDTH    = 5, // 2^5 registers
    parameter DATA_WIDTH    = 32
)
(
    // Clock and Reset
    input logic                   clk,
    input logic                   rst_n,
 
    input logic [1:0]             op_i,
    //Read port R1
    input logic [ADDR_WIDTH-1:0]  raddr_a_i,
    output logic [DATA_WIDTH-1:0] rdata_a_o,

    //Read port R2
    input logic [ADDR_WIDTH-1:0]  raddr_b_i,
    output logic [DATA_WIDTH-1:0] rdata_b_o,

    // Write port W1
    input logic [ADDR_WIDTH-1:0]  waddr_c_i,
    input logic [DATA_WIDTH-1:0]  wdata_c_i,
    input logic                   we_c_i,

    output logic [DATA_WIDTH-1:0] data_c_o,
    output logic                  c_o 
);


   logic [DATA_WIDTH-1:0]         data_a;
   logic [DATA_WIDTH-1:0]         data_b;
   
   register_file_2r_1w i_rf(
             .clk       ( clk       ),
             .rst_n     ( rst_n     ),
             .raddr_a_i ( raddr_a_i ),
             .rdata_a_o ( data_a    ),
             .raddr_b_i ( raddr_b_i ),
             .rdata_b_o ( data_b    ),
             .waddr_c_i ( waddr_c_i ),
             .wdata_c_i ( wdata_c_i ),
             .we_c_i    ( we_c_i    )
             );

   assign rdata_a_o = data_a;
   assign rdata_b_o = data_b;
   
   alu i_alu(
      .clk       ( clk      ),
      .rst_n     ( rst_n    ),
      .op_i      ( op_i     ),
      .data_a_i  ( data_a   ),
      .data_b_i  ( data_b   ),
      .data_c_o  ( data_c_o ),
      .c_o       ( c_o      )
  );

endmodule
