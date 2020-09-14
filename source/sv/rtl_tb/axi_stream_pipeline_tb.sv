`timescale 1ns / 1ps
`default_nettype none
module testbench;

  localparam clk_period_c = 10;
  //localparam Xsize_max_c = 7680;
  //localparam Ysize_max_c = 7680;
  localparam Xsize_max_c = 512;
  localparam Ysize_max_c = 512;

  localparam mem_size_max_c = Xsize_max_c*Ysize_max_c;
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
  logic [23:0] memory_inp [0:mem_size_max_c-1];
  logic [23:0] memory_out [0:mem_size_max_c-1];

  logic [12:0] Xsize;
  logic [12:0] Ysize;
  logic [25:0] mem_size;

  logic clk_i;
  logic rst_n_i;

  logic tvalid_i;
  logic tready_o;
  logic tlast_i;
  logic [23:0]tdata_i;

  logic tvalid_o;
  logic tready_i;
  logic tlast_o;
  logic [23:0]tdata_o;

//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
axi_stream_pipeline pipeline(
  .clk_i   (clk_i   ),
  .rst_n_i (rst_n_i ),

  .tvalid_i(tvalid_i),
  .tready_o(tready_o),
  .tlast_i (tlast_i ),
  .tdata_i (tdata_i ),

  .tvalid_o(tvalid_o),
  .tready_i(tready_i),
  .tlast_o (tlast_o ),
  .tdata_o (tdata_o )
);
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
  always begin
    clk_i = 1; #(clk_period_c / 2);
    clk_i = 0; #(clk_period_c / 2);
  end
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
  initial begin
  rst_n_i = 1;
  @(posedge clk_i);
  rst_n_i = 0;
  @(posedge clk_i);
  rst_n_i = 1;
  @(posedge clk_i);
  end
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
initial begin
  tvalid_i = 0;
  tlast_i  = 0;
  tdata_i  = 0;
  tready_i = 1;
end
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
initial begin
  $readmemh("../../python/data_rgb.in",memory_inp);
  repeat(4)@(posedge clk_i);
    for (int i = 0; i < mem_size+2; i++) begin
      tvalid_i = 1;
      tdata_i = memory_inp[i];
      @(posedge clk_i);
    end
    tvalid_i = 0;
    tdata_i  = 0;
    @(posedge clk_i);
  repeat(4)@(posedge clk_i);
  $stop;
end
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
initial begin
  int j =0;
  Xsize = memory_inp[0];
  Ysize = memory_inp[1];
  mem_size = Xsize*Ysize;
  
  $display("Xsize = %d, Ysize = %d",Xsize,Ysize);
  $display("Xsize*Ysize = %d",mem_size);
  while(j<mem_size) begin
    if(tvalid_o) begin
      memory_out[j] = tdata_o;
      j = j + 1;
    end
    @(posedge clk_i);
  end
  $writememh("../../python/data.out",memory_out);
  $display("0x%h",memory_inp[mem_size-1]);
end

endmodule
`default_nettype wire
