`default_nettype none
module axi_stream_pipeline
(
//-------------------------------------------
// System interaface
//-------------------------------------------
  input  wire         clk_i,
  input  wire         rst_n_i,
//-------------------------------------------
// Slave input
//-------------------------------------------
  input  wire         tvalid_i,
  output wire         tready_o,
  input  wire         tlast_i,
  input  wire [23:0]  tdata_i,
//-------------------------------------------
// Master Output
//-------------------------------------------
  output wire         tvalid_o,
  input  wire         tready_i,
  output wire         tlast_o,
  output wire [23:0]  tdata_o
);
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
  logic         tvalid_r2g;
  logic         tready_sobel;
  logic         tlast_r2g;
  logic [23:0]  tdata_r2g;

//----------------------------------------------------------------------------------------------------
// axi_stream_rgb2gray inst
//----------------------------------------------------------------------------------------------------
axi_stream_rgb2gray rgb2gray(
  .clk_i   (clk_i   ),
  .rst_n_i (rst_n_i ),

  .tvalid_i(tvalid_i    ),
  .tready_o(tready_o    ),
  .tlast_i (tlast_i     ),
  .tdata_i (tdata_i     ),

  .tvalid_o(tvalid_r2g  ),
  .tready_i(tready_sobel),
  .tlast_o (tlast_r2g   ),
  .tdata_o (tdata_r2g   )
);
//----------------------------------------------------------------------------------------------------
// axi_stream_sobel inst
//----------------------------------------------------------------------------------------------------
axi_stream_sobel sobel(
  .clk_i   (clk_i   ),
  .rst_n_i (rst_n_i ),

  .tvalid_i(tvalid_r2g  ),
  .tready_o(tready_sobel),
  .tlast_i (tlast_r2g   ),
  .tdata_i (tdata_r2g   ),

  .tvalid_o(tvalid_o    ),
  .tready_i(tready_i    ),
  .tlast_o (tlast_o     ),
  .tdata_o (tdata_o     )
);

endmodule
`default_nettype wire